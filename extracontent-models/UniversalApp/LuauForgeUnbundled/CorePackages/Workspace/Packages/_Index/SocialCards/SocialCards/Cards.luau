local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")

local altTextCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components").AltTextCard.AltTextCard
local cardComponent = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/utils").CardsHelper.CardComponent
require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/CardsType")

local useTokens = Foundation.Hooks.useTokens

local v5 = {
	anchorPoint = Vector2.new(0, 0),
	layoutOrder = 1,
	position = UDim2.fromScale(0, 0)
}

local function Cards(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useTokens()

	local v7 = React.useCallback(function(p3)
		local children = {}

		for i, component in ipairs(p3.components) do
			if cardComponent[component.type] then
				local data = component.data

				if union.analyticsInfo then
					data = Cryo.Dictionary.join(data, union.analyticsInfo)
				end

				table.insert(children, React.createElement(cardComponent[component.type], data))
			else
				children = { React.createElement(altTextCard, {
						altText = p3.alt_text
					}) }
				break
			end
		end

		return React.createElement(
			Foundation.View,
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = v6.Color.Shift.Shift_200,
				cornerRadius = UDim.new(0, v6.Radius.Large)
			},
			children
		)
	end, {})

	local v8 = {}

	for k, card in pairs(union.cards) do
		table.insert(v8, v7(card))
	end

	return React.createElement(
		Foundation.View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			AnchorPoint = union.anchorPoint,
			Position = union.position,
			LayoutOrder = union.layoutOrder
		},
		v8
	)
end

return Cards
