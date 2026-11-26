local module = require("@luauforge/bundled/fHk")
require("@luauforge/bundled/fBQ")

local function resolveService(p2)
	return p2 or game:GetService("AppStorageService")
end

return {
	STORAGE_KEY = "KidsAccountHasResetToDefaultTheme",
	getThemeKey = function(p2, p3)
		local v5 = p2 or game:GetService("AppStorageService")

		local success, item = pcall(v5.GetItem, v5, "KidsAccountHasResetToDefaultTheme")

		if not success or type(item) ~= "string" or (p3 or module)[item] == nil then
			return nil
		end

		return item
	end,
	setThemeKey = function(p2, p3)
		local v5 = p3 or game:GetService("AppStorageService")

		return (pcall(function()
			v5:SetItem("KidsAccountHasResetToDefaultTheme", p2)
			v5:Flush()
		end))
	end
}
