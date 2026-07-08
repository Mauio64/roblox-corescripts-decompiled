local AppBlox = script:FindFirstAncestor("AppBlox")
local AppBloxParent = AppBlox.Parent
local UIBlox = require(AppBloxParent.UIBlox)
local Cryo = require(AppBloxParent.Cryo)
local React = require(AppBloxParent.React)
local Roact = require(AppBloxParent.Roact)
local t = require(AppBloxParent.t)
local useTokens = require(AppBloxParent.Foundation).Hooks.useTokens
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
local DeviceType = require(AppBloxParent.RobloxAppEnums).DeviceType
local useLastInputMode = require(AppBloxParent.FocusNavigationUtils).useLastInputMode
local Signal = require(AppBloxParent.AppCommonLib).Signal
local getPlatformConfig = require(script.Parent.getPlatformConfig)
local DetailsPageHeader = require(script.Parent.DetailsPageHeader)
local DetailsPageBody = require(script.Parent.DetailsPageBody)
local validateDetailsPageComponentList = require(script.Parent.validateDetailsPageComponentList)
local useAnimateScrollViewToSelection = require(AppBlox.useAnimateScrollViewToSelection)
local getTestId = require(AppBloxParent.RoactUtils).getTestId
local FFlagLuaAppFixDetailsPageThumbnailRenderInPhone = require(AppBloxParent.SharedFlags).FFlagLuaAppFixDetailsPageThumbnailRenderInPhone
local FFlagLuaAppFixSDPLayout = require(AppBloxParent.SharedFlags).FFlagLuaAppFixSDPLayout
local v30 = game:DefineFastFlag("LuaAppDisableStickyBarMediaGallery", false)
local FFlagLuaAppAddTestIdsForArrow = require(AppBloxParent.SharedFlags).FFlagLuaAppAddTestIdsForArrow
local v32 = Roact.PureComponent:extend("DetailsPageTemplate")

local function applyTokenScaling(n1: number, p1) -- line: 59
	return n1 * p1.Stroke.Standard
end

v32.validateProps = t.strictInterface({
	foundationTokens = t.table,
	thumbnailImageUrl = t.optional(t.string),
	thumbnailHeight = t.optional(t.number),
	thumbnailAspectRatio = t.optional(t.Vector2),
	thumbnailShadowHeight = if not FFlagLuaAppFixDetailsPageThumbnailRenderInPhone then nil else t.optional(t.number),
	titleText = t.optional(t.string),
	subTitleText = t.optional(t.string),
	actionBarLabelText = t.optional(t.string),
	renderInfoContent = t.optional(t.callback),
	renderCustomHeader = t.optional(t.callback),
	actionBarProps = t.optional(t.table),
	actionBarWidth = t.optional(t.number),
	actionBarHeight = t.optional(t.number),
	renderActionBarLabelImpressionsDetector = t.optional(t.callback),
	componentList = t.optional(validateDetailsPageComponentList),
	dualPanelBreakpoint = t.optional(t.number),
	sideMargin = t.optional(t.number),
	bodyClipsDescendants = t.optional(t.boolean),
	maxContentWidth = t.optional(t.number),
	startingOffsetPosition = t.optional(t.number),
	headerBarBackgroundHeight = t.optional(t.number),
	onClose = t.callback,
	bannerPlaceholderGradient = t.optional(t.table),
	bannerImageUrl = t.optional(t.string),
	isFullscreen = t.optional(t.boolean),
	renderFullscreenContent = t.optional(t.callback),
	deviceType = t.optional(t.string),
	isMobile = t.optional(t.boolean),
	tokens = t.optional(t.table),
	containerRef = t.optional(t.union(t.table, t.callback)),
	backgroundFrameSize = t.optional(t.UDim2),
	scrollingFrameRef = t.optional(t.table),
	disableScrollingForFocusNav = t.optional(t.boolean),
	gradientHeight = t.optional(t.number),
	backgroundImageTransparency = t.optional(t.number),
	disableBackgroundAspectRatio = t.optional(t.boolean),
	bodyContainerSafeAreaSize = if not FFlagLuaAppFixSDPLayout then nil else t.optional(t.UDim2),
	backgroundImageSize = if not FFlagLuaAppFixSDPLayout then nil else t.optional(t.UDim2),
	headerPadding = if not FFlagLuaAppFixSDPLayout then nil else t.optional(t.number),
	disableStickyActionBar = t.optional(t.boolean),
	hideCloseButton = t.optional(t.boolean)
})
v32.defaultProps = {
	isFullscreen = false,
	deviceType = DeviceType.Desktop
}

