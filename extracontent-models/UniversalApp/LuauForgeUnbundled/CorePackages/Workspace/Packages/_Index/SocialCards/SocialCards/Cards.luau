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

local function renderCard(card, conversationId, analyticsInfo, p2)
	local children = {}

	for i, component in ipairs(card.components) do
		if cardComponent[component.type] then
			local joined = Cryo.Dictionary.join(component.data, {
				conversationId = conversationId
			})

			if analyticsInfo then
				joined = Cryo.Dictionary.join(joined, analyticsInfo)
			end

			table.insert(children, React.createElement(cardComponent[component.type], joined))
		else
			children = { React.createElement(altTextCard, {
					altText = card.alt_text
				}) }
			break
		end
	end

	return React.createElement(
		Foundation.View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = p2.Color.Shift.Shift_200,
			cornerRadius = UDim.new(0, p2.Radius.Large)
		},
		children
	)
end

local function Cards(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useTokens()

	local v7 = {}

	for k, card in pairs(union.cards) do
		table.insert(v7, renderCard(card, union.conversationId, union.analyticsInfo, v6))
	end

	return React.createElement(
		Foundation.View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			AnchorPoint = union.anchorPoint,
			Position = union.position,
			LayoutOrder = union.layoutOrder
		},
		v7
	)
end

return Cards
