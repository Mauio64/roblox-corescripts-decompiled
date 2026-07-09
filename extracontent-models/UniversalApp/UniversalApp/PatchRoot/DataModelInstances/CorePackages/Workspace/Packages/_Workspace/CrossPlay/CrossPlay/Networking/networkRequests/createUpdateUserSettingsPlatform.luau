local Parent = script:FindFirstAncestor("CrossPlay").Parent
local Url = require(Parent.Http).Url
local FStringDebugOverrideCrossPlayApiUrl = require(script.Parent.FStringDebugOverrideCrossPlayApiUrl)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: FStringDebugOverrideCrossPlayApiUrl (copy), Url (copy)
	return t1.roduxNetworking.POST(script.Name, function(p1, s1: string, s2: string, b1: boolean, b2: boolean?) -- line: 19
		-- upvalues: FStringDebugOverrideCrossPlayApiUrl (copy), Url (copy)
		local v10 = p1((if FStringDebugOverrideCrossPlayApiUrl == "" then Url.APIS_URL else FStringDebugOverrideCrossPlayApiUrl), {
			crossPlaySettingsKey = s2,
			crossPlayValue = b1
		}):path("user-settings-api"):path("v1"):path("user-settings")

		if not b2 then
			v10 = v10:path("platform")
		end

		return v10:body({
			[s1] = b1
		})
	end)
end
