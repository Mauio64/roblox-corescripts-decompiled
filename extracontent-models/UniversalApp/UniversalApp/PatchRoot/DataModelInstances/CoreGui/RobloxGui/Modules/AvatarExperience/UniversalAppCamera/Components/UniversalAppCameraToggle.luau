local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Style.withStyle
local IconSize = UIBlox.App.Constant.IconSize
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local AnimationUtils = require(Modules.AvatarExperience.Common.Managers.AnimationUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetCameraButtonStatus = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetCameraButtonStatus
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local mutedError = require(Modules.LuaApp.mutedError)
local SelectOutfitTryOnEmoteAnimationAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnEmoteAnimationAssetId)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local withNavigationFocus = require(CorePackages.Packages.RoactNavigation).withNavigationFocus
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local getCameraOptIn = require(CorePackages.Workspace.Packages.CameraOptIn).getCameraOptIn
local getCameraDevicePermission = require(CorePackages.Workspace.Packages.CameraOptIn).getCameraDevicePermission

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local v29 = Images["icons/controls/videoOff"]
local v30 = Images["icons/controls/video"]
local vector2 = Vector2.new(1, 0)
local uDim2 = UDim2.new(1, -4, 0, 3)
local uDim2_2 = UDim2.fromOffset(5, 5)
local color3 = Color3.new(0, 1, 0)
local v35 = Roact.PureComponent:extend("UniversalAppCameraToggle")
local t1 = {
	toastMessage = "Feature.Avatar.Message.ClassicHeadAndR6CameraWarning",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	toastMessage = "Feature.Avatar.Message.CameraFacialAnimationPaused",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t3 = {
	toastMessage = "Feature.FaceChat.Subtitle.UnableToAccessCamera",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t4 = {
	toastMessage = "Feature.FaceChat.Subtitle.FeatureDisabled",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

v35.validateProps = t.strictInterface({
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

function v35.setCameraButtonStatusWithAnalytics(t5: {[any]: any}, b1: boolean) -- line: 113
	t5.props.setCameraButtonStatus(b1)
	t5.props.analytics.toggleCameraInEditorAndShop(b1, t5.props.avatarRoute.opaque.name)
end
function v35.init(p1) -- line: 119
	-- upvalues: t1 (copy), t4 (copy), t2 (copy), getCameraDevicePermission (copy), t3 (copy), mutedError (copy)
	p1.isMounted = false
	p1:setState({
		isCameraOptIn = false,
		hasDeviceCameraPermissions = false
	})

	function p1.toggleCamera() -- line: 125
		-- upvalues: p1 (copy), t1 (copy), t4 (copy), t2 (copy), getCameraDevicePermission (copy), t3 (copy), mutedError (copy)
		if not p1.props.ableToAnimateHead and p1.props.receivedOutfitInfo then
			p1.props.setCurrentToastMessage(t1)

			return
		end

		local buttonEnabled = p1.props.buttonEnabled

		if p1.props.errorOccurred then
			p1.props.setCameraButtonStatus(false)
			p1.props.setCurrentToastMessage(t4)

			return
		end

		if p1.state.hasDeviceCameraPermissions then
			if not buttonEnabled and not p1.props.pageCanAnimateCameraBasedMood then
				p1.props.setCurrentToastMessage(t2)
			end

			p1:setCameraButtonStatusWithAnalytics(not buttonEnabled)

			return
		end

		getCameraDevicePermission():andThen(function(p2) -- line: 143
			-- upvalues: p1 (copy), t3 (copy)
			if p2 then
				if p1.isMounted then
					p1:setState({
						hasDeviceCameraPermissions = true
					})
				end

				p1:setCameraButtonStatusWithAnalytics(true)

				return
			end

			p1.props.setCurrentToastMessage(t3)
		end):catch(function(p3) -- line: 157
			-- upvalues: mutedError (copy), p1 (copy)
			mutedError(string.format("Universal App Camera Hardware Check error: %s", (tostring(p3))))
			p1.props.setCameraButtonStatus(false)
		end)
	end
end
function v35.render(p4) -- line: 166
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p5) -- line: 167
		-- upvalues: withSelectionCursorProvider (copy), p4 (copy)
		return withSelectionCursorProvider(function(p6) -- line: 168
			-- upvalues: p4 (copy), p5 (copy)
			return p4:renderWithProviders(p5, p6)
		end)
	end)
end
function v35.isVisible(p7) -- line: 174
	-- upvalues: Utils (copy)
	if p7.props.isDebug then
		return true
	end

	local v47 = Utils.isUserCameraEligible() and p7.state.isCameraOptIn
	local v48 = Utils.isAvatarSceneButtonsVisible(p7.props.avatarRoute, p7.props.isFocused, p7.props.isUIFullView, p7.props.isSceneFullView, p7.props.navigation)

	return v47 and v48
end
function v35.getIcon(p8) -- line: 199
	-- upvalues: v30 (copy), v29 (copy)
	if p8.props.buttonEnabled then
		return v30
	end

	return v29
end
function v35.setCameraOptIn(p9) -- line: 207
	-- upvalues: getCameraOptIn (copy)
	getCameraOptIn(p9.props.networking, false):andThen(function(p10) -- line: 208
		-- upvalues: p9 (copy)
		if not p9.isMounted then
			return
		end

		if p10 ~= p9.state.isCameraOptIn then
			p9:setState({
				isCameraOptIn = p10
			})
		end
	end)
end
function v35.didMount(p11) -- line: 220
	p11.isMounted = true
	p11:setCameraOptIn()
end
function v35.willUnmount(p12) -- line: 225
	p12.isMounted = false
end
function v35.didUpdate(p13, p14) -- line: 229
	-- upvalues: AvatarScreen (copy), t2 (copy)
	local name = p13.props.avatarRoute.opaque.name

	p13:setCameraOptIn()

	if p13.props.buttonEnabled and (name ~= AvatarScreen.CatalogSearch and name ~= AvatarScreen.Catalog and name ~= AvatarScreen.AvatarEditor) then
		p13.props.setCameraButtonStatus(false)

		return
	end

	if not p13:isVisible() then
		return
	end

	if p13.props.buttonEnabled and not p13.props.ableToAnimateHead and p13.props.receivedOutfitInfo then
		p13.props.setCameraButtonStatus(false)
	end

	local pageCanAnimateCameraBasedMood = p14.pageCanAnimateCameraBasedMood
	local pageCanAnimateCameraBasedMood2 = p13.props.pageCanAnimateCameraBasedMood
	local v58 = pageCanAnimateCameraBasedMood and not pageCanAnimateCameraBasedMood2
	local v59 = not p14.hasEmoteTryOn and p13.props.hasEmoteTryOn

	if p13.props.buttonEnabled and (v58 or v59) then
		p13.props.setCurrentToastMessage(t2)
	end
end
function v35.renderWithProviders(p15, p16) -- line: 261
	-- upvalues: Constants (copy), Roact (copy), ImageSetButton (copy), IconSize (copy), vector2 (copy), uDim2 (copy), color3 (copy), uDim2_2 (copy)
	local Theme = p16.Theme
	local SceneButtonSize = Constants.SceneButtonSize
	local v64 = not p15.props.canPlayAnimation

	return Roact.createElement("Frame", {
		Size = UDim2.fromOffset(SceneButtonSize, SceneButtonSize),
		Visible = p15:isVisible(),
		BackgroundColor3 = Theme.BackgroundMuted.Color,
		BackgroundTransparency = Theme.BackgroundMuted.Transparency,
		LayoutOrder = p15.props.layoutOrder
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = Constants.SceneButtonCornerRadius
		}),
		Roact.createElement(ImageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(IconSize.Regular, IconSize.Regular),
			BackgroundTransparency = 1,
			Image = p15:getIcon(),
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = (not v64 or p15.props.buttonEnabled) and 0 or 0.5,
			ZIndex = 2,
			[Roact.Event.Activated] = p15.toggleCamera
		}, {
			Dot = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				LayoutOrder = 2,
				AnchorPoint = vector2,
				Position = uDim2,
				BackgroundColor3 = color3,
				Size = uDim2_2,
				Visible = not v64 and p15.props.buttonEnabled
			}, {
				Corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				})
			})
		})
	})
