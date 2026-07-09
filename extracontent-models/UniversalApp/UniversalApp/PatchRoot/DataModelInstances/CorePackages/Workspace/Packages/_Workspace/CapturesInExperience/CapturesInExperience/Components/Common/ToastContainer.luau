local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
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
local v29 = UserInputService:GetPlatform() == Enum.Platform.Windows or UserInputService:GetPlatform() == Enum.Platform.OSX

local function isVideoCapture(p1) -- line: 74
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
		onActivated = if not v29 then nil else function(p2, _, p4) -- line: 95
			-- upvalues: EventNames (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy)
			p2.fireEvent(EventNames.CapturesSavedToDeviceToastOpenButtonActivated)

			local v37

			if not p4 then
				v37 = false
			else
				local captureInfo = p4.captureInfo

				v37 = if captureInfo then if not FFlagEnableCapturesGalleryRetrievalCoreScript then captureInfo.type == CaptureType.Video else captureInfo.CaptureType == Enum.CaptureType.Video else false
			end

			if v37 then
				game:OpenVideosFolder()

				return
			end

			game:OpenScreenshotsFolder()
		end,
		toastCTAKey = if not v29 then nil else "openInFiles"
	},
	[CapturesToastType.CaptureTaken] = {
		toastCTAKey = "shareAction",
		toastSubtitleKey = "shareCaptureDescription",
		toastTitleKey = "captureSaved",
		iconImage = Images["icons/controls/screenshot"],
		onActivated = function(p5, p6, p7) -- line: 109
			-- upvalues: EventNames (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), SocialStopwatch (copy), ShareCapture (copy), ExternalShareSourceType (copy)
			p5.fireEvent(EventNames.CapturesShareToastButtonActivated)

			local v42

			if not p7 then
				v42 = false
			else
				local captureInfo = p7.captureInfo

				v42 = if captureInfo then if not FFlagEnableCapturesGalleryRetrievalCoreScript then captureInfo.type == CaptureType.Video else captureInfo.CaptureType == Enum.CaptureType.Video else false
			end

			if v42 then
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
		onActivated = function(p8, p9) -- line: 159
			-- upvalues: EventNames (copy), CarouselOpened (copy)
			p8.fireEvent(EventNames.CapturesViewToastButtonActivated)
			p9(CarouselOpened(1))
		end
	}
}

return function(_: {[any]: any}) -- line: 170
	-- upvalues: useAnalytics (copy), useDispatch (copy), useLocalization (copy), useSelector (copy), Constants (copy), React (copy), CapturesToastType (copy), t1 (copy), ToastVanished (copy), Dash (copy), FFlagCreateMomentsToast (copy), ToastController (copy), StartMomentsCreationFlow (copy), EventNames (copy), Toast (copy)
	local v47 = useAnalytics()
	local v48 = useDispatch()
	local v49 = useLocalization({
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
	local v50 = useSelector(function(p10) -- line: 195
		-- upvalues: Constants (copy)
		return p10[Constants.RoduxKey].Toast.ToastType
	end)
	local v51 = useSelector(function(p11) -- line: 199
		-- upvalues: Constants (copy)
		return p11[Constants.RoduxKey].Toast.ToastConfig
	end)
	local v52 = useSelector(function(p12) -- line: 203
		-- upvalues: Constants (copy)
		return p12[Constants.RoduxKey].Toast.IsDismissed
	end)
	local v53 = React.useCallback(function(p13) -- line: 207
		-- upvalues: v49 (copy)
		if p13 then
			return v49[p13]
		end

		return nil
	end)
	local v54 = React.useMemo(function() -- line: 214
		-- upvalues: v50 (copy), CapturesToastType (copy), t1 (copy), v48 (copy), ToastVanished (copy), v47 (copy), v51 (copy), Constants (copy), Dash (copy), v53 (copy)
		if v50 == CapturesToastType.None then
			return nil
		end

		local v59 = t1[v50]
		local v60 = v50
		local v61 = nil

		if v59.onActivated then
			function v61() -- line: 230
				-- upvalues: v59 (copy), v47 (copy), v48 (copy), v51 (copy), v60 (copy), v50 (copy), ToastVanished (copy)
				v59.onActivated(v47, v48, v51)

				if v60 == v50 then
					v48(ToastVanished())
				end
			end
		end

		local v62 = v59.duration or Constants.ToastDuration

		return Dash.join(v59, {
			buttonText = v53(v59.toastCTAKey),
			duration = v62,
			onActivated = v61,
			onDismissed = function() -- line: 222
				-- upvalues: v60 (copy), v50 (copy), v48 (copy), ToastVanished (copy)
				if v60 == v50 then
					v48(ToastVanished())
				end
			end,
			toastCTAKey = Dash.None,
			toastSubtitle = v53(v59.toastSubtitleKey),
			toastSubtitleKey = Dash.None,
			toastTitle = v53(v59.toastTitleKey),
			toastTitleKey = Dash.None
		})
	end, {
		v50,
		v51
	})

	if not v54 then
		return nil
	end

	if FFlagCreateMomentsToast then
		if v50 == CapturesToastType.CaptureTakenWithMomentsCTA then
			return React.createElement(ToastController, {
				icon = "icons/brands/moments_large",
				title = v53("momentsTitle"),
				text = v53("discoverPostWatch"),
				actionText = v53("createAction"),
				onAction = function() -- line: 262
					-- upvalues: v51 (copy), v48 (copy), StartMomentsCreationFlow (copy), v47 (copy), EventNames (copy)
					if v51 and v51.captureInfo then
						v48(StartMomentsCreationFlow(v51.captureInfo))
					end

					v47.fireEvent(EventNames.CapturesCreateMomentToastButtonActivated)
				end,
				onDismissed = function() -- line: 268
					-- upvalues: v48 (copy), ToastVanished (copy)
					v48(ToastVanished())
				end,
				duration = v54.duration,
				show = not v52
			})
		end

		if v50 == CapturesToastType.MomentProcessing then
			return React.createElement(ToastController, {
				icon = "icons/brands/moments_large",
				title = v53("momentProcessingTitle"),
				text = v53("momentProcessingDescription"),
				onDismissed = function() -- line: 279
					-- upvalues: v48 (copy), ToastVanished (copy)
					v48(ToastVanished())
				end,
				duration = v54.duration,
				show = not v52
			})
		end

		return React.createElement(React.Fragment, {}, {
			[v50] = React.createElement(Toast, {
				duration = v54.duration,
				show = not v52,
				toastContent = v54
			})
		})
	end

	return React.createElement(React.Fragment, {}, {
		[v50] = React.createElement(Toast, {
			duration = v54.duration,
			show = not v52,
			toastContent = v54
		})
	})
end
