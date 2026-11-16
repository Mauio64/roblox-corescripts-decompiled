local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemDetails/ItemDetailsView")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/BuyActionBarLayout")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")
local useTokens = Foundation.Hooks.useTokens
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Cryo")

local function ItemDetailsLayout(props)
	local v5 = useTokens()

	local size_2700 = v5.Size.Size_2700

	local v6 = React.useMemo(function()
		return Cryo.Dictionary.join(props.itemDetailsViewProps, {
			buyActionBarOffset = size_2700
		})
	end, { props.itemDetailsViewProps, size_2700 })

	local v7 = props.view == ViewType.Compact
	local createElement = React.createElement
	local view = Foundation.View

	local v9 = {
		ItemDetailsView = React.createElement(module3, v6),
		BuyActionBarLayout = 0
	}

	local v10 = if v7 then React.createElement(module4, {
		buyActionBarProps = props.buyActionBarProps,
		enableTopBorder = true,
		ZIndex = 2,
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		padding = UDim.new(0, v5.Padding.Medium),
		Size = UDim2.new(1, 0, 0, size_2700)
	}) else nil
	v9.BuyActionBarLayout = v10
	return createElement(view, { tag = "size-full" }, v9)
end

return ItemDetailsLayout
