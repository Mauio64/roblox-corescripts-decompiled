local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/fox")
local module2 = require("@luauforge/deferred/gXa")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local insetBackground = require("@game/CorePackages/Workspace/Packages/AppBlox").InsetBackground
local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local module3 = require("@luauforge/deferred/gfb")
local module4 = require("@luauforge/bundled/dTM")
require("@luauforge/bundled/dHK")

local module5 = require("@luauforge/bundled/eeo")
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module5.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module6 = require("@luauforge/deferred/gmV")
local module7 = require("@luauforge/deferred/gXc")

local module8 = require("@luauforge/deferred/gUU")
local module9 = require("@luauforge/bundled/dTl")
local module10 = require("@luauforge/bundled/dTm")
local module11 = require("@luauforge/bundled/dTo")
local module12 = require("@luauforge/bundled/fvv")
local module13 = require("@luauforge/bundled/dTh")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module14 = require("@luauforge/deferred/fws")

local module15 = require("@luauforge/deferred/gXb")

local fFlagAXPPEReturnToEntrySurface = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXPPEReturnToEntrySurface

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("ProfilePictureEditorCameraPage")

local iconsactionszoomIn = images["icons/actions/zoomIn"]
local iconsactionszoomOut = images["icons/actions/zoomOut"]

local iconsactionscycleLeft = images["icons/actions/cycleLeft"]
local iconsactionscycleRight = images["icons/actions/cycleRight"]

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p2, callback)
	local v5 = ReactFocusNavigation.useEventMap(navigateBacks, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local strictInterface = t.strictInterface
local v5 = {
	avatarRoute = t.table,
	resolvedFocusNavigationRef = t.table,
	topBarRef = t.table,
	entryOrigin = t.optional(t.table),
	navigation = t.table,
	profilePictureEditorAnalytics = t.table,
	zoomSliderValue = t.number,
	rotateSliderValue = t.number,
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}),
	screenSize = 0,
	isPortrait = 0,
	setCameraSliderZoom = 0,
	setCameraSliderRotate = 0,
	setFinalPageViewMode = 0
}

local v6 = if not module15 then t.Vector2 else nil
v5.screenSize = v6
v5.isPortrait = t.boolean

v5.setCameraSliderZoom = t.callback
v5.setCameraSliderRotate = t.callback
v5.setFinalPageViewMode = t.callback
extended.validateProps = strictInterface(v5)

function extended:init()
	self.bottomBarRef = Roact.createRef()

	self.defaultPositionRef = Roact.createRef()
	self.zoomSliderRef = Roact.createRef()
	self.rotateSliderRef = Roact.createRef()

	function self.goBack()
		if fFlagAXPPEReturnToEntrySurface then
			local entryOrigin = self.props.entryOrigin

			if
				entryOrigin
				and not module4.isWithinViewContext(
					self.props.avatarRoute,
					avatarScreen.ProfilePictureEditorEmotes
				)
			then
				module4.restoreEntryOrigin(self.props.navigation, entryOrigin.screenName)
				return
			end
		end

		self.props.navigation.goBack()
	end

	if fFlagAXPPEReturnToEntrySurface then
		self.backButton = module.makeBackButton(self.goBack)
	end

	function self.onNext()
		self.props.profilePictureEditorAnalytics.clickNextFromCameraPage(
			self.props.zoomSliderValue ~= 0,
			self.props.rotateSliderValue ~= 0
		)

		self.props.setFinalPageViewMode()

		local navigation = self.props.navigation
		navigation.navigate(
			avatarScreen.ProfilePictureEditorFinal,
			not fFlagAXPPEReturnToEntrySurface and {} or module4.getEntryOriginParams(navigation)
		)
	end

	function self.onDefaultPosition()
		self.props.profilePictureEditorAnalytics.clickDefaultPositionsFromCameraPage()
		self.props.setCameraSliderZoom(0)
		self.props.setCameraSliderRotate(0)
	end

	function self.onZoomChanged(p2)
		self.props.setCameraSliderZoom(p2)
	end

	function self.onRotateChanged(p2)
		self.props.setCameraSliderRotate(p2)
	end

	function self.zoomToPoint(p2, p3)
		local v7 = math.clamp(self.props.zoomSliderValue + p2 * 2, -module12.SliderMax, module12.SliderMax)
		self.props.setCameraSliderZoom(v7)
	end

	function self.rotateByPixels(p2)
		local v7 = math.clamp(
			self.props.rotateSliderValue + p2 * 1,
			-module12.SliderMax,
			module12.SliderMax
		)
		self.props.setCameraSliderRotate(v7)
	end
