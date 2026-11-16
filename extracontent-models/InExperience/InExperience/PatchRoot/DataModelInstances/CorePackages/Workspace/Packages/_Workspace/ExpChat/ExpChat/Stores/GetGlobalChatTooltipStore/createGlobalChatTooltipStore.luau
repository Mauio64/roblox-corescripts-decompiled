local parent = script:FindFirstAncestor("ExpChat").Parent
local Display = require(parent.Display)
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, setShouldShowGlobalChatTooltip = createSignal(false)
	local signal2, setIsChatWindowOpen = createSignal(false)
	local signal3, setIsGlobalChatTooltipDismissed = createSignal(false)
	local signal4, setIsGlobalChatTooltipEligible = createSignal(false)

	return {
		getShouldShowGlobalChatTooltip = signal,
		setShouldShowGlobalChatTooltip = setShouldShowGlobalChatTooltip,
		getIsChatWindowOpen = signal2,
		setIsChatWindowOpen = setIsChatWindowOpen,
		getIsGlobalChatTooltipDismissed = signal3,
		setIsGlobalChatTooltipDismissed = setIsGlobalChatTooltipDismissed,
		getIsGlobalChatTooltipEligible = signal4,
		setIsGlobalChatTooltipEligible = setIsGlobalChatTooltipEligible,
		getIsScreenWideEnough = Signals.createComputed(function(p): boolean
			return Display.GetDisplayStore(p).getViewportSize(p).X >= 720
		end),
		reportImpression = function() end
	}
end
