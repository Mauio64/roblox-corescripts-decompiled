local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local scrollingAppCarousel = require("@game/CorePackages/Workspace/Packages/AppBlox").ScrollingAppCarousel
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local uiMode = RobloxAppEnums.UiMode
local deviceType = RobloxAppEnums.DeviceType
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/AppBlox").IconWithTooltip
local maybeForceDarkTheme = require("@luauforge/bundled/ehg").maybeForceDarkTheme

local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local iconButton = Foundation.IconButton
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize

local module3 = require("@luauforge/bundled/iqu")

local fFlagLuaAppPropagateFriendsCarouselHeader = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppPropagateFriendsCarouselHeader

local fFlagLuaAppDisableChevronSeeAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDisableChevronSeeAll

local iconsactionscycleRight = images["icons/actions/cycleRight"]

local extended = Roact.PureComponent:extend("CarouselWidget")

function extended.getDerivedStateFromProps(p2, p3)
	if p2.fetchingStatus == nil then
		return
	end

	local v5 = retrievalStatus.fromRawValue(p2.fetchingStatus)
	local v6 = p3.wasLoaded

	if v5 == retrievalStatus.Done then
		v6 = true
	elseif v5 == retrievalStatus.Failed or v5 == retrievalStatus.NotStarted then
		v6 = false
	elseif v5 == retrievalStatus.Fetching and v6 then
		v5 = retrievalStatus.Done
	end

	return { wasLoaded = v6, dataStatus = v5 }
end

function extended:init()
	self.state = { wasLoaded = false, dataStatus = retrievalStatus.NotStarted }
end

function extended.didMount(object)
	object:setState({
		wasLoaded = false,
		dataStatus = retrievalStatus.fromRawValue(object.props.fetchingStatus)
	})
end

