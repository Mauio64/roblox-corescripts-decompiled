local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local CameraUtility = require(CorePackages.Packages.Thumbnailing).CameraUtility
local Cryo = require(CorePackages.Packages.Cryo)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local PeekabooWidget = require(Modules.AvatarExperience.ProfilePictureEditor.Components.PeekabooWidget)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local ProfilePictureEditorBottomBar = require(Modules.AvatarExperience.ProfilePictureEditor.Components.ProfilePictureEditorBottomBar)
local Constants = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local Utils = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)
local WritePPEConfig = require(Modules.AvatarExperience.ProfilePictureEditor.Thunks.WritePPEConfig)
local SetFinalPageViewMode = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetFinalPageViewMode)
local Analytics = require(Modules.AvatarExperience.ProfilePictureEditor.Services.Analytics)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local BottomInsetBackground = require(Modules.AvatarExperience.Common.Components.BottomInsetBackground)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local InsetBackground = require(CorePackages.Workspace.Packages.AppBlox).InsetBackground
local FFlagAXF10ftFixPeekabooWidget = require(Modules.AvatarExperience.Flags.FFlagAXF10ftFixPeekabooWidget)
local v40 = game:DefineFastFlag("AXMigrateProfilePictureEditorFinalPageToFocusNavigation", false)
local FFlagAXOpaqueMarketplaceTopbar = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXOpaqueMarketplaceTopbar
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local UIBlox = require(CorePackages.Packages.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local t1 = {
	dampingRatio = 1,
	frequency = 1 / Constants.FullscreenTweenTimeSeconds
}
local t2 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 93
	-- upvalues: ReactFocusNavigation (copy), t2 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v57 = ReactFocusNavigation.useEventMap(t2, p1)
	local v58 = React.useMemo(function() -- line: 95
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 98
					-- upvalues: p2 (copy)
					p3.cancelled = true
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v58, v57)
end

local v51 = Roact.PureComponent:extend("ProfilePictureEditorFinalPage")

v51.validateProps = t.strictInterface({
	avatarRoute = t.table,
	resolvedFocusNavigationRef = if not v40 then nil else t.table,
	topBarRef = if not v40 then nil else t.table,
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}),
	screenSize = t.Vector2,
	fieldOfViewDeg = t.optional(t.number),
	zoomSliderValue = t.number,
	rotateSliderValue = t.number,
	emoteAssetId = t.optional(t.string),
	finalPageViewMode = t.userdata,
	currentCharacter = t.optional(t.instanceIsA("Model", nil)),
	equippedAssets = t.optional(t.table),
	isPortrait = t.boolean,
	writePPEConfig = t.callback,
	setFinalPageViewMode = t.callback,
	navigation = t.table,
	networking = t.callback,
	profilePictureEditorAnalytics = t.table,
	is10ftUI = t.boolean
})

function v51.init(p4) -- line: 145
	-- upvalues: v40 (copy), Roact (copy), AvatarScreen (copy), PPEThumbnailType (copy), Otter (copy)
	if not v40 then
		p4.topBarRef = Roact.createRef()
	end

	p4.bottomBarRef = Roact.createRef()
	p4.toggleFullViewButtonRef = Roact.createRef()

	function p4.goBack() -- line: 152
		-- upvalues: p4 (copy)
		p4.props.navigation.goBack()
	end
	function p4.onSave() -- line: 156
		-- upvalues: p4 (copy), AvatarScreen (copy)
		p4:writePPEConfig()

		local v113 = if not p4.props.is10ftUI then AvatarScreen.Catalog else AvatarScreen.AvatarExperienceLandingPage

		p4.props.navigation.navigate(v113)
	end
	function p4.toggleFinalPageViewMode() -- line: 165
		-- upvalues: p4 (copy), PPEThumbnailType (copy)
		local v114 = if p4.props.finalPageViewMode ~= PPEThumbnailType.Closeup then PPEThumbnailType.Closeup else PPEThumbnailType.FullBody

		p4.props.setFinalPageViewMode(v114)
	end

	p4:setState({
		isAnimating = false
	})

	local v60, v61 = Roact.createBinding(0)

	p4.animationBinding = v60
	p4.animationBindingUpdate = v61
	p4.sizeBinding = p4.animationBinding:map(function(p5) -- line: 180
		return UDim2.fromScale(1 + p5, 1 + p5)
	end)
	p4.motor = Otter.createSingleMotor(0)
	p4.motor:onStep(p4.animationBindingUpdate)
	p4.motor:onComplete(function() -- line: 186
		-- upvalues: p4 (copy)
		p4:setState({
			isAnimating = false
		})
	end)
