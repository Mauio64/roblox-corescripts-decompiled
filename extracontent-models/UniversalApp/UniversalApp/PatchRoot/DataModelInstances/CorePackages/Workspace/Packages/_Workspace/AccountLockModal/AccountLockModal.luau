local AccountLockModal = require(script.Components.AccountLockModal)
local AccountUnlockDeepLinkPage = require(script.Components.AccountUnlockDeepLinkPage)

return {
	AccountLockModal = AccountLockModal,
	AccountUnlockDeepLinkPage = AccountUnlockDeepLinkPage,
	["jest.config"] = script["jest.config"]
}
