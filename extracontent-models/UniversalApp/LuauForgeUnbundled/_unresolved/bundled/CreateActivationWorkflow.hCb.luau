local appStorageUtilities = require("@luauforge/bundled/hCc").Utils.AppStorageUtilities
local module = require("@luauforge/bundled/hBw")
local module2 = require("@luauforge/bundled/hBx")
require("@luauforge/bundled/hBy")
require("@luauforge/bundled/hBz")

local function CreateActivationWorkflow(p2, p3, p4)
	if p4 then
		appStorageUtilities.setSignupActionRequired("")
		appStorageUtilities.flush()
	end

	local enterBirthday = module.EnterBirthday

	local v6 = if enterBirthday == module.EnterBirthday then { module2.Close, module2.Next } else enterBirthday == module.AddAuthMethod and { module2.Next } or {}

	return {
		namespace = p2,
		state = enterBirthday,
		availableActions = v6,
		payload = p3,
		history = { enterBirthday }
	}
end

return CreateActivationWorkflow
