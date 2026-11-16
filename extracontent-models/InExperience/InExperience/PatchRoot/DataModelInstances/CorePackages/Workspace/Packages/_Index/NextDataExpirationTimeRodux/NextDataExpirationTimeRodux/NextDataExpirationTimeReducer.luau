local NextDataExpirationTimeRodux = script:FindFirstAncestor("NextDataExpirationTimeRodux")
local SetNextDataExpirationTime = require(NextDataExpirationTimeRodux.SetNextDataExpirationTime)
local ExpirationTimeNamespace = require(NextDataExpirationTimeRodux.ExpirationTimeNamespace)

local parent = NextDataExpirationTimeRodux.Parent
require(parent.DiscoveryTypes)

local function initializeExpirationTimes()
	local result = {}

	for _, v in ExpirationTimeNamespace do
		result[v] = {}
	end

	return result
end

return {
	key = "NextDataExpirationTimeKey",
	reducer = function(p, data)
		local selected = p or initializeExpirationTimes()

		if data.type ~= SetNextDataExpirationTime.name then
			return selected
		end

		assert(selected, "state should always exist, assert for linter")
		local namespace = data.namespace
		local key = data.key
		assert(namespace, "SetNextDataExpirationTime does not have a valid namespace")
		assert(key, `SetNextDataExpirationTime does not have a valid key for namespace {namespace}`)

		local v = selected[namespace]

		if not v then
			warn(`No namespace {namespace} defined in NextDataExpirationTimeReducer for action`)
			return selected
		end

		assert(v, "namespaceState should always exist, assert for linter")

		local clone = table.clone(v)
		clone[key] = data.nextDataExpirationTime

		local clone2 = table.clone(selected)
		clone2[namespace] = clone
		return clone2
	end
}
