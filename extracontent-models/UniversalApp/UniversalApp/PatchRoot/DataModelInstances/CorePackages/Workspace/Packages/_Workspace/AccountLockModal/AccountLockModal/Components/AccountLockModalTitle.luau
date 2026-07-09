local AccountLockModal = script:FindFirstAncestor("AccountLockModal")
local AccountLockModalParent = AccountLockModal.Parent
local Enums = require(AccountLockModal.Common.Enums)
local AccountLockContext = require(AccountLockModal.Contexts.AccountLockContext)
local React = require(AccountLockModalParent.React)
local useLocalization = require(AccountLockModalParent.Localization).Hooks.useLocalization
local Dialog = require(AccountLockModalParent.Foundation).Dialog

local function AccountLockModalTitle(_: {[any]: any}) -- line: 15
	-- upvalues: AccountLockContext (copy), useLocalization (copy), Enums (copy), React (copy), Dialog (copy)
	local state = AccountLockContext.useAccountLockContext().state
	local status = state.status
	local timeUntilRetry = state.timeUntilRetry
	local v13 = timeUntilRetry and string.format("%02d", (math.floor(timeUntilRetry / 3600))) or ""
	local v14 = timeUntilRetry and string.format("%02d", (math.floor(timeUntilRetry % 3600 / 60))) or ""
	local v15 = useLocalization({
		accountLocked = "Feature.AccountLock.Title.AccountLocked",
		tryAgain = "Feature.AccountLock.Title.TryAgain",
		rateLimit = {
			"Feature.AccountLock.Title.RateLimit",
			hh = v13,
			mm = v14
		}
	})

	if status == Enums.AccountLockStatusEnum.Locked then
		return React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v15.accountLocked
		})
	end

	if status == Enums.AccountLockStatusEnum.RateLimited then
		return React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v15.rateLimit
		})
	end

	return React.createElement(Dialog.Title, {
		LayoutOrder = 1,
		text = v15.tryAgain
	})
end

return React.memo(AccountLockModalTitle)