end
function v51.writePPEConfig(p6) -- line: 193
	-- upvalues: Utils (copy)
	local fieldOfViewDeg = p6.props.fieldOfViewDeg
	local zoomSliderValue = p6.props.zoomSliderValue
	local rotateSliderValue = p6.props.rotateSliderValue
	local emoteAssetId = p6.props.emoteAssetId
	local v67 = Utils.getYRotDegFromSliderValue(rotateSliderValue)
	local v68 = Utils.getCameraDistanceScaleFromSliderValue(zoomSliderValue)

	p6.props.writePPEConfig(p6.props.networking, p6.props.profilePictureEditorAnalytics, emoteAssetId, v68, v67, fieldOfViewDeg)
end
function v51.renderBottomContents(p7, p8, p9) -- line: 213
	-- upvalues: getSafeAreaSize (copy), TextService (copy), PPEThumbnailType (copy), Roact (copy), Focusable (copy), v40 (copy), ButtonStack (copy), ButtonType (copy)
	local Theme = p9.Theme
	local p9Font = p9.Font
	local BaseSize = p9Font.BaseSize
	local v75 = p9Font.Header1.RelativeSize * BaseSize
	local Header1Font = p9Font.Header1.Font
	local screenSize = p7.props.screenSize
	local globalGuiInset = p7.props.globalGuiInset
	local v79 = getSafeAreaSize(screenSize, globalGuiInset)
	local v80 = p9Font.Header2.RelativeSize * BaseSize
	local Header2Font = p9Font.Header2.Font
	local TextSize = TextService:GetTextSize(p8.finalContent, v80, Header2Font, Vector2.new(v79.X.Offset * 0.9, 10000))
	local v83 = if p7.props.finalPageViewMode ~= PPEThumbnailType.Closeup then p8.switchToCloseup else p8.switchToFullBody
	local v84 = v79.X.Offset - 20 - 20
	local TextSize2 = TextService:GetTextSize(v83, v80, Header2Font, Vector2.new(v84, 10000))

	return Roact.createFragment({
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0.0625, 0)
		}),
		ContentTopPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0.0625, 0)
		}),
		ButtonFrame = Roact.createElement(Focusable.Frame, {
			Size = UDim2.new(0, TextSize2.X + 20, 0, TextSize2.Y + 17),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[Roact.Ref] = p7.toggleFullViewButtonRef,
			NextSelectionUp = if not v40 then p7.topBarRef else p7.props.topBarRef,
			NextSelectionDown = p7.bottomBarRef
		}, {
			ButtonStack = Roact.createElement(ButtonStack, {
				buttonHeight = TextSize2.Y + 17,
				buttons = {{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = p7.toggleFinalPageViewMode,
						text = v83
					}
				}}
			})
		}),
		Header1TextLabel = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v75),
			Font = Header1Font,
			TextColor3 = Theme.TextEmphasis.Color,
			Text = p8.finalHeader,
			TextSize = v75,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		Header2TextLabel = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			RichText = true,
			TextWrapped = true,
			LayoutOrder = 3,
			Size = UDim2.new(0.9, 0, 0, TextSize.Y),
			Font = Header2Font,
			TextColor3 = Theme.TextEmphasis.Color,
			Text = p8.finalContent,
			TextSize = v80,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end
