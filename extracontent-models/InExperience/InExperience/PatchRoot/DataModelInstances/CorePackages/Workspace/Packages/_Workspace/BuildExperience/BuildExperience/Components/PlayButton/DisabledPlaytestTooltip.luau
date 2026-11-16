local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local EducationalTooltip = Foundation.EducationalTooltip

local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function DisabledPlaytestTooltip(props)
	local v = useLocalization({
		text = LocalizationStrings.PLAYTEST_DISABLED_TOOLTIP,
		title = LocalizationStrings.PLAYTEST_TITLE
	})

	local text = v.text
	local title = v.title

	return React.createElement(EducationalTooltip, {
		LayoutOrder = props.LayoutOrder,
		align = PopoverAlign.End,
		hasActions = false,
		hasSecondaryButtons = false,
		isOpen = props.isOpen,
		onPressedOutside = props.onPressedOutside,
		showSteps = false,
		side = PopoverSide.Bottom,
		text = text,
		testId = "build-disabled-playtest-tooltip",
		title = title
	}, props.children)
end

return DisabledPlaytestTooltip
