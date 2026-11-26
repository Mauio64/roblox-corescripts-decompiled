local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local ChatCardPriority = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardPriority")
local useChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/useChatCardEmphasis")

local FFlagBuildExperienceBuyMoreRobuxCardLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceBuyMoreRobuxCardLayout")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function BuyMoreRobuxCard(props)
	local v5 = if FFlagBuildExperienceChatCardEmphasis then useChatCardEmphasis(ChatCardPriority.BuyMoreRobux) else nil

	local element = React.createElement(text, {
		LayoutOrder = 1,
		Text = props.title,
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
	})

	local element2 = React.createElement(text, {
		LayoutOrder = 2,
		Text = props.description,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
	})

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["col size-full-0 auto-y padding-large stroke-standard stroke-default radius-large"] = true,
			["gap-large"] = FFlagBuildExperienceBuyMoreRobuxCardLayout,
			["gap-medium"] = not FFlagBuildExperienceBuyMoreRobuxCardLayout
		},
		testId = "BuyMoreRobuxCard"
	}

	local v9 = if FFlagBuildExperienceBuyMoreRobuxCardLayout then React.createElement(
		view,
		{ LayoutOrder = 1, tag = "col gap-xxsmall size-full-0 auto-y" },
		{ Title = element, Description = element2 }
	) else nil

	if FFlagBuildExperienceBuyMoreRobuxCardLayout then
		element = nil
	end

	if FFlagBuildExperienceBuyMoreRobuxCardLayout then
		element2 = nil
	end

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v13 = {
		LayoutOrder = 1,
		text = props.primaryActionText,
		size = inputSize.Small,
		variant = 0,
		fillBehavior = 0,
		onActivated = 0,
		testId = "BuyMoreRobuxCard.PrimaryAction"
	}
	local v14 = if v5 == false then buttonVariant.SoftEmphasis else buttonVariant.Emphasis
	v13.variant = v14
	v13.fillBehavior = fillBehavior.Fill
	v13.onActivated = props.onPrimaryAction
	return createElement(view, v7, {
		Copy = v9,
		Title = element,
		Description = element2,
		Actions = createElement2(view, {
			LayoutOrder = FFlagBuildExperienceBuyMoreRobuxCardLayout and 2 or 3,
			tag = "row gap-small size-full-0 auto-y"
		}, {
			PrimaryAction = createElement3(button, v13),
			SecondaryAction = React.createElement(button, {
				LayoutOrder = 2,
				text = props.secondaryActionText,
				size = inputSize.Small,
				variant = buttonVariant.Standard,
				fillBehavior = fillBehavior.Fill,
				onActivated = props.onSecondaryAction,
				testId = "BuyMoreRobuxCard.SecondaryAction"
			})
		})
	})
end

return BuyMoreRobuxCard
