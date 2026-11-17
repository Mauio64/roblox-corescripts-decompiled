local parent = script.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

local Components = require(parent.Components)
local AltTextCard = Components.AltTextCard.AltTextCard
local utils = require(parent.utils)
local cardComponent = utils.CardsHelper.CardComponent
require(parent.CardsType)

local useTokens = Foundation.Hooks.useTokens

local v = { anchorPoint = Vector2.new(0, 0), layoutOrder = 1, position = UDim2.fromScale(0, 0) }

local function renderCard(card, conversationId: string?, analyticsInfo, p)
	local children = {}

	for _, component in ipairs(card.components) do
		if cardComponent[component.type] then
			local joined = Cryo.Dictionary.join(component.data, { conversationId = conversationId })

			if analyticsInfo then
				joined = Cryo.Dictionary.join(joined, analyticsInfo)
			end

			table.insert(children, React.createElement(cardComponent[component.type], joined))
		else
			children = { React.createElement(AltTextCard, { altText = card.alt_text }) }
			break
		end
	end

	return React.createElement(
		Foundation.View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = p.Color.Shift.Shift_200,
			cornerRadius = UDim.new(0, p.Radius.Large)
		},
		children
	)
end

local function Cards(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useTokens()

	local v3 = {}

	for _, card in pairs(union.cards) do
		table.insert(v3, renderCard(card, union.conversationId, union.analyticsInfo, v2))
	end

	return React.createElement(
		Foundation.View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			AnchorPoint = union.anchorPoint,
			Position = union.position,
			LayoutOrder = union.layoutOrder
		},
		v3
	)
end

return Cards
