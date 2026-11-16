local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Style.withStyle
local iconSize = UIBlox.App.Constant.IconSize
local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/bundled/fuD")
local module3 = require("@luauforge/bundled/dwB")
local module4 = require("@luauforge/bundled/gqq")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module5 = require("@luauforge/bundled/dCh")
local setCameraButtonStatus = require("@luauforge/bundled/dHL").Actions.SetCameraButtonStatus
local module6 = require("@luauforge/bundled/goD")
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local module7 = require("@luauforge/bundled/dCn")

local module8 = require("@luauforge/bundled/gqv")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigationFocus = RoactNavigation.withNavigationFocus
local module9 = require("@luauforge/bundled/eda")
local getCameraOptIn = require("@luauforge/deferred/gqx").getCameraOptIn
local getCameraDevicePermission = require("@luauforge/deferred/gqx").getCameraDevicePermission

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local iconscontrolsvideoOff = images["icons/controls/videoOff"]
local iconscontrolsvideo = images["icons/controls/video"]
local vector2 = Vector2.new(1, 0)
local udim = UDim2.new(1, -4, 0, 3)
local udim2 = UDim2.fromOffset(5, 5)
local color = Color3.new(0, 1, 0)

local extended = Roact.PureComponent:extend("UniversalAppCameraToggle")

local v5 = {
	toastMessage = "Feature.Avatar.Message.ClassicHeadAndR6CameraWarning",
	isLocalized = false,
	toastType = module3.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Message.CameraFacialAnimationPaused",
	isLocalized = false,
	toastType = module3.InformationMessage
}

local v7 = {
	toastMessage = "Feature.FaceChat.Subtitle.UnableToAccessCamera",
	isLocalized = false,
	toastType = module3.InformationMessage
}

local v8 = {
	toastMessage = "Feature.FaceChat.Subtitle.FeatureDisabled",
	isLocalized = false,
	toastType = module3.InformationMessage
}

extended.validateProps = t.strictInterface({
	isUIFullView = t.optional(t.boolean),
	isSceneFullView = t.optional(t.boolean),
	layoutOrder = t.optional(t.number),
	isDebug = t.optional(t.boolean),
	hasEmoteTryOn = t.boolean,
	ableToAnimateHead = t.boolean,
	receivedOutfitInfo = t.boolean,
	canPlayAnimation = t.boolean,
	pageCanAnimateCameraBasedMood = t.boolean,
	isPortrait = t.boolean,
	topBarHeight = t.number,
	buttonEnabled = t.boolean,
	errorOccurred = t.boolean,
	analytics = t.table,
	networking = t.callback,
	avatarRoute = t.table,
	navigation = t.table,
	isFocused = t.boolean,
	setCurrentToastMessage = t.callback,
	setCameraButtonStatus = t.callback
})

function extended:setCameraButtonStatusWithAnalytics(p3)
	self.props.setCameraButtonStatus(p3)

	self.props.analytics.toggleCameraInEditorAndShop(p3, self.props.avatarRoute.opaque.name)
end

function extended:init()
	self.isMounted = false
	self:setState({ isCameraOptIn = false, hasDeviceCameraPermissions = false })

	function self.toggleCamera()
		if not self.props.ableToAnimateHead and self.props.receivedOutfitInfo then
			self.props.setCurrentToastMessage(v5)
			return
		end

		local buttonEnabled = self.props.buttonEnabled

		if self.props.errorOccurred then
			self.props.setCameraButtonStatus(false)
			self.props.setCurrentToastMessage(v8)
		else
			if not self.state.hasDeviceCameraPermissions then
				getCameraDevicePermission():andThen(function(p2)
					if not p2 then
						self.props.setCurrentToastMessage(v7)

						return
					end

					if self.isMounted then
						self:setState({ hasDeviceCameraPermissions = true })
					end

					self:setCameraButtonStatusWithAnalytics(true)
				end):catch(function(p2)
					module7(string.format("Universal App Camera Hardware Check error: %s", (tostring(p2))))

					self.props.setCameraButtonStatus(false)
				end)

				return
			end

			if not (buttonEnabled or self.props.pageCanAnimateCameraBasedMood) then
				self.props.setCurrentToastMessage(v6)
			end

			self:setCameraButtonStatusWithAnalytics(not buttonEnabled)
		end
	end
end

