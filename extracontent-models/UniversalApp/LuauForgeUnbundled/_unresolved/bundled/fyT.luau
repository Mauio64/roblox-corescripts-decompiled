local module = require("@luauforge/bundled/fyU")

return function(object)
	if module() then
		return object:getSystemTheme()
	end

	return object:getSystemThemeAsync()
end
