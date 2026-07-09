local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local SharedFlags = require(Parent.SharedFlags)
local createGlobalChatTooltipStore = require(script.createGlobalChatTooltipStore)
local fetchGlobalChatTooltipEligibility = require(script.fetchGlobalChatTooltipEligibility)
local FFlagExpChatShowGlobalChatTooltip = SharedFlags.FFlagExpChatShowGlobalChatTooltip

return Signals.createComputed(function() -- line: 9
	-- upvalues: createGlobalChatTooltipStore (copy), FFlagExpChatShowGlobalChatTooltip (copy), fetchGlobalChatTooltipEligibility (copy)
	local v7 = createGlobalChatTooltipStore()

	if FFlagExpChatShowGlobalChatTooltip then
		v7.reportImpression = fetchGlobalChatTooltipEligibility.reportImpression
		fetchGlobalChatTooltipEligibility.fetchEligibility(function(p1) -- line: 15
			-- upvalues: v7 (copy)
			v7.setIsGlobalChatTooltipEligible(p1.shouldShowTooltip)
		end)
	end

	return v7
end)
