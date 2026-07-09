local FFlagAXRootRFYMigration = require(script.Parent.FFlagAXRootRFYMigration)
local FFlagAXMoveAllTabToWidgetOnly = require(script.Parent.FFlagAXMoveAllTabToWidgetOnly)

return FFlagAXRootRFYMigration and (FFlagAXMoveAllTabToWidgetOnly and game:DefineFastFlag("AXFixWidgetOnlyTabNoItemsFound", false))
