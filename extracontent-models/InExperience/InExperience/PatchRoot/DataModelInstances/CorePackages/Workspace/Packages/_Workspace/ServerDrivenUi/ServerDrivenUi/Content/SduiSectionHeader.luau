local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local combineReactTags = RoactUtils.combineReactTags

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Responsive = require(parent.Responsive)

local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local AppBlox = require(parent.AppBlox)
local IconWithTooltip = AppBlox.IconWithTooltip

local SduiTextIconRow = require(ServerDrivenUi.Content.SduiTextIconRow)

local FoundationImages = require(parent.FoundationImages)
local Images = FoundationImages.Images
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage

local defineFastFlag = game:DefineFastFlag("AddLayoutOrderToSduiSectionHeaderIconComponent", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppSduiSeeAllArrowIconMigration2", false)

local function SduiSectionHeader(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position

	local v = useTokens()

	local titleFontStyle = props.titleFontStyle or v.Typography.HeadingSmall
	local titleColor = props.titleColor or v.Color.Content.Emphasis
	local subtitleFontStyle = props.subtitleFontStyle or v.Typography.BodyMedium
	local subtitleColor = props.subtitleColor or v.Color.Content.Default

	local verticalGap = props.verticalGap or v.Gap.XXSmall
	local small = v.Gap.Small

	local gap = props.titleGap or v.Gap.XXSmall
	local iconWidth = props.titleIconWidth or v.Size.Size_600

	local v2 = props.subtitleText ~= nil and props.subtitleText ~= "" or props.subtitleComponent ~= nil
	local onActivated

	if props.onSubtitleActivated then
		onActivated = props.onSubtitleActivated
	else
		onActivated = props.onTitleActivated
	end

	local subtitleGap = props.subtitleGap or v.Gap.XXSmall
	local subtitleIconWidth = props.subtitleIconWidth or v.Size.Size_400

	local size_700 = v.Size.Size_700

	local v3 = Responsive.usePreferredInput()
	local allowInteractionForDirectionalInput = props.allowInteractionForDirectionalInput
		or v3 ~= Responsive.Input.Directional

	local v4 = allowInteractionForDirectionalInput and (props.infoText ~= nil or props.iconComponent)
	local v5 = allowInteractionForDirectionalInput and props.onTitleActivated ~= nil
	local selectable = allowInteractionForDirectionalInput and (v5 or props.onSubtitleActivated ~= nil)
	local icon

	if defineFastFlag2 then
		icon = props.titleIcon

		if
			icon
			and (icon == GetImageData("LuaApp/icons/GameDetails/navigation/pushRight_small") or icon == Images["icons/navigation/pushRight_small"])
		then
			icon = Images["icons/actions/cycleRight"]
			iconWidth = v.Size.Size_500
			gap = v.Gap.XSmall
		end
	end

	local iconWithTooltip

	if defineFastFlag and props.iconComponent then
		iconWithTooltip = React.createElement(View, { tag = "auto-xy", LayoutOrder = 2 }, {
			IconComponent = props.iconComponent
		})
	else
		iconWithTooltip = props.iconComponent
	end

	local v6

	if FFlagLuaAppEnableSduiHomePage then
		local tag = props.tag
		local v7

		if props.testId then
			v7 = `data-testid={props.testId}`
		end

		v6 = combineReactTags(tag, v7)
	end

	local createElement = React.createElement
	local v7 = {
		["Position"] = nil,
		Position = position,
		AnchorPoint = anchorPoint,
		AutomaticSize = automaticSize or Enum.AutomaticSize.Y,
		Size = size or UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex
	}

	local tag = React.Tag

	if not FFlagLuaAppEnableSduiHomePage then
		if props.testId then
			v6 = `data-testid={props.testId}`
		else
			v6 = nil
		end
	end

	v7[tag] = v6

	local v8 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, small),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		LeftContentFrame = 0,
		IconWithTooltip = 0
	}

	local createElement2 = React.createElement
	local v9 = {}
	v9.LayoutOrder = 1
	v9.Text = v5 and "" or nil
	v9.TextTransparency = v5 and 1 or nil
	v9.Size = UDim2.new(1, 0, 0, 0)
	v9.AutomaticSize = Enum.AutomaticSize.Y
	v9.BackgroundTransparency = 1
	v9.BorderSizePixel = 0
	v9.AutoButtonColor = not v5 and nil
	local activated = React.Event.Activated
	local v10

	if v5 then
		v10 = props.onTitleActivated
	end

	v9[activated] = v10
	v9.Active = v5
	v9.Selectable = v5
	local v11 = {
		UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink }),
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.Name,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, verticalGap),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		ContentRow1 = 0,
		ContentRow2 = 0
	}

	local contentRow = props.titleComponent

	if not contentRow then
		local createElement3 = React.createElement
		local v12 = {
			gap = gap,
			text = props.titleText,
			fontStyle = titleFontStyle,
			textColor = titleColor.Color3,
			textFlexMode = Enum.UIFlexMode.Shrink,
			icon = 0,
			iconWidth = 0,
			iconColor = 0,
			selectable = 0,
			testId = "--sdui-section-header-title"
		}

		if allowInteractionForDirectionalInput then
			if not defineFastFlag2 then
				icon = props.titleIcon
			end
		else
			icon = nil
		end

		v12.icon = icon

		v12.iconWidth = iconWidth
		v12.iconColor = titleColor.Color3
		v12.selectable = v5
		contentRow = createElement3(SduiTextIconRow, v12) or nil
	end

	v11.ContentRow1 = contentRow

	local contentRow2 = props.subtitleComponent

	if not contentRow2 then
		if v2 then
			local createElement3 = React.createElement
			local v12 = {
				onActivated = onActivated,
				gap = subtitleGap,
				text = props.subtitleText,
				fontStyle = subtitleFontStyle,
				textColor = subtitleColor.Color3,
				textFlexMode = Enum.UIFlexMode.Shrink,
				icon = 0,
				iconWidth = 0,
				iconColor = 0,
				selectable = 0,
				testId = "--sdui-section-header-subtitle"
			}
			local icon2

			if allowInteractionForDirectionalInput then
				icon2 = props.subtitleIcon
			end

			v12.icon = icon2
			v12.iconWidth = subtitleIconWidth
			v12.iconColor = subtitleColor.Color3
			v12.selectable = selectable
			contentRow2 = createElement3(SduiTextIconRow, v12) or nil
		else
			contentRow2 = nil
		end
	end

	v11.ContentRow2 = contentRow2
	v8.LeftContentFrame = createElement2(v5 and "TextButton" or "Frame", v9, v11)

	if not iconWithTooltip then
		if v4 and props.infoText then
			local createElement3 = React.createElement
			local v12 = {
				layoutOrder = 2,
				tooltipOrientation = TooltipOrientation.Bottom,
				hoverText = props.infoText,
				triggerPointName = "IconWithTooltip",
				onActivateTooltip = props.onInfoIconActivated,
				supportVR = true,
				supportTenFootUi = true,
				size = UDim2.new(0, size_700, 0, size_700),
				position = 0,
				anchorPoint = 0
			}
			local position2

			if v2 then
				position2 = UDim2.new(1, 0, 0, 0)
			else
				position2 = UDim2.new(1, 0, 0.5, 0)
			end

			v12.position = position2
			local anchorPoint2

			if v2 then
				anchorPoint2 = Vector2.new(1, 0)
			else
				anchorPoint2 = Vector2.new(1, 0.5)
			end

			v12.anchorPoint = anchorPoint2
			iconWithTooltip = createElement3(IconWithTooltip, v12) or nil
		else
			iconWithTooltip = nil
		end
	end

	v8.IconWithTooltip = iconWithTooltip
	return createElement("Frame", v7, v8)
end

return React.memo(SduiSectionHeader)
