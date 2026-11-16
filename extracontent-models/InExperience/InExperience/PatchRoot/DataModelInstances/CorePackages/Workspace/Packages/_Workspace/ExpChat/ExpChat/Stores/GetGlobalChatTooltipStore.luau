local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createGlobalChatTooltipStore = require(script.createGlobalChatTooltipStore)
local fetchGlobalChatTooltipEligibility = require(script.fetchGlobalChatTooltipEligibility)

return Signals.createComputed(function()
	local globalChatTooltipStore = createGlobalChatTooltipStore()
	globalChatTooltipStore.reportImpression = fetchGlobalChatTooltipEligibility.reportImpression

	fetchGlobalChatTooltipEligibility.fetchEligibility(function(p)
		globalChatTooltipStore.setIsGlobalChatTooltipEligible(p.shouldShowTooltip)
	end)

	return globalChatTooltipStore
end)
