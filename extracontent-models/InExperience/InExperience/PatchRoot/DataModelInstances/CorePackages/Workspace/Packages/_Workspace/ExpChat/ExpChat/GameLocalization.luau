local GameLocalization = require(script.GameLocalization)
return GameLocalization({
	TranslateGameText = function(_, _, p)
		return p
	end
})
