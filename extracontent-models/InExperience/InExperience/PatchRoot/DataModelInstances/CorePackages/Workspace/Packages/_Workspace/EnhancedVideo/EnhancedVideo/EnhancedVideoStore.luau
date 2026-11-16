local parent = script.Parent
local parent2 = parent.Parent
local Signals = require(parent2.Signals)
local t = require(parent2.t)
local Loggers = require(parent2.Loggers)

local EnhancedVideoTelemetry = require(parent.EnhancedVideoTelemetry)

local FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline = require(parent.FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline)

local flaggedMutedError = Loggers.flaggedMutedError
local createSignal = Signals.createSignal

local serveEnhancedVideo = require(parent.serveEnhancedVideo)
require(parent.Types)

local interface = t.interface
local v = {
	adDisclosureText = t.string,
	showAdPreferencesUrl = t.boolean,
	videoAssetId = t.string,
	timelineJson = 0
}
local timelineJson2

if FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
	timelineJson2 = t.optional(t.string)
end

v.timelineJson = timelineJson2
local v2 = interface(v)

function createEnhancedVideoStore()
	local signal, v3 = createSignal("")
	local signal2, v4 = createSignal(false)
	local signal3, v5 = createSignal("")
	local getTimelineJson, v6

	if FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
		getTimelineJson, v6 = createSignal("")
	else
		v6 = nil
	end

	local fn

	if FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
		fn = function(p, p2: number)
			return serveEnhancedVideo(p, p2):andThen(function(p3)
				local responseBody = p3.responseBody

				if not v2(responseBody) then
					flaggedMutedError(
						"EnhancedVideo_InvalidResponseSchema",
						`Response does not match expected schema for universe {p2}`
					)

					return nil
				end

				v3(responseBody.adDisclosureText)
				v4(responseBody.showAdPreferencesUrl)
				v5(responseBody.videoAssetId)
				local timelineJson = responseBody.timelineJson or ""
				v6(timelineJson)
				return { videoAssetId = responseBody.videoAssetId, timelineJson = timelineJson }
			end):catch(function(p3): nil
				EnhancedVideoTelemetry.logServeEnhancedVideoError((tostring(p3)))
				return nil
			end)
		end
	else
		fn = function(p, p2: number)
			serveEnhancedVideo(p, p2):andThen(function(p3)
				local responseBody = p3.responseBody

				if not v2(responseBody) then
					flaggedMutedError(
						"EnhancedVideo_InvalidResponseSchema",
						`Response does not match expected schema for universe ${p2}`
					)

					return
				end

				v3(responseBody.adDisclosureText)
				v4(responseBody.showAdPreferencesUrl)
				v5(responseBody.videoAssetId)
			end):catch(function(p3)
				EnhancedVideoTelemetry.logServeEnhancedVideoError((tostring(p3)))
			end)
		end
	end

	if not FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
		getTimelineJson = nil
	end

	return {
		getAdDisclosureText = signal,
		getShowAdPreferencesUrl = signal2,
		getVideoAssetId = signal3,
		getTimelineJson = getTimelineJson,
		fetchInitialData = fn
	}
end

return Signals.createComputed(createEnhancedVideoStore)
