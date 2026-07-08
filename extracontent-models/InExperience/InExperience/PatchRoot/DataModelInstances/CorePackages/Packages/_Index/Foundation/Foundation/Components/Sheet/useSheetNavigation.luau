local Foundation = script:FindFirstAncestor("Foundation")
local SheetContext = require(script.Parent.SheetContext)

return require(Foundation.Utility.createUseModalNavigation)(SheetContext)
