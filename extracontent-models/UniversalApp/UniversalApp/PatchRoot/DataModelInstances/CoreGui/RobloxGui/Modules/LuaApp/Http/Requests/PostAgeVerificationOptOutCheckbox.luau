local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return function(p1, p2) -- line: 12
	-- upvalues: ArgCheck (copy), Url (copy), HttpService (copy)
	ArgCheck.isType(p2, "boolean", "PostAgeVerificationOptOutCheckbox request expects showOverlay to be a boolean")

	return p1(string.format("%s/v1/settings/verify/show-overlay", Url.VOICE_URL), "POST", {
		postBody = HttpService:JSONEncode({
			showOverlay = p2
		})
	})
end
