local module = require("@luauforge/deferred/gwT")
local module2 = require("@luauforge/deferred/gwU")

local module3 = require("@luauforge/deferred/gwV")
local useLocalization = require("@luauforge/deferred/gwY").Hooks.useLocalization

local dialog = require("@luauforge/deferred/gwZ").Dialog

local function AccountLockModalTitle(p2)
	local state = module2.useAccountLockContext().state
	local status = state.status
	local timeUntilRetry = state.timeUntilRetry
	local v5 = useLocalization({
		accountLocked = "Feature.AccountLock.Title.AccountLocked",
		tryAgain = "Feature.AccountLock.Title.TryAgain",
		rateLimit = {
			"Feature.AccountLock.Title.RateLimit",
			hh = timeUntilRetry and string.format("%02d", (math.floor(timeUntilRetry / 3600))) or "",
			mm = timeUntilRetry and string.format("%02d", (math.floor(timeUntilRetry % 3600 / 60))) or ""
		}
	})

	if status == module.AccountLockStatusEnum.Locked then
		return module3.createElement(dialog.Title, {
			text = v5.accountLocked,
			LayoutOrder = 1
		})
	end

	if status == module.AccountLockStatusEnum.RateLimited then
		return module3.createElement(dialog.Title, {
			text = v5.rateLimit,
			LayoutOrder = 1
		})
	end

	return module3.createElement(dialog.Title, { text = v5.tryAgain, LayoutOrder = 1 })
end

return module3.memo(AccountLockModalTitle)
