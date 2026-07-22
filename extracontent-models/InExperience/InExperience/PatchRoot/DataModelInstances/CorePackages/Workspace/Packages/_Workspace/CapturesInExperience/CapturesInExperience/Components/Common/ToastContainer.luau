local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Dash = require(ParentParentParent.Dash)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local UIBlox = require(ParentParentParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Toast = UIBlox.App.Dialog.Toast
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local CaptureType = require(ParentParent.Enums.CaptureType)
local CarouselOpened = require(ParentParent.Actions.CarouselOpened)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local ExternalShareSourceType = require(ParentParent.Enums.ExternalShareSourceType)
local ShareCapture = require(ParentParent.Thunks.ShareCapture)
local StartMomentsCreationFlow = require(ParentParent.Thunks.StartMomentsCreationFlow)
local ToastVanished = require(ParentParent.Actions.ToastVanished)

require(ParentParent.Types)

local ToastController = require(script.Parent.ToastController)
local FFlagCreateMomentsToast = require(ParentParent.Flags.FFlagCreateMomentsToast)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local _ = {
	captureSaved = "captureSaved",
	captureSavedToDevice = "captureSavedToDevice",
	capturesEnabled = "capturesEnabled",
	createAction = "createAction",
	discoverPostWatch = "discoverPostWatch",
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
local v30 = UserInputService:GetPlatform() == Enum.Platform.Windows or UserInputService:GetPlatform() == Enum.Platform.OSX

local function isVideoCapture(p1) -- line: 75
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy)
	if not p1 then
		return false
	end

	local captureInfo = p1.captureInfo

	if not captureInfo then
		return false
	end

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		return captureInfo.CaptureType == Enum.CaptureType.Video
	end

	return captureInfo.type == CaptureType.Video
end

local t1 = {
	[CapturesToastType.CaptureSavedToDevice] = {
		toastTitleKey = "captureSavedToDevice",
		iconImage = Images["icons/status/success"],
		onActivated = if not v30 then nil else function(p2, _, p4) -- line: 96
			-- upvalues: EventNames (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy)
			p2.fireEvent(EventNames.CapturesSavedToDeviceToastOpenButtonActivated)

			local v38

			if not p4 then
				v38 = false
			else
				local captureInfo = p4.captureInfo

				v38 = if captureInfo then if not FFlagEnableCapturesGalleryRetrievalCoreScript then captureInfo.type == CaptureType.Video else captureInfo.CaptureType == Enum.CaptureType.Video else false
			end

			if v38 then
				game:OpenVideosFolder()

				return
			end

			game:OpenScreenshotsFolder()
		end,
		toastCTAKey = if not v30 then nil else "openInFiles"
	},
	[CapturesToastType.CaptureTaken] = {
		toastCTAKey = "shareAction",
		toastSubtitleKey = "shareCaptureDescription",
		toastTitleKey = "captureSaved",
		iconImage = Images["icons/controls/screenshot"],
		onActivated = function(p5, p6, p7) -- line: 110
			-- upvalues: EventNames (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), SocialStopwatch (copy), ShareCapture (copy), ExternalShareSourceType (copy)
			p5.fireEvent(EventNames.CapturesShareToastButtonActivated)

			local v43

			if not p7 then
				v43 = false
			else
				local captureInfo = p7.captureInfo

				v43 = if captureInfo then if not FFlagEnableCapturesGalleryRetrievalCoreScript then captureInfo.type == CaptureType.Video else captureInfo.CaptureType == Enum.CaptureType.Video else false
			end

			if v43 then
				p5.fireEvent(EventNames.CapturesVideoShareToastButtonActivated)
			end

			if p7 and p7.captureInfo then
				if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureShared) then
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureShared)
				end

				p6(ShareCapture(p7.captureInfo, ExternalShareSourceType.Toast))
			end
		end
	},
	[CapturesToastType.CapturesActivated] = {
		toastTitleKey = "capturesEnabled",
		iconImage = Images["icons/status/success"]
	},
	[CapturesToastType.CaptureTakenWithMomentsCTA] = {
		duration = if not FFlagCreateMomentsToast then nil else 5
	},
	[CapturesToastType.MomentProcessing] = {},
	[CapturesToastType.VideoCaptureFailed] = {
		toastTitleKey = "videoCaptureFailed",
		iconImage = Images["icons/status/alert"]
	},
	[CapturesToastType.VideoCaptureInitializationCapturingAlreadyError] = {
		toastTitleKey = "videoCaptureInitializationCapturingAlreadyError",
		iconImage = Images["icons/status/alert"]
	},
	[CapturesToastType.VideoCaptureInitializationNoDeviceSupportError] = {
		toastTitleKey = "videoCaptureInitializationNoDeviceSupportError",
		iconImage = Images["icons/status/alert"]
	},
	[CapturesToastType.VideoCaptureInitializationNoSpaceOnDeviceError] = {
		toastTitleKey = "videoCaptureInitializationNoSpaceOnDeviceError",
		iconImage = Images["icons/status/alert"]
	},
	[CapturesToastType.VideoCaptureInitializationOtherError] = {
		toastTitleKey = "videoCaptureInitializationOtherError",
		iconImage = Images["icons/status/alert"]
	},
	[CapturesToastType.VideoCaptureOtherError] = {
		toastTitleKey = "videoCaptureOtherError",
		iconImage = Images["icons/status/alert"]
	},
	[CapturesToastType.ViewCapture] = {
		toastCTAKey = "viewAction",
		toastTitleKey = "captureSaved",
		iconImage = Images["icons/controls/screenshot"],
		onActivated = function(p8, p9) -- line: 160
			-- upvalues: EventNames (copy), CarouselOpened (copy)
			p8.fireEvent(EventNames.CapturesViewToastButtonActivated)
			p9(CarouselOpened(1))
		end
	}
}

