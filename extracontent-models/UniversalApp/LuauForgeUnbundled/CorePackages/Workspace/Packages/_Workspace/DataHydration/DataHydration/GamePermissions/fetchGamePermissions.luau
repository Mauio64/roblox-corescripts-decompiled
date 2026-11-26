local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePermissions/GamePermissionsStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local interface = t.interface({
	permissions = t.map(t.string, t.boolean)
})

local function decodeUniversePermissions(p2)
	local v5, v6 = interface(p2)
	assert(v5, `Invalid universe permissions response: {tostring(v6)}`)
	local permissions = p2.permissions
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
	fetchUniversePermissions = function(p2, options)
		local v5 = options or {}
		local baseUrl = v5.baseUrl or Http.Url.GROUPS_URL
		return asPromise((fetch({
			network = v5.network,
			method = "GET",
			url = `{baseUrl}v2/universes/{p2}/permissions/resolved`,
			analyticsKey = "groups.universe-permissions",
			decode = decodeUniversePermissions
		})))
	end
}
