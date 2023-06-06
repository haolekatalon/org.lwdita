"""
This script does slug-related tasks, including:
1. Generate slugs for documents in sidebar
2. Add the slug metadata to the corresponding .mdx files
3. Replace all references in documents with proper slugs
"""

import json
import os
import re
import frontmatter
from slugify import slugify


def create_slugs(file_path):
    data = None
    
    with open(file_path) as f:
        data = json.loads(f.read())
    
    # contains pairs of (id, slug)
    slugs = dict()
    
    def crawl_slug(data, slug_path):
        current_slug = slug_path
        for elem in data:
            if elem['type'] == 'category':
                current_slug = slug_path + '/' + slugify(elem['label'].lower().replace(' ', '-'))
                crawl_slug(elem['items'], current_slug)
                
            elif elem['type'] == 'doc':
                current_slug = slug_path + '/' + slugify(elem['label'].lower().replace(' ', '-'))
                slugs[elem['id']] = current_slug
                
            
    crawl_slug(data, '')
    
    return slugs

def replace_substrings(text, replacements):
    pattern = r'\b([\w-]+)\.mdx\b'  # Regular expression pattern to match substrings ending with ".mdx"
    repl = lambda match: replacements.get(match.group(1), match.group(0))
    replaced_text = re.sub(pattern, repl, text)
    return replaced_text
    
def fix_slugs(doc_folder, slugs):
    for path, subdirs, files in os.walk(doc_folder):
        for filename in files:
            file_path = os.path.join(path, filename)
            post = None

            post = frontmatter.load(file_path)

            if 'id' in post and post['id'] in slugs:
                # adding slug
                post['slug'] = slugs[post['id']]
                print(post.metadata)
                # replacing path
                post.content = replace_substrings(post.content, slugs)
                
                with open(file_path, "w") as f:
                    print("writing to", filename)
                    f.write(frontmatter.dumps(post))
                
    
if __name__ == "__main__":
    slugs = create_slugs("out/markdown_github/index.json")
    fix_slugs("out/markdown_github/docs", slugs)