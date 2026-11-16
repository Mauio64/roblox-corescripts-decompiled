local parent = script:FindFirstAncestor("FriendsCommon").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local FFlagConnectionManagementChips = SharedFlags.FFlagConnectionManagementChips
local DataHydration = require(parent.DataHydration)
require(parent.GraphQLServer)
local v

if FFlagConnectionManagementChips then
	v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
else
	v = nil
end

local function useDecoratedTrustedConnections(options)
	if not FFlagConnectionManagementChips then
		return
	end

	local userTrustedConnections = v.getUserTrustedConnections()
	local v2 = SignalsReact.useSignalState(userTrustedConnections.data)

	local v3 = React.useMemo(function()
		if not options then
			return {}
		end

		local idSet = {}

		for _, option in options do
			idSet[option.id] = true
		end

		return idSet
	end, { options })

	local v4 = React.useMemo(function()
		if not v2 then
			return {}
		end

		local idSet = {}

		for _, v4 in v2 do
			idSet[v4.id] = true
		end

		return idSet
	end, { v2 })

	return (React.useMemo(function()
		if not v2 then
			return {}
		end

		local filtered = Cryo.List.filter(options or {}, function(p): boolean
			return v4[p.id] == true
		end)

		local filtered2 = Cryo.List.filter(v2, function(p): boolean
			return v3[p.id] ~= true
		end)

		return Cryo.List.join(filtered, filtered2)
	end, { v4, v2, v3 }))
end

return useDecoratedTrustedConnections
