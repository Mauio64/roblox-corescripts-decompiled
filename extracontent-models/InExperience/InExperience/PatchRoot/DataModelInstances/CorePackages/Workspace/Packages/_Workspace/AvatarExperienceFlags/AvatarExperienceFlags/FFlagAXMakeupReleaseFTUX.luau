local FFlagAXCatalogMakeupSupport = require(script.Parent.FFlagAXCatalogMakeupSupport)
local FFlagAXMakeupEquipping = require(script.Parent.FFlagAXMakeupEquipping)

return game:DefineFastFlag("AXMakeupReleaseFTUX", false) and (FFlagAXCatalogMakeupSupport and FFlagAXMakeupEquipping)
