local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Constants = require(Foundation.Constants)
require(Foundation.Enums.DialogSize)
require(parent.React)

return {
	nonSelectable = Constants.MODAL.DISABLE_SELECTION,
	isolatedSelectionGroup = Constants.MODAL.TRAP_FOCUS
}
