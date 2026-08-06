local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createGlobalChatTooltipStore = require(script.createGlobalChatTooltipStore)
local fetchGlobalChatTooltipEligibility = require(script.fetchGlobalChatTooltipEligibility)

return Signals.createComputed(function() -- line: 7
	-- upvalues: createGlobalChatTooltipStore (copy), fetchGlobalChatTooltipEligibility (copy)
	local v5 = createGlobalChatTooltipStore()

	v5.reportImpression = fetchGlobalChatTooltipEligibility.reportImpression
	fetchGlobalChatTooltipEligibility.fetchEligibility(function(p1) -- line: 11
		-- upvalues: v5 (copy)
		v5.setIsGlobalChatTooltipEligible(p1.shouldShowTooltip)
	end)

	return v5
end)
