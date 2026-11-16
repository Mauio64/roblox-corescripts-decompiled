local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation").Hooks.useTokens

local withStyle = UIBlox.Core.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage

local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local verticalScrollView = UIBlox.App.Container.VerticalScrollView
local actionBar = UIBlox.App.Button.ActionBar
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/StickyActionBar")
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums").DeviceType
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/FocusNavigationUtils").useLastInputMode
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppCommonLib").Signal

local getPlatformConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/getPlatformConfig")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageHeader")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageBody")
local validateDetailsPageComponentList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/validateDetailsPageComponentList")
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/useAnimateScrollViewToSelection")
local getTestId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RoactUtils").getTestId

local fFlagLuaAppFixDetailsPageThumbnailRenderInPhone = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagLuaAppFixDetailsPageThumbnailRenderInPhone
local fFlagLuaAppFixSDPLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagLuaAppFixSDPLayout
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagLuaAppAddTestIdsForArrow
local fFlagLuaAppEdpConsoleMediaGalleryVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagLuaAppEdpConsoleMediaGalleryVideo

local extended = Roact.PureComponent:extend("DetailsPageTemplate")

local function applyTokenScaling(p2, p3)
	return p2 * p3.Stroke.Standard
end

local strictInterface = t.strictInterface
local v5 = {}
v5.foundationTokens = t.table

v5.thumbnailImageUrl = t.optional(t.string)

v5.thumbnailHeight = t.optional(t.number)

v5.thumbnailAspectRatio = t.optional(t.Vector2)

local v6 = if fFlagLuaAppFixDetailsPageThumbnailRenderInPhone then t.optional(t.number) else nil
v5.thumbnailShadowHeight = v6

v5.titleText = t.optional(t.string)

v5.subTitleText = t.optional(t.string)

v5.actionBarLabelText = t.optional(t.string)

v5.renderInfoContent = t.optional(t.callback)

v5.renderCustomHeader = t.optional(t.callback)

v5.actionBarProps = t.optional(t.table)

v5.actionBarWidth = t.optional(t.number)
v5.actionBarHeight = t.optional(t.number)

v5.renderActionBarLabelImpressionsDetector = t.optional(t.callback)

v5.componentList = t.optional(validateDetailsPageComponentList)

v5.dualPanelBreakpoint = t.optional(t.number)

v5.sideMargin = t.optional(t.number)
v5.bodyClipsDescendants = t.optional(t.boolean)

v5.maxContentWidth = t.optional(t.number)

v5.startingOffsetPosition = t.optional(t.number)

v5.headerBarBackgroundHeight = t.optional(t.number)
v5.onClose = t.callback

v5.bannerPlaceholderGradient = t.optional(t.table)

v5.bannerImageUrl = t.optional(t.string)

v5.isFullscreen = t.optional(t.boolean)

v5.renderFullscreenContent = t.optional(t.callback)

v5.deviceType = t.optional(t.string)

v5.isMobile = t.optional(t.boolean)

v5.tokens = t.optional(t.table)

v5.containerRef = t.optional(t.union(t.table, t.callback))

v5.backgroundFrameSize = t.optional(t.UDim2)

v5.scrollingFrameRef = t.optional(t.table)

v5.disableScrollingForFocusNav = t.optional(t.boolean)

v5.gradientHeight = t.optional(t.number)

v5.backgroundImageTransparency = t.optional(t.number)

v5.disableBackgroundAspectRatio = t.optional(t.boolean)

local v7 = if fFlagLuaAppFixSDPLayout then t.optional(t.UDim2) else nil
v5.bodyContainerSafeAreaSize = v7

local v8 = if fFlagLuaAppFixSDPLayout then t.optional(t.UDim2) else nil
v5.backgroundImageSize = v8

local v9 = if fFlagLuaAppFixSDPLayout then t.optional(t.number) else nil
v5.headerPadding = v9

v5.disableStickyActionBar = t.optional(t.boolean)

v5.hideCloseButton = t.optional(t.boolean)

local v10 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then t.optional(t.table) else nil
v5.backgroundContentOverride = v10
extended.validateProps = strictInterface(v5)

extended.defaultProps = { deviceType = deviceType.Desktop, isFullscreen = false }

local function getHeaderPaddingHeight(data, p2)
	local v11 = getPlatformConfig(data.deviceType)
	local v12 = if data.headerBarBackgroundHeight then data.headerBarBackgroundHeight else v11.headerBarBackgroundHeight * data.foundationTokens.Stroke.Standard

	return p2 - v12