end

function extended.renderMiddleContents(p2, p3)
	local theme = p3.Theme
	return Roact.createElement(imageSetLabel, {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(0, 0),
		Image = module12.CircleCutoutAsset,
		ImageColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = 1,
		ZIndex = 4
	})
end

function extended.renderBottomContents(props, props2, p2)
	local font = p2.Font

	local baseSize = font.BaseSize
	local v7 = font.Header2.RelativeSize * baseSize
	local font2 = font.Header2.Font

	local zoomSliderValue = props.props.zoomSliderValue
	local rotateSliderValue = props.props.rotateSliderValue

	local v8 = zoomSliderValue == 0 and rotateSliderValue == 0
	local v9

	if foundationFontFaceMigration then
		v9 = getTextSize(
			props2.defaultPosition,
			v7,
			p2.Tokens.Typography.TitleLarge.Font,
			Vector2.new(10000, 10000),
			{ addTemporaryPadding = false }
		)
	else
		v9 = TextService:GetTextSize(props2.defaultPosition, v7, font2, Vector2.new(10000, 10000))
	end

	return Roact.createElement(
		focusable.Frame,
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			NextSelectionUp = props.props.topBarRef,
			NextSelectionDown = props.bottomBarRef
		},
		{
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			ButtonTopPadding = Roact.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0.05),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					uiSizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, 50)
					})
				}
			),
			ButtonFrame = Roact.createElement(focusable.Frame, {
				Size = UDim2.new(0, v9.X + 20, 0, 36),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				[Roact.Ref] = props.defaultPositionRef,
				NextSelectionUp = props.props.topBarRef,
				NextSelectionDown = props.zoomSliderRef
			}, {
				ButtonStack = Roact.createElement(buttonStack, {
					buttons = {
						{
							buttonType = buttonType.PrimarySystem,
							props = {
								onActivated = props.onDefaultPosition,
								text = props2.defaultPosition,
								isDisabled = v8
							}
						}
					}
				})
			}),
			AboveSliderPadding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 10),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 3
			}),
			ZoomSlider = Roact.createElement(module7, {
				text = props2.zoom,
				onSliderChanged = props.onZoomChanged,
				layoutOrder = 4,
				value = zoomSliderValue,
				leftIcon = iconsactionszoomOut,
				rightIcon = iconsactionszoomIn,
				min = -module12.SliderMax,
				max = module12.SliderMax,
				baseRef = props.zoomSliderRef,
				NextSelectionUp = props.defaultPositionRef,
				NextSelectionDown = props.rotateSliderRef
			}),
			BetweenSliderPadding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 10),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 5
			}),
			RotateSlider = Roact.createElement(module7, {
				text = props2.rotate,
				onSliderChanged = props.onRotateChanged,
				layoutOrder = 6,
				value = rotateSliderValue,
				leftIcon = iconsactionscycleLeft,
				rightIcon = iconsactionscycleRight,
				min = -module12.SliderMax,
				max = module12.SliderMax,
				baseRef = props.rotateSliderRef,
				NextSelectionUp = props.zoomSliderRef,
				NextSelectionDown = props.bottomBarRef
			})
		}
	)
end

