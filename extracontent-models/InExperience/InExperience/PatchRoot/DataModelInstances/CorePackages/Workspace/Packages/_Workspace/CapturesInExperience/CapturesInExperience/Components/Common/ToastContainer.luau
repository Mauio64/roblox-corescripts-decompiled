local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Dash = require(parent2.Dash)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local SocialStopwatch = require(parent2.SocialStopwatch)
local UIBlox = require(parent2.UIBlox)

local IconName = Foundation.Enums.IconName
local Images = UIBlox.App.ImageSet.Images
local Toast = UIBlox.App.Dialog.Toast

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local CapturesToastType = require(parent.Enums.CapturesToastType)
local CaptureType = require(parent.Enums.CaptureType)
local CarouselOpened = require(parent.Actions.CarouselOpened)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local ExternalShareSourceType = require(parent.Enums.ExternalShareSourceType)
local getSaveToStoragePermission = require(parent.Utils.getSaveToStoragePermission)
local ShareCapture = require(parent.Thunks.ShareCapture)
local StartMomentsCreationFlow = require(parent.Thunks.StartMomentsCreationFlow)
local ToastVanished = require(parent.Actions.ToastVanished)
require(parent.Types)

local ToastController = require(script.Parent.ToastController)

local SharedFlags = require(parent2.SharedFlags)
local FFlagBuildExperienceInGameCaptureToChat = SharedFlags.FFlagBuildExperienceInGameCaptureToChat
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local MomentsCommon = require(parent2.MomentsCommon)
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local FFlagCreateMomentsToast = require(parent.Flags.FFlagCreateMomentsToast)

local FFlagCapturesInExpMomentsToastDownloadButton = require(parent.Flags.FFlagCapturesInExpMomentsToastDownloadButton)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local _ = {
	captureSaved = "captureSaved",
	captureSavedToDevice = "captureSavedToDevice",
	capturesEnabled = "capturesEnabled",
	createAction = "createAction",
	discoverPostWatch = "discoverPostWatch",
	momentFailedDescription = "momentFailedDescription",
	momentFailedTitle = "momentFailedTitle",
	momentProcessingDescription = "momentProcessingDescription",
	momentProcessingTitle = "momentProcessingTitle",
	momentsTitle = "momentsTitle",
	openInFiles = "openInFiles",
	shareAction = "shareAction",
	shareCaptureDescription = "shareCaptureDescription",
	videoCaptureFailed = "videoCaptureFailed",
	videoCaptureInitializationCapturingAlreadyError = "videoCaptureInitializationCapturingAlreadyError",
	videoCaptureInitializationNoDeviceSupportError = "videoCaptureInitializationNoDeviceSupportError",
	videoCaptureInitializationNoSpaceOnDeviceError = "videoCaptureInitializationNoSpaceOnDeviceError",
	videoCaptureInitializationOtherError = "videoCaptureInitializationOtherError",
	videoCaptureOtherError = "videoCaptureOtherError",
	viewAction = "viewAction"
}

local v = UserInputService:GetPlatform() == Enum.Platform.Windows or UserInputService:GetPlatform() == Enum.Platform.OSX

local function isVideoCapture(p): boolean -- 2 equivalent calls inferred from this helper
	if not p then
		return false
	end

	local captureInfo = p.captureInfo

	if not captureInfo then
		return false
	end

	if
		FFlagCapturesInExpMomentsToastDownloadButton and typeof(captureInfo) ~= "table"
		or FFlagEnableCapturesGalleryRetrievalCoreScript
	then
		return captureInfo.CaptureType == Enum.CaptureType.Video
	end

	return captureInfo.type == CaptureType.Video
end

