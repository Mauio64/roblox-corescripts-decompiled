local CrossExperience = script:FindFirstAncestor("CrossExperience")
local ExperienceService = game:GetService("ExperienceService")
local HttpService = game:GetService("HttpService")
local logEvent = require(CrossExperience.Analytics.CrossExperienceAnalytics).logEvent
local Constants = require(CrossExperience.Constants)
local getMemStorageKey = require(CrossExperience.Utils.getMemStorageKey)
local EventNames = require(CrossExperience.Analytics.EventNames)
local Logger = require(CrossExperience.Logger)

require(CrossExperience.Types)

local FFlagFixCrossExperienceVoiceExecutePrint = require(CrossExperience.dependencies).SharedFlags.FFlagFixCrossExperienceVoiceExecutePrint

local function v10() -- line: 21
end
local function v11(s1: string, p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 23
	-- upvalues: ExperienceService (copy), FFlagFixCrossExperienceVoiceExecutePrint (copy), Logger (copy)
	local ok, result = pcall(function() -- line: 24
		-- upvalues: ExperienceService (copy), s1 (copy), p1 (copy), p2 (copy), FFlagFixCrossExperienceVoiceExecutePrint (copy), Logger (copy), p3 (copy)
		ExperienceService:ExecuteCrossExperienceCall(s1, p1, function(p4) -- line: 25
			-- upvalues: p2 (copy)
			if p2 then
				p2(p4)
			end
		end, function(s2: string) -- line: 29
			-- upvalues: FFlagFixCrossExperienceVoiceExecutePrint (copy), Logger (copy), p3 (copy)
			if FFlagFixCrossExperienceVoiceExecutePrint then
				Logger:warning("Error executing call: {}", s2)
			else
				print("[CrossExperience] Error executing call", s2)
			end

			if p3 then
				p3(s2)
			end
		end)
	end)

	if not ok then
		if FFlagFixCrossExperienceVoiceExecutePrint then
			Logger:warning("Error executing call pcall: {} {}", s1, result)
		else
			print("[CrossExperience] Error executing call pcall", s1, result)
		end

		if p3 then
			p3("[CrossExperience] Error executing call pcall")
		end
	end
end
local function v12(p5, p6, p7: ((...any) -> ...any), p8: ((...any) -> ...any)) -- line: 54
	-- upvalues: getMemStorageKey (copy), Constants (copy), logEvent (copy), EventNames (copy), v11 (copy)
	local t1 = {
		eventName = p5.NOTIFY,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	}

	logEvent(EventNames.NotifyObserver, t1)
	v11(p5.NOTIFY, p6, p7, p8)
end
local function v13(p9, p10, p11: ((...any) -> ...any), _: ((...any) -> ...any), p13: ((...any) -> ...any)) -- line: 74
	-- upvalues: HttpService (copy), logEvent (copy), EventNames (copy), getMemStorageKey (copy), Constants (copy), v11 (copy)
	local guid = HttpService:GenerateGUID(false)

	logEvent(EventNames.AddObserver, {
		eventName = p10.ADD_OBSERVER,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	})
	v11(p10.ADD_OBSERVER, {
		observerId = guid,
		experienceType = p9
	}, p11, p13)

	return guid
end
local function v14(p14, p15, s3: string, p16: ((...any) -> ...any), p17: ((...any) -> ...any)) -- line: 99
	-- upvalues: logEvent (copy), EventNames (copy), getMemStorageKey (copy), Constants (copy), v11 (copy)
	logEvent(EventNames.RemoveObserver, {
		eventName = p15.REMOVE_OBSERVER,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	})
	v11(p15.REMOVE_OBSERVER, {
		observerId = s3,
		experienceType = p14
	}, p16, p17)
end

return {
	execute = v11,
	notify = function(p18, p19) -- line: 70
		-- upvalues: v12 (copy), v10 (copy)
		v12(p18, p19, v10, v10)
	end,
	notifyWithCallbacks = v12,
	addObserver = function(p20, p21, p22: ((...any) -> ...any)) -- line: 95
		-- upvalues: v13 (copy), v10 (copy)
		return (v13(p20, p21, p22, v10, v10))
	end,
	addObserverWithCallbacks = v13,
	removeObserver = function(p23, p24, s4: string) -- line: 117
		-- upvalues: v14 (copy), v10 (copy)
		return v14(p23, p24, s4, v10, v10)
	end,
	removeObserverWithCallbacks = v14
}
