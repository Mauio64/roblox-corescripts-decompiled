local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local Rodux = require(SocialProofParent.Rodux)
local Cryo = require(SocialProofParent.Cryo)
local NetworkingSocialProof = require(SocialProof.Networking.NetworkingSocialProof)

return Rodux.createReducer({}, {
	[NetworkingSocialProof.GetConnectionsByEntityId.Succeeded.name] = function(p1, p2) -- line: 20
		-- upvalues: Cryo (copy)
		local t1 = {}
		local connections = p2.responseBody.connections
		local totalCount = p2.responseBody.totalCount
		local entityId = p2.postBody.entityId
		local entityType = p2.postBody.entityType
		local connectionType = p2.postBody.connectionType

		if not t1[connectionType] then
			t1[connectionType] = {}
		end

		if not t1[connectionType][entityType] then
			t1[connectionType][entityType] = {}
		end

		local t2 = {}

		if connections then
			t2 = Cryo.List.map(connections, function(p3) -- line: 38
				return (tostring(p3.id))
			end)
		end

		t1[connectionType][entityType][entityId] = {
			totalConnections = totalCount,
			userIds = t2
		}

		return Cryo.Dictionary.union(p1, t1)
	end
})