function extended:render()
	return withStyle(function(p2)
		return withSelectionCursorProvider(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended:isVisible()
	if self.props.isDebug then
		return true
	end

	local isCameraOptIn = module2.isUserCameraEligible() and self.state.isCameraOptIn
	local avatarSceneButtonsVisible = module2.isAvatarSceneButtonsVisible(
		self.props.avatarRoute,
		self.props.isFocused,
		self.props.isUIFullView,
		self.props.isSceneFullView,
		self.props.navigation
	)

	return isCameraOptIn and avatarSceneButtonsVisible
end

function extended.getIcon(p2)
	if p2.props.buttonEnabled then
		return iconscontrolsvideo
	end

	return iconscontrolsvideoOff
end

function extended:setCameraOptIn()
	getCameraOptIn(self.props.networking, false):andThen(function(p2)
		if not self.isMounted then
			return
		end

		if p2 ~= self.state.isCameraOptIn then
			self:setState({ isCameraOptIn = p2 })
		end
	end)
end

function extended:didMount()
	self.isMounted = true
	self:setCameraOptIn()
end

function extended:willUnmount()
	self.isMounted = false
end

function extended:didUpdate(p2)
	local name = self.props.avatarRoute.opaque.name

	self:setCameraOptIn()

	if
		self.props.buttonEnabled
		and name ~= avatarScreen.CatalogSearch
		and name ~= avatarScreen.Catalog
		and name ~= avatarScreen.AvatarEditor
	then
		self.props.setCameraButtonStatus(false)
		return
	end

	if not self:isVisible() then
		return
	end

	if self.props.buttonEnabled and not self.props.ableToAnimateHead and self.props.receivedOutfitInfo then
		self.props.setCameraButtonStatus(false)
	end

	local pageCanAnimateCameraBasedMood = p2.pageCanAnimateCameraBasedMood
	local pageCanAnimateCameraBasedMood2 = self.props.pageCanAnimateCameraBasedMood

	local hasEmoteTryOn = not p2.hasEmoteTryOn and self.props.hasEmoteTryOn

	if
		self.props.buttonEnabled
		and (pageCanAnimateCameraBasedMood and not pageCanAnimateCameraBasedMood2 or hasEmoteTryOn)
	then
		self.props.setCurrentToastMessage(v6)
	end
end

function extended:renderWithProviders(p2)
	local theme = p2.Theme
	local sceneButtonSize = module.SceneButtonSize

	local v9 = not self.props.canPlayAnimation

	return Roact.createElement("Frame", {
		Size = UDim2.fromOffset(sceneButtonSize, sceneButtonSize),
		Visible = self:isVisible(),
		BackgroundColor3 = theme.BackgroundMuted.Color,
		BackgroundTransparency = theme.BackgroundMuted.Transparency,
		LayoutOrder = self.props.layoutOrder
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = module.SceneButtonCornerRadius
		}),
		Roact.createElement(imageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(iconSize.Regular, iconSize.Regular),
			BackgroundTransparency = 1,
			Image = self:getIcon(),
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = v9 and not self.props.buttonEnabled and 0.5 or 0,
			ZIndex = 2,
			[Roact.Event.Activated] = self.toggleCamera
		}, {
			Dot = Roact.createElement("Frame", {
				AnchorPoint = vector2,
				Position = udim,
				BackgroundColor3 = color,
				Size = udim2,
				BorderSizePixel = 0,
				ZIndex = 2,
				Visible = not v9 and self.props.buttonEnabled,
				LayoutOrder = 2
			}, {
				Corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				})
			})
		})
	})
end

local function mapDispatchToProps(callback)
	return {
		setCurrentToastMessage = function(p2)
			callback(module5(p2))
		end,
		setCameraButtonStatus = function(p2)
			callback(setCameraButtonStatus(p2))
		end
	}
end

local v9 = withNavigationFocus((module6((RoactRodux.connect(function(data, p2)
	local topBarHeight = data.TopBar.topBarHeight

	local canAnimateCameraBasedMood = module2.getCategoryInfoFromState(data, p2.avatarRoute).CanAnimateCameraBasedMood == true

	local allowsTryingEmotesOrAnimations, v10 = module4.getAllowsTryingEmotesOrAnimations(
		data,
		p2.avatarRoute
	)
	local canPlayCameraBasedMoodAnimation = module4.canPlayCameraBasedMoodAnimation(
		data,
		canAnimateCameraBasedMood,
		allowsTryingEmotesOrAnimations
	)

	local v11 = module8(data) ~= nil

	local ableToAnimateHead, v12 = module4.ableToAnimateHead(data)

	return {
		hasEmoteTryOn = v11,
		pageCanAnimateCameraBasedMood = canAnimateCameraBasedMood,
		ableToAnimateHead = ableToAnimateHead,
		receivedOutfitInfo = v12,
		canPlayAnimation = canPlayCameraBasedMoodAnimation,
		isPortrait = data.DeviceOrientation == deviceOrientationMode.Portrait,
		topBarHeight = topBarHeight,
		buttonEnabled = data.AvatarExperience.CameraButton.enabled,
		errorOccurred = data.AvatarExperience.CameraButton.errorOccurred
	}
end, mapDispatchToProps)(extended)))))
return (roactServices.connect({
	analytics = avatarExperienceAnalyticsService,
	networking = module9
})(v9))
