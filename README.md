# Hoogle.nvim

Neovim plugin that lets you search through a local Hoogle database.

## Features

- Supports [`snacks.nvim`](https://github.com/folke/snacks.nvim) and [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim)
- Open documentation in your browser
- Copy entry to clipboard
- Specify custom database path
- Supports `stack hoogle`

> [!NOTE]
> This plugin expects the database to be generated and setup (i.e. `hoogle generate` or `stack hoogle --setup` has been run once before)

## Demo

https://github.com/user-attachments/assets/b0b1703e-0b8a-487b-b357-fc2a63d8ae75

## Setup

To use this plugin using `lazy.nvim`, add the following to your configuration:

```lua
{
  "Arthi-chaud/hoogle.nvim",
  ---@type hoogle.Config
  opts = {},
},
```

`opts` has the following type:

```lua
---@class hoogle.Config
---@field use_stack? "in_project" | boolean say whether to use `stack hoogle` or not 
---@field db_path? string absolute path to the Hoogle database (.hoo file) to use
---@field limit? integer maximum number of entries to return 
```


### Snacks

To invoke Snacks' picker, add the following to your configuration

```diff
{
  "folke/snacks.nvim",
+      -- Optional, for nice rendering of docs
+      dependencies = {
+        	"meanderingprogrammer/render-markdown.nvim",
+      },
  keys = {
+   {
+     "<leader>hs",
+     function()
+       Snacks.picker.hoogle()
+     end,
+     desc = "Hoogle",
+   }
  }
}
```

### Telescope

No additional setup is required to use Telescope. Just make sure that the Telescope plugin is enabled.

To launch the picker, run the following vim command:

```
:Telescope hoogle
```

## Actions

This plugin comes with 2 actions: copying to clipboard and opening the doc in the browser.

### Snacks

For bind these actions with Snacks, invoke `Snacks.picker.hoogle()` like this:

```lua
Snacks.picker.hoogle({
    win = {
        input = {
            keys = {
                ["<c-b>"] = { "open_browser", mode = { "i", "n" } },
                ["<enter>"] = { "copy_to_clipboard", mode = { "i", "n" } },
            },
        },
    },
})
```

### Telescope.nvim

For Telescope, add the following to the plugin's configuration

```diff
{
	"nvim-telescope/telescope.nvim",
    ...
	opts = {
+		extensions = {
+			hoogle = {
+				mappings = {
+					["<CR>"] = "copy_to_clipboard",
+					["<C-b>"] = "open_browser",
+				},
+			},
		},
	},
},
```

## Contributions & Reporting

Please feel free to open an issue if you encounter an issue or would like to see a feature added to the plugin.

Pull Requests are also welcome!


## Acknowledgement

- [ndmitchell/hoogle](https://github.com/ndmitchell/hoogle)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [psiska/telescope-hoogle.nvim](https://github.com/psiska/telescope-hoogle.nvim)
- [luc-tielen/telescope_hoogle](https://github.com/luc-tielen/telescope_hoogle)

No Generative AI was used for this.
