local AccountLockModal = script:FindFirstAncestor("AccountLockModal")
local Enums = require(AccountLockModal.Common.Enums)
local AccountLockContext = require(AccountLockModal.Contexts.AccountLockContext)
local AccountLockModalParent = AccountLockModal.Parent
local React = require(AccountLockModalParent.React)
local useLocalization = require(AccountLockModalParent.Localization).Hooks.useLocalization
local Dialog = require(AccountLockModalParent.Foundation).Dialog

local function AccountLockModalContent(_: {[any]: any}) -- line: 16
	-- upvalues: AccountLockContext (copy), useLocalization (copy), Enums (copy), React (copy), Dialog (copy)
	local state = AccountLockContext.useAccountLockContext().state
	local v11 = useLocalization({
		continueBtn = "Feature.AccountLock.Action.Continue"
	})
	local v12 = useLocalization({
		lockedDialog = "Feature.AccountLock.Content.LockedDialog",
		rateLimitedDialog = "Feature.AccountLock.Content.RateLimitDialog",
		errorDialog = {
			"Feature.AccountLock.Content.ErrorDialog",
			continue = "<b>" .. v11.continueBtn .. "</b>"
		}
	})

	if state.status == Enums.AccountLockStatusEnum.Locked then
		return React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = v12.lockedDialog
		})
	end

	if state.status == Enums.AccountLockStatusEnum.RateLimited then
		return React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = v12.rateLimitedDialog
		})
	end

	return React.createElement(Dialog.Text, {
		LayoutOrder = 2,
		Text = v12.errorDialog
	})
end

return React.memo(AccountLockModalContent)
