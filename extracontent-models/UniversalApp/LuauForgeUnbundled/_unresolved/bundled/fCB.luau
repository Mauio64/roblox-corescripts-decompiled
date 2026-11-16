local AccountService = game:GetService("AccountService")
local engineFeature = game:GetEngineFeature("MagicLogin")
local module = require("@luauforge/bundled/fCC")

return function(p2)
	if AccountService and engineFeature then
		if p2 then
			AccountService:MagicLogin(module.START_ADVERTISEMENT)
		else
			AccountService:MagicLogin(module.STOP_ADVERTISEMENT)
		end
	end
end
