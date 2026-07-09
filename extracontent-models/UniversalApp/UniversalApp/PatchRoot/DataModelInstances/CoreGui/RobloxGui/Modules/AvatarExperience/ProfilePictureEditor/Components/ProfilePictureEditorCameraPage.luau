local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local PeekabooWidget = require(Modules.AvatarExperience.ProfilePictureEditor.Components.PeekabooWidget)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local InsetBackground = require(CorePackages.Workspace.Packages.AppBlox).InsetBackground
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local SliderWithLabelAndIcons = require(Modules.AvatarExperience.Common.Components.SliderWithLabelAndIcons)
local ProfilePictureEditorBottomBar = require(Modules.AvatarExperience.ProfilePictureEditor.Components.ProfilePictureEditorBottomBar)
local SetCameraSliderZoom = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetCameraSliderZoom)
local SetCameraSliderRotate = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetCameraSliderRotate)
local SetFinalPageViewMode = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetFinalPageViewMode)
local Constants = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local Analytics = require(Modules.AvatarExperience.ProfilePictureEditor.Services.Analytics)
local BottomInsetBackground = require(Modules.AvatarExperience.Common.Components.BottomInsetBackground)
local FFlagAXF10ftFixPeekabooWidget = require(Modules.AvatarExperience.Flags.FFlagAXF10ftFixPeekabooWidget)
local v36 = game:DefineFastFlag("AXMigrateProfilePictureEditorCameraPageToFocusNavigation", false)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v44 = Roact.PureComponent:extend("ProfilePictureEditorCameraPage")
local v45 = Images["icons/actions/zoomIn"]
local v46 = Images["icons/actions/zoomOut"]
local v47 = Images["icons/actions/cycleLeft"]
local v48 = Images["icons/actions/cycleRight"]
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 95
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v57 = ReactFocusNavigation.useEventMap(t1, p1)
	local v58 = React.useMemo(function() -- line: 97
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 100
					-- upvalues: p2 (copy)
					p3.cancelled = true
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v58, v57)
end

v44.validateProps = t.strictInterface({
	avatarRoute = t.table,
	resolvedFocusNavigationRef = if not v36 then nil else t.table,
	topBarRef = if not v36 then nil else t.table,
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
	screenSize = if not FFlagAXF10ftFixPeekabooWidget then t.Vector2 else nil,
	isPortrait = t.boolean,
	setCameraSliderZoom = t.callback,
	setCameraSliderRotate = t.callback,
	setFinalPageViewMode = t.callback
})

function v44.init(p4) -- line: 137
	-- upvalues: v36 (copy), Roact (copy), AvatarScreen (copy), Constants (copy)
	if not v36 then
		p4.topBarRef = Roact.createRef()
	end

	p4.bottomBarRef = Roact.createRef()
	p4.defaultPositionRef = Roact.createRef()
	p4.zoomSliderRef = Roact.createRef()
	p4.rotateSliderRef = Roact.createRef()

	function p4.goBack() -- line: 147
		-- upvalues: p4 (copy)
		p4.props.navigation.goBack()
	end
	function p4.onNext() -- line: 151
		-- upvalues: p4 (copy), AvatarScreen (copy)
		p4.props.profilePictureEditorAnalytics.clickNextFromCameraPage(p4.props.zoomSliderValue ~= 0, p4.props.rotateSliderValue ~= 0)
		p4.props.setFinalPageViewMode()
		p4.props.navigation.navigate(AvatarScreen.ProfilePictureEditorFinal, {})
	end
	function p4.onDefaultPosition() -- line: 164
		-- upvalues: p4 (copy)
		p4.props.profilePictureEditorAnalytics.clickDefaultPositionsFromCameraPage()
		p4.props.setCameraSliderZoom(0)
		p4.props.setCameraSliderRotate(0)
	end
	function p4.onZoomChanged(p5) -- line: 170
		-- upvalues: p4 (copy)
		p4.props.setCameraSliderZoom(p5)
	end
	function p4.onRotateChanged(p6) -- line: 174
		-- upvalues: p4 (copy)
		p4.props.setCameraSliderRotate(p6)
	end
	function p4.zoomToPoint(n1: number, _) -- line: 178
		-- upvalues: p4 (copy), Constants (copy)
		local v95 = math.clamp(p4.props.zoomSliderValue + n1 * 2, -Constants.SliderMax, Constants.SliderMax)

		p4.props.setCameraSliderZoom(v95)
	end
	function p4.rotateByPixels(n2: number) -- line: 184
		-- upvalues: p4 (copy), Constants (copy)
		local v97 = math.clamp(p4.props.rotateSliderValue + n2 * 1, -Constants.SliderMax, Constants.SliderMax)

		p4.props.setCameraSliderRotate(v97)
	end
