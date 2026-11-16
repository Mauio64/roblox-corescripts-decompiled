local FFlagAXInventoryDurablesSupport = require(script.Parent.FFlagAXInventoryDurablesSupport)
local FFlagAXAvatarEditorStoresContext = require(script.Parent.FFlagAXAvatarEditorStoresContext)

return game:DefineFastFlag("AXMigrateOutfitsToUserInventory2", false)
	and FFlagAXInventoryDurablesSupport
	and FFlagAXAvatarEditorStoresContext
