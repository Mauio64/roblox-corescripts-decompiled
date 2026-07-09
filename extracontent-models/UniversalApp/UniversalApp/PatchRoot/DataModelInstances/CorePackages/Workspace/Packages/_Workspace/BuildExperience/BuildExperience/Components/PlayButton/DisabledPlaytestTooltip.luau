local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local EducationalTooltip = Foundation.EducationalTooltip
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function DisabledPlaytestTooltip(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), EducationalTooltip (copy), PopoverAlign (copy), PopoverSide (copy)
	return React.createElement(EducationalTooltip, {
		hasActions = false,
		hasSecondaryButtons = false,
		showSteps = false,
		text = "Once you have your first build ready, tap here to begin playtesting",
		title = "Playtest",
		LayoutOrder = t1.LayoutOrder,
		align = PopoverAlign.End,
		isOpen = t1.isOpen,
		side = PopoverSide.Bottom
	}, t1.children)
end

return DisabledPlaytestTooltip
