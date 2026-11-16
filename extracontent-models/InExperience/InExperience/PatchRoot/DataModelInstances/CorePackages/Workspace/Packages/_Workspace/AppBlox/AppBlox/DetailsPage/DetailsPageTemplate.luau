local AppBlox = script:FindFirstAncestor("AppBlox")
local parent = AppBlox.Parent
local UIBlox = require(parent.UIBlox)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Roact = require(parent.Roact)
local t = require(parent.t)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local withStyle = UIBlox.Core.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage

local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local ActionBar = UIBlox.App.Button.ActionBar
local StickyActionBar = require(script.Parent.Parent.StickyActionBar)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local getPlatformConfig = require(script.Parent.getPlatformConfig)
local DetailsPageHeader = require(script.Parent.DetailsPageHeader)
local DetailsPageBody = require(script.Parent.DetailsPageBody)
local validateDetailsPageComponentList = require(script.Parent.validateDetailsPageComponentList)
local useAnimateScrollViewToSelection = require(AppBlox.useAnimateScrollViewToSelection)
local RoactUtils = require(parent.RoactUtils)
local getTestId = RoactUtils.getTestId

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixDetailsPageThumbnailRenderInPhone = SharedFlags.FFlagLuaAppFixDetailsPageThumbnailRenderInPhone
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppFixSDPLayout = SharedFlags2.FFlagLuaAppFixSDPLayout
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppAddTestIdsForArrow = SharedFlags3.FFlagLuaAppAddTestIdsForArrow
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags4.FFlagLuaAppEdpConsoleMediaGalleryVideo

local extended = Roact.PureComponent:extend("DetailsPageTemplate")

local function applyTokenScaling(p: number, foundationTokens) -- 4 equivalent calls inferred from this helper
	return p * foundationTokens.Stroke.Standard
end

local strictInterface = t.strictInterface
local v = {}
v.foundationTokens = t.table

v.thumbnailImageUrl = t.optional(t.string)

v.thumbnailHeight = t.optional(t.number)

v.thumbnailAspectRatio = t.optional(t.Vector2)
local thumbnailShadowHeight

if FFlagLuaAppFixDetailsPageThumbnailRenderInPhone then
	thumbnailShadowHeight = t.optional(t.number)
end

v.thumbnailShadowHeight = thumbnailShadowHeight

v.titleText = t.optional(t.string)

v.subTitleText = t.optional(t.string)

v.actionBarLabelText = t.optional(t.string)

v.renderInfoContent = t.optional(t.callback)

v.renderCustomHeader = t.optional(t.callback)

v.actionBarProps = t.optional(t.table)

v.actionBarWidth = t.optional(t.number)
v.actionBarHeight = t.optional(t.number)

v.renderActionBarLabelImpressionsDetector = t.optional(t.callback)

v.componentList = t.optional(validateDetailsPageComponentList)

v.dualPanelBreakpoint = t.optional(t.number)

v.sideMargin = t.optional(t.number)
v.bodyClipsDescendants = t.optional(t.boolean)

v.maxContentWidth = t.optional(t.number)

v.startingOffsetPosition = t.optional(t.number)

v.headerBarBackgroundHeight = t.optional(t.number)
v.onClose = t.callback

v.bannerPlaceholderGradient = t.optional(t.table)

v.bannerImageUrl = t.optional(t.string)

v.isFullscreen = t.optional(t.boolean)

v.renderFullscreenContent = t.optional(t.callback)

v.deviceType = t.optional(t.string)

v.isMobile = t.optional(t.boolean)

v.tokens = t.optional(t.table)

v.containerRef = t.optional(t.union(t.table, t.callback))

v.backgroundFrameSize = t.optional(t.UDim2)

v.scrollingFrameRef = t.optional(t.table)

v.disableScrollingForFocusNav = t.optional(t.boolean)

v.gradientHeight = t.optional(t.number)

v.backgroundImageTransparency = t.optional(t.number)

v.disableBackgroundAspectRatio = t.optional(t.boolean)
local bodyContainerSafeAreaSize

if FFlagLuaAppFixSDPLayout then
	bodyContainerSafeAreaSize = t.optional(t.UDim2)
