local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/Cryo")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SignalsReact")
local fFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SharedFlags").FFlagConnectionManagementChips
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/GraphQLServer")
local v5

if fFlagConnectionManagementChips then
	v5 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
else
	v5 = nil
end

local function useDecoratedTrustedConnections(options)
	if not fFlagConnectionManagementChips then
		return
	end

	local userTrustedConnections = v5.getUserTrustedConnections()
	local v6 = SignalsReact.useSignalState(userTrustedConnections.data)

	local v7 = React.useMemo(function()
		if not options then
			return {}
		end

		local idSet = {}

		for k, option in options do
			idSet[option.id] = true
		end

		return idSet
	end, { options })

	local v8 = React.useMemo(function()
		if not v6 then
			return {}
		end

		local idSet = {}

		for k, v9 in v6 do
			idSet[v9.id] = true
		end

		return idSet
	end, { v6 })

	return (React.useMemo(function()
		if not v6 then
			return {}
		end

		local filtered = Cryo.List.filter(options or {}, function(p2): boolean
			return v8[p2.id] == true
		end)

		local filtered2 = Cryo.List.filter(v6, function(p2): boolean
			return v7[p2.id] ~= true
		end)

		return Cryo.List.join(filtered, filtered2)
	end, { v8, v6, v7 }))
end

return useDecoratedTrustedConnections
