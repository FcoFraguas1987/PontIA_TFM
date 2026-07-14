Este proyecto require del uso de TensorFlow, sólo funciona bien con python 3.12


COMANDOS
brew install python@3.12
python3.12 -m venv venv
source venv/bin/activate
pip install -r requirements_dl.txt
python -m ipykernel install --user --name=tfm-dl --display-name="TFM - Deep Learning (py3.12)"

En VS Code, abrir el notebook y seleccionar el kernel "TFM - Deep Learning (py3.12)".

Efficente_Net_Alejandro.ipynb y Random_Forest_Alejandro.ipynb usan `google.colab` y están pensados para ejecutarse en Google Colab, no en este entorno local.


Estructura del proyecto

04_Deep_Learning/
│
├── config_dl.py
│
├── 03_dl_resnet50_baseline.ipynb
├── CNN_dataset.ipynb
├── Efficente_Net_Alejandro.ipynb (Google Colab)
├── Random_Forest_Alejandro.ipynb (Google Colab)
│
├── best_model.keras (CNN)
├── efficientnet_final.h5
├── models/
│
└── Resultados (matrices de confusión, classification_report, resúmenes de modelo).
├── 03_dl_resnet50_baseline.ipynb
├── CNN_dataset.ipynb
├── Efficente_Net_Alejandro.ipynb
├── Matriz_confusion_CNN.jpg
├── Matriz_confusion_ResNet.jpg
├── README.txt
├── Random_Forest_Alejandro.ipynb
├── __pycache__
│   └── config_dl.cpython-312.pyc
├── best_model.keras
├── classification_report_CNN.csv
├── classification_report_ResNet.csv
├── classification_report_knn_test.csv
├── config_dl.py
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
│   │   │   ├── Guava
│   │   │   ├── Kiwi
│   │   │   ├── Mango
│   │   │   ├── Orange
│   │   │   ├── Peach
│   │   │   ├── Pear
│   │   │   ├── Persimmon
│   │   │   ├── Pitaya
│   │   │   ├── Plum
│   │   │   ├── Pomegranate
│   │   │   ├── Tomatoes
│   │   │   ├── folder_path
│   │   │   ├── muskmelon
│   │   │   ├── pictures_path
│   │   │   ├── raw_dataset.csv
│   │   │   └── solo_archivos.txt
│   │   └── raw_dataset.csv
│   ├── sample_100
│   │   └── sample_100.csv
│   └── splits
│       ├── test_dataset.csv
│       └── train_dataset.csv
├── efficientnet_final.h5
├── matriz_confusion_knn_test.csv
├── model_summary_CNN.png
├── models
│   └── dl
│       └── resnet50_baseline_best.keras
├── requirements_dl.txt
├── resnet50_summary.csv
├── resnet50_summary.txt
├── test_dataset.csv
├── train_dataset.csv
└── venv
    ├── bin
    │   ├── Activate.ps1
    │   ├── activate
    │   ├── activate.csh
    │   ├── activate.fish
    │   ├── cffi-gen-src
    │   ├── debugpy
    │   ├── debugpy-adapter
    │   ├── f2py
    │   ├── fonttools
    │   ├── httpx
    │   ├── idna
    │   ├── imageio_download_bin
    │   ├── imageio_remove_bin
    │   ├── ipython
    │   ├── ipython3
    │   ├── jlpm
    │   ├── jsonpointer
    │   ├── jsonschema
    │   ├── jupyter
    │   ├── jupyter-builder
    │   ├── jupyter-console
    │   ├── jupyter-dejavu
    │   ├── jupyter-events
    │   ├── jupyter-execute
    │   ├── jupyter-kernel
    │   ├── jupyter-kernelspec
    │   ├── jupyter-lab
    │   ├── jupyter-labextension
    │   ├── jupyter-labhub
    │   ├── jupyter-migrate
    │   ├── jupyter-nbconvert
    │   ├── jupyter-notebook
    │   ├── jupyter-run
    │   ├── jupyter-server
    │   ├── jupyter-troubleshoot
    │   ├── jupyter-trust
    │   ├── lsm2bin
    │   ├── markdown-it
    │   ├── mistune
    │   ├── normalizer
    │   ├── numpy-config
    │   ├── pip
    │   ├── pip3
    │   ├── pip3.12
    │   ├── pybabel
    │   ├── pyftmerge
    │   ├── pyftsubset
    │   ├── pygmentize
    │   ├── pyjson5
    │   ├── python -> python3.12
    │   ├── python3 -> python3.12
    │   ├── python3.12 -> /opt/homebrew/opt/python@3.12/bin/python3.12
    │   ├── saved_model_cli
    │   ├── send2trash
    │   ├── tf_upgrade_v2
    │   ├── tflite_convert
    │   ├── tiff2fsspec
    │   ├── tiffcomment
    │   ├── tifffile
    │   ├── toco
    │   ├── tqdm
    │   ├── ttx
    │   ├── wheel
    │   └── wsdump
    ├── etc
    │   └── jupyter
    │       ├── jupyter_notebook_config.d
    │       ├── jupyter_server_config.d
    │       └── nbconfig
    ├── include
    │   └── python3.12
    ├── lib
    │   └── python3.12
    │       └── site-packages
    ├── pyvenv.cfg
    └── share
        ├── applications
        │   ├── jupyter-notebook.desktop
        │   └── jupyterlab.desktop
        ├── icons
        │   └── hicolor
        ├── jupyter
        │   ├── kernels
        │   ├── lab
        │   ├── labextensions
        │   ├── nbconvert
        │   └── nbextensions
        └── man
            └── man1

50 directories, 99 files
