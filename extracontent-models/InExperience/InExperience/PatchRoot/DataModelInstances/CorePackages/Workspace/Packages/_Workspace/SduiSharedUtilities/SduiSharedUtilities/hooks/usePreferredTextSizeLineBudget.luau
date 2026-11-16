local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local TextSize = require(parent.TextSize)
local getPreferredTextSizeLineBudget = require(SduiSharedUtilities.getPreferredTextSizeLineBudget)

local function usePreferredTextSizeLineBudget(p: number?)
	local v = React.useCallback(function(p2)
		return getPreferredTextSizeLineBudget(TextSize.getTextSizeStore(p2).getTextSizeOffset(p2), p)
	end, { p })

	return SignalsReact.useSignalState(v)
end

return usePreferredTextSizeLineBudget