local function getHeaderPaddingHeight(p2, n2: number) -- line: 170
	-- upvalues: getPlatformConfig (copy)
	local v39 = getPlatformConfig(p2.deviceType)

	return n2 - if not p2.headerBarBackgroundHeight then v39.headerBarBackgroundHeight * p2.foundationTokens.Stroke.Standard else p2.headerBarBackgroundHeight
end

function v32.init(p3) -- line: 179
	-- upvalues: Roact (copy), Signal (copy), getPlatformConfig (copy), DeviceType (copy)
	p3.containerRef = Roact.createRef()
	p3.scrollingFrameRef = p3.props.scrollingFrameRef
	p3.scrolled = false
	p3.scrollViewPositionChangedSignal = Signal.new()
	p3.state = {
		showStickyActionTopBar = false,
		backgroundHeight = 500,
		backgroundComponentPosition = 250,
		containerSize = Vector2.new(500, 500)
	}

	function p3.onContainerSizeChange(p4) -- line: 191
		-- upvalues: p3 (copy)
		p3:setState({
			containerSize = p4.AbsoluteSize
		})
	end
	function p3.onBackgroundComponentFrameSizeChange(p5) -- line: 197
		-- upvalues: p3 (copy), getPlatformConfig (copy)
		p3:setState(function(_, p7) -- line: 199
			-- upvalues: p5 (copy), getPlatformConfig (copy)
			local AbsoluteSizeY = p5.AbsoluteSize.Y
			local v83 = getPlatformConfig(p7.deviceType)
			local v84 = math.max(0, AbsoluteSizeY - (if not p7.headerBarBackgroundHeight then v83.headerBarBackgroundHeight * p7.foundationTokens.Stroke.Standard else p7.headerBarBackgroundHeight)) / 2

			return {
				backgroundHeight = AbsoluteSizeY,
				backgroundComponentPosition = v84
			}
		end)
	end
	function p3.canvasPositionChange(p8) -- line: 210
		-- upvalues: p3 (copy), getPlatformConfig (copy), DeviceType (copy)
		p3.scrollViewPositionChangedSignal:fire()
		p3.scrolled = true
		p3:setState(function(p9, p10) -- line: 214
			-- upvalues: getPlatformConfig (copy), p8 (copy), p3 (copy), DeviceType (copy)
			local backgroundHeight = p9.backgroundHeight
			local v88 = getPlatformConfig(p10.deviceType)
			local v89 = backgroundHeight - if not p10.headerBarBackgroundHeight then v88.headerBarBackgroundHeight * p10.foundationTokens.Stroke.Standard else p10.headerBarBackgroundHeight
			local v90 = math.max(0, v89 - p8.CanvasPosition.Y) / 2

			if v89 < p8.CanvasPosition.Y then
				if p9.showStickyActionTopBar == false and p3.props.deviceType ~= DeviceType.Phone and not p3.props.disableStickyActionBar then
					return {
						showStickyActionTopBar = true
					}
				end

				return nil
			end

			if p9.showStickyActionTopBar == true then
				return {
					showStickyActionTopBar = false,
					backgroundComponentPosition = v90
				}
			end

			return {
				backgroundComponentPosition = v90
			}
		end)
	end
