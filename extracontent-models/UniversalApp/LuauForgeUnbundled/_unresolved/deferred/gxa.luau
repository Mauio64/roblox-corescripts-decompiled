local module = require("@luauforge/deferred/gwT")
local module2 = require("@luauforge/deferred/gwU")

local module3 = require("@luauforge/deferred/gwV")
local useLocalization = require("@luauforge/deferred/gwY").Hooks.useLocalization

local dialog = require("@luauforge/deferred/gwZ").Dialog

local function AccountLockModalContent(p2)
	local state = module2.useAccountLockContext().state

	local v5 = useLocalization({
		lockedDialog = "Feature.AccountLock.Content.LockedDialog",
		errorDialog = {
			"Feature.AccountLock.Content.ErrorDialog",
			continue = "<b>" .. useLocalization({
				continueBtn = "Feature.AccountLock.Action.Continue"
			}).continueBtn .. "</b>"
		},
		rateLimitedDialog = "Feature.AccountLock.Content.RateLimitDialog"
	})

	if state.status == module.AccountLockStatusEnum.Locked then
		return module3.createElement(dialog.Text, {
			Text = v5.lockedDialog,
			LayoutOrder = 2
		})
	end

	if state.status == module.AccountLockStatusEnum.RateLimited then
		return module3.createElement(dialog.Text, {
			Text = v5.rateLimitedDialog,
			LayoutOrder = 2
		})
	end

	return module3.createElement(dialog.Text, { Text = v5.errorDialog, LayoutOrder = 2 })
end

return module3.memo(AccountLockModalContent)
