local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Cryo")
local NetworkingSocialProof = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Networking/NetworkingSocialProof")

return Rodux.createReducer({}, {
	[NetworkingSocialProof.GetConnectionsByEntityId.Succeeded.name] = function(p2, p3)
		local v6 = {}
		local connections = p3.responseBody.connections
		local totalCount = p3.responseBody.totalCount
		local entityId = p3.postBody.entityId
		local entityType = p3.postBody.entityType
		local connectionType = p3.postBody.connectionType

		if not v6[connectionType] then
			v6[connectionType] = {}
		end

		if not v6[connectionType][entityType] then
			v6[connectionType][entityType] = {}
		end

		local v7 = not connections and {} or Cryo.List.map(connections, function(p4)
			return (tostring(p4.id))
		end)

		v6[connectionType][entityType][entityId] = {
			totalConnections = totalCount,
			userIds = v7
		}

		return Cryo.Dictionary.union(p2, v6)
	end
})
