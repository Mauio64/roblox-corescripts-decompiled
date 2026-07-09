local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local GetPublishGameSheetStore = require(BuildExperience.Stores.GetPublishGameSheetStore)

require(BuildExperience.Stores.GetPublishGameSheetStore.createPublishGameSheetStore)

local function BuildOverflowSheetButton(t1: {[any]: any}) -- line: 25
	-- upvalues: GetPublishGameSheetStore (copy), React (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy)
	local v11 = t1.store or GetPublishGameSheetStore()
	local v12 = React.useCallback(function() -- line: 28
		-- upvalues: v11 (copy), t1 (copy)
		v11.setIsOpen(true)

		if t1.onActivated then
			t1.onActivated()
		end
	end, {
		v11,
		t1.onActivated
	})

	return React.createElement(IconButton, {
		isCircular = true,
		testId = "build-header-overflow-sheet-button",
		icon = t1.icon,
		variant = ButtonVariant.OverMedia,
		size = InputSize.Medium,
		onActivated = v12,
		LayoutOrder = t1.LayoutOrder
	})
end

return BuildOverflowSheetButton
