local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local SignalsReact = require(Parent.SignalsReact)
local FFlagConnectionManagementChips = require(Parent.SharedFlags).FFlagConnectionManagementChips
local DataHydration = require(Parent.DataHydration)

require(Parent.GraphQLServer)

local v7 = if not FFlagConnectionManagementChips then nil else DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function useDecoratedTrustedConnections(t1: {[any]: any}?) -- line: 17
	-- upvalues: FFlagConnectionManagementChips (copy), v7 (copy), SignalsReact (copy), React (copy), Cryo (copy)
	if not FFlagConnectionManagementChips then
		return
	end

	local v10 = v7.getUserTrustedConnections()
	local v11 = SignalsReact.useSignalState(v10.data)
	local v12 = React.useMemo(function() -- line: 25
		-- upvalues: t1 (copy)
		if not t1 then
			return {}
		end

		local t2 = {}

		for _, v16 in t1 do
			t2[v16.id] = true
		end

		return t2
	end, { t1 })
	local v13 = React.useMemo(function() -- line: 37
		-- upvalues: v11 (copy)
		if not v11 then
			return {}
		end

		local t3 = {}

		for _, v19 in v11 do
			t3[v19.id] = true
		end

		return t3
	end, { v11 })

	return (React.useMemo(function() -- line: 49
		-- upvalues: v11 (copy), Cryo (copy), t1 (copy), v13 (copy), v12 (copy)
		if not v11 then
			return {}
		end

		local v20 = Cryo.List.filter(t1 or {}, function(p1) -- line: 54
			-- upvalues: v13 (copy)
			return v13[p1.id] == true
		end)
		local v21 = Cryo.List.filter(v11, function(p2) -- line: 58
			-- upvalues: v12 (copy)
			return v12[p2.id] ~= true
		end)

		return Cryo.List.join(v20, v21)
	end, {
		v13,
		v11,
		v12
	}))
end

return useDecoratedTrustedConnections
