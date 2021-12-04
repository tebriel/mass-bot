#!/usr/bin/env python

from distutils.core import setup

setup(name='mass-bot',
      version='1.0',
      description='Massenomics Bot',
      author='Chris Moultrie',
      author_email='821688+tebriel@users.noreply.github.com',
      url='https://github.com/tebriel/mass-bot/',
      packages=['bot'],
      install_requires=[
            'hikari',
            'azure-storage-blob',
      ],
)