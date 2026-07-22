local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local EducationalTooltip = Foundation.EducationalTooltip
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function DisabledPlaytestTooltip(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), EducationalTooltip (copy), PopoverAlign (copy), PopoverSide (copy), LocalizationStrings (copy)
	return React.createElement(EducationalTooltip, {
		hasActions = false,
		hasSecondaryButtons = false,
		showSteps = false,
		LayoutOrder = t1.LayoutOrder,
		align = PopoverAlign.End,
		isOpen = t1.isOpen,
		side = PopoverSide.Bottom,
		text = LocalizationStrings.PLAYTEST_DISABLED_TOOLTIP,
		title = LocalizationStrings.PLAYTEST_TITLE
	}, t1.children)
end

return DisabledPlaytestTooltip
