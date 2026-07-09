local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetLocale = require(Modules.LuaApp.Http.Requests.GetLocale)

return function(p1) -- line: 6
	-- upvalues: GetLocale (copy)
	return GetLocale(p1):andThen(function(p2) -- line: 7
		local v5 = p2[1]
		local locale = nil
		local v7 = nil
		local locale2 = nil

		if v5 then
			v7 = v5.generalExperience and v5.generalExperience.locale
			locale = v5.signupAndLogin.locale
			locale2 = v5.ugc.locale
		end

		return {
			signupAndLoginLocale = locale,
			generalExperienceLocale = v7,
			ugcLocale = locale2
		}
	end)
end
