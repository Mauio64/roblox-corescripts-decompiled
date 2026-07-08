local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local SharedFlags = require(Parent.SharedFlags)
local createUserChatSettingStore = require(script.createUserChatSettingStore)
local FFlagAIRephraseSettingEnabled = SharedFlags.FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled

local function applyAIRephraseFeatureValue(s1: string, s2: string, p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 15
	if s1 == "AIRephraseSettingStatus" then
		p1(s2 == "Enabled" or s2 == "Disabled")
		p2(s2 == "Enabled")
	end
end
local function buildAIRephraseConfig() -- line: 27
	return {
		requiresChatEnabled = true,
		setupListener = function(_: ((...any) -> ...any), _: ((...any) -> ...any)) -- line: 29
			return function() -- line: 30
			end
		end,
		buildFeatureValueHandler = function(p5, p6) -- line: 32
			return function(s3: string, s4: string) -- line: 33
				-- upvalues: p5 (copy), p6 (copy)
				local v37 = p5
				local v38 = p6

				if s3 == "AIRephraseSettingStatus" then
					v37(s4 == "Enabled" or s4 == "Disabled")
					v38(s4 == "Enabled")
				end
			end
		end,
		onSetEnabled = function(b1: boolean, p7: ((...any) -> ...any)) -- line: 37
			p7(b1)
		end
	}
end
local function applyChatSummariesFeatureValue(s5: string, s6: string, p8: ((...any) -> ...any), p9: ((...any) -> ...any)) -- line: 44
	if s5 == "AllowThirdPartySummary" then
		p8(s6 == "Enabled" or s6 == "Disabled")
		p9(s6 == "Enabled")
	end
end
local function buildChatSummariesConfig() -- line: 56
	return {
		requiresChatEnabled = false,
		setupListener = function(_: ((...any) -> ...any), _: ((...any) -> ...any)) -- line: 58
			return function() -- line: 59
			end
		end,
		buildFeatureValueHandler = function(p12, p13) -- line: 61
			return function(s7: string, s8: string) -- line: 62
				-- upvalues: p12 (copy), p13 (copy)
				local v41 = p12
				local v42 = p13

				if s7 == "AllowThirdPartySummary" then
					v41(s8 == "Enabled" or s8 == "Disabled")
					v42(s8 == "Enabled")
				end
			end
		end,
		onSetEnabled = function(b2: boolean, p14: ((...any) -> ...any)) -- line: 66
			p14(b2)
		end
	}
end

local v11 = if not FFlagAIRephraseSettingEnabled then nil else Signals.createComputed(function() -- line: 74
	-- upvalues: createUserChatSettingStore (copy), buildAIRephraseConfig (copy)
	return createUserChatSettingStore((buildAIRephraseConfig()))
end)
local v12 = if not FFlagChatSummariesSettingEnabled then nil else Signals.createComputed(function() -- line: 80
	-- upvalues: createUserChatSettingStore (copy), buildChatSummariesConfig (copy)
	return createUserChatSettingStore((buildChatSummariesConfig()))
end)

return {
	getAIRephraseSettingStore = v11,
	getChatSummariesSettingStore = v12,
	updateExpChatFeatureValue = function(s9: string, s10: string) -- line: 88
		-- upvalues: v11 (copy), v12 (copy)
		if v11 then
			v11(false).setIsSettingVisible(s9, s10)
		end

		if v12 then
			v12(false).setIsSettingVisible(s9, s10)
		end
	end
}
