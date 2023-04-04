# -*- coding: utf-8 -*-

from os import environ
from pathlib import Path


ROOT = Path(__file__).resolve().parent


# -- General configuration ------------------------------------------------

extensions = [
    'sphinx.ext.extlinks',
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinxcontrib.bibtex',
    'myst_parser'
]

bibtex_default_style = 'plain'
bibfiles = [
#    ROOT.parent / 'refs.bib',
]
bibtex_bibfiles = [str(item) for item in bibfiles]
#for item in bibfiles:
#    if not item.exists():
#        raise Exception(f"Bibliography file {item} does not exist!")

source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown'
}

project = 'MOON: 1110011'
author = 'Moon authors and contributors'
copyright = f'2016-2023, {author}'

version = "latest"
release = version  # The full version, including alpha/beta/rc tags.

language = 'en'

numfig = True

todo_include_todos = True

# -- Options for HTML output ----------------------------------------------

html_theme = "furo"

html_css_files = [
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/fontawesome.min.css",
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/solid.min.css",
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/brands.min.css",
]

ref_name = environ.get("GITHUB_REF_NAME", "main")

html_theme_options = {
    "source_repository": "https://github.com/itsas-taldea/moon",
    "source_branch": ref_name,
    "source_directory": "doc",
    "sidebar_hide_name": True,
    "footer_icons": [
        {
            "name": "COMPUS",
            "url": "https://compus.deusto.es/",
            "html": "",
            "class": "fa-solid fa-graduation-cap",
        },
        {
            "name": "COMPUS MOON",
            "url": "https://compus.deusto.es/moon/",
            "html": "",
            "class": "fa-solid fa-globe",
        },
        {
            "name": "GitHub",
            "url": "https://github.com/itsas-taldea/moon",
            "html": "",
            "class": "fa-solid fa-brands fa-github",
        },
    ],
}

html_static_path = ['_static']

html_logo = str(Path(html_static_path[0]) / "logo.png")
html_favicon = str(Path(html_static_path[0]) / "logo.png")

# -- Sphinx.Ext.InterSphinx -----------------------------------------------

intersphinx_mapping = {
   'python': ('https://docs.python.org/3/', None),
}

# -- Sphinx.Ext.ExtLinks --------------------------------------------------

extlinks = {
   'wikipedia': ('https://en.wikipedia.org/wiki/%s', 'w:%s'),
   'youtube':   ('https://www.youtube.com/watch?v=%s', 'yt:%s'),
   "web":       ('https://%s', '%s'),
   "gh":        ('https://github.com/%s', 'gh:%s'),
   "gl":        ('https://gitlab.com/%s', 'gl:%s'),
   'ghsharp': ('https://github.com/itsas-taldea/moon/issues/%s', '#%s'),
   'ghissue': ('https://github.com/itsas-taldea/moon/issues/%s', 'issue #%s'),
   'ghpull':  ('https://github.com/itsas-taldea/moon/pull/%s', 'pull request #%s'),
   'ghsrc':   (f'https://github.com/itsas-taldea/moon/blob/{ref_name}/%s', '%s')
}
