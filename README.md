<!-- <p align="center">
  <img
    width="250"
    src="thumbnail.png"
    alt="thumbnail"
  />
</p> -->

<p align="center">
  <a href="https://github.com/ZwerOxotnik/factorio-RCON-stuff/tags">
    <img src="https://img.shields.io/github/tag/ZwerOxotnik/factorio-RCON-stuff.svg?label=Release&color=FF5500" alt="Release">
  </a>
  <a href="https://github.com/ZwerOxotnik/factorio-RCON-stuff/stargazers">
    <img src="https://img.shields.io/github/stars/ZwerOxotnik/factorio-RCON-stuff.svg?label=Stars&color=F08125" alt="Star">
  </a>
  <a href="https://discordapp.com/invite/YyJVUCa">
    <img src="https://discordapp.com/api/guilds/480103519769067542/widget.png?style=shield" alt="Discord">
  <br/>
  <a href="https://www.patreon.com/ZwerOxotnik">
    <img src="https://ionicabizau.github.io/badges/patreon.svg" alt="Patreon">
  <a href="https://ko-fi.com/zweroxotnik">
    <img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg" height="20" alt="Buy me a coffee">
  <a href="http://github.com/ZwerOxotnik/factorio-RCON-stuff/fork">
    <img src="https://img.shields.io/github/forks/ZwerOxotnik/factorio-RCON-stuff.svg?label=Forks&color=7889DD" alt="Fork">
  </a>
</p>

<p align="center">
</p>


**Stuff for RCON [AAR]**

Optimized stuff for RCON via scenario/mod

* In order to detect if it's scenario or mod use: `/sc if remote.interfaces.AAR then remote.call("AAR", "getSource") end`
* If it's a scenario use something like this to get results: `/sc someFunction(parameters)`
* If it's a mod use something like this to get results: `/sc __AAR__ someFunction(parameters)`
* You should active the mod by calling "activate()" via rcon, before calling any other fuction.

<p align="center">
<a href="https://mods.factorio.com/mod/AAR/downloads"><strong>Download the mod&nbsp;&nbsp;▶</strong></a>
</p>


‼️ Important Links (Translations, Discord Support)
---------------------------------------------------------------

| Installation Guide | Translations | Discord |
| ------------------ | ------------ | ------- |
| 📖 [Installation Guide](https://wiki.factorio.com/index.php?title=Installing_Mods) | 📚 [Help with translations](https://crowdin.com/project/factorio-mods-localization) | 🦜 [Discord](https://discord.gg/zYTM3rZM4T) |

If you want to download from this source, then use commands below (requires [git](https://git-scm.com/downloads)).

```bash
git clone --recurse-submodules -j8 https://github.com/ZwerOxotnik/factorio-RCON-stuff
cd factorio-RCON-stuff
```

[Contributing](/CONTRIBUTING.md)
--------------------------------

Don't be afraid to contribute! We have many, many things you can do to help out. If you're trying to contribute but stuck, tag @ZwerOxotnik

Alternatively, join the [Discord group](https://discordapp.com/invite/YyJVUCa) and send a message there.

Please read the [contributing file](/CONTRIBUTING.md) for other details on how to contribute.


License
-------
Copyright (c) 2022 ZwerOxotnik \<zweroxotnik@gmail.com\>

Use of the source code included here is governed by the Apache License, Version 2.0. See the [LICENSE](/LICENSE) file for details.

[homepage]: http://mods.factorio.com/mod/factorio-RCON-stuff
[ZwerOxotnik]: github.com/ZwerOxotnik/
