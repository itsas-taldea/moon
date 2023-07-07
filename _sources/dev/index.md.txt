# Development

The videogame in this repository is implemented using {web}`Godot <godotengine.org>`.
The Godot Editor is made using Godot itself.
As a result, it is available on the same platforms that games can be exported to:
GNU/Linux, Windows, macOS, Android, Web, consoles...
See {web}`godotengine.org/download`.

After getting the editor, open the project in subdir {ghsrc}`godot` of this repository and you are ready to tinker with it!

```{NOTE}
You can get the sources either through {web}`git <git-scm.com>` or by downloading a zipfile or a tarball as explained at
{web}`docs.github.com: Downloading source code archives <docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives>`.
```

```{NOTE}
Use {web}`docs.godotengine.org` to learn about Godot's features and concepts.
Reading {web}`docs.godotengine.org: Getting Started <docs.godotengine.org/en/stable/getting_started/introduction/index.html>` is strongly recommended.
```

## Continuous Integration

A {gh}`GitHub Actions <features/actions>` workflow is setup in this repository (see {ghsrc}`Pipeline.yml <.github/workflows/Pipeline.yml>`),
in order to automatically:

- Export the game for GNU/Linux, Windows, macOS and Web.
  - Upload the GNU/Linux, Windows and macOS builds as assets of release {gh}`tip <itsas-taldea/moon/releases/tag/tip>`.
  - Move tag `tip` forward.
- Build the documentation.
  - Combine it with the Web build and publish to {web}`GitHub Pages <pages.github.com/>`:
    - {web}`itsas-taldea.github.io/moon`
    - {web}`itsas-taldea.github.io/moon/play`
