# 🫂 Snoogle

_[Snacks.nvim](https://github.com/folke/snacks.nvim)_ + _[Hoogle](https://github.com/ndmitchell/hoogle)_ = _Snoogle_

**Snoogle** is a Neovim plugin that lets you look through a local Hoogle database.

## Demo

https://github.com/user-attachments/assets/cf590b15-9708-406a-a335-3cb205227a62

## Setup


```diff
+  {
+ 	 "Arthi-chaud/snoogle.nvim",
+  	 opts = {},
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
