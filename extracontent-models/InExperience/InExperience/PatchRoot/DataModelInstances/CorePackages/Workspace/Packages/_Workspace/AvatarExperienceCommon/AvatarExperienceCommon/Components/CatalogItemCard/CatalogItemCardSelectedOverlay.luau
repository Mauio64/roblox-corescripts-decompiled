local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(Parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local ItemCardComponents = require(Parent.AvatarExperienceUIKit).ItemCardComponents
local ItemCardIcon = ItemCardComponents.ItemCardIcon
local ItemCardBadge = ItemCardComponents.ItemCardBadge
local Responsive = require(Parent.Responsive)
local useLastInput = Responsive.useLastInput
local useIsSpatial = Responsive.useIsSpatial
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXFixBadgeStatusConfigOptions = AvatarExperienceFlags.FFlagAXFixBadgeStatusConfigOptions
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local FFlagAXSelectedBorderWrapsBackground = AvatarExperienceFlags.FFlagAXSelectedBorderWrapsBackground

local function v20(t1: {[any]: any}) -- line: 43
	local t2 = {{
		type = "icon",
		icon = t1.icon
	}}

	if t1.text then
		table.insert(t2, {
			type = "text",
			text = t1.text
		})
	end

	return t2
end
local function CatalogItemCardSelectedOverlay(t3: {[any]: any}) -- line: 55
	-- upvalues: useTokens (copy), useLastInput (copy), useIsSpatial (copy), Responsive (copy), React (copy), FFlagAXSelectedBorderWrapsBackground (copy), View (copy), ItemCardBadge (copy), FFlagAXFixBadgeStatusConfigOptions (copy), FFlagAXShowFaeUpsell (copy), v20 (copy), FFlagAXInventoryDurablesSupport (copy), ItemCardIcon (copy), Button (copy), ButtonType (copy)
	local v25 = useTokens()
	local v26 = useLastInput()
	local v27 = useIsSpatial()
	local v28 = v26 == Responsive.Input.Directional and not v27

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		Size = UDim2.fromScale(1, 1)
	}, {
		CatalogItemCardSelectedOverlayCornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v25.Radius.Medium)
		}),
		CatalogItemCardSelectedOverlayStroke = if not not FFlagAXSelectedBorderWrapsBackground and t3.suppressBorder then nil else React.createElement("UIStroke", {
			Color = v25.Color.Content.Emphasis.Color3,
			Transparency = v25.Color.Content.Emphasis.Transparency,
			Thickness = v25.Stroke.Standard,
			LineJoinMode = Enum.LineJoinMode.Round,
			[React.Tag] = "data-testid=selection-stroke"
		}),
		CatalogItemCardSelectedOverlayBadge = if not t3.badge then nil else React.createElement(View, {
			tag = "padding-top-small padding-left-small",
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Badge = React.createElement(ItemCardBadge, {
				displayBorder = true,
				content = if not FFlagAXFixBadgeStatusConfigOptions and not FFlagAXShowFaeUpsell then {
					{
						type = "icon",
						icon = t3.badge.icon
					},
					{
						type = "text",
						text = t3.badge.text
					}
				} else v20(t3.badge)
			})
		}),
		CatalogItemCardSelectedOverlayItemStatusIcon = if not FFlagAXInventoryDurablesSupport or (not t3.itemStatusIcon or t3.badge) then nil else React.createElement(View, {
			tag = "padding-top-small padding-left-small",
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Icon = React.createElement(ItemCardIcon, {
				icon = t3.itemStatusIcon
			})
		}),
		CatalogItemCardSelectedOverlayButton = if v28 or not t3.buttonText then nil else React.createElement(Button, {
			isDisabled = false,
			fontStyle = "CaptionHeader",
			text = t3.buttonText,
			buttonType = ButtonType.PrimarySystem,
			onActivated = t3.onActivated,
			anchorPoint = Vector2.new(0.5, 1),
			position = UDim2.new(0.5, 0, 1, -v25.Gap.XXSmall),
			size = UDim2.new(1, -(v25.Gap.XXSmall * 2), 0, v25.Size.Size_700)
		})
	})
end

return CatalogItemCardSelectedOverlay
