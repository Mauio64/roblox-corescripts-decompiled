local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local cameraUtility = Thumbnailing.CameraUtility
local Cryo = require(CorePackages.Packages.Cryo)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/fvR")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local module3 = require("@luauforge/deferred/gJH")
local module4 = require("@luauforge/deferred/hjm")

local module5 = require("@luauforge/bundled/ehL")
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module5.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module6 = require("@luauforge/deferred/gRz")
local module7 = require("@luauforge/bundled/dXh")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module8 = require("@luauforge/deferred/hhc")
local module9 = require("@luauforge/bundled/fCW")
local module10 = require("@luauforge/bundled/dWC")
local module11 = require("@luauforge/bundled/fCV")
local module12 = require("@luauforge/deferred/gNa")
local module13 = require("@luauforge/bundled/dWJ")
local module14 = require("@luauforge/deferred/fDS")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local insetBackground = require("@game/CorePackages/Workspace/Packages/AppBlox").InsetBackground

local module15 = require("@luauforge/deferred/hjn")

local fFlagAXPPEReturnToEntrySurface = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXPPEReturnToEntrySurface

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle

local v5 = {
	frequency = 1 / module9.FullscreenTweenTimeSeconds,
	dampingRatio = 1
}

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p2, callback)
	local v6 = ReactFocusNavigation.useEventMap(navigateBacks, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local extended = Roact.PureComponent:extend("ProfilePictureEditorFinalPage")

extended.validateProps = t.strictInterface({
	avatarRoute = t.table,
	resolvedFocusNavigationRef = t.table,
	topBarRef = t.table,
	entryOrigin = t.optional(t.table),
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
	profilePictureEditorAnalytics = t.table
})

function extended:init()
	self.bottomBarRef = Roact.createRef()
	self.toggleFullViewButtonRef = Roact.createRef()

	function self.goBack()
		self.props.navigation.goBack()
	end

	function self.onSave()
		self:writePPEConfig()

		local catalog = avatarScreen.Catalog

		if fFlagAXPPEReturnToEntrySurface then
			module7.restoreEntryOrigin(self.props.navigation, catalog)
		else
			self.props.navigation.navigate(catalog)
		end
	end

	function self.toggleFinalPageViewMode()
		local v6 = if self.props.finalPageViewMode == module10.Closeup then module10.FullBody else module10.Closeup

		self.props.setFinalPageViewMode(v6)
	end

	self:setState({ isAnimating = false })

	local binding, v6 = Roact.createBinding(0)
	self.animationBinding = binding
	self.animationBindingUpdate = v6

	self.sizeBinding = self.animationBinding:map(function(p2)
		return UDim2.fromScale(1 + p2, 1 + p2)
	end)

	self.motor = Otter.createSingleMotor(0)
	self.motor:onStep(self.animationBindingUpdate)
	self.motor:onComplete(function()
		self:setState({ isAnimating = false })
	end)
end

function extended.writePPEConfig(p2)
	local fieldOfViewDeg = p2.props.fieldOfViewDeg
	local zoomSliderValue = p2.props.zoomSliderValue
	local rotateSliderValue = p2.props.rotateSliderValue
	local emoteAssetId = p2.props.emoteAssetId

	local yRotDegFromSliderValue = module11.getYRotDegFromSliderValue(rotateSliderValue)
	local cameraDistanceScaleFromSliderValue = module11.getCameraDistanceScaleFromSliderValue(zoomSliderValue)

	p2.props.writePPEConfig(
		p2.props.networking,
		p2.props.profilePictureEditorAnalytics,
		emoteAssetId,
		cameraDistanceScaleFromSliderValue,
		yRotDegFromSliderValue,
		fieldOfViewDeg
	)
end

function extended.renderBottomContents(props, props2, props3)
	local theme = props3.Theme

	local font = props3.Font
	local baseSize = font.BaseSize

	local v6 = font.Header1.RelativeSize * baseSize

	local safeAreaSize = getSafeAreaSize(props.props.screenSize, props.props.globalGuiInset)

	local v7 = font.Header2.RelativeSize * baseSize
	local textSize = getTextSize(
		props2.finalContent,
		v7,
		props3.Tokens.Typography.TitleLarge.Font,
		Vector2.new(safeAreaSize.X.Offset * 0.9, 10000),
		{ addTemporaryPadding = false }
	)
	local v8

	if props.props.finalPageViewMode == module10.Closeup then
		v8 = props2.switchToFullBody
	else
		v8 = props2.switchToCloseup
	end

	local v9 = safeAreaSize.X.Offset - 20 - 20
	local textSize2 = getTextSize(
		v8,
		v7,
		props3.Tokens.Typography.TitleLarge.Font,
		Vector2.new(v9, 10000),
		{ addTemporaryPadding = false }
	)

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
		ButtonFrame = Roact.createElement(focusable.Frame, {
			Size = UDim2.new(0, textSize2.X + 20, 0, textSize2.Y + 17),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[Roact.Ref] = props.toggleFullViewButtonRef,
			NextSelectionUp = props.props.topBarRef,
			NextSelectionDown = props.bottomBarRef
		}, {
			ButtonStack = Roact.createElement(buttonStack, {
				buttonHeight = textSize2.Y + 17,
				buttons = {
					{
						buttonType = buttonType.Secondary,
						props = {
							onActivated = props.toggleFinalPageViewMode,
							text = v8
						}
					}
				}
			})
		}),
		Header1TextLabel = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, v6),
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(props3.Tokens.Typography.HeadingSmall.Font),
			TextColor3 = theme.TextEmphasis.Color,
			Text = props2.finalHeader,
			TextSize = v6,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			LayoutOrder = 2
		}),
		Header2TextLabel = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.9, 0, 0, textSize.Y),
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(props3.Tokens.Typography.TitleLarge.Font),
			TextColor3 = theme.TextEmphasis.Color,
			Text = props2.finalContent,
			TextSize = v7,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			RichText = true,
			TextWrapped = true,
			LayoutOrder = 3
		})
	})
