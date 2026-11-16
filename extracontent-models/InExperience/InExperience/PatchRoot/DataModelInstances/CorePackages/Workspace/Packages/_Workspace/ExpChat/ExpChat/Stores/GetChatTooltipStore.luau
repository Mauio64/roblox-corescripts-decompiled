local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local ExpChatShared = require(parent.ExpChatShared)

local createChatTooltipStore = require(script.createChatTooltipStore)
local promptsApi = require(script.promptsApi)

local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore

return Signals.createComputed(function()
	local chatTooltipStore = createChatTooltipStore()

	if FFlagExpChatUseUnifiedTooltipStore then
		promptsApi.fetchAllTooltipEligibility(function(p)
			local customPrompts = p.customPrompts
			chatTooltipStore.setIsEligible("GlobalChatTooltip", customPrompts.GlobalChatTooltip ~= nil)

			if FFlagExpChatPresetChatEnabled then
				chatTooltipStore.setIsEligible("PresetChatTooltip", customPrompts.PresetChatTooltip ~= nil)
			end
		end)
	end

	return chatTooltipStore
end)
