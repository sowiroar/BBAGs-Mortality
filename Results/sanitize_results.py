import os
import pandas as pd
import numpy as np

# Rutas de archivos
results_dir = r"C:\Users\eguen\Documents\Githubs-Redlat\Repo-Gap\Brainlat\Results"
keys_path = r"C:\Users\eguen\Documents\Githubs-Redlat\Repo-Gap\Brainlat\keys_mortality.csv"

# 1. Cargar keys_mortality.csv y crear el mapa de ID viejo -> hash UID
if not os.path.exists(keys_path):
    raise FileNotFoundError(f"No se encontro el archivo de claves en {keys_path}")

df_keys = pd.read_csv(keys_path)
df_keys = df_keys.dropna(subset=['uid', 'id'])
id_to_uid = dict(zip(df_keys['id'].astype(str), df_keys['uid']))

def make_uid_str(df, hh_col, p_col):
    hh = df[hh_col]
    p  = df[p_col]
    # Conversion limpia a enteros nullables de Pandas
    hh_int = pd.to_numeric(hh, errors="coerce").astype("Int64")
    p_int  = pd.to_numeric(p,  errors="coerce").astype("Int64")
    uid = np.where(hh_int.isna() | p_int.isna(),
                   np.nan,
                   hh_int.astype(str) + "_" + p_int.astype(str))
    return pd.Series(uid, index=df.index)

def find_id_columns(cols):
    """Busca nombres de columnas equivalentes a householdid y particid (case-insensitive)."""
    hh_col = None
    p_col = None
    
    # Normalizar columnas a minúsculas para la comparación
    cols_lower = [c.lower() for c in cols]
    
    # Buscar householdid
    for idx, c in enumerate(cols_lower):
        if c in ['householdid', 'houseid', 'household_id', 'house_id']:
            hh_col = cols[idx]
            break
            
    # Buscar particid
    for idx, c in enumerate(cols_lower):
        if c in ['particid', 'partic_id', 'participantid', 'participant_id']:
            p_col = cols[idx]
            break
            
    return hh_col, p_col

# 2. Recorrer los archivos de Results
files = os.listdir(results_dir)
processed_count = 0

for file_name in files:
    file_path = os.path.join(results_dir, file_name)
    ext = os.path.splitext(file_name)[1].lower()
    
    if ext not in ['.parquet', '.xlsx']:
        continue
        
    try:
        # Cargar DataFrame
        if ext == '.parquet':
            df = pd.read_parquet(file_path)
        else:
            # Excel
            df = pd.read_excel(file_path)
            
        # Comprobar si tiene columnas de ID
        hh_col, p_col = find_id_columns(df.columns)
        
        if hh_col and p_col:
            print(f"\n[INFO] Procesando y sanitizando: {file_name}")
            print(f"   Columnas identificadas: Casa='{hh_col}', Participante='{p_col}'")
            print(f"   Filas iniciales: {len(df)}")
            
            # Generar ID viejo y asignar hash UID
            df['temp_id_for_mapping'] = make_uid_str(df, hh_col, p_col)
            df['uid'] = df['temp_id_for_mapping'].astype(str).map(id_to_uid)
            
            # Limpiar nulos de UID
            df = df.dropna(subset=['uid'])
            
            # Eliminar columnas originales y temporales
            cols_to_drop = [hh_col, p_col, 'temp_id_for_mapping']
            df = df.drop(columns=cols_to_drop, errors='ignore')
            
            # Guardar de nuevo
            if ext == '.parquet':
                df.to_parquet(file_path)
            else:
                df.to_excel(file_path, index=False)
                
            print(f"   [SUCCESS] Sanitizado con exito. Filas finales: {len(df)}")
            processed_count += 1
            
    except Exception as e:
        print(f"[ERROR] Al procesar {file_name}: {e}")

print(f"\n[FINISHED] Proceso finalizado. Se sanitizaron {processed_count} archivos.")
