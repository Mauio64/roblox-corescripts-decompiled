local module = require("@luauforge/bundled/gic")

game:DefineFastFlag("FixFetchThemePromiseRejection", false)

return function(p2, p3)
	return module(p2, p3):andThen(function(list)
		local item = list[1]

		if not game:GetFastFlag("FixFetchThemePromiseRejection") then
			return (string.lower(item.themeType))
		end

		if item then
			return string.lower(item.themeType)
		end

		return string.lower("light")
	end)
end
