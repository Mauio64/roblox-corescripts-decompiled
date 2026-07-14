local CorePackages = game:GetService("CorePackages")
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local u3 = nil
local ok, result = pcall(function() -- line: 7
	return game:GetService("LocalizationService").RobloxLocaleId
end)
local u6 = ok
local u7 = result

return {
	LocStringUA = function(_, p2) -- line: 11
		-- upvalues: u6 (ref), u3 (ref), Localization (copy), u7 (ref)
		if u6 and not u3 then
			u3 = Localization.new(u7)
		else
			u3 = Localization.new("en-us")
		end

		return u3.localizationContext:getString(u7, p2) or p2
	end
}