function v51.renderMiddleContents(p10, p11) -- line: 312
	-- upvalues: PPEThumbnailType (copy), Roact (copy), ImageSetLabel (copy), Constants (copy)
	local Theme = p11.Theme

	if p10.props.finalPageViewMode == PPEThumbnailType.Closeup or p10.state.isAnimating then
		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = 4,
			Size = p10.sizeBinding,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = Constants.CircleCutoutAsset,
			ImageColor3 = Theme.BackgroundDefault.Color
		})
	end

	return nil
end
function v51.renderWithProviders(p12, p13, p14) -- line: 329
	-- upvalues: getSafeAreaSize (copy), Roact (copy), Focusable (copy), FFlagAXF10ftFixPeekabooWidget (copy), v40 (copy), TopBar (copy), FFlagAXOpaqueMarketplaceTopbar (copy), FFlagEnableLeftNavOnConsole (copy), PeekabooWidget (copy), ProfilePictureEditorBottomBar (copy), BottomInsetBackground (copy), InsetBackground (copy)
	local screenSize = p12.props.screenSize
	local globalGuiInset = p12.props.globalGuiInset
	local v94 = getSafeAreaSize(screenSize, globalGuiInset)
	local isPortrait = p12.props.isPortrait
	local v96 = globalGuiInset.bottom > 0

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = if not FFlagAXF10ftFixPeekabooWidget then v94 else UDim2.fromScale(1, 1),
		Position = UDim2.new(0, 0, 0, 0),
		Active = true,
		defaultChild = p12.bottomBarRef,
		[Roact.Ref] = if not v40 then p12.props[Roact.Ref] else p12.props.resolvedFocusNavigationRef
	}, {
		SimpleTopBar = Roact.createElement(TopBar.Container, {
			titleText = p13.title,
			[Roact.Ref] = if not v40 then p12.topBarRef else p12.props.topBarRef,
			NextSelectionDown = p12.toggleFullViewButtonRef,
			transparentBackground = not FFlagAXOpaqueMarketplaceTopbar and not FFlagEnableLeftNavOnConsole or (isPortrait and true or false),
			hideSiteMessageBanner = isPortrait,
			leftItem = TopBar.BackButton
		}),
		PeekabooWidget = Roact.createElement(PeekabooWidget, {
			viewportYScale = 0.375,
			viewportXScale = 0.8,
			topMarginYScale = 0.2,
			renderBottomContents = function() -- line: 365
				-- upvalues: p12 (copy), p13 (copy), p14 (copy)
				return p12:renderBottomContents(p13, p14)
			end,
			renderMiddleContents = function() -- line: 368
				-- upvalues: p12 (copy), p14 (copy)
				return p12:renderMiddleContents(p14)
			end
		}),
		BottomBar = Roact.createElement(ProfilePictureEditorBottomBar, {
			baseRef = p12.bottomBarRef,
			NextSelectionUp = p12.toggleFullViewButtonRef,
			button1 = {
				textKey = "Authentication.CrossDevice.Action.GoBack",
				onActivated = p12.goBack
			},
			button2 = {
				textKey = "Feature.Avatar.Action.Save",
				isDisabled = p12.props.fieldOfViewDeg == nil,
				onActivated = p12.onSave
			}
		}),
		BottomInsetBackground = if not FFlagEnableLeftNavOnConsole then if not v96 then nil else Roact.createElement(BottomInsetBackground, {
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
function v51.render(p15) -- line: 402
	-- upvalues: withLocalization (copy), withStyle (copy)
	return withLocalization({
		title = "Feature.Avatar.Label.PPEFinalHeader",
		finalHeader = "Feature.Avatar.Label.PPEFinalSubheader",
		finalContent = "Feature.Avatar.Label.PPEFinalBody",
		switchToFullBody = "Feature.Avatar.Label.PPEViewFullButton",
		switchToCloseup = "Feature.Avatar.Label.PPEViewCloseupButton"
	})(function(p16) -- line: 409
		-- upvalues: withStyle (copy), p15 (copy)
		return withStyle(function(p17) -- line: 410
			-- upvalues: p15 (copy), p16 (copy)
			return p15:renderWithProviders(p16, p17)
		end)
	end)
end
function v51.didUpdate(p18, p19, _) -- line: 416
	-- upvalues: PPEThumbnailType (copy), Otter (copy), t1 (copy)
	local n1 = nil

	if p19.finalPageViewMode == PPEThumbnailType.Closeup and p18.props.finalPageViewMode == PPEThumbnailType.FullBody then
		n1 = 1
	elseif p19.finalPageViewMode == PPEThumbnailType.FullBody and p18.props.finalPageViewMode == PPEThumbnailType.Closeup then
		n1 = 0
	end

	if n1 then
		p18.motor:stop()
		p18.motor:setGoal(Otter.spring(n1, t1))
		p18.motor:start()
		p18:setState({
			isAnimating = true
		})
	end
end
function v51.willUnmount(p21) -- line: 439
	if p21.motor then
		p21.motor:destroy()
		p21.motor = nil
	end
end

local v52 = RoactRodux.connect(function(p22, _) -- line: 446
	-- upvalues: DeviceOrientationMode (copy)
	return {
		isPortrait = p22.DeviceOrientation == DeviceOrientationMode.Portrait,
		globalGuiInset = p22.GlobalGuiInset,
		screenSize = p22.ScreenSize,
		fieldOfViewDeg = p22.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.fieldOfViewDeg,
		zoomSliderValue = p22.AvatarExperience.ProfilePictureEditor.CameraSliders.zoomSliderValue,
		rotateSliderValue = p22.AvatarExperience.ProfilePictureEditor.CameraSliders.rotateSliderValue,
		emoteAssetId = p22.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId,
		finalPageViewMode = p22.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode,
		currentCharacter = p22.AvatarExperience.AvatarScene.Character.CurrentCharacter,
		equippedAssets = p22.AvatarExperience.AvatarEditor.Character.EquippedAssets
	}
end, function(p24) -- line: 461
	-- upvalues: WritePPEConfig (copy), PPEThumbnailType (copy), CameraUtility (copy), SetFinalPageViewMode (copy)
	return {
		writePPEConfig = function(_, p26, p27, p28, p29, p30) -- line: 463
			-- upvalues: p24 (copy), WritePPEConfig (copy), PPEThumbnailType (copy), CameraUtility (copy)
			p24(WritePPEConfig(p26, PPEThumbnailType.Closeup, p27, p28, p29, p30))
			p24(WritePPEConfig(p26, PPEThumbnailType.FullBody, p27, CameraUtility.DistanceScaleForFullBody, p29, p30))
		end,
		setFinalPageViewMode = function(p31) -- line: 495
			-- upvalues: p24 (copy), SetFinalPageViewMode (copy)
			return p24(SetFinalPageViewMode(p31))
		end
	}
end)(v51)
local u53 = withMappedNavigationParams((withStackVisibilityWrapper((RoactServices.connect({
	profilePictureEditorAnalytics = Analytics,
	networking = RoactNetworking
})(v52)))))

local function ProfilePictureEditorFinalPageContainer(p32) -- line: 509
	-- upvalues: v40 (copy), useFocusGuiObject (copy), React (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), Cryo (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), u53 (ref)
	local v112

	if v40 then
		local v107 = useFocusGuiObject()
		local v108 = React.useRef(nil)
		local v109 = React.useCallback(function() -- line: 515
			-- upvalues: v107 (copy), v108 (copy)
			if v107 and (v108 and v108.current) then
				v107(v108.current)
			end
		end, { v107 })
		local v110 = useFocusNavigationBindings(nil, v109)
		local v111 = useTableWrappedCallbackRef(v110)

		v112 = Cryo.Dictionary.join(p32, {
			is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole,
			topBarRef = v108,
			resolvedFocusNavigationRef = v111
		})
	else
		v112 = Cryo.Dictionary.join(p32, {
			is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole
		})
	end

	return React.createElement(u53, v112)
end

return ProfilePictureEditorFinalPageContainer
