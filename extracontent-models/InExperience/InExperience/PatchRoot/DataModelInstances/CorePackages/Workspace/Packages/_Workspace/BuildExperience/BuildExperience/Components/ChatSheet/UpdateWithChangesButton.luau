local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function UpdateWithChangesButton(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), Button (copy), LocalizationStrings (copy), InputSize (copy), ButtonVariant (copy)
	return React.createElement(Button, {
		text = LocalizationStrings.CHAT_UPDATE_WITH_CHANGES,
		size = InputSize.Medium,
		variant = ButtonVariant.Emphasis,
		width = UDim.new(1, 0),
		onActivated = t1.onActivated,
		LayoutOrder = t1.LayoutOrder
	})
end

return UpdateWithChangesButton
