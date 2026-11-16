local ExperienceService = game:GetService("ExperienceService")
local HttpService = game:GetService("HttpService")

local logEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Analytics/CrossExperienceAnalytics").logEvent
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Constants")
local getMemStorageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Utils/getMemStorageKey")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Analytics/EventNames")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Logger")
require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")

local fFlagFixCrossExperienceVoiceExecutePrint = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies").SharedFlags.FFlagFixCrossExperienceVoiceExecutePrint

local function fn() end

local function fn2(p2, p3, callback, callback2)
	local success, result = pcall(function()
		ExperienceService:ExecuteCrossExperienceCall(p2, p3, function(p4)
			if callback then
				callback(p4)
			end
		end, function(p4)
			if fFlagFixCrossExperienceVoiceExecutePrint then
				Logger:warning("Error executing call: {}", p4)
			else
				print("[CrossExperience] Error executing call", p4)
			end

			if callback2 then
				callback2(p4)
			end
		end)
	end)

	if not success then
		if fFlagFixCrossExperienceVoiceExecutePrint then
			Logger:warning("Error executing call pcall: {} {}", p2, result)
		else
			print("[CrossExperience] Error executing call pcall", p2, result)
		end

		if callback2 then
			callback2("[CrossExperience] Error executing call pcall")
		end
	end
end

local function fn3(p2, p3, fn4, fn5)
	local v5 = {
		eventName = p2.NOTIFY,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	}

	logEvent(EventNames.NotifyObserver, v5)
	fn2(p2.NOTIFY, p3, fn4, fn5)
end

local function fn4(p2, p3, p4, fn5, fn6)
	local guid = HttpService:GenerateGUID(false)
	logEvent(EventNames.AddObserver, {
		eventName = p3.ADD_OBSERVER,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	})

	fn2(p3.ADD_OBSERVER, { observerId = guid, experienceType = p2 }, p4, fn6)

	return guid
end

local function fn5(p2, p3, p4, fn6, fn7)
	logEvent(EventNames.RemoveObserver, {
		eventName = p3.REMOVE_OBSERVER,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	})

	fn2(p3.REMOVE_OBSERVER, { observerId = p4, experienceType = p2 }, fn6, fn7)
end

return {
	execute = fn2,
	notify = function(p2, p3)
		fn3(p2, p3, fn, fn)
	end,
	notifyWithCallbacks = fn3,
	addObserver = function(p2, p3, p4)
		return fn4(p2, p3, p4, fn, fn)
	end,
	addObserverWithCallbacks = fn4,
	removeObserver = function(p2, p3, p4)
		return fn5(p2, p3, p4, fn, fn)
	end,
	removeObserverWithCallbacks = fn5
}