local v2 = {
	[CapturesToastType.CaptureSavedToDevice] = {
		iconImage = Images["icons/status/success"],
		onActivated = v and function(p, _, p2)
			p.fireEvent(EventNames.CapturesSavedToDeviceToastOpenButtonActivated)

			if isVideoCapture(p2) then -- inferred equivalent call
				game:OpenVideosFolder()
			else
				game:OpenScreenshotsFolder()
			end
		end or nil,
		toastCTAKey = v and "openInFiles" or nil,
		toastTitleKey = "captureSavedToDevice"
	},
	[CapturesToastType.CaptureTaken] = {
		iconImage = Images["icons/controls/screenshot"],
		onActivated = function(p, callback, p2)
			p.fireEvent(EventNames.CapturesShareToastButtonActivated)

			if isVideoCapture(p2) then -- inferred equivalent call
				p.fireEvent(EventNames.CapturesVideoShareToastButtonActivated)
			end

			if p2 and p2.captureInfo then
				if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureShared) then
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureShared)
				end

				callback(ShareCapture(p2.captureInfo, ExternalShareSourceType.Toast))
			end
		end,
		toastCTAKey = "shareAction",
		toastSubtitleKey = "shareCaptureDescription",
		toastTitleKey = "captureSaved"
	},
	[CapturesToastType.CaptureTakenWithAction] = {
		iconImage = Images["icons/controls/screenshot"],
		onActivated = function(_, _, p)
			if p and p.toastAction and p.captureInfo then
				p.toastAction.onActivated(p.captureInfo)
			end
		end,
		toastTitleKey = "captureSaved"
	},
	[CapturesToastType.CapturesActivated] = {
		iconImage = Images["icons/status/success"],
		toastTitleKey = "capturesEnabled"
	},
	[CapturesToastType.CaptureTakenWithMomentsCTA] = {
		duration = FFlagCreateMomentsToast and 5 or nil
	},
	[CapturesToastType.MomentFailed] = {
		iconImage = Images["icons/status/alert"],
		toastSubtitleKey = "momentFailedDescription",
		toastTitleKey = "momentFailedTitle"
	},
	[CapturesToastType.MomentProcessing] = {},
	[CapturesToastType.VideoCaptureFailed] = {
		iconImage = Images["icons/status/alert"],
		toastTitleKey = "videoCaptureFailed"
	},
	[CapturesToastType.VideoCaptureInitializationCapturingAlreadyError] = {
		iconImage = Images["icons/status/alert"],
		toastTitleKey = "videoCaptureInitializationCapturingAlreadyError"
	},
	[CapturesToastType.VideoCaptureInitializationNoDeviceSupportError] = {
		iconImage = Images["icons/status/alert"],
		toastTitleKey = "videoCaptureInitializationNoDeviceSupportError"
	},
	[CapturesToastType.VideoCaptureInitializationNoSpaceOnDeviceError] = {
		iconImage = Images["icons/status/alert"],
		toastTitleKey = "videoCaptureInitializationNoSpaceOnDeviceError"
	},
	[CapturesToastType.VideoCaptureInitializationOtherError] = {
		iconImage = Images["icons/status/alert"],
		toastTitleKey = "videoCaptureInitializationOtherError"
	},
	[CapturesToastType.VideoCaptureOtherError] = {
		iconImage = Images["icons/status/alert"],
		toastTitleKey = "videoCaptureOtherError"
	},
	[CapturesToastType.ViewCapture] = {
		iconImage = Images["icons/controls/screenshot"],
		onActivated = function(p, callback)
			p.fireEvent(EventNames.CapturesViewToastButtonActivated)
			callback(CarouselOpened(1))
		end,
		toastCTAKey = "viewAction",
		toastTitleKey = "captureSaved"
	}
}

