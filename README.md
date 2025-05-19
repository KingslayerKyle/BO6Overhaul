# Black Ops 6 Overhaul

## 🖥️ Development Highlights

- Extensive time and effort went into locating images to preserve the original look.
- Everything was recreated 1:1 by eye manually positioning each UI element.
- Using Photoshop to re-create missing icons, with a few pieces generously provided by others.
- Recreated core BO6 systems in BO3 through custom GSC scripting and Lua UI work, closely replicating visuals, functionality, and behavior.
- Created a font exporter to obtain the fonts used in the UI.
- Created the [BO6 Tools Maya Plugin](https://github.com/KingslayerKyle/BO6ToolsMayaPlugin) (for vertex color material mapping)
- Gathered feedback from testers and implemented additional suggestions and bug fixes.

## ❤ Support & Acknowledgement Request

This project took over a month of dedicated work. My name on the start menu is a subtle, handwritten-style signature to acknowledge that. Please don’t remove it — it’s a small but appreciated way to show respect for the time and effort put into this.

## 💵 Donations
If you appreciate the time and effort that went into this project, consider showing your support with a donation:\
[https://paypal.me/kingslayerkyle](https://paypal.me/kingslayerkyle)

---

## 📦 Requirements

Download from the GitHub release:
[BlackOps3Shaders on GitHub](https://github.com/LG-RZ/BlackOps3Shaders/releases)

* Extract the archive.
* Drag & drop the `share` and `source_data` folders into your **BO3 root directory**.

---

## 🤝 Installation Guidance

**Note:** The order of the #using statements does not affect functionality. They are simply organized into sections (e.g., shared scripts, zombies mode scripts) for better readability and maintainability. You can add the required #using anywhere in the list, regardless of its position—just place it in the section that makes the most sense for your organization.

---

## 🛠️ Installation

### 1. Root Files (Assets)

Drag & drop **all files** into your **BO3 root directory**.

### 2. Map Files (Code)

Drag & drop **all files** into your **maps folder**.

---

## 📜 Script Setup

### 1. GSC & CSC Files

In your map’s `.gsc` and `.csc` files, add:

```c
#using scripts\zm\_zm_t10_hud;
```

### 2. Zone File

In your map’s zone file, add:

```txt
include,t10
```

---

## 🔊 Sound Configuration

Open:

```
your_maps_folder/sound/zoneconfig/your_maps_name.szc
```

Find this block:

```json
{
  "Type" : "ALIAS",
  "Name" : "user_aliases",
  "Filename" : "user_aliases.csv",
  "Specs" : []
},
```

Add the following directly underneath:

```json
{
  "Type" : "ALIAS",
  "Name" : "t10_aliases",
  "Filename" : "t10_aliases.csv",
  "Specs" : []
},
```

Save and exit.

---

## 📝 Additional Notes

### Map Name & Description:

Replace the map name and description in:

```
ui/uieditor/menus/hud/T10Hud_zm_factory.lua
```

Lines **38 & 39**

```lua
-- The map name & description,
-- This is used on the start menu & scoreboard
CoD.UsermapName = "Replace with your maps name"
CoD.UsermapDesc = "Replace with your maps description"
```

---

### Inventory Widget

There is a pre-made inventory widget included that can be enabled in:

```
ui/uieditor/menus/hud/T10Hud_zm_factory.lua
```

Line **44**

This widget is shown on the scoreboard, to use it you will need to create your own item images and integrate them using basic lua knowledge.

---

### Wunderfizz Requirements:

Before you start, make sure both Electric Cherry and Widow's Wine are turned on in your map. To do this, add these two lines to your map's GSC and CSC files:

```c
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_widows_wine;
```

These perks are set to show up in the menu by default. If a perk is in the menu but not in your map, you'll get an error. If you don't want to use one or both of these perks, remove them instead (this will require some basic understanding of the lua files)

---

### Perk change script:

**The Wunderfizz machine and all stock perk machines include perk change support.**
To enable this functionality, you must manually activate it by calling the perk change script. If you haven’t already done so, complete the steps below.

To enable it, add the following to the top of your map's `.gsc` file:

```c
#using scripts\zm\_zm_perks;
```

Then add the following to your map's `.gsc` file **after** the `zm_usermap::main();` line:

```c
level thread zm_perks::spare_change();
```

---

### Powerup modifications

Max Ammo will also refill your clip. If you currently have a script that already does this, remove it.

Carpenter will refill the health of your **armor**.

---

### Prefab Machines:

You can place **as many** of each machine prefab as you'd like.

---

### Wunderfizz Random Jingles:

Wunderfizz will play random jingles if your **perk jingle aliases** are set up correctly.

---

### Configurable settings:

You can toggle hitmarkers and change Pack-a-Punch camos for **each tier** in the `_zm_t10_weapon_upgrade.gsh` file.

Each script that has a `.gsh` file also contains additional configurable settings.

---

# Credits

## ✍️ Author

* **Kingslayer Kyle**

## 🤝 Contributors

* **Dest1yo** — Tools
* **Glitch** — UI Icons, Textures
* **IceGrenade** — Voicelines
* **JariK** — Tools
* **LG** — PostFX, Outlines
* **MrChuse** — Renders
* **Rayjiun** — FX
* **Ronan** — UI Icons, Textures
* **Scobalula** — Drops, Tools
* **WetEgg** — Models, Animations, Sounds

## 🧪 Testers

* Deadshot
* EpicNNG
* itsbrodes
* Kunjora
* MrChuse
* MrTomWaffles
* Owen C137
* Remarkable Atlus
* REX
* Ronan
* SaintVertigo
* Scrappy
* Teaa
* VorteX
* XcDylan93
* Zeus KrAZy
