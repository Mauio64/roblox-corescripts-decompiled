local module = require("@luauforge/bundled/fGK")

return function(object)
	if module() then
		return object:getSystemTheme()
	end

	return object:getSystemThemeAsync()
end
