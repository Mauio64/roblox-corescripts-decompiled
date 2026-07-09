local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local RetrieveCaptures = require(ParentParent.Thunks.RetrieveCaptures)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)
local TriggerSourceType = require(ParentParent.Enums.TriggerSourceType)

require(ParentParent.Types)

local fetchCapturesFromGallery = require(ParentParent.Utils.fetchCapturesFromGallery)
local findMatchingCapture = require(ParentParent.Utils.findMatchingCapture)
local getCaptureObject = require(ParentParent.Utils.getCaptureObject)
local waitForFlashOverlay = require(ParentParent.Utils.waitForFlashOverlay)
local FFlagCreateMomentsToast = require(ParentParent.Flags.FFlagCreateMomentsToast)
local FFlagEnableUpdatedCaptureControls = require(ParentParent.Flags.FFlagEnableUpdatedCaptureControls)
local CaptureType = require(ParentParent.Enums.CaptureType)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local EngineFeature = game:GetEngineFeature("CaptureServiceEnableXExperiencePostingApis")

local function triggerDefaultToast(p1, b1: boolean, p2, b2: boolean, p3: ((...any) -> ...any)) -- line: 33
	-- upvalues: ToastTriggered (copy), CapturesToastType (copy), EventNames (copy)
	if b1 then
		p1:dispatch(ToastTriggered(CapturesToastType.CaptureTaken, {
			captureInfo = p2
		}))
	else
		p1:dispatch(ToastTriggered(CapturesToastType.ViewCapture))
	end

	if b2 then
		p3(EventNames.CapturesVideoShareToastViewed)
	end

	p3(EventNames.CapturesShareToastViewed)
end
local function makeCaptureSavedHandler(p4, _, p6: ((...any) -> ...any)) -- line: 55
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), TriggerSourceType (copy), FFlagEnableUpdatedCaptureControls (copy), SocialStopwatch (copy), EventNames (copy), RetrieveCaptures (copy), waitForFlashOverlay (copy), CapturesPolicy (copy), getCaptureObject (copy), FFlagCreateMomentsToast (copy), EngineFeature (copy), triggerDefaultToast (copy), Constants (copy), fetchCapturesFromGallery (copy), findMatchingCapture (copy), ToastTriggered (copy), CapturesToastType (copy)
	local function captureSavedHandler(p7, p8) -- line: 56
		-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), TriggerSourceType (copy), FFlagEnableUpdatedCaptureControls (copy), SocialStopwatch (copy), p6 (copy), EventNames (copy), p4 (copy), RetrieveCaptures (copy), waitForFlashOverlay (copy), CapturesPolicy (copy), getCaptureObject (copy), FFlagCreateMomentsToast (copy), EngineFeature (copy), triggerDefaultToast (copy), Constants (copy), fetchCapturesFromGallery (copy), findMatchingCapture (copy), ToastTriggered (copy), CapturesToastType (copy)
		local v33 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then p7.type == CaptureType.Video else p7.CaptureType == Enum.CaptureType.Video

		if p8 == TriggerSourceType.UserSave and (not FFlagEnableUpdatedCaptureControls or not v33) then
			local v34 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CaptureTaken)

			p6(EventNames.CapturesEntrypointLatency, {
				statValue = if not v34 then nil else v34.timeElapsed
			})
		end

		p4:dispatch(RetrieveCaptures())
		waitForFlashOverlay(p4)

		if p8 == TriggerSourceType.PromptedShare then
			return
		end

		local v35 = CapturesPolicy.PolicyImplementation.read()
		local v36 = not not v35 and CapturesPolicy.Mapper(v35).enableShareCaptureCTA()
		local v37 = getCaptureObject(p7)
		local v38 = false
		local v39 = if not FFlagCreateMomentsToast then nil else game.GameId

		if FFlagCreateMomentsToast and EngineFeature then
			local v40 = v37 ~= nil and v37.CaptureType == Enum.CaptureType.Video
			local v41 = if not v40 then nil else v37.TimeLength

			v38 = v37 ~= nil and (not v40 or type(v41) == "number" and v41 >= 6)
		end

		if not v38 or v39 == nil then
			triggerDefaultToast(p4, v36, p7, v33, p6)

			return
		end

		if p4:getState()[Constants.RoduxKey].MomentsEligibility.byUniverseId[v39] == true then
			if FFlagCreateMomentsToast and v37 then
				local v42 = fetchCapturesFromGallery()

				v37 = findMatchingCapture(v42, v37) or v37
			end

			p4:dispatch(ToastTriggered(CapturesToastType.CaptureTakenWithMomentsCTA, {
				captureInfo = v37
			}))
			p6(EventNames.CapturesCreateMomentToastViewed)

			return
		end

		triggerDefaultToast(p4, v36, p7, v33, p6)
	end

	return captureSavedHandler
end

return makeCaptureSavedHandler
