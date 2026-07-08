local Foundation = script:FindFirstAncestor("Foundation")
local Constants = require(Foundation.Constants)

require(Foundation.Enums.DialogSize)
require(Foundation.Enums.OnCloseCallbackReason)

return {
	nonSelectable = Constants.MODAL.DISABLE_SELECTION,
	isolatedSelectionGroup = Constants.MODAL.TRAP_FOCUS
}
