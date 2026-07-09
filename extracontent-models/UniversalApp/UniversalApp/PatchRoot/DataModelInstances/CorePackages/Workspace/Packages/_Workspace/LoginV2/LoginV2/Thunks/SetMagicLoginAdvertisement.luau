local LoginV2 = script:FindFirstAncestor("LoginV2")
local AccountService = game:GetService("AccountService")
local EngineFeature = game:GetEngineFeature("MagicLogin")
local Constants = require(LoginV2.Components.Constants)

return function(b1: boolean) -- line: 8
	-- upvalues: AccountService (copy), EngineFeature (copy), Constants (copy)
	if AccountService and EngineFeature then
		if b1 then
			AccountService:MagicLogin(Constants.START_ADVERTISEMENT)

			return
		end

		AccountService:MagicLogin(Constants.STOP_ADVERTISEMENT)
	end
end
