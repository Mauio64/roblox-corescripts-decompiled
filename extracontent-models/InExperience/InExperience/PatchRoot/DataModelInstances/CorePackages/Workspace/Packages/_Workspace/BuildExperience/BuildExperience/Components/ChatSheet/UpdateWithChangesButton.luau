local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Button = Foundation.Button

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function UpdateWithChangesButton(p)
	local v = useLocalization({ updateWithChanges = LocalizationStrings.CHAT_UPDATE_WITH_CHANGES })

	return React.createElement(Button, {
		text = v.updateWithChanges,
		size = InputSize.Medium,
		variant = ButtonVariant.Emphasis,
		width = UDim.new(1, 0),
		onActivated = p.onActivated,
		LayoutOrder = p.LayoutOrder
	})
end

return UpdateWithChangesButton
