local parent = script.Parent
local parent2 = parent.Parent
local Signals = require(parent2.Signals)
local t = require(parent2.t)
local Loggers = require(parent2.Loggers)

local EnhancedVideoTelemetry = require(parent.EnhancedVideoTelemetry)

local flaggedMutedError = Loggers.flaggedMutedError
local createSignal = Signals.createSignal

local serveEnhancedVideo = require(parent.serveEnhancedVideo)
require(parent.Types)

local interface = t.interface({
	adDisclosureText = t.string,
	showAdPreferencesUrl = t.boolean,
	videoAssetId = t.string,
	timelineJson = t.optional(t.string)
})

function createEnhancedVideoStore()
	local signal, v = createSignal("")
	local signal2, v2 = createSignal(false)
	local signal3, v3 = createSignal("")
	local signal4, v4 = createSignal("")

	return {
		getAdDisclosureText = signal,
		getShowAdPreferencesUrl = signal2,
		getVideoAssetId = signal3,
		getTimelineJson = signal4,
		fetchInitialData = function(p, p2: number)
			return serveEnhancedVideo(p, p2):andThen(function(p3)
				local responseBody = p3.responseBody

				if not interface(responseBody) then
					flaggedMutedError(
						"EnhancedVideo_InvalidResponseSchema",
						`Response does not match expected schema for universe {p2}`
					)

					return nil
				end

				v(responseBody.adDisclosureText)
				v2(responseBody.showAdPreferencesUrl)
				v3(responseBody.videoAssetId)
				local timelineJson = responseBody.timelineJson or ""
				v4(timelineJson)
				return { videoAssetId = responseBody.videoAssetId, timelineJson = timelineJson }
			end):catch(function(p3): nil
				EnhancedVideoTelemetry.logServeEnhancedVideoError((tostring(p3)))
				return nil
			end)
		end
	}
end

return Signals.createComputed(createEnhancedVideoStore)
