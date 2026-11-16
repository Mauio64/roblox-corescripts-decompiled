local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local Constants = require(foundation.Constants)
require(foundation.Enums.DialogSize)
require(parent.React)

return {
	nonSelectable = Constants.MODAL.DISABLE_SELECTION,
	isolatedSelectionGroup = Constants.MODAL.TRAP_FOCUS
}