end

local function mapDispatchToProps(p17) -- line: 338
	-- upvalues: SetCurrentToastMessage (copy), SetCameraButtonStatus (copy)
	return {
		setCurrentToastMessage = function(p18) -- line: 340
			-- upvalues: p17 (copy), SetCurrentToastMessage (copy)
			p17(SetCurrentToastMessage(p18))
		end,
		setCameraButtonStatus = function(p19) -- line: 343
			-- upvalues: p17 (copy), SetCameraButtonStatus (copy)
			p17(SetCameraButtonStatus(p19))
		end
	}
end

local v41 = withNavigationFocus((withAppRoute((RoactRodux.connect(function(p20, p21) -- line: 307
	-- upvalues: Utils (copy), AnimationUtils (copy), SelectOutfitTryOnEmoteAnimationAssetId (copy), DeviceOrientationMode (copy)
	local topBarHeight = p20.TopBar.topBarHeight
	local v68 = Utils.getCategoryInfoFromState(p20, p21.avatarRoute).CanAnimateCameraBasedMood == true
	local v69, _ = AnimationUtils.getAllowsTryingEmotesOrAnimations(p20, p21.avatarRoute)
	local v71 = AnimationUtils.canPlayCameraBasedMoodAnimation(p20, v68, v69)
	local v72 = SelectOutfitTryOnEmoteAnimationAssetId(p20) ~= nil
	local v73, v74 = AnimationUtils.ableToAnimateHead(p20)

	return {
		hasEmoteTryOn = v72,
		pageCanAnimateCameraBasedMood = v68,
		ableToAnimateHead = v73,
		receivedOutfitInfo = v74,
		canPlayAnimation = v71,
		isPortrait = p20.DeviceOrientation == DeviceOrientationMode.Portrait,
		topBarHeight = topBarHeight,
		buttonEnabled = p20.AvatarExperience.CameraButton.enabled,
		errorOccurred = p20.AvatarExperience.CameraButton.errorOccurred
	}
end, mapDispatchToProps)(v35)))))

return (RoactServices.connect({
	analytics = Analytics,
	networking = RoactNetworking
})(v41))
