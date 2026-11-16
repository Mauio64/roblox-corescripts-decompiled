local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local module = require("@luauforge/deferred/gkN")

local iconSize = Foundation.Enums.IconSize
local getLocalizedPrice = module.Utils.getLocalizedPrice

local useTokens = Foundation.Hooks.useTokens
local timerBadge = module.TimerBadge
local text = Foundation.Text
local view = Foundation.View
local icon = Foundation.Icon

local function HeroUnitHeader(props)
	local v5 = useTokens()
	local titleText = props.titleText
	local descriptionText = props.descriptionText
	local priceInRobux = props.priceInRobux

	local v6 = not (descriptionText == nil) and descriptionText ~= ""

	local titleTag = props.titleTag
	local descriptionTag = props.descriptionTag
	local titleGroupGapTag = props.titleGroupGapTag

	local formatted = `size-full-0 auto-y text-wrap text-align-x-left content-emphasis {titleTag}`
	local formatted2 = `size-full-0 auto-y text-wrap text-align-x-left content-default {descriptionTag}`

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = 2,
		tag = `col align-x-left size-full-0 auto-y {titleGroupGapTag}`
	}

	local v10 = if titleText then React.createElement(text, {
		LayoutOrder = 1,
		Text = titleText,
		tag = formatted
	}) else nil

	local v11 = if v6 then React.createElement(text, {
		LayoutOrder = 2,
		tag = formatted2,
		Text = descriptionText
	}) else nil

	local v12 = if priceInRobux ~= nil then React.createElement(
		view,
		{ LayoutOrder = 3, tag = "row align-y-center gap-xsmall auto-xy" },
		{
			RobuxIcon = React.createElement(icon, {
				LayoutOrder = 1,
				name = "robux",
				style = v5.Color.Content.Default,
				size = iconSize.Small
			}),
			Price = React.createElement(text, {
				LayoutOrder = 2,
				Text = getLocalizedPrice(priceInRobux),
				tag = "auto-xy text-body-large content-default"
			})
		}
	) else nil
	local element = createElement(view, v8, {
		Title = v10,
		Description = v11,
		PriceLine = v12
	})

	if props.centerTitleGroup then
		if props.bottomSlot then
			local createElement2 = React.createElement
			local v14 = {
				LayoutOrder = props.LayoutOrder,
				tag = "col flex-y-between align-x-left size-full"
			}

			local createElement3 = React.createElement
			local v16 = {
				LayoutOrder = 1,
				Size = UDim2.new(0, 0, 0, 0),
				tag = "auto-xy"
			}

			local v18 = if props.availableUntil then React.createElement(timerBadge, {
				endTime = props.availableUntil
			}) else nil
			return createElement2(view, v14, {
				TopSlot = createElement3(view, v16, { Badge = v18 }),
				TitleGroup = element,
				BottomSlot = React.createElement(
					view,
					{ LayoutOrder = 3, Size = UDim2.new(0, 0, 0, 0), tag = "auto-xy" },
					{ Slot = props.bottomSlot }
				)
			})
		else
			local createElement2 = React.createElement
			local v14 = { LayoutOrder = props.LayoutOrder, tag = "size-full" }

			local v16 = if props.availableUntil then React.createElement(
				view,
				{ Size = UDim2.new(0, 0, 0, 0), tag = "auto-xy" },
				{
					Badge = React.createElement(timerBadge, {
						endTime = props.availableUntil
					})
				}
			) else nil
			return createElement2(view, v14, {
				TopSlot = v16,
				TitleGroup = React.createElement(view, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					tag = "col align-x-left"
				}, { Content = element })
			})
		end
	else
		local badgeGapTag = props.badgeGapTag or "gap-large"
		local createElement2 = React.createElement
		local v14 = {
			LayoutOrder = props.LayoutOrder,
			tag = `col align-x-left size-full-0 auto-y {badgeGapTag}`
		}

		local v16 = if props.availableUntil then React.createElement(timerBadge, {
			LayoutOrder = 1,
			endTime = props.availableUntil
		}) else nil

		local v17 = if props.bottomSlot then React.createElement(
			view,
			{ LayoutOrder = 3, Size = UDim2.new(0, 0, 0, 0), tag = "auto-xy" },
			{ Slot = props.bottomSlot }
		) else nil
		return createElement2(view, v14, {
			Badge = v16,
			TitleGroup = element,
			BottomSlot = v17
		})
	end
end

return HeroUnitHeader
