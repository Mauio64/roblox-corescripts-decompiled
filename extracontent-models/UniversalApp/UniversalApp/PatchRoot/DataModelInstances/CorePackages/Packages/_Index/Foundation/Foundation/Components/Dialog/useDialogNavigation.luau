local Foundation = script:FindFirstAncestor("Foundation")
local DialogContext = require(script.Parent.DialogContext)

return require(Foundation.Utility.createUseModalNavigation)(DialogContext)
