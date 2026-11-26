local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/UIBlox")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local itemCardComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit").ItemCardComponents

local itemCardIcon = itemCardComponents.ItemCardIcon
local itemCardBadge = itemCardComponents.ItemCardBadge
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive")
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local useSelectedOverlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/useSelectedOverlayButton")

local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXFixBadgeStatusConfigOptions = AvatarExperienceFlags.FFlagAXFixBadgeStatusConfigOptions
local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local fFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack

local function fn(badge)
	local v5 = {
		{ type = "icon", icon = badge.icon }
	}

	if badge.text then
		table.insert(v5, { type = "text", text = badge.text })
	end

	return v5
end

local function CatalogItemCardSelectedOverlay(props)
	local v5 = useTokens()
	local v6, v7, v8

	if fFlagAXMarketplaceItemCardIndicatorStack then
		local v9 = useSelectedOverlayButton(props.buttonText ~= nil)
		v6 = v9.isVisible
		v7 = v9.bottomOffset
		v8 = v9.height
	else
		local v9 = useLastInput()
		local v10 = useIsSpatial()
		local v11 = v9 == Responsive.Input.Directional and not v10

		v7 = v5.Gap.XXSmall
		v8 = v5.Size.Size_700
		v6 = not v11
	end

	local createElement = React.createElement

	local v10 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2
	}
	local v11 = {
		CatalogItemCardSelectedOverlayCornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Medium)
		}),
		CatalogItemCardSelectedOverlayStroke = 0,
		CatalogItemCardSelectedOverlayBadge = 0,
		CatalogItemCardSelectedOverlayItemStatusIcon = 0,
		CatalogItemCardSelectedOverlayButton = 0
	}
	local v12

	if not props.suppressBorder then
		v12 = React.createElement("UIStroke", {
			Color = v5.Color.Content.Emphasis.Color3,
			Transparency = v5.Color.Content.Emphasis.Transparency,
			Thickness = v5.Stroke.Standard,
			LineJoinMode = Enum.LineJoinMode.Round,
			[React.Tag] = "data-testid=selection-stroke"
		})
	end

	v11.CatalogItemCardSelectedOverlayStroke = v12
	local v13

	if props.badge then
		local createElement2 = React.createElement
		local v15 = {
			tag = "padding-top-small padding-left-small",
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}

		local createElement3 = React.createElement

		local v19 = if fFlagAXFixBadgeStatusConfigOptions or fFlagAXShowFaeUpsell then fn(props.badge) else {
			{ type = "icon", icon = props.badge.icon },
			{ type = "text", text = props.badge.text }
		}
		v13 = createElement2(view, v15, {
			Badge = createElement3(itemCardBadge, {
				content = v19,
				displayBorder = true
			})
		})
	end

	v11.CatalogItemCardSelectedOverlayBadge = v13

	local v14 = if fFlagAXInventoryDurablesSupport and props.itemStatusIcon and not props.badge then React.createElement(
		view,
		{
			tag = "padding-top-small padding-left-small",
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		},
		{
			Icon = React.createElement(itemCardIcon, { icon = props.itemStatusIcon })
		}
	) else nil
	v11.CatalogItemCardSelectedOverlayItemStatusIcon = v14

	local v15 = if v6 and props.buttonText then React.createElement(button, {
		text = props.buttonText,
		buttonType = buttonType.PrimarySystem,
		onActivated = props.onActivated,
		isDisabled = false,
		anchorPoint = Vector2.new(0.5, 1),
		position = UDim2.new(0.5, 0, 1, -v7),
		size = UDim2.new(1, -(v5.Gap.XXSmall * 2), 0, v8),
		fontStyle = "CaptionHeader"
	}) else nil
	v11.CatalogItemCardSelectedOverlayButton = v15
	return createElement("Frame", v10, v11)
end

return CatalogItemCardSelectedOverlay
