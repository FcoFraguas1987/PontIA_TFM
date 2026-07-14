Los cuadernos de KNN y SVM se han ejecutado en local, el de Random Forest se ha ejecutado en google Colab, por lo que las imágenes se han subido al espacio de Colab.

ENTORNO (para KNN y SVM)

Requiere Python 3.12.

COMANDOS
brew install python@3.12
python3.12 -m venv venv
source venv/bin/activate
pip install -r requirements_ml.txt
python -m ipykernel install --user --name=tfm-ml --display-name="TFM - Machine Learning (py3.12)"

En VS Code, abrir el notebook y seleccionar el kernel "TFM - Machine Learning (py3.12)".

Random_Forest_Alejandro.ipynb usa `google.colab` y está pensado para ejecutarse en Google Colab, no en este entorno local.

La estructura del proyecto es:.
├── 01_SVM.ipynb
├── 02_ml_knn_dataset_completo.ipynb
├── classification_report_knn_test.csv
├── classification_report_SVM.csv
├── data
│   ├── processed
│   │   ├── dataset_maestro.csv
│   │   └── features
│   ├── raw
│   │   ├── archive
│   │   │   ├── Apple
│   │   │   ├── Banana
│   │   │   ├── Carambola
│   │   │   ├── Creacion_dataset.ipynb
│   │   │   ├── folder_path
│   │   │   ├── Guava
│   │   │   ├── Kiwi
│   │   │   ├── Mango
│   │   │   ├── muskmelon
│   │   │   ├── Orange
│   │   │   ├── Peach
│   │   │   ├── Pear
│   │   │   ├── Persimmon
│   │   │   ├── pictures_path
│   │   │   ├── Pitaya
│   │   │   ├── Plum
│   │   │   ├── Pomegranate
│   │   │   ├── raw_dataset.csv
│   │   │   ├── solo_archivos.txt
│   │   │   └── Tomatoes
│   │   └── raw_dataset.csv
│   └── sample_100
│       └── sample_100.csv
├── matriz_confusion_knn_test.csv
├── Matriz_confusion_SVM.jpg
├── models
├── outputs
├── Random_Forest_Alejandro.ipynb
└── README.txt

24 directories, 16 files
