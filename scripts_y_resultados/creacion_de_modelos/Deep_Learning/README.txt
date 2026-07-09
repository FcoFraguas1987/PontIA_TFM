Este proyecto require del uso de TensorFlow, sólo funciona bien con python 3.12


COMANDOS
brew install python@3.12 
python3.12 -m venv dl_env 
source dl_env/bin/activate
pip install -r requirements_dl.txt


Estructura del proyecto

project_DS/
│
├── config_dl.py
│
├── CNN_dataset.ipynb
│
├── best_model.keras (CNN)
│
├── Resultados de CNN (matriz_confusión, classification_report)
│
├── evaluate.py
│
├── predict.py
│
├── utils.py
│
└── main.py