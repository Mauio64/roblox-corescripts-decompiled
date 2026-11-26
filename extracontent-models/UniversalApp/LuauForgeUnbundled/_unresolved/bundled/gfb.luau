local module = require("@luauforge/bundled/gfc")

return function(p2)
	return module(p2):andThen(function(list)
		local item = list[1]
		local locale, locale2, locale3

		if item then
			locale = item.generalExperience and item.generalExperience.locale
			locale2 = item.signupAndLogin.locale
			locale3 = item.ugc.locale
		end

		return {
			signupAndLoginLocale = locale2,
			generalExperienceLocale = locale,
			ugcLocale = locale3
		}
	end)
end