end
function v32.render(p11) -- line: 251
	-- upvalues: DeviceType (copy), getPlatformConfig (copy), FFlagLuaAppFixSDPLayout (copy), withStyle (copy), getIconSize (copy), IconSize (copy), Roact (copy), getIconSizeUDim2 (copy), React (copy), FFlagLuaAppAddTestIdsForArrow (copy), getTestId (copy), IconButton (copy), Images (copy), LoadableImage (copy), v30 (copy), StickyActionBar (copy), VerticalScrollView (copy), DetailsPageHeader (copy), FFlagLuaAppFixDetailsPageThumbnailRenderInPhone (copy), DetailsPageBody (copy), ActionBar (copy)
	local v42 = p11.props.deviceType == DeviceType.Phone
	local v43 = getPlatformConfig(p11.props.deviceType)
	local v44 = if not p11.props.thumbnailHeight then v43.thumbnailHeight * p11.props.foundationTokens.Stroke.Standard else p11.props.thumbnailHeight
	local v45 = if not p11.props.headerBarBackgroundHeight then v43.headerBarBackgroundHeight * p11.props.foundationTokens.Stroke.Standard else p11.props.headerBarBackgroundHeight
	local v46 = if not p11.props.sideMargin then v43.sideMargin else p11.props.sideMargin
	local v47 = if not p11.props.dualPanelBreakpoint then v43.dualPanelBreakpoint else p11.props.dualPanelBreakpoint
	local g49 = nil
	local headerPadding = nil

	if FFlagLuaAppFixSDPLayout then
		headerPadding = p11.props.headerPadding

		if headerPadding then
			g49 = true
		end
	end

	if not g49 then
		local props = p11.props
		local backgroundHeight = p11.state.backgroundHeight
		local v52 = getPlatformConfig(props.deviceType)

		headerPadding = backgroundHeight - if not props.headerBarBackgroundHeight then v52.headerBarBackgroundHeight * props.foundationTokens.Stroke.Standard else props.headerBarBackgroundHeight
	end

	g49 = false

	local v53 = headerPadding
	local backgroundComponentPosition = p11.state.backgroundComponentPosition
	local containerSize = p11.state.containerSize
	local isFullscreen = p11.props.isFullscreen
	local renderFullscreenContent = p11.props.renderFullscreenContent
	local v58 = not v42 and (not not isFullscreen and not not renderFullscreenContent)

	return withStyle(function(p12) -- line: 275
		-- upvalues: p11 (copy), v42 (copy), getIconSize (copy), IconSize (copy), v45 (copy), Roact (copy), getIconSizeUDim2 (copy), React (copy), FFlagLuaAppAddTestIdsForArrow (copy), getTestId (copy), IconButton (copy), v58 (copy), Images (copy), LoadableImage (copy), backgroundComponentPosition (copy), FFlagLuaAppFixSDPLayout (copy), containerSize (copy), v30 (copy), StickyActionBar (copy), VerticalScrollView (copy), v53 (copy), DetailsPageHeader (copy), v44 (copy), FFlagLuaAppFixDetailsPageThumbnailRenderInPhone (copy), v46 (copy), DetailsPageBody (copy), v47 (copy), renderFullscreenContent (copy), ActionBar (copy)
		local Theme = p12.Theme
		local v76 = p11.props.bannerImageUrl == nil
		local v77 = p11.props.bannerPlaceholderGradient or {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Theme.BackgroundMuted.Color),
				ColorSequenceKeypoint.new(1, Theme.BackgroundUIDefault.Color)
			})
		}
		local v78 = v42 and (getIconSize(IconSize.Large) + 22) / 2 or v45 / 2
		local v79 = v42 and p11.props.actionBarProps

		return Roact.createElement("TextButton", {
			Text = "",
			Selectable = false,
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			[Roact.Ref] = if not p11.props.containerRef then p11.containerRef else p11.props.containerRef,
			[Roact.Change.AbsoluteSize] = p11.onContainerSizeChange
		}, {
			CloseButtonFrame = if p11.props.hideCloseButton then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = getIconSizeUDim2(IconSize.Large),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 22, 0, v78),
				ZIndex = 2,
				[React.Tag] = if not FFlagLuaAppAddTestIdsForArrow then nil else getTestId("details-close-button")
			}, {
				CloseButton = Roact.createElement(IconButton, {
					size = UDim2.fromScale(1, 1),
					icon = v58 and Images["icons/navigation/pushBack"] or Images["icons/navigation/close"],
					iconColor3 = p12.Theme.UIEmphasis.Color,
					iconSize = IconSize.Medium,
					onActivated = p11.props.onClose,
					showBackground = p11.state.showStickyActionTopBar == false,
					backgroundColor = p12.Theme.BackgroundUIDefault
				})
			}),
			BackgroundDetailsFrame = Roact.createElement("Frame", {
				BackgroundColor3 = Theme.BackgroundMuted.Color,
				BackgroundTransparency = Theme.BackgroundMuted.Transparency,
				Size = if not p11.props.backgroundFrameSize then UDim2.fromScale(1, 1) else p11.props.backgroundFrameSize,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				[Roact.Change.AbsoluteSize] = p11.onBackgroundComponentFrameSizeChange
			}, {
				GradientPlaceholder = v76 and Roact.createElement("UIGradient", v77) or nil,
				UIAspectRatioConstraint = if not v76 and not p11.props.disableBackgroundAspectRatio then Roact.createElement("UIAspectRatioConstraint", {
					AspectRatio = 1.7777777777777777
				}) else nil,
				BackgroundImage = v76 == false and Roact.createElement(LoadableImage, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0, backgroundComponentPosition),
					Size = FFlagLuaAppFixSDPLayout and p11.props.backgroundImageSize or UDim2.new(0, containerSize.x, 1, 0),
					Image = p11.props.bannerImageUrl,
					ScaleType = Enum.ScaleType.Crop,
					BackgroundTransparency = p11.props.backgroundImageTransparency
				}) or nil
			}),
			StickyActionBarFrame = not (not p11.state.showStickyActionTopBar and not (if not v30 then v58 else v58 and not p11.props.disableStickyActionBar)) and Roact.createElement("TextButton", {
				Text = "",
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, v45),
				BackgroundColor3 = Theme.BackgroundUIDefault.Color,
				BackgroundTransparency = Theme.BackgroundUIDefault.Transparency
			}, {
				StickyActionBar = Roact.createElement(StickyActionBar, {
					actionBarProps = p11.props.actionBarProps,
					actionBarWidth = p11.props.actionBarWidth,
					infoProps = {
						icon = p11.props.thumbnailImageUrl,
						title = p11.props.titleText
					}
				})
			}) or nil,
			ContentScrollingFrame = Roact.createElement(VerticalScrollView, {
				size = UDim2.fromScale(1, 1),
				canvasSizeY = UDim.new(1, 0),
				useAutomaticCanvasSize = true,
				scrollingEnabled = not p11.props.disableScrollingForFocusNav and not v58,
				[Roact.Change.CanvasPosition] = p11.canvasPositionChange,
				scrollingFrameRef = p11.scrollingFrameRef,
				isGamepadFocusable = false,
				selectable = false
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Padding = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v53)
				}),
				MainView = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical
					}),
					HeaderContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v45)
					}, {
						DetailsPageHeader = Roact.createElement(DetailsPageHeader, {
							thumbnailImageUrl = p11.props.thumbnailImageUrl,
							thumbnailAspectRatio = p11.props.thumbnailAspectRatio,
							thumbnailHeight = v44,
							thumbnailShadowHeight = if not FFlagLuaAppFixDetailsPageThumbnailRenderInPhone then nil else p11.props.thumbnailShadowHeight,
							titleText = p11.props.titleText,
							subTitleText = p11.props.subTitleText,
							actionBarLabelText = p11.props.actionBarLabelText,
							renderInfoContent = p11.props.renderInfoContent,
							renderCustomHeader = p11.props.renderCustomHeader,
							actionBarProps = if p11.state.showStickyActionTopBar or if not v30 then v58 else not p11.props.disableStickyActionBar and v58 then nil else p11.props.actionBarProps,
							actionBarWidth = p11.props.actionBarWidth,
							actionBarHeight = p11.props.actionBarHeight,
							headerBarBackgroundHeight = v45,
							sideMargin = v46,
							maxContentWidth = p11.props.maxContentWidth,
							deviceType = p11.props.deviceType,
							gradientHeight = p11.props.gradientHeight,
							renderActionBarLabelImpressionsDetector = p11.props.renderActionBarLabelImpressionsDetector,
							scrollViewPositionChangedSignal = p11.scrollViewPositionChangedSignal
						})
					}),
					BodyContainer = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 0),
						BackgroundColor3 = Theme.BackgroundDefault.Color,
						BackgroundTransparency = Theme.BackgroundDefault.Transparency,
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						BodyContainerSafeArea = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = FFlagLuaAppFixSDPLayout and p11.props.bodyContainerSafeAreaSize or UDim2.fromOffset(math.min(containerSize.x, containerSize.y * 1.7777777777777777), 0),
							AnchorPoint = Vector2.new(0.5, 0),
							Position = UDim2.fromScale(0.5, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							DetailsPageBody = Roact.createElement(DetailsPageBody, {
								bottomPadding = 100,
								titleText = p11.props.titleText,
								subTitleText = p11.props.subTitleText,
								renderInfoContent = p11.props.renderInfoContent,
								bodyClipsDescendants = p11.props.bodyClipsDescendants,
								componentList = p11.props.componentList,
								dualPanelBreakpoint = v47,
								sideMargin = v46,
								maxContentWidth = p11.props.maxContentWidth,
								deviceType = p11.props.deviceType,
								showPageDetails = v42 and p11.props.renderCustomHeader == nil
							})
						})
					})
				}),
				MobileActionViewPadding = v79 and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 72)
				})
			}),
			FullscreenFrame = v58 and Roact.createElement("TextButton", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				ClipsDescendants = true,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, -v45),
				Position = UDim2.fromOffset(0, v45)
			}, {
				FullscreenContent = renderFullscreenContent()
			}) or nil,
			MobileActionBarFrame = v79 and Roact.createElement("TextButton", {
				Text = "",
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ZIndex = 3,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 72),
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency
			}, {
				GradientBar = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundColor3 = Theme.BackgroundDefault.Color,
					AnchorPoint = Vector2.new(0, 1)
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
					button = p11.props.actionBarProps.button,
					icons = p11.props.actionBarProps.icons
				})
			})
		})
	end)
