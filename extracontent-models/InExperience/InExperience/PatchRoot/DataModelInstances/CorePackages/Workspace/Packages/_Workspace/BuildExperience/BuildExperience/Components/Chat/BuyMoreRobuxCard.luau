local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ChatCardPriority = require(script.Parent.ChatCardEmphasis.ChatCardPriority)
local useChatCardEmphasis = require(script.Parent.ChatCardEmphasis.useChatCardEmphasis)

local FFlagBuildExperienceBuyMoreRobuxCardLayout = require(BuildExperience.Flags.FFlagBuildExperienceBuyMoreRobuxCardLayout)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function BuyMoreRobuxCard(props)
	local v

	if FFlagBuildExperienceChatCardEmphasis then
		v = useChatCardEmphasis(ChatCardPriority.BuyMoreRobux)
	end

	local element = React.createElement(Text, {
		LayoutOrder = 1,
		Text = props.title,
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
	})

	local element2 = React.createElement(Text, {
		LayoutOrder = 2,
		Text = props.description,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
	})

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["col size-full-0 auto-y padding-large stroke-standard stroke-default radius-large"] = true,
			["gap-large"] = FFlagBuildExperienceBuyMoreRobuxCardLayout,
			["gap-medium"] = not FFlagBuildExperienceBuyMoreRobuxCardLayout
		},
		testId = "BuyMoreRobuxCard"
	}
	local copy

	if FFlagBuildExperienceBuyMoreRobuxCardLayout then
		copy = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, {
			Title = element,
			Description = element2
		})
	end

	if FFlagBuildExperienceBuyMoreRobuxCardLayout then
		element = nil
	end

	if FFlagBuildExperienceBuyMoreRobuxCardLayout then
		element2 = nil
	end

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		text = props.primaryActionText,
		size = InputSize.Small,
		variant = 0,
		fillBehavior = 0,
		onActivated = 0,
		testId = "BuyMoreRobuxCard.PrimaryAction"
	}
	local variant

	if v == false then
		variant = ButtonVariant.SoftEmphasis
	else
		variant = ButtonVariant.Emphasis
	end

	v3.variant = variant
	v3.fillBehavior = FillBehavior.Fill
	v3.onActivated = props.onPrimaryAction
	return createElement(View, v2, {
		Copy = copy,
		Title = element,
		Description = element2,
		Actions = createElement2(View, {
			LayoutOrder = FFlagBuildExperienceBuyMoreRobuxCardLayout and 2 or 3,
			tag = "row gap-small size-full-0 auto-y"
		}, {
			PrimaryAction = createElement3(Button, v3),
			SecondaryAction = React.createElement(Button, {
				LayoutOrder = 2,
				text = props.secondaryActionText,
				size = InputSize.Small,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				onActivated = props.onSecondaryAction,
				testId = "BuyMoreRobuxCard.SecondaryAction"
			})
		})
	})
end

return BuyMoreRobuxCard
