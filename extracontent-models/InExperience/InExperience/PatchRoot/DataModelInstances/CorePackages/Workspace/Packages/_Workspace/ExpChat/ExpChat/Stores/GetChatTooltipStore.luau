local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local ExpChatShared = require(Parent.ExpChatShared)
local createChatTooltipStore = require(script.createChatTooltipStore)
local promptsApi = require(script.promptsApi)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore

return Signals.createComputed(function() -- line: 15
	-- upvalues: createChatTooltipStore (copy), FFlagExpChatUseUnifiedTooltipStore (copy), promptsApi (copy), FFlagExpChatPresetChatEnabled (copy)
	local v8 = createChatTooltipStore()

	if FFlagExpChatUseUnifiedTooltipStore then
		promptsApi.fetchAllTooltipEligibility(function(p1) -- line: 19
			-- upvalues: v8 (copy), FFlagExpChatPresetChatEnabled (copy)
			local customPrompts = p1.customPrompts

			v8.setIsEligible("GlobalChatTooltip", customPrompts.GlobalChatTooltip ~= nil)

			if FFlagExpChatPresetChatEnabled then
				v8.setIsEligible("PresetChatTooltip", customPrompts.PresetChatTooltip ~= nil)
			end
		end)
	end

	return v8
end)
