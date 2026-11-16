local parent = script.Parent.Parent
local parent2 = parent.Parent

local formatNumber = require(parent.Utility.formatNumber)
local logger = require(parent.Utility.logger)

local React = require(parent2.React)

local UIBlox = require(parent2.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(parent2.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local View = Foundation.View

local VirtualItemBadgeType = require(parent.Enums.VirtualItemBadgeType)

local ModelViewport = require(parent.Generic.ModelViewport)
local YellowBadge = require(parent.Generic.YellowBadge)

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local VirtualItemBadgeCounter = require(parent.Generic.Events.VirtualItemBadgeCounter)
local VirtualItemBadgeShownCounter = VirtualItemBadgeCounter.VirtualItemBadgeShownCounter

local iconsstatusimageunavailable = Images["icons/status/imageunavailable"]

local function withMaxLength(itemName: string) -- 1 equivalent call inferred from this helper
	if #itemName > 50 then
		return itemName:sub(1, 50) .. "..."
	end

	return itemName
end

return function(props)
	local v = useLocalization({ Popular = "IAPExperience.RobuxUpsell.Text.PopularItem" })

	local v2 = useTokens()
	local v3 = props.isPortrait and 128 or 80

	local state, setState = React.useState(0)
	local function updateComponentWidth(p)
		if not p then
			return
		end

		local v4 = p.AbsoluteSize.X - v3 - 6

		if v4 ~= state then
			setState(v4)
		end
	end

	local itemIcon

	if props.model == nil then
		local createElement = React.createElement
		local v4 = {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, v3, 0, v3),
			ScaleType = Enum.ScaleType.Stretch,
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0
		}
		local image

		if props.itemIcon then
			image = props.itemIcon
		else
			image = iconsstatusimageunavailable
		end

		v4.Image = image
		local imageColor

		if not props.itemIcon then
			imageColor = v2.Color.Content.Default.Color3
		end

		v4.ImageColor3 = imageColor
		local imageTransparency

		if not props.itemIcon then
			imageTransparency = v2.Color.Content.Default.Transparency
		end

		v4.ImageTransparency = imageTransparency
		itemIcon = createElement(ImageSetLabel, v4)
	else
		itemIcon = React.createElement(ModelViewport, {
			model = props.model,
			Position = UDim2.fromOffset(5, 5),
			Size = UDim2.fromOffset(v3, v3)
		})
	end

	local itemBadge

	if props.badgeType and props.badgeType == VirtualItemBadgeType.Popular then
		itemBadge = React.createElement(YellowBadge, {
			LayoutOrder = 2,
			Text = v.Popular,
			Icon = "icons/menu/fire_fill"
		})
	else
		itemBadge = nil
	end

	React.useEffect(function()
		if not itemBadge then
			return
		end

		logger.debug({ message = "Virtual Item Badge Shown", badgeType = props.badgeType })

		default:logRobloxTelemetryCounter(VirtualItemBadgeShownCounter, 1, {
			badgeType = props.badgeType
		})
	end, {})

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		tag = "auto-y row gap-small align-y-center align-x-left"
	}

	local createElement2 = React.createElement
	local v5 = {
		LayoutOrder = 2,
		onAbsoluteSizeChanged = updateComponentWidth,
		Size = UDim2.new(1, 0, 0, 0),
		tag = "col auto-y gap-small"
	}

	local children = {
		ItemName = React.createElement(Text, {
			LayoutOrder = 1,
			Size = UDim2.new(0, state, 0, 0),
			Text = withMaxLength(props.itemName), -- inferred equivalent call
			tag = "auto-y text-align-x-left text-wrap text-title-medium content-emphasis"
		}),
		ItemDetails = 0
	}

	local createElement3 = React.createElement
	local v6 = {
		LayoutOrder = 2,
		tag = props.isPortrait and "auto-xy col gap-small align-y-center" or "auto-xy row gap-small align-y-center"
	}
	local itemCost

	if props.itemRobuxCost then
		itemCost = React.createElement(Text, {
			LayoutOrder = 1,
			Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, props.itemRobuxCost),
			tag = "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"
		})
	end

	children.ItemDetails = createElement3(View, v6, { ItemCost = itemCost, ItemBadge = itemBadge })
	return createElement(View, v4, {
		ItemIcon = itemIcon,
		ItemDetailsFrame = createElement2(View, v5, children)
	})
end