function extended:renderWithProviders(p2, p3)
	local screenSize = self.props.screenSize
	local globalGuiInset = self.props.globalGuiInset
	local isPortrait = self.props.isPortrait

	local createElement = Roact.createElement
	local frame = focusable.Frame

	local v7 = if module15 then UDim2.fromScale(1, 1) else getSafeAreaSize(screenSize, globalGuiInset)
	local resolvedFocusNavigationRefsByRef = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v7,
		Position = UDim2.new(0, 0, 0, 0),
		Active = true,
		defaultChild = self.zoomSliderRef,
		[Roact.Ref] = self.props.resolvedFocusNavigationRef
	}

	local createElement2 = Roact.createElement
	local container = module.Container
	local topBarRefsByRef = {
		tag = compositionTags.ContentRegion.Header,
		sideMarginOverride = 0,
		titleText = p2.title,
		[Roact.Ref] = self.props.topBarRef,
		NextSelectionDown = self.defaultPositionRef,
		transparentBackground = false,
		hideSiteMessageBanner = isPortrait
	}

	local v8 = if fFlagAXPPEReturnToEntrySurface then self.backButton else module.BackButton
	topBarRefsByRef.leftItem = v8
	return createElement(frame, resolvedFocusNavigationRefsByRef, {
		SimpleTopBar = createElement2(container, topBarRefsByRef),
		PeekabooWidget = Roact.createElement(module2, {
			viewportYScale = 0.375,
			viewportXScale = 2 / 3,
			topMarginYScale = 0.125,
			renderBottomContents = function()
				return self:renderBottomContents(p2, p3)
			end,
			renderMiddleContents = function()
				return self:renderMiddleContents(p3)
			end,
			zoomToPoint = self.zoomToPoint,
			rotateByPixels = self.rotateByPixels
		}),
		BottomBar = Roact.createElement(module8, {
			baseRef = self.bottomBarRef,
			NextSelectionUp = self.rotateSliderRef,
			button1 = {
				textKey = "Authentication.CrossDevice.Action.GoBack",
				onActivated = self.goBack
			},
			button2 = {
				textKey = "Authentication.CrossDevice.Action.Next",
				onActivated = self.onNext
			}
		}),
		InsetBackground = Roact.createElement(insetBackground, {
			directions = { left = true, top = true, right = true, bottom = true }
		})
	})
end

function extended:render()
	return withLocalization({
		title = "Feature.Avatar.Label.PPEPositionCameraHeader",
		defaultPosition = "Feature.Avatar.Action.Reset",
		zoom = "Feature.Avatar.Action.Zoom",
		rotate = "Feature.Avatar.Action.Rotate"
	})(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local function mapStateToProps(data, p2)
	local v7 = {
		isPortrait = data.DeviceOrientation == deviceOrientationMode.Portrait,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = 0,
		zoomSliderValue = 0,
		rotateSliderValue = 0
	}
	local v8 = if not module15 then data.ScreenSize else nil
	v7.screenSize = v8
	v7.zoomSliderValue = data.AvatarExperience.ProfilePictureEditor.CameraSliders.zoomSliderValue
	v7.rotateSliderValue = data.AvatarExperience.ProfilePictureEditor.CameraSliders.rotateSliderValue
	return v7
end

local function mapDispatchToProps(callback)
	return {
		setCameraSliderZoom = function(p2)
			return callback(module9(p2))
		end,
		setCameraSliderRotate = function(p2)
			return callback(module10(p2))
		end,
		setFinalPageViewMode = function()
			return callback(module11(module13.Closeup))
		end
	}
end

local v7 = module3((module6((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)))))

local v8 = roactServices.connect({ profilePictureEditorAnalytics = module14 })(v7)

return function(p2)
	local ref = React.useRef(nil)
	local v9 = useFocusGuiObject()
	local v10 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, React.useCallback(function()
		if v9 and ref and ref.current then
			v9(ref.current)
		end
	end, { v9 }))))

	return React.createElement(
		v8,
		Cryo.Dictionary.join(p2, { topBarRef = ref, resolvedFocusNavigationRef = v10 })
	)
end
