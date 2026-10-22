# 🫂 Snoogle

_[Snacks.nvim](https://github.com/folke/snacks.nvim)_ + _[Hoogle](https://github.com/ndmitchell/hoogle)_ = _Snoogle_

**Snoogle** is a Neovim plugin that lets you look through a local Hoogle database.

## Demo

https://github.com/user-attachments/assets/b0b1703e-0b8a-487b-b357-fc2a63d8ae75

## Setup


```diff
+  {
+ 	 "Arthi-chaud/snoogle.nvim",
+    ---@type snoogle.Config
+  	 opts = {
+       use_stack = false --- @type boolean | "in_project"
+       db_path = "" --- @type string? optional
+    },
+  },
{
  "folke/snacks.nvim",
+      -- Optional, for nice rendering of docs
+      dependencies = {
+        	"meanderingprogrammer/render-markdown.nvim",
+      },
   ...
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

### Actions

2 actions are available: `copy_to_clipboad` & `open_browser`. For enable them, invoke `Snacks.picker.hoogle()` like this:

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


## Acknowledgement

- [ndmitchell/hoogle](https://github.com/ndmitchell/hoogle)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [psiska/telescope-hoogle.nvim](https://github.com/psiska/telescope-hoogle.nvim)
- [luc-tielen/telescope_hoogle](https://github.com/luc-tielen/telescope_hoogle)

No Generative AI was used for this
