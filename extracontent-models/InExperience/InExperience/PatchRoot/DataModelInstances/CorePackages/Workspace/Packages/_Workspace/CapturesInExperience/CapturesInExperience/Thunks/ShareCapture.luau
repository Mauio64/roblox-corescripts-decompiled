local parent = script.Parent.Parent
local parent2 = parent.Parent

local CaptureService = game:GetService("CaptureService")
local LocalizationService = game:GetService("LocalizationService")

local ExternalContentSharingProtocol = require(parent2.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local RobloxAppLocales = require(parent2.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local SocialStopwatch = require(parent2.SocialStopwatch)

local CaptureType = require(parent.Enums.CaptureType)
local Constants = require(parent.Constants)
local ServerType = require(parent.Enums.ServerType)
local EventNames = require(parent.Analytics.EventNames)
require(parent.Enums.ExternalShareSourceType)
local FireEvent = require(parent.Analytics.FireEvent)
local getPlaceIdFromCapture = require(parent.Utils.getPlaceIdFromCapture)
local Networking = require(parent.App.Networking)
require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local ShareLinksNetworking = Networking.ShareLinksNetworking
local LinkType = Networking.ShareLinksRodux.Enums.LinkType

local v = Localization.new(LocalizationService.RobloxLocaleId)

local function shareImage(image: string, url: string?)
	if not default then
		return
	end

	assert(default ~= nil, "ExternalContentSharingProtocol is required")

	default:shareImage({
		context = Constants.CapturesContext,
		image = image,
		shareSheetTitle = v:Format("Feature.Captures.Action.ShareYourCapture"),
		url = url
	})
end

local function shareVideo(video: string, url: string?)
	if not default then
		return
	end

	assert(default ~= nil, "ExternalContentSharingProtocol is required")

	default:shareVideo({
		context = Constants.CapturesContext,
		shareSheetTitle = v:Format("Feature.Captures.Action.ShareYourCapture"),
		url = url,
		video = video
	})
end

local function shareCapture(data, url: string?)
	if FFlagEnableCapturesGalleryRetrievalCoreScript and data.CaptureTime ~= nil then
		local preCaptureShared = CaptureService:PreCaptureShared(data)

		if data.CaptureType == Enum.CaptureType.Video then
			shareVideo(preCaptureShared, url)
		else
			shareImage(preCaptureShared, url)
		end

		CaptureService:OnCaptureObjectShared(data)
	elseif FFlagUseRbxstorageInGallery and data.type == CaptureType.Video then
		shareVideo(CaptureService:PreVideoCaptureShared(data.videoCapture), url)
		CaptureService:OnVideoCaptureShared(data.videoCapture)
	else
		shareImage(data.filePath, url)
		CaptureService:OnCaptureShared(data.filePath)
	end
end

local function sendShareLatencyEvent(externalShareSource) -- 3 equivalent calls inferred from this helper
	local v2 = SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CaptureShared)
	local capturesShareLatency = EventNames.CapturesShareLatency
	local statValue

	if v2 then
		statValue = v2.timeElapsed
	end

	FireEvent(capturesShareLatency, {
		statValue = statValue,
		externalShareSource = externalShareSource
	})
end

return function(data, externalShareSource, launchData: string?)
	return function(object)
		local v2 = object:getState().ServerType == ServerType.StandardServer
		local v3

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			v3 = data.CaptureType == Enum.CaptureType.Video
		else
			v3 = data.type == CaptureType.Video
		end

		if v2 then
			local jobId = nil
			local placeId = game.PlaceId
			local placeId2

			if v3 then
				if FFlagEnableCapturesGalleryRetrievalCoreScript then
					placeId2 = data.SourcePlaceId
				else
					placeId2 = data.videoCapture.SourcePlaceId
				end
			else
				placeId2 = getPlaceIdFromCapture(data)
			end

			if placeId == placeId2 then
				jobId = game.JobId
			end

			local v4 = {
				instanceId = jobId,
				launchData = launchData,
				linkType = LinkType.ScreenshotInvite.rawValue(),
				placeId = placeId2
			}

			object:dispatch(ShareLinksNetworking.GenerateLink.API(v4)):andThen(function(p)
				shareCapture(data, p.responseBody.shortUrl)
				sendShareLatencyEvent(externalShareSource) -- inferred equivalent call
			end):catch(function(p)
				warn("GenerateLink failed with error:", p)

				FireEvent(EventNames.ShareCaptureGenerateLinkFailed, { httpError = p.HttpError })

				shareCapture(data)
				sendShareLatencyEvent(externalShareSource) -- inferred equivalent call
			end)
		else
			shareCapture(data)
			FireEvent(EventNames.CapturesShareFromNonStandardServer)
			sendShareLatencyEvent(externalShareSource) -- inferred equivalent call
		end
	end
end
