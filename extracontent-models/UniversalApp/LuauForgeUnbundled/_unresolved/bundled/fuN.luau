local splitPaneStore = require("@luauforge/bundled/dFR").SplitPaneStore

local function getSupportPaneWidthFraction(p2)
	return splitPaneStore.getStore().getSupportWidthFraction(p2 or false)
end

return {
	isSupportPaneLayoutActive = function(p2)
		return splitPaneStore.getStore().getIsBreakpointEnabled(p2 or false)
	end,
	getLandscapeNavWidth = function()
		if splitPaneStore.getStore().getIsBreakpointEnabled(false) then
			return 1 - splitPaneStore.getStore().getSupportWidthFraction(false)
		end

		return 0.6
	end,
	getLandscapeSceneWidth = function()
		if splitPaneStore.getStore().getIsBreakpointEnabled(false) then
			return getSupportPaneWidthFraction()
		end

		return 0.4
	end,
	getSupportPaneWidthFraction = getSupportPaneWidthFraction,
	getOverlayLayoutOverSupportPane = function()
		local supportWidthFraction = splitPaneStore.getStore().getSupportWidthFraction(false)

		return UDim2.fromScale(1 - supportWidthFraction, 0), UDim2.fromScale(supportWidthFraction, 1)
	end
}
