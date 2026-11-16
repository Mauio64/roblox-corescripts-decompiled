local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local createUserChatSettingStore = require(script.createUserChatSettingStore)

local FFlagAIRephraseSettingEnabled = SharedFlags.FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled

local function applyAIRephraseFeatureValue(p: string, p2: string, callback, callback2) -- 1 equivalent call inferred from this helper
	if p == "AIRephraseSettingStatus" then
		callback(p2 == "Enabled" or p2 == "Disabled")
		callback2(p2 == "Enabled")
	end
end

local function buildAIRephraseConfig()
	return {
		setupListener = function(_, _)
			return function() end
		end,
		buildFeatureValueHandler = function(callback, callback2)
			return function(p: string, p2: string)
				if p == "AIRephraseSettingStatus" then
					applyAIRephraseFeatureValue("AIRephraseSettingStatus", p2, callback, callback2) -- inferred equivalent call
				end
			end
		end,
		onSetEnabled = function(flag: boolean, callback)
			callback(flag)
		end,
		requiresChatEnabled = true
	}
end

local function applyChatSummariesFeatureValue(p: string, p2: string, callback, callback2) -- 1 equivalent call inferred from this helper
	if p == "AllowThirdPartySummary" then
		callback(p2 == "Enabled" or p2 == "Disabled")
		callback2(p2 == "Enabled")
	end
end

local function buildChatSummariesConfig()
	return {
		setupListener = function(_, _)
			return function() end
		end,
		buildFeatureValueHandler = function(callback, callback2)
			return function(p: string, p2: string)
				if p == "AllowThirdPartySummary" then
					applyChatSummariesFeatureValue("AllowThirdPartySummary", p2, callback, callback2) -- inferred equivalent call
				end
			end
		end,
		onSetEnabled = function(flag: boolean, callback)
			callback(flag)
		end,
		requiresChatEnabled = false
	}
end

local getAIRephraseSettingStore

if FFlagAIRephraseSettingEnabled then
	getAIRephraseSettingStore = Signals.createComputed(function()
		return createUserChatSettingStore(buildAIRephraseConfig())
	end)
else
	getAIRephraseSettingStore = nil
end

local getChatSummariesSettingStore

if FFlagChatSummariesSettingEnabled then
	getChatSummariesSettingStore = Signals.createComputed(function()
		return createUserChatSettingStore(buildChatSummariesConfig())
	end)
else
	getChatSummariesSettingStore = nil
end

return {
	getAIRephraseSettingStore = getAIRephraseSettingStore,
	getChatSummariesSettingStore = getChatSummariesSettingStore,
	updateExpChatFeatureValue = function(p: string, p2: string)
		if getAIRephraseSettingStore then
			getAIRephraseSettingStore(false).setIsSettingVisible(p, p2)
		end

		if getChatSummariesSettingStore then
			getChatSummariesSettingStore(false).setIsSettingVisible(p, p2)
		end
	end
}
