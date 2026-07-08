local Parent = script:FindFirstAncestor("ExpChat").Parent
local Display = require(Parent.Display)
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal

return function() -- line: 28
	-- upvalues: createSignal (copy), Signals (copy), Display (copy)
	local v5, v6 = createSignal(false)
	local v7, v8 = createSignal(false)
	local v9, v10 = createSignal(false)
	local v11, v12 = createSignal(false)
	local v13 = Signals.createComputed(function(p1) -- line: 34
		-- upvalues: Display (copy)
		return Display.GetDisplayStore(p1).getViewportSize(p1).X >= 720
	end)

	return {
		getShouldShowGlobalChatTooltip = v5,
		setShouldShowGlobalChatTooltip = v6,
		getIsChatWindowOpen = v7,
		setIsChatWindowOpen = v8,
		getIsGlobalChatTooltipDismissed = v9,
		setIsGlobalChatTooltipDismissed = v10,
		getIsGlobalChatTooltipEligible = v11,
		setIsGlobalChatTooltipEligible = v12,
		getIsScreenWideEnough = v13,
		reportImpression = function() -- line: 49
		end
	}
end
