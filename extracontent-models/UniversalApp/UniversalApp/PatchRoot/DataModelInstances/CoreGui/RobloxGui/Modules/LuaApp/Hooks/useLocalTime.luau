local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)

return function(s1: string?, s2: string?) -- line: 11
	-- upvalues: useRoactService (copy), RoactLocalization (copy)
	local v6 = useRoactService(RoactLocalization)

	if s1 then
		local dateTime = DateTime.fromIsoDate(s1)

		if dateTime then
			local Locale = v6:GetLocale()

			return dateTime:FormatLocalTime(s2 or "l", Locale)
		end
	end

	return nil
end
