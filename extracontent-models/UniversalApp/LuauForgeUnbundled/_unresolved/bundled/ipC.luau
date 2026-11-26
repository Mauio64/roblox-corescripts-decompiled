local setCurrentCharacter = require("@luauforge/bundled/dKU").Actions.SetCurrentCharacter

return function(p2)
	return function(object)
		object:dispatch(setCurrentCharacter(p2))
	end
end
