local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local educationalTooltip = Foundation.EducationalTooltip

local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local function DisabledPlaytestTooltip(props)
	local v5 = useLocalization({
		text = LocalizationStrings.PLAYTEST_DISABLED_TOOLTIP,
		title = LocalizationStrings.PLAYTEST_TITLE
	})

	local text = v5.text
	local title = v5.title

	return React.createElement(educationalTooltip, {
		LayoutOrder = props.LayoutOrder,
		align = popoverAlign.End,
		hasActions = false,
		hasSecondaryButtons = false,
		isOpen = props.isOpen,
		onPressedOutside = props.onPressedOutside,
		showSteps = false,
		side = popoverSide.Bottom,
		text = text,
		testId = "build-disabled-playtest-tooltip",
		title = title
	}, props.children)
end

return DisabledPlaytestTooltip
