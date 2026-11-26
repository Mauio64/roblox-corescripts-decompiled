local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local function useShareSheetSelection()
	local state, setState = React.useState({})
	return {
		onConversationActivated = React.useCallback(function(p2)
			setState(function(p3)
				local clone = table.clone(p3)

				if clone[p2] then
					clone[p2] = nil
					return clone
				end

				clone[p2] = true

				return clone
			end)
		end, {}),
		onSendActivated = React.useCallback(function()
			setState({})
		end, {}),
		selectedConversationIds = state
	}
end

return useShareSheetSelection
