local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local Divider = Foundation.Divider
local DividerOrientation = Foundation.Enums.DividerOrientation

require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local function ResponsivePanelLayout(t1: {[any]: any}) -- line: 78
	-- upvalues: React (copy), Foundation (copy), Divider (copy), DividerOrientation (copy)
	local panelConfig = t1.panelConfig

	return React.createElement(Foundation.View, {
		ClipsDescendants = true,
		tag = panelConfig.tag,
		LayoutOrder = t1.LayoutOrder
	}, {
		FirstPanel = if not t1.renderFirstPanel then nil else React.createElement(Foundation.View, {
			Size = if not t1.renderSecondPanel then UDim2.new(1, 0, 1, 0) else panelConfig.panelSizes.first,
			LayoutOrder = panelConfig.layoutOrder.first
		}, {
			RightBorder = if not panelConfig.showRightBorder then nil else React.createElement(Divider, {
				orientation = DividerOrientation.Vertical,
				Position = UDim2.new(1, -1, 0, 0)
			}),
			StartSlot = t1.renderFirstPanel()
		}),
		SecondPanel = if not t1.renderSecondPanel then nil else React.createElement(Foundation.View, {
			Size = if not t1.renderFirstPanel then UDim2.new(1, 0, 1, 0) else panelConfig.panelSizes.second,
			LayoutOrder = panelConfig.layoutOrder.second
		}, {
			EndSlot = t1.renderSecondPanel()
		})
	})
end

return ResponsivePanelLayout