end

function extended:init()
	self.containerRef = Roact.createRef()
	self.scrollingFrameRef = self.props.scrollingFrameRef
	self.scrolled = false
	self.scrollViewPositionChangedSignal = signal.new()
	self.state = {
		showStickyActionTopBar = false,
		backgroundHeight = 500,
		containerSize = Vector2.new(500, 500),
		backgroundComponentPosition = 250
	}

	function self.onContainerSizeChange(p2)
		self:setState({ containerSize = p2.AbsoluteSize })
	end

	function self.onBackgroundComponentFrameSizeChange(p2)
		self:setState(function(p3, data)
			local y = p2.AbsoluteSize.Y
			local v11 = getPlatformConfig(data.deviceType)
			local v12

			if data.headerBarBackgroundHeight then
				v12 = data.headerBarBackgroundHeight
			else
				v12 = v11.headerBarBackgroundHeight * data.foundationTokens.Stroke.Standard
			end

			return {
				backgroundHeight = y,
				backgroundComponentPosition = math.max(0, y - v12) / 2
			}
		end)
	end

	function self.canvasPositionChange(p2)
		self.scrollViewPositionChangedSignal:fire()
		self.scrolled = true
		self:setState(function(p3, data)
			local backgroundHeight = p3.backgroundHeight
			local v11 = getPlatformConfig(data.deviceType)
			local v12 = if data.headerBarBackgroundHeight then data.headerBarBackgroundHeight else v11.headerBarBackgroundHeight * data.foundationTokens.Stroke.Standard

			local v13 = backgroundHeight - v12

			local v14 = math.max(0, v13 - p2.CanvasPosition.Y) / 2

			if v13 < p2.CanvasPosition.Y then
				if
					p3.showStickyActionTopBar == false
					and self.props.deviceType ~= deviceType.Phone
					and not self.props.disableStickyActionBar
				then
					return { showStickyActionTopBar = true }
				end

				return nil
			elseif p3.showStickyActionTopBar == true then
				return {
					showStickyActionTopBar = false,
					backgroundComponentPosition = v14
				}
			else
				return { backgroundComponentPosition = v14 }
			end
		end)
	end
end

