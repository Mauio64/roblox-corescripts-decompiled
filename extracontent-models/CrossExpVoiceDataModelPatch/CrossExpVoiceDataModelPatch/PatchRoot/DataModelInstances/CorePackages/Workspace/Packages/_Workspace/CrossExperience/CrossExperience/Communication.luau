local CrossExperience = script:FindFirstAncestor("CrossExperience")
local ExperienceService = game:GetService("ExperienceService")
local HttpService = game:GetService("HttpService")

local CrossExperienceAnalytics = require(CrossExperience.Analytics.CrossExperienceAnalytics)
local logEvent = CrossExperienceAnalytics.logEvent
local Constants = require(CrossExperience.Constants)
local getMemStorageKey = require(CrossExperience.Utils.getMemStorageKey)
local EventNames = require(CrossExperience.Analytics.EventNames)
local Logger = require(CrossExperience.Logger)
require(CrossExperience.Types)

local dependencies = require(CrossExperience.dependencies)
local fFlagFixCrossExperienceVoiceExecutePrint = dependencies.SharedFlags.FFlagFixCrossExperienceVoiceExecutePrint

local function fn() end

local function fn2(p: string, p2, callback, callback2)
	local success, result = pcall(function()
		ExperienceService:ExecuteCrossExperienceCall(p, p2, function(p3)
			if callback then
				callback(p3)
			end
		end, function(p3: string)
			if fFlagFixCrossExperienceVoiceExecutePrint then
				Logger:warning("Error executing call: {}", p3)
			else
				print("[CrossExperience] Error executing call", p3)
			end

			if callback2 then
				callback2(p3)
			end
		end)
	end)

	if not success then
		if fFlagFixCrossExperienceVoiceExecutePrint then
			Logger:warning("Error executing call pcall: {} {}", p, result)
		else
			print("[CrossExperience] Error executing call pcall", p, result)
		end

		if callback2 then
			callback2("[CrossExperience] Error executing call pcall")
		end
	end
end

local function fn3(p, p2, fn4, fn5)
	local v = {
		eventName = p.NOTIFY,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	}

	logEvent(EventNames.NotifyObserver, v)
	fn2(p.NOTIFY, p2, fn4, fn5)
end

local function fn4(experienceType, p, callback, _, fn5)
	local guid = HttpService:GenerateGUID(false)
	logEvent(EventNames.AddObserver, {
		eventName = p.ADD_OBSERVER,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	})

	fn2(p.ADD_OBSERVER, { observerId = guid, experienceType = experienceType }, callback, fn5)

	return guid
end

local function fn5(experienceType, p, observerId: string, fn6, fn7)
	logEvent(EventNames.RemoveObserver, {
		eventName = p.REMOVE_OBSERVER,
		clientTimeStamp = os.time(),
		cevJoinAttemptId = getMemStorageKey(Constants.CEV_JOIN_ATTEMPT_ID_KEY)
	})

	fn2(p.REMOVE_OBSERVER, { observerId = observerId, experienceType = experienceType }, fn6, fn7)
end

local Communication = {}
Communication.execute = fn2

function Communication.notify(p, p2)
	fn3(p, p2, fn, fn)
end

Communication.notifyWithCallbacks = fn3

function Communication.addObserver(experienceType, p, callback)
	return fn4(experienceType, p, callback, fn, fn)
end

Communication.addObserverWithCallbacks = fn4

function Communication.removeObserver(experienceType, p, observerId: string)
	return fn5(experienceType, p, observerId, fn, fn)
end

Communication.removeObserverWithCallbacks = fn5
return Communication
