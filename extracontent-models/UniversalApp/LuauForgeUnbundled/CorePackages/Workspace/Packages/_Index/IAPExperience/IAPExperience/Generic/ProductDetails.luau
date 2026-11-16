local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local view = Foundation.View

local VirtualItemBadgeType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local ModelViewport = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ModelViewport")
local YellowBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/YellowBadge")

local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local virtualItemBadgeShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/VirtualItemBadgeCounter").VirtualItemBadgeShownCounter

local iconsstatusimageunavailable = images["icons/status/imageunavailable"]

local function withMaxLength(value)
	if #value > 50 then
		return value:sub(1, 50) .. "..."
	end

	return value
end

return function(props)
	local v5 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem"
	})

	local v6 = useTokens()
	local v7 = props.isPortrait and 128 or 80

	local state, setState = React.useState(0)
	local function updateComponentWidth(p2)
		if not p2 then
			return
		end

		local v8 = p2.AbsoluteSize.X - v7 - 6

		if v8 ~= state then
			setState(v8)
		end
	end

	local v8

	if props.model == nil then
		local createElement = React.createElement
		local v10 = {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, v7, 0, v7),
			ScaleType = Enum.ScaleType.Stretch,
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0
		}
		local v11 = if props.itemIcon then props.itemIcon else iconsstatusimageunavailable
		v10.Image = v11
		local v12 = if not props.itemIcon then v6.Color.Content.Default.Color3 else nil
		v10.ImageColor3 = v12
		local v13 = if not props.itemIcon then v6.Color.Content.Default.Transparency else nil
		v10.ImageTransparency = v13
		v8 = createElement(imageSetLabel, v10)
	else
		v8 = React.createElement(ModelViewport, {
			model = props.model,
			Position = UDim2.fromOffset(5, 5),
			Size = UDim2.fromOffset(v7, v7)
		})
	end

	local v9

	if props.badgeType and props.badgeType == VirtualItemBadgeType.Popular then
		v9 = React.createElement(YellowBadge, {
			LayoutOrder = 2,
			Text = v5.Popular,
			Icon = "icons/menu/fire_fill"
		})
	else
		v9 = nil
	end

	React.useEffect(function()
		if not v9 then
			return
		end

		logger.debug({
			message = "Virtual Item Badge Shown",
			badgeType = props.badgeType
		})

		default:logRobloxTelemetryCounter(virtualItemBadgeShownCounter, 1, {
			badgeType = props.badgeType
		})
	end, {})

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		tag = "auto-y row gap-small align-y-center align-x-left"
	}

	local createElement2 = React.createElement
	local v14 = {
		LayoutOrder = 2,
		onAbsoluteSizeChanged = updateComponentWidth,
		Size = UDim2.new(1, 0, 0, 0),
		tag = "col auto-y gap-small"
	}

	local createElement3 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		Size = UDim2.new(0, state, 0, 0),
		Text = 0,
		tag = "auto-y text-align-x-left text-wrap text-title-medium content-emphasis"
	}
	local v17 = props.itemName

	if #v17 > 50 then
		v17 = v17:sub(1, 50) .. "..."
	end

	v16.Text = v17
	local children = { ItemName = createElement3(text, v16), ItemDetails = 0 }

	local createElement4 = React.createElement
	local v19 = {
		LayoutOrder = 2,
		tag = props.isPortrait and "auto-xy col gap-small align-y-center" or "auto-xy row gap-small align-y-center"
	}

	local v21 = if props.itemRobuxCost then React.createElement(text, {
		LayoutOrder = 1,
		Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, props.itemRobuxCost),
		tag = "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"
	}) else nil
	children.ItemDetails = createElement4(view, v19, { ItemCost = v21, ItemBadge = v9 })
	return createElement(view, v11, {
		ItemIcon = v8,
		ItemDetailsFrame = createElement2(view, v14, children)
	})
end
