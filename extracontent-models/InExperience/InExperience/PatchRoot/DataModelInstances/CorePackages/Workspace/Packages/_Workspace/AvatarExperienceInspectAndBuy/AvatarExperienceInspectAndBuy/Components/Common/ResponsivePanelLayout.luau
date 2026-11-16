local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Divider = Foundation.Divider
local DividerOrientation = Foundation.Enums.DividerOrientation
require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local function ResponsivePanelLayout(props)
	local panelConfig = props.panelConfig

	local createElement = React.createElement
	local view = Foundation.View
	local v = { tag = panelConfig.tag, LayoutOrder = props.LayoutOrder, ClipsDescendants = true }
	local firstPanel

	if props.renderFirstPanel then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local size

		if props.renderSecondPanel then
			size = panelConfig.panelSizes.first
		else
			size = UDim2.new(1, 0, 1, 0)
		end

		local v2 = { Size = size, LayoutOrder = panelConfig.layoutOrder.first }
		local rightBorder

		if panelConfig.showRightBorder then
			rightBorder = React.createElement(Divider, {
				orientation = DividerOrientation.Vertical,
				Position = UDim2.new(1, -1, 0, 0)
			})
		end

		firstPanel = createElement2(view2, v2, {
			RightBorder = rightBorder,
			StartSlot = props.renderFirstPanel()
		})
	end

	local secondPanel

	if props.renderSecondPanel then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local size

		if props.renderFirstPanel then
			size = panelConfig.panelSizes.second
		else
			size = UDim2.new(1, 0, 1, 0)
		end

		secondPanel = createElement2(view2, {
			Size = size,
			LayoutOrder = panelConfig.layoutOrder.second
		}, {
			EndSlot = props.renderSecondPanel()
		})
	end

	return createElement(view, v, { FirstPanel = firstPanel, SecondPanel = secondPanel })
end

return ResponsivePanelLayout