end
function v44.renderMiddleContents(_, p9) -- line: 191
	-- upvalues: Roact (copy), ImageSetLabel (copy), Constants (copy)
	local Theme = p9.Theme

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		ZIndex = 4,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(0, 0),
		Image = Constants.CircleCutoutAsset,
		ImageColor3 = Theme.BackgroundDefault.Color
	})
end
function v44.renderBottomContents(p10, p11, p12) -- line: 203
	-- upvalues: TextService (copy), Roact (copy), Focusable (copy), v36 (copy), ButtonStack (copy), ButtonType (copy), SliderWithLabelAndIcons (copy), v46 (copy), v45 (copy), Constants (copy), v47 (copy), v48 (copy)
	local p12Font = p12.Font
	local BaseSize = p12Font.BaseSize
	local v68 = p12Font.Header2.RelativeSize * BaseSize
	local Header2Font = p12Font.Header2.Font
	local zoomSliderValue = p10.props.zoomSliderValue
	local rotateSliderValue = p10.props.rotateSliderValue
	local v72 = zoomSliderValue == 0 and rotateSliderValue == 0
	local TextSize = TextService:GetTextSize(p11.defaultPosition, v68, Header2Font, Vector2.new(10000, 10000))

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		NextSelectionUp = if not v36 then p10.topBarRef else p10.props.topBarRef,
		NextSelectionDown = p10.bottomBarRef
	}, {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		ButtonTopPadding = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0.05)
		}, {
			uiSizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, 50)
			})
		}),
		ButtonFrame = Roact.createElement(Focusable.Frame, {
			Size = UDim2.new(0, TextSize.X + 20, 0, 36),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			[Roact.Ref] = p10.defaultPositionRef,
			NextSelectionUp = if not v36 then p10.topBarRef else p10.props.topBarRef,
			NextSelectionDown = p10.zoomSliderRef
		}, {
			ButtonStack = Roact.createElement(ButtonStack, {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p10.onDefaultPosition,
						text = p11.defaultPosition,
						isDisabled = v72
					}
				}}
			})
		}),
		AboveSliderPadding = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 10)
		}),
		ZoomSlider = Roact.createElement(SliderWithLabelAndIcons, {
			layoutOrder = 4,
			text = p11.zoom,
			onSliderChanged = p10.onZoomChanged,
			value = zoomSliderValue,
			leftIcon = v46,
			rightIcon = v45,
			min = -Constants.SliderMax,
			max = Constants.SliderMax,
			baseRef = p10.zoomSliderRef,
			NextSelectionUp = p10.defaultPositionRef,
			NextSelectionDown = p10.rotateSliderRef
		}),
		BetweenSliderPadding = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, 10)
		}),
		RotateSlider = Roact.createElement(SliderWithLabelAndIcons, {
			layoutOrder = 6,
			text = p11.rotate,
			onSliderChanged = p10.onRotateChanged,
			value = rotateSliderValue,
			leftIcon = v47,
			rightIcon = v48,
			min = -Constants.SliderMax,
			max = Constants.SliderMax,
			baseRef = p10.rotateSliderRef,
			NextSelectionUp = p10.zoomSliderRef,
			NextSelectionDown = p10.bottomBarRef
		})
	})
