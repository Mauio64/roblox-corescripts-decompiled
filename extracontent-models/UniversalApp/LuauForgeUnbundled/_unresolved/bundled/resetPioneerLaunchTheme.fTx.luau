local CorePackages = game:GetService("CorePackages")
local MemStorageService = game:GetService("MemStorageService")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/fBn")
local module2 = require("@luauforge/bundled/fDH")
local module3 = require("@luauforge/bundled/fBr")
local module4 = require("@luauforge/bundled/fyV")

local function applyStoredTheme()
	local authenticatedTheme = module.getAuthenticatedTheme()

	if authenticatedTheme ~= "" then
		MemStorageService:Fire(module3.ThemeUpdate, authenticatedTheme)
	end

	module4.ClearThemeOverride()
end

local function resetPioneerLaunchTheme(p2, p3)
	if p2 and p3 and p3 > 0 then
		return module2(p2, p3):andThen(function(p4)
			module.setAuthenticatedTheme(p4)
			local authenticatedTheme = module.getAuthenticatedTheme()

			if authenticatedTheme ~= "" then
				MemStorageService:Fire(module3.ThemeUpdate, authenticatedTheme)
			end

			module4.ClearThemeOverride()
		end, function()
			local authenticatedTheme = module.getAuthenticatedTheme()

			if authenticatedTheme ~= "" then
				MemStorageService:Fire(module3.ThemeUpdate, authenticatedTheme)
			end

			module4.ClearThemeOverride()

			return Promise.resolve()
		end)
	end

	local authenticatedTheme = module.getAuthenticatedTheme()

	if authenticatedTheme ~= "" then
		MemStorageService:Fire(module3.ThemeUpdate, authenticatedTheme)
	end

	module4.ClearThemeOverride()

	return Promise.resolve()
end

return resetPioneerLaunchTheme
