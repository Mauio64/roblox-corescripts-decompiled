local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local divider = Foundation.Divider
local dividerOrientation = Foundation.Enums.DividerOrientation
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")

local function ResponsivePanelLayout(props)
	local panelConfig = props.panelConfig

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = panelConfig.tag,
		LayoutOrder = props.LayoutOrder,
		ClipsDescendants = true
	}
	local v7

	if props.renderFirstPanel then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v9 = if props.renderSecondPanel then panelConfig.panelSizes.first else UDim2.new(1, 0, 1, 0)
		local v8 = { Size = v9, LayoutOrder = panelConfig.layoutOrder.first }

		local v11 = if panelConfig.showRightBorder then React.createElement(divider, {
			orientation = dividerOrientation.Vertical,
			Position = UDim2.new(1, -1, 0, 0)
		}) else nil
		v7 = createElement2(view2, v8, {
			RightBorder = v11,
			StartSlot = props.renderFirstPanel()
		})
	end

	local v8

	if props.renderSecondPanel then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v10 = if props.renderFirstPanel then panelConfig.panelSizes.second else UDim2.new(1, 0, 1, 0)
		v8 = createElement2(view2, {
			Size = v10,
			LayoutOrder = panelConfig.layoutOrder.second
		}, {
			EndSlot = props.renderSecondPanel()
		})
	end

	return createElement(view, v5, { FirstPanel = v7, SecondPanel = v8 })
end

return ResponsivePanelLayout
