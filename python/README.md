# Index Generator Readme

Jupyter notebooks must be modified to contain the following lines somewhere inside if you want them to be included in the index.

```python
#NAME: insert-title-here
#DESCRIPTION: insert-description-here
```

The generator can be passed a string as an argument that will be used to give the index a custom title. If an argument is not given you will be prompted for a title at runtime.

The generator will generate an index of Jupyter Notebooks, sorted into subcategories according to the sub directory they reside in. This notebook will be named indexgen.ipynb.
To run the generator just type the following command.

```bash
python3 index_generator.py -t title-here -p /path/to/notebooks
```

Make sure .indexraw.txt is in the same directory as index_generator.py.