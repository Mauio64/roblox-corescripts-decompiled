local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local SharedFlags = require(Parent.SharedFlags)
local ExpChatShared = require(Parent.ExpChatShared)
local createChatTooltipStore = require(script.createChatTooltipStore)
local promptsApi = require(script.promptsApi)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local FFlagExpChatShowGlobalChatTooltip = SharedFlags.FFlagExpChatShowGlobalChatTooltip

return Signals.createComputed(function() -- line: 17
	-- upvalues: createChatTooltipStore (copy), FFlagExpChatUseUnifiedTooltipStore (copy), promptsApi (copy), FFlagExpChatShowGlobalChatTooltip (copy), FFlagExpChatPresetChatEnabled (copy)
	local v10 = createChatTooltipStore()

	if FFlagExpChatUseUnifiedTooltipStore then
		promptsApi.fetchAllTooltipEligibility(function(p1) -- line: 21
			-- upvalues: FFlagExpChatShowGlobalChatTooltip (copy), v10 (copy), FFlagExpChatPresetChatEnabled (copy)
			local customPrompts = p1.customPrompts

			if FFlagExpChatShowGlobalChatTooltip then
				v10.setIsEligible("GlobalChatTooltip", customPrompts.GlobalChatTooltip ~= nil)
			end

			if FFlagExpChatPresetChatEnabled then
				v10.setIsEligible("PresetChatTooltip", customPrompts.PresetChatTooltip ~= nil)
			end
		end)
	end

	return v10
end)