end

function extended.renderMiddleContents(props, p2)
	local theme = p2.Theme

	if props.props.finalPageViewMode == module10.Closeup or props.state.isAnimating then
		return Roact.createElement(imageSetLabel, {
			Size = props.sizeBinding,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = module9.CircleCutoutAsset,
			ImageColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 1,
			ZIndex = 4
		})
	end

	return nil
end

function extended:renderWithProviders(p2, p3)
	local v6 = getSafeAreaSize(self.props.screenSize, self.props.globalGuiInset)
	local isPortrait = self.props.isPortrait

	local createElement = Roact.createElement
	local frame = focusable.Frame

	if module15 then
		v6 = UDim2.fromScale(1, 1)
	end

	return createElement(frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v6,
		Position = UDim2.new(0, 0, 0, 0),
		Active = true,
		defaultChild = self.bottomBarRef,
		[Roact.Ref] = self.props.resolvedFocusNavigationRef
	}, {
		SimpleTopBar = Roact.createElement(module2.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = p2.title,
			[Roact.Ref] = self.props.topBarRef,
			NextSelectionDown = self.toggleFullViewButtonRef,
			transparentBackground = isPortrait,
			hideSiteMessageBanner = isPortrait,
			leftItem = module2.BackButton
		}),
		PeekabooWidget = Roact.createElement(module4, {
			viewportYScale = 0.375,
			viewportXScale = 0.8,
			topMarginYScale = 0.2,
			renderBottomContents = function()
				return self:renderBottomContents(p2, p3)
			end,
			renderMiddleContents = function()
				return self:renderMiddleContents(p3)
			end
		}),
		BottomBar = Roact.createElement(module8, {
			baseRef = self.bottomBarRef,
			NextSelectionUp = self.toggleFullViewButtonRef,
			button1 = {
				textKey = "Authentication.CrossDevice.Action.GoBack",
				onActivated = self.goBack
			},
			button2 = {
				textKey = "Feature.Avatar.Action.Save",
				isDisabled = self.props.fieldOfViewDeg == nil,
				onActivated = self.onSave
			}
		}),
		InsetBackground = Roact.createElement(insetBackground, {
			directions = { left = true, top = true, right = true, bottom = true }
		})
	})
end

function extended:render()
	return withLocalization({
		title = "Feature.Avatar.Label.PPEFinalHeader",
		finalHeader = "Feature.Avatar.Label.PPEFinalSubheader",
		finalContent = "Feature.Avatar.Label.PPEFinalBody",
		switchToFullBody = "Feature.Avatar.Label.PPEViewFullButton",
		switchToCloseup = "Feature.Avatar.Label.PPEViewCloseupButton"
	})(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended.didUpdate(object, p2, p3)
	local v6 = p2.finalPageViewMode == module10.Closeup
		and object.props.finalPageViewMode == module10.FullBody
		and 1
		or p2.finalPageViewMode == module10.FullBody
		and object.props.finalPageViewMode == module10.Closeup
		and 0
		or nil

	if v6 then
		object.motor:stop()
		object.motor:setGoal(Otter.spring(v6, v5))
		object.motor:start()
		object:setState({ isAnimating = true })
	end
end

function extended:willUnmount()
	if self.motor then
		self.motor:destroy()
		self.motor = nil
	end
end

local v6 = RoactRodux.connect(function(data, p2)
	return {
		isPortrait = data.DeviceOrientation == deviceOrientationMode.Portrait,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize,
		fieldOfViewDeg = data.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.fieldOfViewDeg,
		zoomSliderValue = data.AvatarExperience.ProfilePictureEditor.CameraSliders.zoomSliderValue,
		rotateSliderValue = data.AvatarExperience.ProfilePictureEditor.CameraSliders.rotateSliderValue,
		emoteAssetId = data.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId,
		finalPageViewMode = data.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode,
		currentCharacter = data.AvatarExperience.AvatarScene.Character.CurrentCharacter,
		equippedAssets = data.AvatarExperience.AvatarEditor.Character.EquippedAssets
	}
end, function(callback)
	return {
		writePPEConfig = function(p2, p3, p4, p5, p6, p7)
			callback(module12(p3, module10.Closeup, p4, p5, p6, p7))

			callback(module12(p3, module10.FullBody, p4, cameraUtility.DistanceScaleForFullBody, p6, p7))
		end,
		setFinalPageViewMode = function(p2)
			return callback(module13(p2))
		end
	}
end)(extended)

local v7 = module3((module6((roactServices.connect({
	profilePictureEditorAnalytics = module14,
	networking = module
})(v6)))))

local function ProfilePictureEditorFinalPageContainer(p2)
	local v8 = useFocusGuiObject()
	local ref = React.useRef(nil)

	local v11 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, React.useCallback(function()
		if v8 and ref and ref.current then
			v8(ref.current)
		end
	end, { v8 }))))

	local joined = Cryo.Dictionary.join(p2, {
		topBarRef = ref,
		resolvedFocusNavigationRef = v11
	})

	return React.createElement(v7, joined)
end

return ProfilePictureEditorFinalPageContainer
