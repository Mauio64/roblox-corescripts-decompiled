local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signals = require(scriptParentParent.Signals)
local t = require(scriptParentParent.t)
local Loggers = require(scriptParentParent.Loggers)
local EnhancedVideoTelemetry = require(scriptParent.EnhancedVideoTelemetry)
local FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline = require(scriptParent.FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline)
local flaggedMutedError = Loggers.flaggedMutedError
local createSignal = Signals.createSignal
local serveEnhancedVideo = require(scriptParent.serveEnhancedVideo)

require(scriptParent.Types)

local v11 = t.interface({
	adDisclosureText = t.string,
	showAdPreferencesUrl = t.boolean,
	videoAssetId = t.string,
	timelineJson = if not FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then nil else t.optional(t.string)
})

function createEnhancedVideoStore() -- line: 40
	-- upvalues: createSignal (copy), FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline (copy), serveEnhancedVideo (copy), v11 (copy), flaggedMutedError (copy), EnhancedVideoTelemetry (copy)
	local v12, v13 = createSignal("")
	local v14, v15 = createSignal(false)
	local v16, v17 = createSignal("")
	local v18 = nil
	local u19 = nil

	if FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
		local v20

		v18, v20 = createSignal("")
		u19 = v20
	end

	local v21 = not FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline and function(p1, n1: number) -- line: 78
		-- upvalues: serveEnhancedVideo (copy), v11 (copy), flaggedMutedError (copy), v13 (copy), v15 (copy), v17 (copy), EnhancedVideoTelemetry (copy)
		serveEnhancedVideo(p1, n1):andThen(function(p2) -- line: 80
			-- upvalues: v11 (copy), flaggedMutedError (copy), n1 (copy), v13 (copy), v15 (copy), v17 (copy)
			local responseBody = p2.responseBody

			if not v11(responseBody) then
				flaggedMutedError("EnhancedVideo_InvalidResponseSchema", `Response does not match expected schema for universe ${ n1 }`)

				return
			end

			v13(responseBody.adDisclosureText)
			v15(responseBody.showAdPreferencesUrl)
			v17(responseBody.videoAssetId)
		end):catch(function(p3) -- line: 93
			-- upvalues: EnhancedVideoTelemetry (copy)
			EnhancedVideoTelemetry.logServeEnhancedVideoError((tostring(p3)))
		end)
	end or function(p4, n2: number) -- line: 51
		-- upvalues: serveEnhancedVideo (copy), v11 (copy), flaggedMutedError (copy), v13 (copy), v15 (copy), v17 (copy), u19 (ref), EnhancedVideoTelemetry (copy)
		return serveEnhancedVideo(p4, n2):andThen(function(p5) -- line: 53
			-- upvalues: v11 (copy), flaggedMutedError (copy), n2 (copy), v13 (copy), v15 (copy), v17 (copy), u19 (ref)
			local responseBody = p5.responseBody

			if not v11(responseBody) then
				flaggedMutedError("EnhancedVideo_InvalidResponseSchema", `Response does not match expected schema for universe { n2 }`)

				return nil
			end

			v13(responseBody.adDisclosureText)
			v15(responseBody.showAdPreferencesUrl)
			v17(responseBody.videoAssetId)

			local v28 = responseBody.timelineJson or ""

			u19(v28)

			return {
				videoAssetId = responseBody.videoAssetId,
				timelineJson = v28
			}
		end):catch(function(p6) -- line: 72
			-- upvalues: EnhancedVideoTelemetry (copy)
			EnhancedVideoTelemetry.logServeEnhancedVideoError((tostring(p6)))

			return nil
		end)
	end

	return {
		getAdDisclosureText = v12,
		getShowAdPreferencesUrl = v14,
		getVideoAssetId = v16,
		getTimelineJson = if not FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then nil else v18,
		fetchInitialData = v21
	}
end

return Signals.createComputed(createEnhancedVideoStore)
