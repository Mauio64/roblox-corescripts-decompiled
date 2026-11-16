local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local GetConversationListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationListStore")

local v5 = { oldestConversationIsFetched = false, isFetchingConversations = false }

local function useConversationList(p2)
	local v6 = GetConversationListStore(false)
	local v7 = p2 ~= false
	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if v7 then
				return v6.getConversations(p3)
			end

			return {}
		end)
	end, { v6, v7 })

	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if v7 then
				return v6.getListStatus(p3)
			end

			return v5
		end)
	end, { v6, v7 })

	return {
		items = SignalsReact.useSignalState(v8),
		listStatus = SignalsReact.useSignalState(v9)
	}
end

return useConversationList
