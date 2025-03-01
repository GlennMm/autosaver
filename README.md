# Autosaver

Autosaver is a lightweight Neovim plugin written in Lua that automatically saves your buffers on specific events. It supports toggling the autosave feature via a Neovim command and persists its state across sessions.

### Features

- Automatic Saving: Saves your file on events like InsertLeave and TextChanged.
- Persistent State: Remembers whether autosave was enabled or disabled across sessions.
- Command: The plugin creates a :Autosave command which has the options on/off/status or toggle.
- Exclusion of Filetypes: Configure filetypes to exclude from autosaving (e.g., commit messages, markdown files).
- You can also pass you own function that implement the way of saving files which get run when a file is being saved.
- you can also write you own custom logic for saving. An idea you could add custom save logic automatically save changes inside the buffer being edited (:w)  instead of the default (:wa). N.B i just assuming i have not tried that as of yet. 

### Installation

You can install Autosaver using your favorite Neovim plugin manager.

Example using Lazy.nvim:

```lua
return {
  "GlennMm/autosaver",
  ---@class AutosaveOptions
  ---@field excluded_filetypes table<string, boolean> List of filetypes to exclude from autosave
  ---@field autosave_function? fun() Custom function to handle autosavin
  opts = {
    excluded_filetypes = { markdown = true, gitcommit = true },
  },
  config = true,
}
```

Example using Packer.nvim:

```lua
use { 
    "GlennMm/autosaver", 
    config = function() 
        require("autosaver").setup({ 
            excluded_filetypes = { markdown = true, gitcommit = true }, 
        }) 
    end, 
}
```

### Usage

Once installed and configured, Autosaver will automatically save your files when you leave insert mode or when text changes.

Toggle Autosave: Use the command ```:Autosave on/off/status/toggle``` to switch autosave on or off. A notification will display the current state.

### Configuration

The plugin exposes a setup function that accepts a table of options.

Option: excluded_filetypes (table): A list of filetypes to exclude from autosaving.
Default:

```lua
{ 
    markdown = true, 
    gitcommit = true 
}
```

Example:

```lua
require("autosaver").setup({ 
    excluded_filetypes = { 
        markdown = true, 
        gitcommit = true, 
        text = true 
    }, 
})
```

The autosave state (enabled/disabled) is persisted in a file under Neovim's data directory (typically ~/.local/share/nvim/autosave_state.txt).

### Contributing

Feel free to open issues or submit pull requests to help improve Autosaver.

### License

MIT License. See the LICENSE file for details.

You can save this text into a file and use it as the README for your plugin.
