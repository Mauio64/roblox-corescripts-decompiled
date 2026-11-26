local module = require("@luauforge/deferred/gXi")
local module2 = require("@luauforge/deferred/gXj")

local module3 = require("@luauforge/deferred/gXk")
local useLocalization = require("@luauforge/deferred/gXn").Hooks.useLocalization

local dialog = require("@luauforge/deferred/gXo").Dialog

local function AccountLockModalContent(p2)
	local state = module2.useAccountLockContext().state

	local v6 = useLocalization({
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
			Text = v6.lockedDialog,
			LayoutOrder = 2
		})
	end

	if state.status == module.AccountLockStatusEnum.RateLimited then
		return module3.createElement(dialog.Text, {
			Text = v6.rateLimitedDialog,
			LayoutOrder = 2
		})
	end

	return module3.createElement(dialog.Text, { Text = v6.errorDialog, LayoutOrder = 2 })
end

return module3.memo(AccountLockModalContent)
