local SetNextDataExpirationTime = require("@game/CorePackages/Workspace/Packages/_Index/NextDataExpirationTimeRodux/NextDataExpirationTimeRodux/SetNextDataExpirationTime")
local ExpirationTimeNamespace = require("@game/CorePackages/Workspace/Packages/_Index/NextDataExpirationTimeRodux/NextDataExpirationTimeRodux/ExpirationTimeNamespace")

require("@game/CorePackages/Workspace/Packages/_Workspace/NextDataExpirationTimeRodux/DiscoveryTypes")

local function initializeExpirationTimes()
	local result = {}

	for k, v5 in ExpirationTimeNamespace do
		result[v5] = {}
	end

	return result
end

return {
	key = "NextDataExpirationTimeKey",
	reducer = function(p2, data)
		local v5 = p2 or initializeExpirationTimes()

		if data.type ~= SetNextDataExpirationTime.name then
			return v5
		end

		assert(v5, "state should always exist, assert for linter")
		local namespace = data.namespace
		local key = data.key
		assert(namespace, "SetNextDataExpirationTime does not have a valid namespace")
		assert(key, `SetNextDataExpirationTime does not have a valid key for namespace {namespace}`)

		local v6 = v5[namespace]

		if not v6 then
			warn(`No namespace {namespace} defined in NextDataExpirationTimeReducer for action`)
			return v5
		end

		assert(v6, "namespaceState should always exist, assert for linter")

		local clone = table.clone(v6)
		clone[key] = data.nextDataExpirationTime

		local clone2 = table.clone(v5)
		clone2[namespace] = clone
		return clone2
	end
}
