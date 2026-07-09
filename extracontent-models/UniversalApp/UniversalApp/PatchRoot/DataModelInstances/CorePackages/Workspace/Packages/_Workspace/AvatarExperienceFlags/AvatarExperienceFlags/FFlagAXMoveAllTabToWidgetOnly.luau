local FFlagAXRootRFYMigration = require(script.Parent.FFlagAXRootRFYMigration)
local FFlagAXPassScreenSizeToWidgetApi = require(script.Parent.FFlagAXPassScreenSizeToWidgetApi)

return FFlagAXRootRFYMigration and (FFlagAXPassScreenSizeToWidgetApi and game:DefineFastFlag("AXMoveAllTabToWidgetOnly5", false))
