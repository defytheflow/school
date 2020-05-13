from setuptools import setup


setup(
    name  = 'lesson',
    version = '0.0.5',
    license = 'MIT',
    description = 'A tool for conducting coding lessons',
    author = 'Artyom Danilov',
    author_email = 'defytheflow@gmail.com',
    url = 'https://github.com/defytheflow/lesson',
    packages = ['lesson'],
    entry_points = {
        'console_scripts': [
            'lesson = lesson.main:main',
        ]
    }
)
