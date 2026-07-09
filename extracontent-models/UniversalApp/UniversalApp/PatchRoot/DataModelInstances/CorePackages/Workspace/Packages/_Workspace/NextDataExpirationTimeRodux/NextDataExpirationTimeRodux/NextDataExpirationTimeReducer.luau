local NextDataExpirationTimeRodux = script:FindFirstAncestor("NextDataExpirationTimeRodux")
local SetNextDataExpirationTime = require(NextDataExpirationTimeRodux.SetNextDataExpirationTime)
local ExpirationTimeNamespace = require(NextDataExpirationTimeRodux.ExpirationTimeNamespace)
local NextDataExpirationTimeRoduxParent = NextDataExpirationTimeRodux.Parent

require(NextDataExpirationTimeRoduxParent.DiscoveryTypes)

local function initializeExpirationTimes() -- line: 8
	-- upvalues: ExpirationTimeNamespace (copy)
	local t1 = {}

	for _, v8 in ExpirationTimeNamespace do
		t1[v8] = {}
	end

	return t1
end

return {
	key = "NextDataExpirationTimeKey",
	reducer = function(p1, p2) -- line: 17
		-- upvalues: initializeExpirationTimes (copy), SetNextDataExpirationTime (copy)
		local v11 = p1 or initializeExpirationTimes()

		if p2.type == SetNextDataExpirationTime.name then
			assert(v11, "state should always exist, assert for linter")

			local namespace = p2.namespace
			local key = p2.key

			assert(namespace, "SetNextDataExpirationTime does not have a valid namespace")
			assert(key, `SetNextDataExpirationTime does not have a valid key for namespace { namespace }`)

			local v14 = v11[namespace]

			if not v14 then
				warn(`No namespace { namespace } defined in NextDataExpirationTimeReducer for action`)

				return v11
			end

			assert(v14, "namespaceState should always exist, assert for linter")

			local v15 = table.clone(v14)

			v15[key] = p2.nextDataExpirationTime

			local v16 = table.clone(v11)

			v16[namespace] = v15

			return v16
		end

		return v11
	end
}
