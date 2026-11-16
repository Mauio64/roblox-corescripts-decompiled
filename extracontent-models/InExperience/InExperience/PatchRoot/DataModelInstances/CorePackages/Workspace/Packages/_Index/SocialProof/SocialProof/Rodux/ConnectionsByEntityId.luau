local SocialProof = script:FindFirstAncestor("SocialProof")
local parent = SocialProof.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
local NetworkingSocialProof = require(SocialProof.Networking.NetworkingSocialProof)

return Rodux.createReducer({}, {
	[NetworkingSocialProof.GetConnectionsByEntityId.Succeeded.name] = function(p, p2)
		local v = {}
		local connections = p2.responseBody.connections
		local totalCount = p2.responseBody.totalCount
		local entityId = p2.postBody.entityId
		local entityType = p2.postBody.entityType
		local connectionType = p2.postBody.connectionType

		if not v[connectionType] then
			v[connectionType] = {}
		end

		if not v[connectionType][entityType] then
			v[connectionType][entityType] = {}
		end

		local userIds = not connections and {} or Cryo.List.map(connections, function(p3)
			return (tostring(p3.id))
		end)

		v[connectionType][entityType][entityId] = {
			totalConnections = totalCount,
			userIds = userIds
		}

		return Cryo.Dictionary.union(p, v)
	end
})
