local FFlagEnableSduiV2HomeInterleave = require(script.Parent.FFlagEnableSduiV2HomeInterleave)
local FFlagSduiVariableItemWidthCarousel = require(script.Parent.FFlagSduiVariableItemWidthCarousel)

return game:DefineFastFlag("SduiGenreSelector2", false) and (FFlagEnableSduiV2HomeInterleave and FFlagSduiVariableItemWidthCarousel)
