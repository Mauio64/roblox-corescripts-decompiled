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

local function Cards(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useTokens()

	local v3 = React.useCallback(function(p2)
		local children = {}

		for _, component in ipairs(p2.components) do
			if cardComponent[component.type] then
				local data = component.data

				if union.analyticsInfo then
					data = Cryo.Dictionary.join(data, union.analyticsInfo)
				end

				table.insert(children, React.createElement(cardComponent[component.type], data))
			else
				children = { React.createElement(AltTextCard, { altText = p2.alt_text }) }
				break
			end
		end

		return React.createElement(
			Foundation.View,
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = v2.Color.Shift.Shift_200,
				cornerRadius = UDim.new(0, v2.Radius.Large)
			},
			children
		)
	end, {})

	local v4 = {}

	for _, card in pairs(union.cards) do
		table.insert(v4, v3(card))
	end

	return React.createElement(
		Foundation.View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			AnchorPoint = union.anchorPoint,
			Position = union.position,
			LayoutOrder = union.layoutOrder
		},
		v4
	)
end

return Cards
