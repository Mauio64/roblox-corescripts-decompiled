local NotApprovedPageV2 = require(script.Components.NotApprovedPageV2)
local AccountReactivationPrompt = require(script.Components.AccountReactivationPrompt.AccountReactivationPrompt)

return {
	NotApprovedPageV2 = NotApprovedPageV2,
	AccountReactivationPrompt = AccountReactivationPrompt,
	["jest.config"] = script["jest.config"]
}