end

v.bodyContainerSafeAreaSize = bodyContainerSafeAreaSize
local backgroundImageSize

if FFlagLuaAppFixSDPLayout then
	backgroundImageSize = t.optional(t.UDim2)
end

v.backgroundImageSize = backgroundImageSize
local headerPadding

if FFlagLuaAppFixSDPLayout then
	headerPadding = t.optional(t.number)
end

v.headerPadding = headerPadding

v.disableStickyActionBar = t.optional(t.boolean)

v.hideCloseButton = t.optional(t.boolean)
local backgroundContentOverride

if FFlagLuaAppEdpConsoleMediaGalleryVideo then
	backgroundContentOverride = t.optional(t.table)
end

v.backgroundContentOverride = backgroundContentOverride
extended.validateProps = strictInterface(v)

extended.defaultProps = { deviceType = DeviceType.Desktop, isFullscreen = false }

local function getHeaderPaddingHeight(data, backgroundHeight: number) -- 3 equivalent calls inferred from this helper
	local platformConfig = getPlatformConfig(data.deviceType)
	local v2

	if data.headerBarBackgroundHeight then
		v2 = data.headerBarBackgroundHeight
	else
		v2 = applyTokenScaling(platformConfig.headerBarBackgroundHeight, data.foundationTokens) -- inferred equivalent call
	end

	return backgroundHeight - v2
end

function extended:init()
	self.containerRef = Roact.createRef()
	self.scrollingFrameRef = self.props.scrollingFrameRef
	self.scrolled = false
	self.scrollViewPositionChangedSignal = Signal.new()
	self.state = {
		showStickyActionTopBar = false,
		backgroundHeight = 500,
		containerSize = Vector2.new(500, 500),
		backgroundComponentPosition = 250
	}

	function self.onContainerSizeChange(p)
		self:setState({ containerSize = p.AbsoluteSize })
	end

	function self.onBackgroundComponentFrameSizeChange(p)
		self:setState(function(_, data)
			local y = p.AbsoluteSize.Y
			local platformConfig = getPlatformConfig(data.deviceType)
			local v2

			if data.headerBarBackgroundHeight then
				v2 = data.headerBarBackgroundHeight
			else
				v2 = applyTokenScaling(platformConfig.headerBarBackgroundHeight, data.foundationTokens) -- inferred equivalent call
			end

			return {
				backgroundHeight = y,
				backgroundComponentPosition = math.max(0, y - v2) / 2
			}
		end)
	end

	function self.canvasPositionChange(p)
		self.scrollViewPositionChangedSignal:fire()
		self.scrolled = true
		self:setState(function(p2, data)
			local headerPaddingHeight = getHeaderPaddingHeight(data, p2.backgroundHeight) -- inferred equivalent call

			local backgroundComponentPosition = math.max(0, headerPaddingHeight - p.CanvasPosition.Y) / 2

			if headerPaddingHeight < p.CanvasPosition.Y then
				if
					p2.showStickyActionTopBar == false
					and self.props.deviceType ~= DeviceType.Phone
					and not self.props.disableStickyActionBar
				then
					return { showStickyActionTopBar = true }
				end

				return nil
			elseif p2.showStickyActionTopBar == true then
				return {
					showStickyActionTopBar = false,
					backgroundComponentPosition = backgroundComponentPosition
				}
			else
				return { backgroundComponentPosition = backgroundComponentPosition }
			end
		end)
	end
end

