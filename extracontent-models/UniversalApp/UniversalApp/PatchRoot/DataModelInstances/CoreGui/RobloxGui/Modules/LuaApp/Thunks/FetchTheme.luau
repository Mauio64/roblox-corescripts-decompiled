local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetTheme = require(Modules.LuaApp.Http.Requests.GetTheme)

game:DefineFastFlag("FixFetchThemePromiseRejection", false)

return function(p1, p2) -- line: 8
	-- upvalues: GetTheme (copy)
	return GetTheme(p1, p2):andThen(function(p3) -- line: 9
		local v6 = p3[1]

		if game:GetFastFlag("FixFetchThemePromiseRejection") then
			if v6 then
				return string.lower(v6.themeType)
			end

			return string.lower("light")
		end

		return (string.lower(v6.themeType))
	end)
end
