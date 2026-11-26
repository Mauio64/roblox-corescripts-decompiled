local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module2 = require("@luauforge/bundled/fCe")

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local module3 = require("@luauforge/bundled/dWo")

local iconsnavigationpushBack = images["icons/navigation/pushBack"]
local iconsnavigationclose = images["icons/navigation/close"]

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function mapTokens(p2)
	return {
		tooltipIconPadding = p2.Size.Size_200,
		horizontalPadding = p2.Size.Size_400,
		widgetCloseOrBackButtonSize = p2.Size.Size_900,
		size250 = p2.Size.Size_500,
		size1300 = p2.Size.Size_2600
	}
end

return function(props)
	local v5 = useDispatch()
	local v6 = useDesignTokens(mapTokens)
	local v7 = useStyle()
	local v8, v9 = useDefaultFocusBehavior()
	local focusedWidgetTitle

	if props.focusedWidgetTitle and props.focusedWidgetTitle ~= "" then
		focusedWidgetTitle = props.focusedWidgetTitle
	end

	local v10

	if props.focusedWidgetTooltip and props.focusedWidgetTooltip ~= "" then
		v10 = props.focusedWidgetTooltip
	end

	local v11 = useLocalization({ title = focusedWidgetTitle, tooltip = v10 })

	local title = v11.title
	local v12

	if props.focusedWidgetLocalizedTitle and props.focusedWidgetLocalizedTitle ~= "" then
		v12 = props.focusedWidgetLocalizedTitle
	else
		v12 = v11.title
	end

	local v13 = v11.tooltip

	if props.focusedWidgetLocalizedTooltip and props.focusedWidgetLocalizedTooltip ~= "" then
		v13 = props.focusedWidgetLocalizedTooltip
	end

	local state, setState = React.useState(false)
	local v14

	if fFlagSignalsNavP3gAvatarExperience then
		v14 = useSignalState(module2.getIsAvatarExperienceRoute())
	else
		v14 = useSelector(module2.isAvatarExperienceRoute, getUseSelectorDeepEquals())
	end

	React.useEffect(function()
		if not v14 then
			setState(false)
		end
	end, { v14 })

	local theme = v7.Theme
	local font = v7.Font

	local v15 = v6.size250 / 2
	local v16 = font.BaseSize * font.Header2.RelativeSize

	local v17 = React.useCallback(function()
		v5(module3(props.searchUuid))

		if type(props.onClose) == "function" then
			props.onClose()
		end
	end, { props.searchUuid, props.onClose })

	if not props.active then
		return nil
	end

	local v18 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local v19 = useIsSpatial()
	local v20 = v13 and not v19
	local createElement = React.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 0, v6.size1300 / 2),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Selectable = true,
		ref = v9
	}

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v6.horizontalPadding),
			PaddingRight = UDim.new(0, v6.horizontalPadding)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		BackButton = 0,
		Divider = 0,
		TitleFrame = 0
	}

	local createElement2 = React.createElement
	local v24 = {}
	v24.BackgroundTransparency = 1
	v24.Size = UDim2.new(0, v6.widgetCloseOrBackButtonSize, 0, v6.widgetCloseOrBackButtonSize)
	local v25 = if props.showCloseIcon then iconsnavigationclose else iconsnavigationpushBack
	v24.Image = v25
	v24.ImageColor3 = theme.SystemPrimaryDefault.Color
	v24.Visible = true
	v24.LayoutOrder = 1
	v24[Roact.Event.Activated] = v17
	v24.ref = v8
	children.BackButton = createElement2(imageSetButton, v24)

	children.Divider = React.createElement("Frame", {
		BackgroundColor3 = theme.Divider.Color,
		BackgroundTransparency = theme.Divider.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(0, 1, 0, 16)
	})
	local v26

	if v12 then
		local createElement3 = Roact.createElement
		local v28 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = 3
		}

		local v29 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v6.tooltipIconPadding)
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v15),
				PaddingLeft = UDim.new(0, v6.size250 / 4),
				PaddingRight = UDim.new(0, v6.horizontalPadding),
				PaddingBottom = UDim.new(0, v15)
			}),
			Title = 0,
			TitleTooltip = 0
		}

		local v30 = if v12 then React.createElement("TextLabel", {
			Text = v12,
			FontFace = normalizeFontFace(v7.Tokens.Typography.TitleLarge.Font),
			TextSize = v16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			LayoutOrder = 0
		}) else nil
		v29.Title = v30
		local v31

		if v20 then
			v31 = withTooltip(
				{ bodyText = v13, useLargeDropShadow = true },
				{
					preferredOrientation = tooltipOrientation.Bottom,
					guiTarget = CoreGui,
					active = state,
					DisplayOrder = 1
				},
				function(p2)
					return React.createElement("Frame", {
						Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						[React.Change.AbsolutePosition] = p2,
						[React.Change.AbsoluteSize] = p2
					}, { React.createElement(iconButton, {
							icon = images["icons/actions/info_small"],
							iconSize = iconSize.Small,
							iconColor3 = theme.SystemPrimaryDefault.Color,
							iconTransparency = theme.SystemPrimaryDefault.Transparency,
							onActivated = v18
						}) })
				end
			)
		end

		v29.TitleTooltip = v31
		v26 = createElement3("Frame", v28, v29)
	end

	children.TitleFrame = v26
	return createElement("Frame", v22, children)
end
