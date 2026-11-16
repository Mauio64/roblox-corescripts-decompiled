local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)
local t = require(parent.t)

require(script.Parent.GamePermissionsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local interface = t.interface({ permissions = t.map(t.string, t.boolean) })

local function decodeUniversePermissions(p)
	local v, v2 = interface(p)
	assert(v, `Invalid universe permissions response: {tostring(v2)}`)
	local permissions = p.permissions
	return {
		canEdit = permissions.canEdit == true,
		canEditOnBuild = permissions.canEditOnBuild == true,
		canPublish = permissions.canPublish == true,
		canMonetize = permissions.canMonetize == true,
		canViewAnalytics = permissions.canViewAnalytics == true,
		canPreview = permissions.canPreview == true,
		canAdvertise = permissions.canAdvertise == true,
		canViewOnCreatorHub = permissions.canViewOnCreatorHub == true
	}
end

return {
	fetchUniversePermissions = function(p: number, options)
		local v = options or {}
		local baseUrl = v.baseUrl or Http.Url.GROUPS_URL
		return asPromise((fetch({
			network = v.network,
			method = "GET",
			url = `{baseUrl}v2/universes/{p}/permissions/resolved`,
			analyticsKey = "groups.universe-permissions",
			decode = decodeUniversePermissions
		})))
	end
}
