local parent = script.Parent.Parent
local parent2 = parent.Parent

local SocialStopwatch = require(parent2.SocialStopwatch)

local CapturesPolicy = require(parent.App.CapturesPolicy)
local CheckMomentsEligibility = require(parent.Thunks.CheckMomentsEligibility)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local RetrieveCaptures = require(parent.Thunks.RetrieveCaptures)
local ToastTriggered = require(parent.Actions.ToastTriggered)
local TriggerSourceType = require(parent.Enums.TriggerSourceType)
require(parent.Types)

local fetchCapturesFromGallery = require(parent.Utils.fetchCapturesFromGallery)
local findMatchingCapture = require(parent.Utils.findMatchingCapture)
local getCaptureObject = require(parent.Utils.getCaptureObject)
local pendingCaptureToastAction = require(parent.Utils.pendingCaptureToastAction)
local waitForFlashOverlay = require(parent.Utils.waitForFlashOverlay)

local SharedFlags = require(parent2.SharedFlags)
local FFlagBuildExperienceInGameCaptureToChat = SharedFlags.FFlagBuildExperienceInGameCaptureToChat
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local MomentsCommon = require(parent2.MomentsCommon)
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities

local FFlagCreateMomentsToast = require(parent.Flags.FFlagCreateMomentsToast)
local FFlagMomentsCaptureEndIxpEnabled = require(parent.Flags.FFlagMomentsCaptureEndIxpEnabled)

local FFlagCapturesInExpMomentsEligibilityRetry = require(parent.Flags.FFlagCapturesInExpMomentsEligibilityRetry)

local FIntMomentsInExperienceMinCaptureSeconds = require(parent.Flags.FIntMomentsInExperienceMinCaptureSeconds)

local CaptureType = require(parent.Enums.CaptureType)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local engineFeature = game:GetEngineFeature("CaptureServiceEnableXExperiencePostingApis")

local function triggerDefaultToast(object, flag: boolean, captureInfo, flag2: boolean, callback)
	if flag then
		object:dispatch(ToastTriggered(CapturesToastType.CaptureTaken, { captureInfo = captureInfo }))
	else
		object:dispatch(ToastTriggered(CapturesToastType.ViewCapture))
	end

	if flag2 then
		callback(EventNames.CapturesVideoShareToastViewed)
	end

	callback(EventNames.CapturesShareToastViewed)
end

local function makeCaptureSavedHandler(object, _, callback)
	local function captureSavedHandler(captureInfo, p)
		local v

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			v = captureInfo.CaptureType == Enum.CaptureType.Video
		else
			v = captureInfo.type == CaptureType.Video
		end

		if p == TriggerSourceType.UserSave and not v then
			local v2 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CaptureTaken)
			local capturesEntrypointLatency = EventNames.CapturesEntrypointLatency
			local statValue

			if v2 then
				statValue = v2.timeElapsed
			end

			callback(capturesEntrypointLatency, { statValue = statValue })
		end

		object:dispatch(RetrieveCaptures())
		waitForFlashOverlay(object)

		if FFlagBuildExperienceInGameCaptureToChat and p == TriggerSourceType.UserSave then
			local toastAction = pendingCaptureToastAction.consume()
			local captureInfo2

			if toastAction then
				captureInfo2 = getCaptureObject(captureInfo)
			end

			if captureInfo2 ~= nil then
				object:dispatch(ToastTriggered(CapturesToastType.CaptureTakenWithAction, {
					captureInfo = captureInfo2,
					toastAction = toastAction
				}))

				return
			end
		end

		if p == TriggerSourceType.PromptedShare then
			return
		end

		local v2 = CapturesPolicy.PolicyImplementation.read()
		local v3

		if v2 then
			v3 = CapturesPolicy.Mapper(v2).enableShareCaptureCTA()
		else
			v3 = false
		end

		local captureInfo2 = getCaptureObject(captureInfo)

		local v4 = false
		local gameId

		if FFlagCreateMomentsToast then
			gameId = game.GameId
		end

		local v5 = not FFlagMomentsCreationFeatureGate or GetMomentsCapabilities(false).getCanCreateMoments(false)

		if FFlagCreateMomentsToast and engineFeature and v5 then
			local v6

			if captureInfo2 == nil then
				v6 = false
			else
				v6 = captureInfo2.CaptureType == Enum.CaptureType.Video
			end

			local timeLength

			if v6 then
				timeLength = captureInfo2.TimeLength
			end

			if captureInfo2 == nil then
				v4 = false
			else
				v4 = not v6

				if not v4 then
					if type(timeLength) == "number" then
						v4 = FIntMomentsInExperienceMinCaptureSeconds <= timeLength
					else
						v4 = false
					end
				end
			end
		end

		if
			FFlagMomentsCaptureEndIxpEnabled
			and FFlagCapturesInExpMomentsEligibilityRetry
			and not FFlagCreateMomentsToast
		then
			object:dispatch((CheckMomentsEligibility(game.GameId)))
		end

		if not v4 or gameId == nil then
			triggerDefaultToast(object, v3, captureInfo, v, callback)
			return
		end

		if FFlagCapturesInExpMomentsEligibilityRetry then
			object:dispatch((CheckMomentsEligibility(gameId)))
		end

		if object:getState()[Constants.RoduxKey].MomentsEligibility.byUniverseId[gameId] ~= true then
			triggerDefaultToast(object, v3, captureInfo, v, callback)
			return
		end

		if FFlagCreateMomentsToast then
			captureInfo2 = captureInfo2
				and (findMatchingCapture(fetchCapturesFromGallery(), captureInfo2) or captureInfo2)
		end

		object:dispatch(ToastTriggered(CapturesToastType.CaptureTakenWithMomentsCTA, {
			captureInfo = captureInfo2
		}))

		callback(EventNames.CapturesCreateMomentToastViewed)
	end

	return captureSavedHandler
end

return makeCaptureSavedHandler