function extended.render(data)
	local v11 = data.props.deviceType == deviceType.Phone
	local v12 = getPlatformConfig(data.props.deviceType)
	local v13

	if data.props.thumbnailHeight then
		v13 = data.props.thumbnailHeight
	else
		v13 = v12.thumbnailHeight * data.props.foundationTokens.Stroke.Standard
	end

	local v14

	if data.props.headerBarBackgroundHeight then
		v14 = data.props.headerBarBackgroundHeight
	else
		v14 = v12.headerBarBackgroundHeight * data.props.foundationTokens.Stroke.Standard
	end

	local sideMargin = if data.props.sideMargin then data.props.sideMargin else v12.sideMargin
	local dualPanelBreakpoint

	if data.props.dualPanelBreakpoint then
		dualPanelBreakpoint = data.props.dualPanelBreakpoint
	else
		dualPanelBreakpoint = v12.dualPanelBreakpoint
	end

	local v15 = fFlagLuaAppFixSDPLayout and data.props.headerPadding

	if not v15 then
		local props = data.props
		local backgroundHeight = data.state.backgroundHeight
		local v16 = getPlatformConfig(props.deviceType)
		local v17 = if props.headerBarBackgroundHeight then props.headerBarBackgroundHeight else v16.headerBarBackgroundHeight * props.foundationTokens.Stroke.Standard

		v15 = backgroundHeight - v17
	end

	local backgroundComponentPosition = data.state.backgroundComponentPosition
	local containerSize = data.state.containerSize

	local isFullscreen = data.props.isFullscreen
	local renderFullscreenContent = data.props.renderFullscreenContent
	local v16 = not v11 and isFullscreen and renderFullscreenContent and true or false
	return withStyle(function(p2)
		local theme = p2.Theme
		local v17 = data.props.bannerImageUrl == nil
		local bannerPlaceholderGradient = data.props.bannerPlaceholderGradient or {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, theme.BackgroundMuted.Color),
				ColorSequenceKeypoint.new(1, theme.BackgroundUIDefault.Color)
			})
		}

		local v18 = v11 and (getIconSize(iconSize.Large) + 22) / 2 or v14 / 2

		local actionBarProps = v11 and data.props.actionBarProps

		local createElement = Roact.createElement
		local v20 = {
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
		local v21 = if data.props.containerRef then data.props.containerRef else data.containerRef
		v20[ref] = v21
		v20[Roact.Change.AbsoluteSize] = data.onContainerSizeChange
		local v22

		if not data.props.hideCloseButton then
			local createElement2 = Roact.createElement
			local v24 = {
				BackgroundTransparency = 1,
				["Size"] = getIconSizeUDim2(iconSize.Large),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 22, 0, v18),
				ZIndex = 2
			}

			local tag = React.Tag
			local v25 = if fFlagLuaAppAddTestIdsForArrow then getTestId("details-close-button") else nil
			v24[tag] = v25
			v22 = createElement2("Frame", v24, {
				CloseButton = Roact.createElement(iconButton, {
					size = UDim2.fromScale(1, 1),
					icon = v16 and images["icons/navigation/pushBack"] or images["icons/navigation/close"],
					iconColor3 = p2.Theme.UIEmphasis.Color,
					iconSize = iconSize.Medium,
					onActivated = data.props.onClose,
					showBackground = data.state.showStickyActionTopBar == false,
					backgroundColor = p2.Theme.BackgroundUIDefault
				})
			})
		end

		local createElement2 = Roact.createElement
		local onBackgroundComponentFrameSizeChangesByAbsoluteSize = {}
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.BackgroundColor3 = theme.BackgroundMuted.Color
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.BackgroundTransparency = theme.BackgroundMuted.Transparency
		local v24 = if data.props.backgroundFrameSize then data.props.backgroundFrameSize else UDim2.fromScale(1, 1)
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.Size = v24
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.AnchorPoint = Vector2.new(0.5, 0)
		onBackgroundComponentFrameSizeChangesByAbsoluteSize.Position = UDim2.fromScale(0.5, 0)
		onBackgroundComponentFrameSizeChangesByAbsoluteSize[Roact.Change.AbsoluteSize] = data.onBackgroundComponentFrameSizeChange
		local v25 = {
			GradientPlaceholder = v17 and Roact.createElement("UIGradient", bannerPlaceholderGradient) or nil,
			UIAspectRatioConstraint = 0,
			BackgroundImage = 0
		}

		local v26 = if not (v17 or data.props.disableBackgroundAspectRatio) then Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 16 / 9
		}) else nil
		v25.UIAspectRatioConstraint = v26

		local v27 = if v17 == false then Roact.createElement(loadableImage, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0, backgroundComponentPosition),
			Size = fFlagLuaAppFixSDPLayout and data.props.backgroundImageSize or UDim2.new(0, containerSize.x, 1, 0),
			Image = data.props.bannerImageUrl,
			ScaleType = Enum.ScaleType.Crop,
			BackgroundTransparency = data.props.backgroundImageTransparency
		}) or nil else nil
		v25.BackgroundImage = v27
		local children = {
			CloseButtonFrame = v22,
			BackgroundDetailsFrame = createElement2(
				"Frame",
				onBackgroundComponentFrameSizeChangesByAbsoluteSize,
				v25
			),
			StickyActionBarFrame = 0,
			ContentScrollingFrame = 0,
			FullscreenFrame = 0,
			MobileActionBarFrame = 0
		}

		local v28 = if data.state.showStickyActionTopBar or v16 and not data.props.disableStickyActionBar then Roact.createElement("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, v14),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
			BorderSizePixel = 0
		}, {
			StickyActionBar = Roact.createElement(module6, {
				actionBarProps = data.props.actionBarProps,
				actionBarWidth = data.props.actionBarWidth,
				infoProps = {
					icon = data.props.thumbnailImageUrl,
					title = data.props.titleText
				}
			})
		}) or nil else nil
		children.StickyActionBarFrame = v28

		local createElement3 = Roact.createElement
		local canvasPositionChangesByCanvasPosition = {
			size = UDim2.fromScale(1, 1),
			canvasSizeY = UDim.new(1, 0),
			useAutomaticCanvasSize = true,
			scrollingEnabled = not (data.props.disableScrollingForFocusNav or v16),
			[Roact.Change.CanvasPosition] = data.canvasPositionChange,
			scrollingFrameRef = data.scrollingFrameRef,
			isGamepadFocusable = false,
			selectable = false
		}

		local v30 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			Padding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v15),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}),
			MainView = 0,
			MobileActionViewPadding = 0
		}

		local createElement4 = Roact.createElement
		local v32 = {
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
		local v34 = {
			Size = UDim2.new(1, 0, 0, v14),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local createElement6 = Roact.createElement
		local v37 = {
			thumbnailImageUrl = data.props.thumbnailImageUrl,
			thumbnailAspectRatio = data.props.thumbnailAspectRatio,
			thumbnailHeight = v13,
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

		local v38 = if fFlagLuaAppFixDetailsPageThumbnailRenderInPhone then data.props.thumbnailShadowHeight else nil
		v37.thumbnailShadowHeight = v38

		v37.titleText = data.props.titleText
		v37.subTitleText = data.props.subTitleText
		v37.actionBarLabelText = data.props.actionBarLabelText
		v37.renderInfoContent = data.props.renderInfoContent
		v37.renderCustomHeader = data.props.renderCustomHeader

		local v39 = if not (data.state.showStickyActionTopBar or not data.props.disableStickyActionBar and v16) then data.props.actionBarProps else nil
		v37.actionBarProps = v39

		v37.actionBarWidth = data.props.actionBarWidth
		v37.actionBarHeight = data.props.actionBarHeight

		v37.headerBarBackgroundHeight = v14
		v37.sideMargin = sideMargin
		v37.maxContentWidth = data.props.maxContentWidth

		v37.deviceType = data.props.deviceType
		v37.gradientHeight = data.props.gradientHeight
		v37.renderActionBarLabelImpressionsDetector = data.props.renderActionBarLabelImpressionsDetector
		v37.scrollViewPositionChangedSignal = data.scrollViewPositionChangedSignal
		children2.HeaderContainer = createElement5("Frame", v34, {
			DetailsPageHeader = createElement6(module8, v37)
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
				Size = fFlagLuaAppFixSDPLayout and data.props.bodyContainerSafeAreaSize or UDim2.fromOffset(
					math.min(containerSize.x, containerSize.y * (16 / 9)),
					0
				),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				DetailsPageBody = Roact.createElement(module9, {
					titleText = data.props.titleText,
					subTitleText = data.props.subTitleText,
					renderInfoContent = data.props.renderInfoContent,
					bodyClipsDescendants = data.props.bodyClipsDescendants,
					componentList = data.props.componentList,
					dualPanelBreakpoint = dualPanelBreakpoint,
					sideMargin = sideMargin,
					maxContentWidth = data.props.maxContentWidth,
					deviceType = data.props.deviceType,
					showPageDetails = v11 and data.props.renderCustomHeader == nil,
					bottomPadding = 100
				})
			})
		})
		v30.MainView = createElement4("Frame", v32, children2)

		v30.MobileActionViewPadding = actionBarProps
			and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 72),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			})
		children.ContentScrollingFrame = createElement3(
			verticalScrollView,
			canvasPositionChangesByCanvasPosition,
			v30
		)

		children.FullscreenFrame = v16 and Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, -v14),
			Position = UDim2.fromOffset(0, v14),
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
			ActionBar = Roact.createElement(actionBar, {
				button = data.props.actionBarProps.button,
				icons = data.props.actionBarProps.icons
			})
		})
		return createElement("TextButton", v20, children)
	end)
