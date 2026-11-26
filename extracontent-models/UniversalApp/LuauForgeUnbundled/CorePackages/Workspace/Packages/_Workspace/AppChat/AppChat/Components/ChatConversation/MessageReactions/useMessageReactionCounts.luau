local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local GetMessageReactionsViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsViewModelStore")

local function useMessageReactionCounts(p2)
	local v5 = React.useMemo(function()
		return GetMessageReactionsViewModelStore(false).getReactionCounts(p2)
	end, { p2 })
	SignalsReact.useSignalState(v5)

	return v5(false)
end

return useMessageReactionCounts
