local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = CoreGui.RobloxGui.Modules

require(CorePackages.Workspace.Packages.Http)

local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 51
	-- upvalues: Url (copy), LocalizationService (copy)
	return p1(string.format("%sv1/locales/user-localization-locus-supported-locales", Url.LOCALE), "GET", {
		headers = {
			["Accept-Language"] = LocalizationService.SystemLocaleId
		}
	})
end
