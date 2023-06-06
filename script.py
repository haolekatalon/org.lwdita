#importing the os module
import os
from generate_slugs import *

#to get the current working directory
directory = os.getcwd()

print(directory)

slugs = create_slugs("out/markdown_github/index.json")
fix_slugs("out/markdown_github/docs", slugs)