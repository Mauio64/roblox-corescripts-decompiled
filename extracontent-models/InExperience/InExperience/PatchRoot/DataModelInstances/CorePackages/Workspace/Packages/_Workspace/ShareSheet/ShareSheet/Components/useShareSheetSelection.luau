local Parent = script:FindFirstAncestor("ShareSheet").Parent
local React = require(Parent.React)

local function useShareSheetSelection() -- line: 14
	-- upvalues: React (copy)
	local v4, v5 = React.useState({})
	local v6 = React.useCallback(function(s1: string) -- line: 16
		-- upvalues: v5 (copy)
		v5(function(t1: {[any]: any}) -- line: 18
			-- upvalues: s1 (copy)
			local v10 = table.clone(t1)

			if v10[s1] then
				v10[s1] = nil

				return v10
			end

			v10[s1] = true

			return v10
		end)
	end, {})
	local v7 = React.useCallback(function() -- line: 29
		-- upvalues: v5 (copy)
		v5({})
	end, {})

	return {
		onConversationActivated = v6,
		onSendActivated = v7,
		selectedConversationIds = v4
	}
end

return useShareSheetSelection
