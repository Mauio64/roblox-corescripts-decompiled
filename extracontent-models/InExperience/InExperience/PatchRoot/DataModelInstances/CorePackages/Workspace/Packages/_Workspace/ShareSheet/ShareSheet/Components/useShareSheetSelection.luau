local parent = script:FindFirstAncestor("ShareSheet").Parent

local React = require(parent.React)

local function useShareSheetSelection()
	local state, setState = React.useState({})
	return {
		onConversationActivated = React.useCallback(function(p: string)
			setState(function(p2)
				local clone = table.clone(p2)

				if clone[p] then
					clone[p] = nil
					return clone
				end

				clone[p] = true

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
