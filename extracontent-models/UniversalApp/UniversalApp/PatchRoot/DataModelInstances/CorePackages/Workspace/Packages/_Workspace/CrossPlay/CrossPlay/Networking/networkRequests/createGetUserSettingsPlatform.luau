local Parent = script:FindFirstAncestor("CrossPlay").Parent
local Url = require(Parent.Http).Url
local FStringDebugOverrideCrossPlayApiUrl = require(script.Parent.FStringDebugOverrideCrossPlayApiUrl)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: FStringDebugOverrideCrossPlayApiUrl (copy), Url (copy)
	return t1.roduxNetworking.GET(script.Name, function(p1, s1: string, s2: string, b1: boolean?) -- line: 19
		-- upvalues: FStringDebugOverrideCrossPlayApiUrl (copy), Url (copy)
		local v9 = p1((if FStringDebugOverrideCrossPlayApiUrl == "" then Url.APIS_URL else FStringDebugOverrideCrossPlayApiUrl), {
			crossPlaySettingsKey = s2
		}):path("user-settings-api"):path("v1"):path("user-settings")

		if not b1 then
			v9 = v9:path("platform")
		end

		return v9:queryArgs({
			[not b1 and "requestedPlatformSettings" or "requestedUserSettings"] = s1
		})
	end)
end
