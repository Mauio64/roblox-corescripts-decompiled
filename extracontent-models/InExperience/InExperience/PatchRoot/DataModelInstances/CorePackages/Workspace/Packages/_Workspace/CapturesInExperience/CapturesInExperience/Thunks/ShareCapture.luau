local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CaptureService = game:GetService("CaptureService")
local LocalizationService = game:GetService("LocalizationService")
local default = require(ParentParentParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Localization = require(ParentParentParent.RobloxAppLocales).Localization
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local CaptureType = require(ParentParent.Enums.CaptureType)
local Constants = require(ParentParent.Constants)
local ServerType = require(ParentParent.Enums.ServerType)
local EventNames = require(ParentParent.Analytics.EventNames)

require(ParentParent.Enums.ExternalShareSourceType)

local FireEvent = require(ParentParent.Analytics.FireEvent)
local getPlaceIdFromCapture = require(ParentParent.Utils.getPlaceIdFromCapture)
local Networking = require(ParentParent.App.Networking)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local ShareLinksNetworking = Networking.ShareLinksNetworking
local LinkType = Networking.ShareLinksRodux.Enums.LinkType
local v19 = Localization.new(LocalizationService.RobloxLocaleId)

local function shareImage(s1: string, s2: string?) -- line: 33
	-- upvalues: default (copy), Constants (copy), v19 (copy)
	if not default then
		return
	end

	assert(default ~= nil, "ExternalContentSharingProtocol is required")
	default:shareImage({
		context = Constants.CapturesContext,
		image = s1,
		shareSheetTitle = v19:Format("Feature.Captures.Action.ShareYourCapture"),
		url = s2
	})
end
local function shareVideo(s3: string, s4: string?) -- line: 48
	-- upvalues: default (copy), Constants (copy), v19 (copy)
	if not default then
		return
	end

	assert(default ~= nil, "ExternalContentSharingProtocol is required")
	default:shareVideo({
		context = Constants.CapturesContext,
		shareSheetTitle = v19:Format("Feature.Captures.Action.ShareYourCapture"),
		url = s4,
		video = s3
	})
end
local function shareCapture(p1, s5: string?) -- line: 63
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureService (copy), shareVideo (copy), shareImage (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy)
	if FFlagEnableCapturesGalleryRetrievalCoreScript and p1.CaptureTime ~= nil then
		local v30 = CaptureService:PreCaptureShared(p1)

		if p1.CaptureType == Enum.CaptureType.Video then
			shareVideo(v30, s5)
		else
			shareImage(v30, s5)
		end

		CaptureService:OnCaptureObjectShared(p1)

		return
	end

	if FFlagUseRbxstorageInGallery and p1.type == CaptureType.Video then
		local v31 = CaptureService:PreVideoCaptureShared(p1.videoCapture)

		shareVideo(v31, s5)
		CaptureService:OnVideoCaptureShared(p1.videoCapture)

		return
	end

	shareImage(p1.filePath, s5)
	CaptureService:OnCaptureShared(p1.filePath)
end
local function sendShareLatencyEvent(p2) -- line: 82
	-- upvalues: SocialStopwatch (copy), FireEvent (copy), EventNames (copy)
	local v33 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CaptureShared)

	FireEvent(EventNames.CapturesShareLatency, {
		statValue = if not v33 then nil else v33.timeElapsed,
		externalShareSource = p2
	})
end

return function(p3, p4, s6: string?) -- line: 90
	-- upvalues: ServerType (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), shareCapture (copy), FireEvent (copy), EventNames (copy), SocialStopwatch (copy), getPlaceIdFromCapture (copy), LinkType (copy), ShareLinksNetworking (copy)
	return function(p5) -- line: 95
		-- upvalues: ServerType (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), p3 (copy), CaptureType (copy), shareCapture (copy), FireEvent (copy), EventNames (copy), p4 (copy), SocialStopwatch (copy), getPlaceIdFromCapture (copy), s6 (copy), LinkType (copy), ShareLinksNetworking (copy)
		local v38 = p5:getState().ServerType == ServerType.StandardServer
		local v39 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then p3.type == CaptureType.Video else p3.CaptureType == Enum.CaptureType.Video

		if not v38 then
			shareCapture(p3)
			FireEvent(EventNames.CapturesShareFromNonStandardServer)

			local v40 = p4
			local v41 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CaptureShared)

			FireEvent(EventNames.CapturesShareLatency, {
				statValue = if not v41 then nil else v41.timeElapsed,
				externalShareSource = v40
			})

			return
		end

		local JobId = nil
		local PlaceId = game.PlaceId
		local v44 = if not v39 then getPlaceIdFromCapture(p3) else if not FFlagEnableCapturesGalleryRetrievalCoreScript then p3.videoCapture.SourcePlaceId else p3.SourcePlaceId

		if PlaceId == v44 then
			JobId = game.JobId
		end

		local t1 = {
			instanceId = JobId,
			launchData = s6,
			linkType = LinkType.ScreenshotInvite.rawValue(),
			placeId = v44
		}

		p5:dispatch(ShareLinksNetworking.GenerateLink.API(t1)):andThen(function(p6) -- line: 129
			-- upvalues: shareCapture (copy), p3 (copy), p4 (copy), SocialStopwatch (copy), FireEvent (copy), EventNames (copy)
			local shortUrl = p6.responseBody.shortUrl

			shareCapture(p3, shortUrl)

			local v48 = p4
			local v49 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CaptureShared)

			FireEvent(EventNames.CapturesShareLatency, {
				statValue = if not v49 then nil else v49.timeElapsed,
				externalShareSource = v48
			})
		end):catch(function(p7) -- line: 134
			-- upvalues: FireEvent (copy), EventNames (copy), shareCapture (copy), p3 (copy), p4 (copy), SocialStopwatch (copy)
			warn("GenerateLink failed with error:", p7)
			FireEvent(EventNames.ShareCaptureGenerateLinkFailed, {
				httpError = p7.HttpError
			})
			shareCapture(p3)

			local v51 = p4
			local v52 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CaptureShared)

			FireEvent(EventNames.CapturesShareLatency, {
				statValue = if not v52 then nil else v52.timeElapsed,
				externalShareSource = v51
			})
		end)
	end
end