return function(_: {[any]: any}) -- line: 171
	-- upvalues: useAnalytics (copy), useDispatch (copy), useLocalization (copy), useSelector (copy), Constants (copy), React (copy), CapturesToastType (copy), t1 (copy), ToastVanished (copy), Dash (copy), FFlagCreateMomentsToast (copy), ToastController (copy), HttpService (copy), StartMomentsCreationFlow (copy), EventNames (copy), Toast (copy)
	local v48 = useAnalytics()
	local v49 = useDispatch()
	local v50 = useLocalization({
		captureSaved = "Feature.Captures.Toast.CaptureSaved",
		captureSavedToDevice = "Feature.Captures.Toast.CaptureSavedToDevice",
		capturesEnabled = "Feature.Captures.Toast.CapturesEnabled",
		createAction = "Feature.Captures.Action.Create",
		discoverPostWatch = "Feature.Captures.Description.DiscoverPostWatch",
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
	local v51 = useSelector(function(p10) -- line: 196
		-- upvalues: Constants (copy)
		return p10[Constants.RoduxKey].Toast.ToastType
	end)
	local v52 = useSelector(function(p11) -- line: 200
		-- upvalues: Constants (copy)
		return p11[Constants.RoduxKey].Toast.ToastConfig
	end)
	local v53 = useSelector(function(p12) -- line: 204
		-- upvalues: Constants (copy)
		return p12[Constants.RoduxKey].Toast.IsDismissed
	end)
	local v54 = React.useCallback(function(p13) -- line: 208
		-- upvalues: v50 (copy)
		if p13 then
			return v50[p13]
		end

		return nil
	end)
	local v55 = React.useMemo(function() -- line: 215
		-- upvalues: v51 (copy), CapturesToastType (copy), t1 (copy), v49 (copy), ToastVanished (copy), v48 (copy), v52 (copy), Constants (copy), Dash (copy), v54 (copy)
		if v51 == CapturesToastType.None then
			return nil
		end

		local v60 = t1[v51]
		local v61 = v51
		local v62 = nil

		if v60.onActivated then
			function v62() -- line: 231
				-- upvalues: v60 (copy), v48 (copy), v49 (copy), v52 (copy), v61 (copy), v51 (copy), ToastVanished (copy)
				v60.onActivated(v48, v49, v52)

				if v61 == v51 then
					v49(ToastVanished())
				end
			end
		end

		local v63 = v60.duration or Constants.ToastDuration

		return Dash.join(v60, {
			buttonText = v54(v60.toastCTAKey),
			duration = v63,
			onActivated = v62,
			onDismissed = function() -- line: 223
				-- upvalues: v61 (copy), v51 (copy), v49 (copy), ToastVanished (copy)
				if v61 == v51 then
					v49(ToastVanished())
				end
			end,
			toastCTAKey = Dash.None,
			toastSubtitle = v54(v60.toastSubtitleKey),
			toastSubtitleKey = Dash.None,
			toastTitle = v54(v60.toastTitleKey),
			toastTitleKey = Dash.None
		})
	end, {
		v51,
		v52
	})

	if not v55 then
		return nil
	end

	if FFlagCreateMomentsToast then
		if v51 == CapturesToastType.CaptureTakenWithMomentsCTA then
			return React.createElement(ToastController, {
				icon = "icons/brands/moments_large",
				title = v54("momentsTitle"),
				text = v54("discoverPostWatch"),
				actionText = v54("createAction"),
				onAction = function() -- line: 263
					-- upvalues: v52 (copy), HttpService (copy), v49 (copy), StartMomentsCreationFlow (copy), v48 (copy), EventNames (copy)
					if v52 and v52.captureInfo then
						local guid = HttpService:GenerateGUID(false)

						v49(StartMomentsCreationFlow(v52.captureInfo, guid))
						v48.fireEvent(EventNames.XExpMomentCreationStarted, {
							creationSessionId = guid
						})
					end

					v48.fireEvent(EventNames.CapturesCreateMomentToastButtonActivated)
				end,
				onDismissed = function() -- line: 273
					-- upvalues: v49 (copy), ToastVanished (copy)
					v49(ToastVanished())
				end,
				duration = v55.duration,
				show = not v53
			})
		end

		if v51 == CapturesToastType.MomentProcessing then
			return React.createElement(ToastController, {
				icon = "icons/brands/moments_large",
				title = v54("momentProcessingTitle"),
				text = v54("momentProcessingDescription"),
				onDismissed = function() -- line: 284
					-- upvalues: v49 (copy), ToastVanished (copy)
					v49(ToastVanished())
				end,
				duration = v55.duration,
				show = not v53
			})
		end

		return React.createElement(React.Fragment, {}, {
			[v51] = React.createElement(Toast, {
				duration = v55.duration,
				show = not v53,
				toastContent = v55
			})
		})
	end

	return React.createElement(React.Fragment, {}, {
		[v51] = React.createElement(Toast, {
			duration = v55.duration,
			show = not v53,
			toastContent = v55
		})
	})
end