end
function v44.renderWithProviders(p13, p14, p15) -- line: 305
	-- upvalues: Roact (copy), Focusable (copy), FFlagAXF10ftFixPeekabooWidget (copy), getSafeAreaSize (copy), v36 (copy), TopBar (copy), FFlagEnableLeftNavOnConsole (copy), PeekabooWidget (copy), ProfilePictureEditorBottomBar (copy), BottomInsetBackground (copy), InsetBackground (copy)
	local screenSize = p13.props.screenSize
	local globalGuiInset = p13.props.globalGuiInset
	local isPortrait = p13.props.isPortrait
	local v80 = globalGuiInset.bottom > 0

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = if not FFlagAXF10ftFixPeekabooWidget then getSafeAreaSize(screenSize, globalGuiInset) else UDim2.fromScale(1, 1),
		Position = UDim2.new(0, 0, 0, 0),
		Active = true,
		defaultChild = p13.zoomSliderRef,
		[Roact.Ref] = if not v36 then p13.props[Roact.Ref] else p13.props.resolvedFocusNavigationRef
	}, {
		SimpleTopBar = Roact.createElement(TopBar.Container, {
			titleText = p14.title,
			[Roact.Ref] = if not v36 then p13.topBarRef else p13.props.topBarRef,
			NextSelectionDown = p13.defaultPositionRef,
			transparentBackground = not FFlagEnableLeftNavOnConsole,
			hideSiteMessageBanner = isPortrait,
			leftItem = TopBar.BackButton
		}),
		PeekabooWidget = Roact.createElement(PeekabooWidget, {
			viewportYScale = 0.375,
			viewportXScale = 0.6666666666666666,
			topMarginYScale = 0.125,
			renderBottomContents = function() -- line: 339
				-- upvalues: p13 (copy), p14 (copy), p15 (copy)
				return p13:renderBottomContents(p14, p15)
			end,
			renderMiddleContents = function() -- line: 342
				-- upvalues: p13 (copy), p15 (copy)
				return p13:renderMiddleContents(p15)
			end,
			zoomToPoint = p13.zoomToPoint,
			rotateByPixels = p13.rotateByPixels
		}),
		BottomBar = Roact.createElement(ProfilePictureEditorBottomBar, {
			baseRef = p13.bottomBarRef,
			NextSelectionUp = p13.rotateSliderRef,
			button1 = {
				textKey = "Authentication.CrossDevice.Action.GoBack",
				onActivated = p13.goBack
			},
			button2 = {
				textKey = "Authentication.CrossDevice.Action.Next",
				onActivated = p13.onNext
			}
		}),
		BottomInsetBackground = if not FFlagEnableLeftNavOnConsole then if not v80 then nil else Roact.createElement(BottomInsetBackground, {
			globalGuiInset = globalGuiInset
		}) else nil,
		InsetBackground = if not FFlagEnableLeftNavOnConsole then nil else Roact.createElement(InsetBackground, {
			directions = {
				left = true,
				top = true,
				right = true,
				bottom = true
			}
		})
	})
end
function v44.render(p16) -- line: 378
	-- upvalues: withLocalization (copy), withStyle (copy)
	return withLocalization({
		title = "Feature.Avatar.Label.PPEPositionCameraHeader",
		defaultPosition = "Feature.Avatar.Action.Reset",
		zoom = "Feature.Avatar.Action.Zoom",
		rotate = "Feature.Avatar.Action.Rotate"
	})(function(p17) -- line: 384
		-- upvalues: withStyle (copy), p16 (copy)
		return withStyle(function(p18) -- line: 385
			-- upvalues: p16 (copy), p17 (copy)
			return p16:renderWithProviders(p17, p18)
		end)
	end)
end

local function mapStateToProps(p19, _) -- line: 391
	-- upvalues: DeviceOrientationMode (copy), FFlagAXF10ftFixPeekabooWidget (copy)
	return {
		isPortrait = p19.DeviceOrientation == DeviceOrientationMode.Portrait,
		globalGuiInset = p19.GlobalGuiInset,
		screenSize = if not FFlagAXF10ftFixPeekabooWidget then p19.ScreenSize else nil,
		zoomSliderValue = p19.AvatarExperience.ProfilePictureEditor.CameraSliders.zoomSliderValue,
		rotateSliderValue = p19.AvatarExperience.ProfilePictureEditor.CameraSliders.rotateSliderValue
	}
end
local function mapDispatchToProps(p21) -- line: 403
	-- upvalues: SetCameraSliderZoom (copy), SetCameraSliderRotate (copy), SetFinalPageViewMode (copy), PPEThumbnailType (copy)
	return {
		setCameraSliderZoom = function(p22) -- line: 405
			-- upvalues: p21 (copy), SetCameraSliderZoom (copy)
			return p21(SetCameraSliderZoom(p22))
		end,
		setCameraSliderRotate = function(p23) -- line: 408
			-- upvalues: p21 (copy), SetCameraSliderRotate (copy)
			return p21(SetCameraSliderRotate(p23))
		end,
		setFinalPageViewMode = function() -- line: 411
			-- upvalues: p21 (copy), SetFinalPageViewMode (copy), PPEThumbnailType (copy)
			return p21(SetFinalPageViewMode(PPEThumbnailType.Closeup))
		end
	}
end

local v53 = withMappedNavigationParams((withStackVisibilityWrapper((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v44)))))
local u54 = RoactServices.connect({
	profilePictureEditorAnalytics = Analytics
})(v53)

if v36 then
	return function(p24) -- line: 427
		-- upvalues: React (copy), useFocusGuiObject (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), u54 (ref), Cryo (copy)
		local v86 = React.useRef(nil)
		local v87 = useFocusGuiObject()
		local v88 = React.useCallback(function() -- line: 430
			-- upvalues: v87 (copy), v86 (copy)
			if v87 and (v86 and v86.current) then
				v87(v86.current)
			end
		end, { v87 })
		local v89 = useFocusNavigationBindings(nil, v88)
		local v90 = useTableWrappedCallbackRef(v89)

		return React.createElement(u54, Cryo.Dictionary.join(p24, {
			topBarRef = v86,
			resolvedFocusNavigationRef = v90
		}))
	end
end

return u54
