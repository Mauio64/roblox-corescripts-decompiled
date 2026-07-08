local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Cryo = require(scriptParentParent.Cryo)
local Foundation = require(scriptParentParent.Foundation)
local React = require(scriptParentParent.React)
local AltTextCard = require(scriptParent.Components).AltTextCard.AltTextCard
local CardComponent = require(scriptParent.utils).CardsHelper.CardComponent

require(scriptParent.CardsType)

local useTokens = Foundation.Hooks.useTokens
local t1 = {
	layoutOrder = 1,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.fromScale(0, 0)
}

local function Cards(t2: {[any]: any}) -- line: 30
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), React (copy), CardComponent (copy), AltTextCard (copy), Foundation (copy)
	local v12 = Cryo.Dictionary.union(t1, t2)
	local v13 = useTokens()
	local v14 = React.useCallback(function(p1) -- line: 34
		-- upvalues: CardComponent (copy), v12 (copy), Cryo (copy), React (copy), AltTextCard (copy), Foundation (copy), v13 (copy)
		local t3 = {}

		for _, v in ipairs(p1.components) do
			if not CardComponent[v.type] then
				t3 = { React.createElement(AltTextCard, {
					altText = p1.alt_text
				}) }

				return React.createElement(Foundation.View, {
					AutomaticSize = Enum.AutomaticSize.XY,
					backgroundStyle = v13.Color.Shift.Shift_200,
					cornerRadius = UDim.new(0, v13.Radius.Large)
				}, t3)
			end

			local data = v.data

			if v12.analyticsInfo then
				data = Cryo.Dictionary.join(data, v12.analyticsInfo)
			end

			table.insert(t3, React.createElement(CardComponent[v.type], data))
		end

		return React.createElement(Foundation.View, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v13.Color.Shift.Shift_200,
			cornerRadius = UDim.new(0, v13.Radius.Large)
		}, t3)
	end, {})
	local t4 = {}

	for _, v in pairs(v12.cards) do
		table.insert(t4, v14(v))
	end

	return React.createElement(Foundation.View, {
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = v12.anchorPoint,
		Position = v12.position,
		LayoutOrder = v12.layoutOrder
	}, t4)
end

return Cards