function extended.render(data)
	local v2 = data.props.deviceType == DeviceType.Phone
	local platformConfig = getPlatformConfig(data.props.deviceType)
	local thumbnailHeight

	if data.props.thumbnailHeight then
		thumbnailHeight = data.props.thumbnailHeight
	else
		thumbnailHeight = applyTokenScaling(platformConfig.thumbnailHeight, data.props.foundationTokens) -- inferred equivalent call
	end

	local headerBarBackgroundHeight

	if data.props.headerBarBackgroundHeight then
		headerBarBackgroundHeight = data.props.headerBarBackgroundHeight
	else
		headerBarBackgroundHeight = applyTokenScaling( -- inferred equivalent call
			platformConfig.headerBarBackgroundHeight,
			data.props.foundationTokens
		)
	end

	local sideMargin

	if data.props.sideMargin then
		sideMargin = data.props.sideMargin
	else
		sideMargin = platformConfig.sideMargin
	end

	local dualPanelBreakpoint

	if data.props.dualPanelBreakpoint then
		dualPanelBreakpoint = data.props.dualPanelBreakpoint
	else
		dualPanelBreakpoint = platformConfig.dualPanelBreakpoint
	end

	local v3 = FFlagLuaAppFixSDPLayout and data.props.headerPadding
		or getHeaderPaddingHeight(data.props, data.state.backgroundHeight) -- inferred equivalent call
	local backgroundComponentPosition = data.state.backgroundComponentPosition
	local containerSize = data.state.containerSize

	local isFullscreen = data.props.isFullscreen
	local renderFullscreenContent = data.props.renderFullscreenContent
	local v4 = not v2 and isFullscreen and renderFullscreenContent and true or false
	return withStyle(function(p)
		local theme = p.Theme
		local v5 = data.props.bannerImageUrl == nil
		local bannerPlaceholderGradient = data.props.bannerPlaceholderGradient or {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, theme.BackgroundMuted.Color),
				ColorSequenceKeypoint.new(1, theme.BackgroundUIDefault.Color)
			})
		}

		local v6 = v2 and (getIconSize(IconSize.Large) + 22) / 2 or headerBarBackgroundHeight / 2

		local actionBarProps = v2 and data.props.actionBarProps

		local createElement = Roact.createElement
		local v7 = {
			["Text"] = nil,
			Text = "",
			Selectable = false,
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ClipsDescendants = true
		}

		local ref = Roact.Ref
		local v8

		if data.props.containerRef then
			v8 = data.props.containerRef
		else
			v8 = data.containerRef
		end

		v7[ref] = v8
		v7[Roact.Change.AbsoluteSize] = data.onContainerSizeChange
		local closeButtonFrame

		if not data.props.hideCloseButton then
			local createElement2 = Roact.createElement
			local v9 = {
				BackgroundTransparency = 1,
				["Size"] = getIconSizeUDim2(IconSize.Large),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 22, 0, v6),
				ZIndex = 2
			}

			local tag = React.Tag
			local v10

			if FFlagLuaAppAddTestIdsForArrow then
				v10 = getTestId("details-close-button")
			end

			v9[tag] = v10
			closeButtonFrame = createElement2("Frame", v9, {
				CloseButton = Roact.createElement(IconButton, {
					size = UDim2.fromScale(1, 1),
					icon = v4 and Images["icons/navigation/pushBack"] or Images["icons/navigation/close"],
					iconColor3 = p.Theme.UIEmphasis.Color,
					iconSize = IconSize.Medium,
					onActivated = data.props.onClose,
					showBackground = data.state.showStickyActionTopBar == false,
					backgroundColor = p.Theme.BackgroundUIDefault
				})
			})
		end

		local createElement2 = Roact.createElement
		local onBackgroundComponentFrameSizeChangesByAbsoluteSize = {}
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.BackgroundColor3 = theme.BackgroundMuted.Color
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.BackgroundTransparency = theme.BackgroundMuted.Transparency
		local size

		if data.props.backgroundFrameSize then
			size = data.props.backgroundFrameSize
		else
			size = UDim2.fromScale(1, 1)
		end

		onBackgroundComponentFrameSizeChangesByAbsoluteSize.Size = size
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.AnchorPoint = Vector2.new(0.5, 0)
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.Position = UDim2.fromScale(0.5, 0)
		onBackgroundComponentFrameSizeChangesByAbsoluteSize[Roact.Change.AbsoluteSize] = data.onBackgroundComponentFrameSizeChange
		local v9 = {
			GradientPlaceholder = v5 and Roact.createElement("UIGradient", bannerPlaceholderGradient) or nil,
			UIAspectRatioConstraint = 0,
			BackgroundImage = 0
		}
		local uiAspectRatioConstraint

		if not (v5 or data.props.disableBackgroundAspectRatio) then
			uiAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 16 / 9
			})
		end

		v9.UIAspectRatioConstraint = uiAspectRatioConstraint
		local backgroundImage

		if v5 == false then
			backgroundImage = Roact.createElement(LoadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0, backgroundComponentPosition),
				Size = FFlagLuaAppFixSDPLayout and data.props.backgroundImageSize or UDim2.new(0, containerSize.x, 1, 0),
				Image = data.props.bannerImageUrl,
				ScaleType = Enum.ScaleType.Crop,
				BackgroundTransparency = data.props.backgroundImageTransparency
			}) or nil
		end

		v9.BackgroundImage = backgroundImage
		local children = {
			CloseButtonFrame = closeButtonFrame,
			BackgroundDetailsFrame = createElement2("Frame", onBackgroundComponentFrameSizeChangesByAbsoluteSize, v9),
			StickyActionBarFrame = 0,
			ContentScrollingFrame = 0,
			FullscreenFrame = 0,
			MobileActionBarFrame = 0
		}
		local stickyActionBarFrame

		if data.state.showStickyActionTopBar or v4 and not data.props.disableStickyActionBar then
			stickyActionBarFrame = Roact.createElement("TextButton", {
				Text = "",
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 0, headerBarBackgroundHeight),
				BackgroundColor3 = theme.BackgroundUIDefault.Color,
				BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
				BorderSizePixel = 0
			}, {
				StickyActionBar = Roact.createElement(StickyActionBar, {
					actionBarProps = data.props.actionBarProps,
					actionBarWidth = data.props.actionBarWidth,
					infoProps = {
						icon = data.props.thumbnailImageUrl,
						title = data.props.titleText
					}
				})
			}) or nil
		end

		children.StickyActionBarFrame = stickyActionBarFrame

		local createElement3 = Roact.createElement
		local canvasPositionChangesByCanvasPosition = {
			size = UDim2.fromScale(1, 1),
			canvasSizeY = UDim.new(1, 0),
			useAutomaticCanvasSize = true,
			scrollingEnabled = not (data.props.disableScrollingForFocusNav or v4),
			[Roact.Change.CanvasPosition] = data.canvasPositionChange,
			scrollingFrameRef = data.scrollingFrameRef,
			isGamepadFocusable = false,
			selectable = false
		}

		local v10 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			Padding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v3),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}),
			MainView = 0,
			MobileActionViewPadding = 0
		}

		local createElement4 = Roact.createElement
		local v11 = {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children2 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			HeaderContainer = 0,
			BodyContainer = 0
		}

		local createElement5 = Roact.createElement
		local v12 = {
			Size = UDim2.new(1, 0, 0, headerBarBackgroundHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local createElement6 = Roact.createElement
		local v13 = {
			thumbnailImageUrl = data.props.thumbnailImageUrl,
			thumbnailAspectRatio = data.props.thumbnailAspectRatio,
			thumbnailHeight = thumbnailHeight,
			thumbnailShadowHeight = 0,
			titleText = 0,
			subTitleText = 0,
			actionBarLabelText = 0,
			renderInfoContent = 0,
			renderCustomHeader = 0,
			actionBarProps = 0,
			actionBarWidth = 0,
			actionBarHeight = 0,
			headerBarBackgroundHeight = 0,
			sideMargin = 0,
			maxContentWidth = 0,
			deviceType = 0,
			gradientHeight = 0,
			renderActionBarLabelImpressionsDetector = 0,
			scrollViewPositionChangedSignal = 0
		}
		local thumbnailShadowHeight2

		if FFlagLuaAppFixDetailsPageThumbnailRenderInPhone then
			thumbnailShadowHeight2 = data.props.thumbnailShadowHeight
		end

		v13.thumbnailShadowHeight = thumbnailShadowHeight2

		v13.titleText = data.props.titleText
		v13.subTitleText = data.props.subTitleText
		v13.actionBarLabelText = data.props.actionBarLabelText
		v13.renderInfoContent = data.props.renderInfoContent
		v13.renderCustomHeader = data.props.renderCustomHeader
		local actionBarProps2

		if not (data.state.showStickyActionTopBar or not data.props.disableStickyActionBar and v4) then
			actionBarProps2 = data.props.actionBarProps
		end

		v13.actionBarProps = actionBarProps2

		v13.actionBarWidth = data.props.actionBarWidth
		v13.actionBarHeight = data.props.actionBarHeight

		v13.headerBarBackgroundHeight = headerBarBackgroundHeight
		v13.sideMargin = sideMargin
		v13.maxContentWidth = data.props.maxContentWidth

		v13.deviceType = data.props.deviceType
		v13.gradientHeight = data.props.gradientHeight
		v13.renderActionBarLabelImpressionsDetector = data.props.renderActionBarLabelImpressionsDetector
		v13.scrollViewPositionChangedSignal = data.scrollViewPositionChangedSignal
		children2.HeaderContainer = createElement5("Frame", v12, {
			DetailsPageHeader = createElement6(DetailsPageHeader, v13)
		})

		children2.BodyContainer = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = 2,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			BodyContainerSafeArea = Roact.createElement("Frame", {
				Size = FFlagLuaAppFixSDPLayout and data.props.bodyContainerSafeAreaSize or UDim2.fromOffset(
					math.min(containerSize.x, containerSize.y * (16 / 9)),
					0
				),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				DetailsPageBody = Roact.createElement(DetailsPageBody, {
					titleText = data.props.titleText,
					subTitleText = data.props.subTitleText,
					renderInfoContent = data.props.renderInfoContent,
					bodyClipsDescendants = data.props.bodyClipsDescendants,
					componentList = data.props.componentList,
					dualPanelBreakpoint = dualPanelBreakpoint,
					sideMargin = sideMargin,
					maxContentWidth = data.props.maxContentWidth,
					deviceType = data.props.deviceType,
					showPageDetails = v2 and data.props.renderCustomHeader == nil,
					bottomPadding = 100
				})
			})
		})
		v10.MainView = createElement4("Frame", v11, children2)

		v10.MobileActionViewPadding = actionBarProps
			and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 72),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			})
		children.ContentScrollingFrame = createElement3(VerticalScrollView, canvasPositionChangesByCanvasPosition, v10)

		children.FullscreenFrame = v4 and Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, -headerBarBackgroundHeight),
			Position = UDim2.fromOffset(0, headerBarBackgroundHeight),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			ClipsDescendants = true,
			ZIndex = 2
		}, { FullscreenContent = renderFullscreenContent() }) or nil

		children.MobileActionBarFrame = actionBarProps and Roact.createElement("TextButton", {
			Text = "",
			AutoButtonColor = false,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 72),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 3
		}, {
			GradientBar = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				AnchorPoint = Vector2.new(0, 1),
				BorderSizePixel = 0,
				LayoutOrder = 1
			}, {
				Gradient = Roact.createElement("UIGradient", {
					Rotation = 270,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.25),
						NumberSequenceKeypoint.new(1, 0.9999)
					})
				})
			}),
			ActionBar = Roact.createElement(ActionBar, {
				button = data.props.actionBarProps.button,
				icons = data.props.actionBarProps.icons
			})
		})
		return createElement("TextButton", v7, children)
	end)
end

function extended.didMount(p)
	if p.containerRef.current then
		p.onContainerSizeChange(p.containerRef.current)
	end
end

function extended.didUpdate(data)
	local platformConfig = getPlatformConfig(data.props.deviceType)

	if data.scrolled == false and data.scrollingFrameRef.current then
		local startingOffsetPosition

		if data.props.startingOffsetPosition then
			startingOffsetPosition = data.props.startingOffsetPosition
		else
			startingOffsetPosition = platformConfig.startingOffsetPosition
		end

		local v2 = math.max(0, getHeaderPaddingHeight(data.props, data.state.backgroundHeight) - startingOffsetPosition) -- inferred equivalent call
		data.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, v2)
	end
end

return function(p)
	local ref = React.useRef(nil)
	useAnimateScrollViewToSelection(ref, 0.4)
	local foundationTokens = useTokens()
	local disableScrollingForFocusNav = useLastInputMode() ~= "Cursor"
	return React.createElement(
		extended,
		Cryo.Dictionary.join(p, {
			foundationTokens = foundationTokens,
			scrollingFrameRef = ref,
			disableScrollingForFocusNav = disableScrollingForFocusNav
		})
	)
end