return function(_)
	local v3 = useAnalytics()
	local v4 = useDispatch()

	local v5 = useLocalization({
		captureSaved = "Feature.Captures.Toast.CaptureSaved",
		captureSavedToDevice = "Feature.Captures.Toast.CaptureSavedToDevice",
		capturesEnabled = "Feature.Captures.Toast.CapturesEnabled",
		createAction = "Feature.Captures.Action.Create",
		discoverPostWatch = "Feature.Captures.Description.DiscoverPostWatch",
		momentFailedDescription = "Feature.Moments.Label.MomentFailedToPostBody",
		momentFailedTitle = "Feature.Moments.Label.MomentFailedToPostTitle",
		momentProcessingDescription = "Feature.Captures.Description.MomentProcessing",
		momentProcessingTitle = "Feature.Captures.Toast.MomentProcessing",
		momentsTitle = "Feature.Captures.Toast.CreateMoment2",
		openInFiles = "Feature.Captures.Action.OpenInFiles",
		shareAction = "Feature.Captures.Action.Share",
		shareCaptureDescription = "Feature.Captures.Description.ShareCTA",
		videoCaptureFailed = "Feature.Captures.Toast.VideoCaptureFailed",
		videoCaptureInitializationCapturingAlreadyError = "Feature.Captures.Toast.VideoCaptureInitializationCapturingAlreadyError",
		videoCaptureInitializationNoDeviceSupportError = "Feature.Captures.Toast.VideoCaptureInitializationNoDeviceSupportError",
		videoCaptureInitializationNoSpaceOnDeviceError = "Feature.Captures.Toast.VideoCaptureInitializationNoSpaceOnDeviceError",
		videoCaptureInitializationOtherError = "Feature.Captures.Toast.VideoCaptureInitializationOtherError",
		videoCaptureOtherError = "Feature.Captures.Toast.VideoCaptureOtherError",
		viewAction = "Feature.Captures.Action.ViewCapture"
	})

	local v6 = useSelector(function(p)
		return p[Constants.RoduxKey].Toast.ToastType
	end)

	local v7 = useSelector(function(p)
		return p[Constants.RoduxKey].Toast.ToastConfig
	end)

	local v8 = useSelector(function(p)
		return p[Constants.RoduxKey].Toast.IsDismissed
	end)

	local v9 = React.useCallback(function(p)
		if p then
			return v5[p]
		end

		return nil
	end)

	local toastContent = React.useMemo(function()
		if v6 == CapturesToastType.None then
			return nil
		end

		local v10 = v2[v6]
		local v11 = v6

		local function onDismissed() -- 1 equivalent call inferred from this helper
			if v11 == v6 then
				v4(ToastVanished())
			end
		end

		local fn = v10.onActivated and function()
			v10.onActivated(v3, v4, v7)
			onDismissed() -- inferred equivalent call
		end or nil

		local duration = v10.duration or Constants.ToastDuration

		local buttonText = v9(v10.toastCTAKey)

		if FFlagBuildExperienceInGameCaptureToChat and v7 and v7.toastAction then
			buttonText = v7.toastAction.text
		end

		return Dash.join(v10, {
			buttonText = buttonText,
			duration = duration,
			onActivated = fn,
			onDismissed = onDismissed,
			toastCTAKey = Dash.None,
			toastSubtitle = v9(v10.toastSubtitleKey),
			toastSubtitleKey = Dash.None,
			toastTitle = v9(v10.toastTitleKey),
			toastTitleKey = Dash.None
		})
	end, { v6, v7 })

	if
		not toastContent
		or FFlagMomentsCreationFeatureGate
		and v6 == CapturesToastType.CaptureTakenWithMomentsCTA
		and not GetMomentsCapabilities(false).getCanCreateMoments(false)
	then
		return nil
	end

	if not FFlagCreateMomentsToast then
		return React.createElement(React.Fragment, {}, {
			[v6] = React.createElement(Toast, {
				duration = toastContent.duration,
				show = not v8,
				toastContent = toastContent
			})
		})
	end

	if v6 == CapturesToastType.CaptureTakenWithMomentsCTA then
		return React.createElement(ToastController, {
			title = v9("momentsTitle"),
			text = v9("discoverPostWatch"),
			icon = "icons/brands/moments_large",
			actionText = v9("createAction"),
			onAction = function()
				if v7 and v7.captureInfo then
					local guid = HttpService:GenerateGUID(false)
					v4(StartMomentsCreationFlow(v7.captureInfo, guid))
					v3.fireEvent(EventNames.XExpMomentCreationStarted, { creationSessionId = guid })
				end

				v3.fireEvent(EventNames.CapturesCreateMomentToastButtonActivated)
			end,
			iconAction = FFlagCapturesInExpMomentsToastDownloadButton and {
				icon = IconName.ArrowDownToLine,
				onActivated = function()
					if v7 and v7.captureInfo then
						getSaveToStoragePermission({ v7.captureInfo }, nil, v4)
					end

					v3.fireEvent(EventNames.CapturesCreateMomentToastDownloadActivated)
				end
			} or nil,
			onDismissed = function()
				v4(ToastVanished())
			end,
			duration = toastContent.duration,
			show = not v8
		})
	end

	if v6 == CapturesToastType.MomentProcessing then
		return React.createElement(ToastController, {
			title = v9("momentProcessingTitle"),
			text = v9("momentProcessingDescription"),
			icon = "icons/brands/moments_large",
			onDismissed = function()
				v4(ToastVanished())
			end,
			duration = toastContent.duration,
			show = not v8
		})
	end

	if v6 == CapturesToastType.MomentFailed then
		return React.createElement(React.Fragment, {}, {
			[v6] = React.createElement(ToastController, {
				title = v9("momentFailedTitle"),
				text = v9("momentFailedDescription"),
				icon = "icons/brands/moments_large",
				onDismissed = function()
					v4(ToastVanished())
				end,
				duration = toastContent.duration,
				show = not v8
			})
		})
	end

	return React.createElement(React.Fragment, {}, {
		[v6] = React.createElement(Toast, {
			duration = toastContent.duration,
			show = not v8,
			toastContent = toastContent
		})
	})
end