function extended.render(p2)
	local layoutOrder = p2.props.layoutOrder
	local onSeeAll = p2.props.onSeeAll
	local title = p2.props.title
	local items = p2.props.items
	local fetchingStatus = p2.props.fetchingStatus
	local onRetry = p2.props.onRetry

	local carouselHeight = p2.props.carouselHeight
	local canvasWidth = p2.props.canvasWidth
	local onChangeCanvasPosition = p2.props.onChangeCanvasPosition
	local onRefCallback = p2.props.onRefCallback

	local index = p2.props.index
	local itemCount = p2.props.itemCount
	local itemWidth = p2.props.itemWidth
	local itemPadding = p2.props.itemPadding
	local carouselMargin = p2.props.carouselMargin
	local showSeeAll = p2.props.showSeeAll
	local designTokens = p2.props.designTokens
	local showTooltip = p2.props.showTooltip
	local onActivateTooltip = p2.props.onActivateTooltip
	local tooltipHoverText = p2.props.tooltipHoverText
	local deviceType2 = p2.props.deviceType
	local screenSize = p2.props.screenSize

	local v5 = not fFlagLuaAppPropagateFriendsCarouselHeader or not (title == nil) and title ~= ""

	local darkThemeTextColor = if p2.props.forceDarkThemeForHeader then designTokens.darkThemeTextColor else nil

	local function fn(p3, callback)
		local theme = p3.Theme

		local element = Roact.createElement(scrollingAppCarousel, {
			items = items,
			index = index,
			itemCount = itemCount,
			itemWidth = itemWidth,
			itemPadding = itemPadding,
			carouselMargin = carouselMargin,
			carouselHeight = carouselHeight,
			canvasWidth = canvasWidth,
			onChangeCanvasPosition = onChangeCanvasPosition,
			onRefCallback = onRefCallback
		})

		local element2 = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(designTokens.headerFont),
			Text = title,
			TextSize = designTokens.headerTextSize,
			TextColor3 = darkThemeTextColor or theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextTruncate = Enum.TextTruncate.SplitWord
		})

		local v6 = not fFlagLuaAppDisableChevronSeeAll

		local createElement = Roact.createElement
		local v8 = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = 0
		}
		local v9 = if v6 then p2.props.textIconPadding else UDim.new(0, 4)
		v8.Padding = v9
		local children = {
			Layout = createElement("UIListLayout", v8),
			Title = element2,
			SeeAllArrow = 0,
			UISizeConstraint = 0
		}
		local v10

		if showSeeAll then
			local createElement2 = Roact.createElement

			local v13 = if v6 then p2.props.seeAllImageSize or UDim2.new(0, 20, 0, 20) else UDim2.new(0, 20, 0, 20)
			v10 = createElement2(imageSetLabel, {
				Size = v13,
				BackgroundTransparency = 1,
				Image = iconsactionscycleRight,
				ImageColor3 = darkThemeTextColor or theme.TextEmphasis.Color,
				ImageTransparency = theme.TextEmphasis.Transparency,
				LayoutOrder = 2
			}) or nil
		end

		children.SeeAllArrow = v10

		local createElement2 = Roact.createElement

		local v13 = if showTooltip then Vector2.new(screenSize.X - 2 * (carouselMargin or 0) - 48, 1e999) else Vector2.new(screenSize.X - 2 * (carouselMargin or 0), 1e999)
		children.UISizeConstraint = createElement2("UISizeConstraint", { MaxSize = v13 })

		local v14 = p2.props.subtitle and p2.props.subtitle ~= ""

		local subtitleTextSize = designTokens.subtitleTextSize

		local v15 = nil

		if v14 then
			if type(p2.props.subtitle) == "string" then
				v15 = Roact.createElement("TextLabel", {
					Text = p2.props.subtitle,
					Size = UDim2.new(1, 0, 0, subtitleTextSize),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					FontFace = normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font),
					TextColor3 = darkThemeTextColor or theme.TextDefault.Color,
					TextSize = subtitleTextSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y
				})
			elseif type(p2.props.subtitle) == "table" then
				v15 = p2.props.subtitle
			end
		end

		local v16 = v14 and {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			TitleWrapper = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(),
					AutomaticSize = Enum.AutomaticSize.XY,
					LayoutOrder = 1,
					BackgroundTransparency = 1
				},
				children
			),
			Subtitle = v15,
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(screenSize.X - 2 * (carouselMargin or 0), 1e999)
			})
		} or children
		local v17

		if showSeeAll then
			v17 = Roact.createElement("ImageButton", {
				AutomaticSize = Enum.AutomaticSize.XY,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				SelectionImageObject = callback(cursorKind.InputButton),
				[Roact.Event.Activated] = onSeeAll
			}, v16)
		else
			v17 = Roact.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				v16
			)
		end

		local createElement3 = Roact.createElement
		local v19 = {
			Size = UDim2.new(0, screenSize.X - 48, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v21 = if deviceType2 == deviceType.Desktop then Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}) else nil

		local createElement4 = Roact.createElement
		local v23 = {
			tooltipOrientation = tooltipOrientation.Bottom,
			onActivateTooltip = onActivateTooltip,
			anchorPoint = Vector2.new(1, 0),
			position = 0,
			layoutOrder = 2,
			hoverText = 0,
			triggerPointName = "CarouselTooltip"
		}

		local v24 = if deviceType2 ~= deviceType.Desktop then UDim2.new(1, 0, 0, 0) else nil
		v23.position = v24

		v23.hoverText = tooltipHoverText
		local element3 = createElement3("Frame", v19, {
			Layout = v21,
			HeaderText = v17,
			CarouselTooltip = createElement4(iconWithTooltip, v23)
		})

		local v25 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			Header = 0,
			CarouselFrame = 0
		}

		local v26 = v5

		if v26 then
			if showTooltip then
				v17 = element3
			end

			v26 = maybeForceDarkTheme(v17, p2.props.forceDarkThemeForHeader)
		end

		v25.Header = v26

		local createElement5 = Roact.createElement
		local v28 = {
			Size = UDim2.new(1, 0, 0, carouselHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v30

		if fetchingStatus then
			v30 = Roact.createElement(loadingStateContainer, {
				dataStatus = p2.state.dataStatus,
				onRetry = onRetry,
				renderOnLoading = function(): nil
					return nil
				end,
				renderOnLoaded = function()
					return element
				end
			}) or element
		else
			v30 = element
		end

		v25.CarouselFrame = createElement5("Frame", v28, { CarouselContent = v30 })
		local v31

		if p2.props.onActivateInfoIcon then
			v31 = Roact.createElement(view, {
				Size = UDim2.new(1, -designTokens.iconSizeSmall, 0, -12),
				tag = "col align-x-right align-y-top"
			}, {
				Roact.createElement(view, { Size = UDim2.new(0, 0, 0, 14) }),
				Roact.createElement(iconButton, {
					size = iconSize.Small,
					icon = "icons/actions/info_small",
					onActivated = p2.props.onActivateInfoIcon
				})
			})
		end

		if module3() then
			return Roact.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder
				},
				v25,
				v31
			)
		end

		return Roact.createElement(
			FitChildren.FitFrame,
			{
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			},
			v25,
			v31
		)
	end

	return withStyle(function(p3)
		return withSelectionCursorProvider(function(p4)
			return fn(p3, p4)
		end)
	end)
end

return function(p2)
	local v5 = useUiModeInfo()
	local v6 = useStyle()
	local v7 = useDesignTokens(function(data)
		if v5.uiMode == uiMode.TenFoot then
			return {
				headerFont = data.Typography.HeadingSmall.Font,
				headerTextSize = data.Typography.HeadingSmall.FontSize,
				subtitleTextSize = data.Typography.TitleLarge.FontSize,
				darkThemeTextColor = data.Color.Extended.White.White_100.Color3,
				iconSizeSmall = data.Size.Size_800
			}
		end

		return {
			headerFont = data.Typography.HeadingSmall.Font,
			headerTextSize = v6.Font.BaseSize * v6.Font.Header1.RelativeSize,
			subtitleTextSize = v6.Font.BaseSize * v6.Font.CaptionLarge.RelativeSize,
			darkThemeTextColor = data.Color.Extended.White.White_100.Color3,
			iconSizeSmall = data.Size.Size_800
		}
	end)

	local v8 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local v9 = p2.showSeeAll and v5.uiMode ~= uiMode.TenFoot

	local joined = Cryo.Dictionary.join(p2, {
		designTokens = v7,
		showSeeAll = v9,
		screenSize = v8
	})

	return Roact.createElement(extended, joined)
end