end
function v32.didMount(p13) -- line: 527
	if p13.containerRef.current then
		p13.onContainerSizeChange(p13.containerRef.current)
	end
end
function v32.didUpdate(p14) -- line: 533
	-- upvalues: getPlatformConfig (copy)
	local v61 = getPlatformConfig(p14.props.deviceType)

	if p14.scrolled == false and p14.scrollingFrameRef.current then
		local v62 = if not p14.props.startingOffsetPosition then v61.startingOffsetPosition else p14.props.startingOffsetPosition
		local props = p14.props
		local backgroundHeight = p14.state.backgroundHeight
		local v65 = getPlatformConfig(props.deviceType)
		local v66 = math.max(0, backgroundHeight - (if not props.headerBarBackgroundHeight then v65.headerBarBackgroundHeight * props.foundationTokens.Stroke.Standard else props.headerBarBackgroundHeight) - v62)

		p14.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, v66)
	end
end

return function(p15) -- line: 547
	-- upvalues: React (copy), useAnimateScrollViewToSelection (copy), useTokens (copy), useLastInputMode (copy), v32 (copy), Cryo (copy)
	local v68 = React.useRef(nil)

	useAnimateScrollViewToSelection(v68, 0.4)

	local v69 = useTokens()
	local v70 = useLastInputMode() ~= "Cursor"

	return React.createElement(v32, Cryo.Dictionary.join(p15, {
		foundationTokens = v69,
		scrollingFrameRef = v68,
		disableScrollingForFocusNav = v70
	}))
end
