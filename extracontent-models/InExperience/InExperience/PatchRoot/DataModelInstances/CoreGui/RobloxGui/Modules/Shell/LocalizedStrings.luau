local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Locales = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell").Locales
local lib = require(Locales:FindFirstChild("en-us"))
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local FFlagAppShellMigrateLocales = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppShellMigrateLocales
local lib2 = nil
local u8 = nil
local ok, result = pcall(function() -- line: 18
	return game:GetService("LocalizationService").RobloxLocaleId
end)
local u11 = ok
local u12 = result
local t1 = {
	GetLocale = function(_) -- line: 22
		-- upvalues: FFlagAppShellMigrateLocales (copy), Locales (copy), u12 (ref), u11 (ref), lib2 (ref), lib (copy)
		if FFlagAppShellMigrateLocales then
			error("Attempt to use GetLocale with FFlagAppShellMigrateLocales enabled")
		end

		local v15 = Locales:FindFirstChild(u12)

		if u11 and v15 then
			lib2 = require(v15)
		end

		if lib2 == nil then
			lib2 = lib
		end

		return lib2
	end,
	LocString = function(p2, p3) -- line: 40
		-- upvalues: FFlagAppShellMigrateLocales (copy), lib2 (ref), lib (copy)
		if FFlagAppShellMigrateLocales then
			error("Attempt to use LocString with FFlagAppShellMigrateLocales enabled")
		end

		local v18 = lib2 and lib2 or p2:GetLocale()

		return v18 and v18[p3] or (lib[p3] or p3)
	end
}

function t1.LocalizedString(_, p5) -- line: 57
	-- upvalues: FFlagAppShellMigrateLocales (copy), t1 (copy)
	if FFlagAppShellMigrateLocales then
		error("Attempt to use LocalizedString with FFlagAppShellMigrateLocales enabled")
	end

	local v21 = "Xbox.Old." .. p5

	return t1:LocString(v21)
end
function t1.LocStringUA(_, p7) -- line: 68
	-- upvalues: u11 (ref), u8 (ref), Localization (copy), u12 (ref)
	if u11 and not u8 then
		u8 = Localization.new(u12)
	else
		u8 = Localization.new("en-us")
	end

	return u8.localizationContext:getString(u12, p7) or p7
end

return t1
