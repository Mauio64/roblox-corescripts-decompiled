local parent = script.Parent.Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)

local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled
local FFlagEnableClientSummarySystemMessageOnLua = SharedFlags.FFlagEnableClientSummarySystemMessageOnLua

local FFlagExpChatTextChannelWindowWelcomeAndSummary = require(script.Parent.Flags.FFlagExpChatTextChannelWindowWelcomeAndSummary)

local function resolveEligible(p: string, p2: string, fFlagChatSummariesSettingEnabled: boolean, fFlagEnableClientSummarySystemMessageOnLua: boolean): nil | boolean -- 1 equivalent call inferred from this helper
	if fFlagChatSummariesSettingEnabled then
		if p == "AllowThirdPartySummary" then
			return p2 == "Enabled"
		end
	elseif fFlagEnableClientSummarySystemMessageOnLua and p == "EligibleForThirdPartySummary" then
		return p2 == "true"
	end

	return nil
end

local function createThirdPartySummaryEligibility(p: string)
	local signal, v = Signals.createSignal(false)

	if FFlagExpChatTextChannelWindowWelcomeAndSummary then
		coroutine.wrap(function()
			local expChatFeatureValueChanged = RobloxReplicatedStorage:WaitForChild("ExpChatFeatureValueChanged", 10)

			if not expChatFeatureValueChanged then
				return
			end

			expChatFeatureValueChanged.OnClientEvent:Connect(function(p2: number, p3: string, p4: string)
				if tostring(p2) ~= p then
					return
				end

				local eligible = resolveEligible( -- inferred equivalent call
					p3,
					p4,
					FFlagChatSummariesSettingEnabled,
					FFlagEnableClientSummarySystemMessageOnLua
				)

				if eligible ~= nil then
					v(eligible)
				end
			end)
		end)()
	end

	return { getIsEligible = signal }
end

return { create = createThirdPartySummaryEligibility, resolveEligible = resolveEligible }
