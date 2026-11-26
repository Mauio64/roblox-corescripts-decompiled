local module = require("@luauforge/deferred/gXi")
local module2 = require("@luauforge/deferred/gXj")

local module3 = require("@luauforge/deferred/gXk")
local useLocalization = require("@luauforge/deferred/gXn").Hooks.useLocalization

local dialog = require("@luauforge/deferred/gXo").Dialog

local function AccountLockModalTitle(p2)
	local state = module2.useAccountLockContext().state
	local status = state.status
	local timeUntilRetry = state.timeUntilRetry
	local v7 = useLocalization({
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
			text = v7.accountLocked,
			LayoutOrder = 1
		})
	end

	if status == module.AccountLockStatusEnum.RateLimited then
		return module3.createElement(dialog.Title, {
			text = v7.rateLimit,
			LayoutOrder = 1
		})
	end

	return module3.createElement(dialog.Title, { text = v7.tryAgain, LayoutOrder = 1 })
end

return module3.memo(AccountLockModalTitle)
