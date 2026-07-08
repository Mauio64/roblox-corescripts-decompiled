local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local formatNumber = require(ParentParent.Utility.formatNumber)
local logger = require(ParentParent.Utility.logger)
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Foundation = require(ParentParentParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local View = Foundation.View
local VirtualItemBadgeType = require(ParentParent.Enums.VirtualItemBadgeType)
local ModelViewport = require(ParentParent.Generic.ModelViewport)
local YellowBadge = require(ParentParent.Generic.YellowBadge)
local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local default = require(ParentParentParent.LoggingProtocol).default
local VirtualItemBadgeShownCounter = require(ParentParent.Generic.Events.VirtualItemBadgeCounter).VirtualItemBadgeShownCounter
local v20 = Images["icons/status/imageunavailable"]

local function withMaxLength(s1: string) -- line: 41
	if #s1 > 50 then
		return s1:sub(1, 50) .. "..."
	end

	return s1
end

return function(t1: {[any]: any}) -- line: 57
	-- upvalues: useLocalization (copy), useTokens (copy), React (copy), ModelViewport (copy), ImageSetLabel (copy), v20 (copy), VirtualItemBadgeType (copy), YellowBadge (copy), logger (copy), default (copy), VirtualItemBadgeShownCounter (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy)
	local v24 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem"
	})
	local v25 = useTokens()
	local v26 = not t1.isPortrait and 80 or 128
	local v27, v28 = React.useState(0)

	local function updateComponentWidth(p1) -- line: 66
		-- upvalues: v26 (copy), v27 (copy), v28 (copy)
		if not p1 then
			return
		end

		local v45 = p1.AbsoluteSize.X - v26 - 6

		if v45 ~= v27 then
			v28(v45)
		end
	end

	local v30 = if t1.model == nil then React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 5, 0, 5),
		Size = UDim2.new(0, v26, 0, v26),
		ScaleType = Enum.ScaleType.Stretch,
		Image = if not t1.itemIcon then v20 else t1.itemIcon,
		ImageColor3 = if not t1.itemIcon then v25.Color.Content.Default.Color3 else nil,
		ImageTransparency = if not t1.itemIcon then v25.Color.Content.Default.Transparency else nil
	}) else React.createElement(ModelViewport, {
		model = t1.model,
		Position = UDim2.fromOffset(5, 5),
		Size = UDim2.fromOffset(v26, v26)
	})
	local v31 = if not t1.badgeType or t1.badgeType ~= VirtualItemBadgeType.Popular then nil else React.createElement(YellowBadge, {
		LayoutOrder = 2,
		Icon = "icons/menu/fire_fill",
		Text = v24.Popular
	})

	React.useEffect(function() -- line: 102
		-- upvalues: v31 (copy), logger (copy), t1 (copy), default (copy), VirtualItemBadgeShownCounter (copy)
		if not v31 then
			return
		end

		logger.debug({
			message = "Virtual Item Badge Shown",
			badgeType = t1.badgeType
		})
		default:logRobloxTelemetryCounter(VirtualItemBadgeShownCounter, 1, {
			badgeType = t1.badgeType
		})
	end, {})

	local createElement = React.createElement
	local v33 = View
	local t2 = {
		tag = "auto-y row gap-small align-y-center align-x-left",
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local t3 = {
		ItemIcon = v30
	}
	local createElement2 = React.createElement
	local v37 = View
	local t4 = {
		LayoutOrder = 2,
		tag = "col auto-y gap-small",
		onAbsoluteSizeChanged = updateComponentWidth,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local t5 = {}
	local createElement3 = React.createElement
	local v41 = FoundationText
	local t6 = {
		LayoutOrder = 1,
		tag = "auto-y text-align-x-left text-wrap text-title-medium content-emphasis",
		Size = UDim2.new(0, v27, 0, 0)
	}
	local itemName = t1.itemName

	t6.Text = if not (#itemName > 50) then itemName else itemName:sub(1, 50) .. "..."
	t5.ItemName = createElement3(v41, t6)
	t5.ItemDetails = React.createElement(View, {
		LayoutOrder = 2,
		tag = not t1.isPortrait and "auto-xy row gap-small align-y-center" or "auto-xy col gap-small align-y-center"
	}, {
		ItemCost = if not t1.itemRobuxCost then nil else React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis",
			Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.itemRobuxCost)
		}),
		ItemBadge = v31
	})
	t3.ItemDetailsFrame = createElement2(v37, t4, t5)

	return createElement(v33, t2, t3)
end
