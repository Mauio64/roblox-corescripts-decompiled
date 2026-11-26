local module = require("@luauforge/bundled/fHq")
local module2 = require("@luauforge/bundled/fHk")
require("@luauforge/bundled/fBQ")

local v5 = { Account = "Account", Device = "Device", None = "None" }

return {
	ThemeAccess = v5,
	getThemeAccess = function(p2, p3, p4, p5)
		if p2 == nil or p4 then
			return v5.None
		end

		if p3 then
			return v5.Account
		end

		if (p5 or module2)[p2] == true then
			return v5.Device
		end

		return v5.None
	end,
	isOpenAccessTheme = function(p2, p3): boolean
		return (p3 or module2)[p2] == true
	end,
	getFeaturedThemeKeys = function(p2, p3, p4, p5)
		local featuredThemeKeys = {}

		for k, v6 in p4 or module do
			local v7

			if v6 == nil or p3 then
				v7 = v5.None
			else
				v7 = if p2 then v5.Account elseif (p5 or module2)[v6] == true then v5.Device else v5.None
			end

			if v7 ~= v5.None then
				table.insert(featuredThemeKeys, v6)
			end
		end

		return featuredThemeKeys
	end
}
