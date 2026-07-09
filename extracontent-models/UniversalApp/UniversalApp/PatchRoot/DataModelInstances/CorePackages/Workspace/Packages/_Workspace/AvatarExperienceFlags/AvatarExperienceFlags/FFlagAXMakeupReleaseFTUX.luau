local FFlagAXCustomizeMakeupSupport = require(script.Parent.FFlagAXCustomizeMakeupSupport)
local FFlagAXCatalogMakeupSupport = require(script.Parent.FFlagAXCatalogMakeupSupport)
local FFlagAXMakeupEquipping = require(script.Parent.FFlagAXMakeupEquipping)

return game:DefineFastFlag("AXMakeupReleaseFTUX", false) and (FFlagAXCustomizeMakeupSupport and (FFlagAXCatalogMakeupSupport and FFlagAXMakeupEquipping))
