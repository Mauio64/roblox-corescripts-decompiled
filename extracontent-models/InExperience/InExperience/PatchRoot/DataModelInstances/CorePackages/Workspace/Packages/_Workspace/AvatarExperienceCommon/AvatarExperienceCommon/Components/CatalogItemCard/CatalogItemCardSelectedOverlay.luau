local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardComponents = AvatarExperienceUIKit.ItemCardComponents

local ItemCardIcon = ItemCardComponents.ItemCardIcon
local ItemCardBadge = ItemCardComponents.ItemCardBadge
local Responsive = require(parent.Responsive)
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local useSelectedOverlayButton = require(script.Parent.useSelectedOverlayButton)

local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXFixBadgeStatusConfigOptions = AvatarExperienceFlags.FFlagAXFixBadgeStatusConfigOptions
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local FFlagAXMarketplaceItemCardIndicatorStack = AvatarExperienceFlags.FFlagAXMarketplaceItemCardIndicatorStack

local function fn(badge)
	local v = {
		{ type = "icon", icon = badge.icon }
	}

	if badge.text then
		table.insert(v, { type = "text", text = badge.text })
	end

	return v
end

local function CatalogItemCardSelectedOverlay(props)
	local v = useTokens()
	local v2, v3, v4

	if FFlagAXMarketplaceItemCardIndicatorStack then
		local v5 = useSelectedOverlayButton(props.buttonText ~= nil)
		v2 = v5.isVisible
		v3 = v5.bottomOffset
		v4 = v5.height
	else
		local v5 = useLastInput()
		local v6 = useIsSpatial()
		local v7

		if v5 == Responsive.Input.Directional then
			v7 = not v6
		else
			v7 = false
		end

		v3 = v.Gap.XXSmall
		v4 = v.Size.Size_700
		v2 = not v7
	end

	local createElement = React.createElement

	local v5 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2
	}
	local v6 = {
		CatalogItemCardSelectedOverlayCornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v.Radius.Medium)
		}),
		CatalogItemCardSelectedOverlayStroke = 0,
		CatalogItemCardSelectedOverlayBadge = 0,
		CatalogItemCardSelectedOverlayItemStatusIcon = 0,
		CatalogItemCardSelectedOverlayButton = 0
	}
	local catalogItemCardSelectedOverlayStroke

	if not props.suppressBorder then
		catalogItemCardSelectedOverlayStroke = React.createElement("UIStroke", {
			Color = v.Color.Content.Emphasis.Color3,
			Transparency = v.Color.Content.Emphasis.Transparency,
			Thickness = v.Stroke.Standard,
			LineJoinMode = Enum.LineJoinMode.Round,
			[React.Tag] = "data-testid=selection-stroke"
		})
	end

	v6.CatalogItemCardSelectedOverlayStroke = catalogItemCardSelectedOverlayStroke
	local catalogItemCardSelectedOverlayBadge

	if props.badge then
		local createElement2 = React.createElement
		local v7 = {
			tag = "padding-top-small padding-left-small",
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}

		local createElement3 = React.createElement
		local content

		if FFlagAXFixBadgeStatusConfigOptions or FFlagAXShowFaeUpsell then
			content = fn(props.badge)
		else
			content = {
				{ type = "icon", icon = props.badge.icon },
				{ type = "text", text = props.badge.text }
			}
		end

		catalogItemCardSelectedOverlayBadge = createElement2(View, v7, {
			Badge = createElement3(ItemCardBadge, { content = content, displayBorder = true })
		})
	end

	v6.CatalogItemCardSelectedOverlayBadge = catalogItemCardSelectedOverlayBadge
	local catalogItemCardSelectedOverlayItemStatusIcon

	if FFlagAXInventoryDurablesSupport and props.itemStatusIcon and not props.badge then
		catalogItemCardSelectedOverlayItemStatusIcon = React.createElement(
			View,
			{
				tag = "padding-top-small padding-left-small",
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			},
			{
				Icon = React.createElement(ItemCardIcon, { icon = props.itemStatusIcon })
			}
		)
	end

	v6.CatalogItemCardSelectedOverlayItemStatusIcon = catalogItemCardSelectedOverlayItemStatusIcon
	local catalogItemCardSelectedOverlayButton

	if v2 and props.buttonText then
		catalogItemCardSelectedOverlayButton = React.createElement(Button, {
			text = props.buttonText,
			buttonType = ButtonType.PrimarySystem,
			onActivated = props.onActivated,
			isDisabled = false,
			anchorPoint = Vector2.new(0.5, 1),
			position = UDim2.new(0.5, 0, 1, -v3),
			size = UDim2.new(1, -(v.Gap.XXSmall * 2), 0, v4),
			fontStyle = "CaptionHeader"
		})
	end

	v6.CatalogItemCardSelectedOverlayButton = catalogItemCardSelectedOverlayButton
	return createElement("Frame", v5, v6)
end

return CatalogItemCardSelectedOverlay
