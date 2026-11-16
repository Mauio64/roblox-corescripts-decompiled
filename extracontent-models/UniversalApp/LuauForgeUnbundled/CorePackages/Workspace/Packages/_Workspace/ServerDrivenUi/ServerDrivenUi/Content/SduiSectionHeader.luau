local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local combineReactTags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils").combineReactTags

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")

local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppBlox").IconWithTooltip

local SduiTextIconRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTextIconRow")

local images = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/FoundationImages").Images
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppAssets").GetImageData
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppEnableSduiHomePage

local defineFastFlag = game:DefineFastFlag("AddLayoutOrderToSduiSectionHeaderIconComponent", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppSduiSeeAllArrowIconMigration2", false)

local function SduiSectionHeader(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position

	local v5 = useTokens()

	local titleFontStyle = props.titleFontStyle or v5.Typography.HeadingSmall
	local titleColor = props.titleColor or v5.Color.Content.Emphasis
	local subtitleFontStyle = props.subtitleFontStyle or v5.Typography.BodyMedium
	local subtitleColor = props.subtitleColor or v5.Color.Content.Default

	local verticalGap = props.verticalGap or v5.Gap.XXSmall
	local small = v5.Gap.Small

	local v6 = props.titleGap or v5.Gap.XXSmall
	local v7 = props.titleIconWidth or v5.Size.Size_600

	local v8 = props.subtitleText ~= nil and props.subtitleText ~= "" or props.subtitleComponent ~= nil
	local v9 = if props.onSubtitleActivated then props.onSubtitleActivated else props.onTitleActivated

	local subtitleGap = props.subtitleGap or v5.Gap.XXSmall
	local subtitleIconWidth = props.subtitleIconWidth or v5.Size.Size_400

	local size_700 = v5.Size.Size_700

	local v10 = Responsive.usePreferredInput()
	local allowInteractionForDirectionalInput = props.allowInteractionForDirectionalInput
		or v10 ~= Responsive.Input.Directional

	local v11 = allowInteractionForDirectionalInput and (props.infoText ~= nil or props.iconComponent)
	local v12 = allowInteractionForDirectionalInput and props.onTitleActivated ~= nil
	local v13 = allowInteractionForDirectionalInput and (v12 or props.onSubtitleActivated ~= nil)
	local v14

	if defineFastFlag2 then
		v14 = props.titleIcon

		if
			v14
			and (v14 == getImageData("LuaApp/icons/GameDetails/navigation/pushRight_small") or v14 == images["icons/navigation/pushRight_small"])
		then
			v14 = images["icons/actions/cycleRight"]
			v7 = v5.Size.Size_500
			v6 = v5.Gap.XSmall
		end
	end

	local v15

	if defineFastFlag and props.iconComponent then
		v15 = React.createElement(view, { tag = "auto-xy", LayoutOrder = 2 }, {
			IconComponent = props.iconComponent
		})
	else
		v15 = props.iconComponent
	end

	local v16

	if fFlagLuaAppEnableSduiHomePage then
		local tag = props.tag
		local v18 = if props.testId then `data-testid={props.testId}` else nil
		v16 = combineReactTags(tag, v18)
	end

	local createElement = React.createElement
	local v18 = {
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

	if not fFlagLuaAppEnableSduiHomePage then
		v16 = if props.testId then `data-testid={props.testId}` else nil
	end

	v18[tag] = v16

	local v19 = {
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
	local v21 = {}
	v21.LayoutOrder = 1
	v21.Text = v12 and "" or nil
	v21.TextTransparency = v12 and 1 or nil
	v21.Size = UDim2.new(1, 0, 0, 0)
	v21.AutomaticSize = Enum.AutomaticSize.Y
	v21.BackgroundTransparency = 1
	v21.BorderSizePixel = 0
	v21.AutoButtonColor = if v12 then false else nil
	local activated = React.Event.Activated
	local v23 = if v12 then props.onTitleActivated else nil
	v21[activated] = v23
	v21.Active = v12
	v21.Selectable = v12
	local v24 = {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		}),
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

	local v25 = props.titleComponent

	if not v25 then
		local createElement3 = React.createElement
		local v27 = {
			gap = v6,
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
				v14 = props.titleIcon
			end
		else
			v14 = nil
		end

		v27.icon = v14

		v27.iconWidth = v7
		v27.iconColor = titleColor.Color3
		v27.selectable = v12
		v25 = createElement3(SduiTextIconRow, v27) or nil
	end

	v24.ContentRow1 = v25

	local v26 = props.subtitleComponent

	if not v26 then
		if v8 then
			local createElement3 = React.createElement
			local v28 = {
				onActivated = v9,
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
			local v29 = if allowInteractionForDirectionalInput then props.subtitleIcon else nil
			v28.icon = v29
			v28.iconWidth = subtitleIconWidth
			v28.iconColor = subtitleColor.Color3
			v28.selectable = v13
			v26 = createElement3(SduiTextIconRow, v28) or nil
		else
			v26 = nil
		end
	end

	v24.ContentRow2 = v26
	v19.LeftContentFrame = createElement2(v12 and "TextButton" or "Frame", v21, v24)

	if not v15 then
		if v11 and props.infoText then
			local createElement3 = React.createElement
			local v28 = {
				layoutOrder = 2,
				tooltipOrientation = tooltipOrientation.Bottom,
				hoverText = props.infoText,
				triggerPointName = "IconWithTooltip",
				onActivateTooltip = props.onInfoIconActivated,
				supportVR = true,
				supportTenFootUi = true,
				size = UDim2.new(0, size_700, 0, size_700),
				position = 0,
				anchorPoint = 0
			}
			local v29 = if v8 then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 0.5, 0)
			v28.position = v29
			local v30 = if v8 then Vector2.new(1, 0) else Vector2.new(1, 0.5)
			v28.anchorPoint = v30
			v15 = createElement3(iconWithTooltip, v28) or nil
		else
			v15 = nil
		end
	end

	v19.IconWithTooltip = v15
	return createElement("Frame", v18, v19)
end

return React.memo(SduiSectionHeader)
