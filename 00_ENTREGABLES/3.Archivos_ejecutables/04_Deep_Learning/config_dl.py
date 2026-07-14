"""
config

Archivo de configuración del proyecto de clasificación de frutas.

Todas las constantes del proyecto deben definirse aquí para evitar
números "mágicos" repartidos por el código.
"""

# ==========================
# DATASET
# ==========================

# Ruta al CSV con las imágenes y etiquetas
DATASET_CSV = "data/raw/raw_dataset.csv"

# Carpeta donde se encuentran las imágenes
IMAGE_FOLDER = "data/raw/archive/"

# ==========================
# IMÁGENES
# ==========================

# Tamaño al que se redimensionarán todas las imágenes
IMAGE_SIZE = (224, 224) #por diseño de CNN

# Número de canales de color
CHANNELS = 3

# ==========================
# PARTICIONES
# ==========================

TRAIN_SIZE = 0.70
TEST_SIZE = 0.30

# Semilla para reproducibilidad
RANDOM_STATE = 33

# ==========================
# ENTRENAMIENTO
# ==========================

BATCH_SIZE = 32

EPOCHS = 20

LEARNING_RATE = 0.001

# ==========================
# MODELO
# ==========================

NUM_CLASSES = 15

CLASS_NAMES = [      'Apple',      'Banana',   'Carambola',       'Guava',        'Kiwi',
       'Mango',   'muskmelon',      'Orange',       'Peach',        'Pear',
   'Persimmon',      'Pitaya',        'Plum', 'Pomegranate',    'Tomatoes']



#CELDA DE RUTAS#

PROJECT_ROOT = "."

DATASET_DIR = "dataset"

MODELS_DIR = "models"

RESULTS_DIR = "results"

FIGURES_DIR = "figures"

LOGS_DIR = "logs"