end

function extended.didMount(p2)
	if p2.containerRef.current then
		p2.onContainerSizeChange(p2.containerRef.current)
	end
end

function extended.didUpdate(data)
	local v11 = getPlatformConfig(data.props.deviceType)

	if data.scrolled == false and data.scrollingFrameRef.current then
		local startingOffsetPosition

		if data.props.startingOffsetPosition then
			startingOffsetPosition = data.props.startingOffsetPosition
		else
			startingOffsetPosition = v11.startingOffsetPosition
		end

		local props = data.props
		local backgroundHeight = data.state.backgroundHeight
		local v13 = getPlatformConfig(props.deviceType)
		local v14

		if props.headerBarBackgroundHeight then
			v14 = props.headerBarBackgroundHeight
		else
			v14 = v13.headerBarBackgroundHeight * props.foundationTokens.Stroke.Standard
		end

		local v15 = math.max(0, backgroundHeight - v14 - startingOffsetPosition)
		data.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, v15)
	end
end

return function(p2)
	local ref = React.useRef(nil)
	useAnimateScrollViewToSelection(ref, 0.4)
	local v11 = useTokens()
	local v12 = useLastInputMode() ~= "Cursor"
	return React.createElement(
		extended,
		Cryo.Dictionary.join(p2, {
			foundationTokens = v11,
			scrollingFrameRef = ref,
			disableScrollingForFocusNav = v12
		})
	)
end
