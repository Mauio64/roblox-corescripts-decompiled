local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local EducationalTooltip = Foundation.EducationalTooltip
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function PrivateShareTooltip(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), EducationalTooltip (copy), PopoverAlign (copy), PopoverSide (copy), LocalizationStrings (copy)
	return React.createElement(EducationalTooltip, {
		hasActions = false,
		hasSecondaryButtons = false,
		showSteps = false,
		testId = "build-private-share-tooltip",
		LayoutOrder = t1.LayoutOrder,
		align = PopoverAlign.End,
		anchorRef = t1.anchorRef,
		isOpen = t1.isOpen,
		side = PopoverSide.Bottom,
		text = LocalizationStrings.SHARE_AUDIENCE_PRIVATE_DESCRIPTION,
		title = LocalizationStrings.SHARE_AUDIENCE_PRIVATE_TITLE
	}, t1.children)
end

return PrivateShareTooltip
