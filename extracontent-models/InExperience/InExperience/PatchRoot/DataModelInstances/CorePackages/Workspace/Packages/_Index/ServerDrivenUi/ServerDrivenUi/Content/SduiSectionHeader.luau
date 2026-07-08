local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local UIBlox = require(ServerDrivenUiParent.UIBlox)
local Foundation = require(ServerDrivenUiParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Responsive = require(ServerDrivenUiParent.Responsive)
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local IconWithTooltip = require(ServerDrivenUiParent.AppBlox).IconWithTooltip
local SduiTextIconRow = require(ServerDrivenUi.Content.SduiTextIconRow)
local Images = require(ServerDrivenUiParent.FoundationImages).Images
local GetImageData = require(ServerDrivenUiParent.RobloxAppAssets).GetImageData
local v14 = game:DefineFastFlag("AddLayoutOrderToSduiSectionHeaderIconComponent", false)
local v15 = game:DefineFastFlag("LuaAppSduiSeeAllArrowIconMigration2", false)

local function SduiSectionHeader(t1: {[any]: any}) -- line: 79
	-- upvalues: useTokens (copy), Responsive (copy), v15 (copy), GetImageData (copy), Images (copy), v14 (copy), React (copy), View (copy), SduiTextIconRow (copy), IconWithTooltip (copy), TooltipOrientation (copy)
	local layoutOrder = t1.layoutOrder
	local anchorPoint = t1.anchorPoint
	local automaticSize = t1.automaticSize
	local size = t1.size
	local zIndex = t1.zIndex
	local position = t1.position
	local v24 = useTokens()
	local v25 = t1.titleFontStyle or v24.Typography.HeadingSmall
	local v26 = t1.titleColor or v24.Color.Content.Emphasis
	local v27 = t1.subtitleFontStyle or v24.Typography.BodyMedium
	local v28 = t1.subtitleColor or v24.Color.Content.Default
	local v29 = t1.verticalGap or v24.Gap.XXSmall
	local Small = v24.Gap.Small
	local v31 = t1.titleGap or v24.Gap.XXSmall
	local v32 = t1.titleIconWidth or v24.Size.Size_600
	local v33 = t1.subtitleText ~= nil and t1.subtitleText ~= "" or t1.subtitleComponent ~= nil
	local v34 = if not t1.onSubtitleActivated then t1.onTitleActivated else t1.onSubtitleActivated
	local v35 = t1.subtitleGap or v24.Gap.XXSmall
	local v36 = t1.subtitleIconWidth or v24.Size.Size_400
	local Size_700 = v24.Size.Size_700
	local v38 = Responsive.usePreferredInput()
	local v39 = t1.allowInteractionForDirectionalInput or v38 ~= Responsive.Input.Directional
	local v40 = v39 and (t1.infoText ~= nil or t1.iconComponent)
	local v41 = v39 and t1.onTitleActivated ~= nil
	local v42 = v39 and (v41 or t1.onSubtitleActivated ~= nil)
	local titleIcon = nil

	if v15 then
		titleIcon = t1.titleIcon

		if titleIcon and (titleIcon == GetImageData("LuaApp/icons/GameDetails/navigation/pushRight_small") or titleIcon == Images["icons/navigation/pushRight_small"]) then
			titleIcon = Images["icons/actions/cycleRight"]
			v32 = v24.Size.Size_500
			v31 = v24.Gap.XSmall
		end
	end

	local v44 = if not v14 or not t1.iconComponent then t1.iconComponent else React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = 2
	}, {
		IconComponent = t1.iconComponent
	})

	return React.createElement("Frame", {
		Position = position,
		AnchorPoint = anchorPoint,
		AutomaticSize = automaticSize or Enum.AutomaticSize.Y,
		Size = size or UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, Small),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		LeftContentFrame = React.createElement(not v41 and "Frame" or "TextButton", {
			LayoutOrder = 1,
			Text = if not v41 then nil else "",
			TextTransparency = if not v41 then nil else 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = not v41 and nil,
			[React.Event.Activated] = if not v41 then nil else t1.onTitleActivated,
			Active = v41,
			Selectable = v41
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Shrink
			}),
			UIListLayout = React.createElement("UIListLayout", {
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.Name,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v29),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			ContentRow1 = t1.titleComponent or (React.createElement(SduiTextIconRow, {
				testId = "--sdui-section-header-title",
				gap = v31,
				text = t1.titleText,
				fontStyle = v25,
				textColor = v26.Color3,
				textFlexMode = Enum.UIFlexMode.Shrink,
				icon = if not v39 then nil else if not v15 then t1.titleIcon else titleIcon,
				iconWidth = v32,
				iconColor = v26.Color3,
				selectable = v41
			}) or nil),
			ContentRow2 = t1.subtitleComponent or (v33 and React.createElement(SduiTextIconRow, {
				testId = "--sdui-section-header-subtitle",
				onActivated = v34,
				gap = v35,
				text = t1.subtitleText,
				fontStyle = v27,
				textColor = v28.Color3,
				textFlexMode = Enum.UIFlexMode.Shrink,
				icon = if not v39 then nil else t1.subtitleIcon,
				iconWidth = v36,
				iconColor = v28.Color3,
				selectable = v42
			}) or nil)
		}),
		IconWithTooltip = v44 or (v40 and (not not t1.infoText and React.createElement(IconWithTooltip, {
			layoutOrder = 2,
			triggerPointName = "IconWithTooltip",
			supportVR = true,
			supportTenFootUi = true,
			tooltipOrientation = TooltipOrientation.Bottom,
			hoverText = t1.infoText,
			onActivateTooltip = t1.onInfoIconActivated,
			size = UDim2.new(0, Size_700, 0, Size_700),
			position = if not v33 then UDim2.new(1, 0, 0.5, 0) else UDim2.new(1, 0, 0, 0),
			anchorPoint = if not v33 then Vector2.new(1, 0.5) else Vector2.new(1, 0)
		})) or nil)
	})
end

return React.memo(SduiSectionHeader)
