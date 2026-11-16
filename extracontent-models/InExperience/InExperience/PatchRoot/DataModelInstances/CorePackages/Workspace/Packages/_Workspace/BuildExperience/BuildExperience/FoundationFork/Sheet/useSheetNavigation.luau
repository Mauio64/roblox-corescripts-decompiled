local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation

local SheetContext = require(script.Parent.SheetContext)
local createUseModalNavigation = require(foundation.Utility.createUseModalNavigation)

return createUseModalNavigation(SheetContext)
