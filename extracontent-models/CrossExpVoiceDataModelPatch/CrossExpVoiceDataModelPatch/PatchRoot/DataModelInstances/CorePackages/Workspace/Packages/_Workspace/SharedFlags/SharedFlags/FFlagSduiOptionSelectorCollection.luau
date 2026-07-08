local FFlagSduiActionsShouldTakeOverrides = require(script.Parent.FFlagSduiActionsShouldTakeOverrides)
local FFlagSduiGenreSelector = require(script.Parent.FFlagSduiGenreSelector)

return game:DefineFastFlag("SduiOptionSelectorCollection", false) and (FFlagSduiActionsShouldTakeOverrides and FFlagSduiGenreSelector)
