local module = require("@luauforge/bundled/fCO")
local appStorageUtilities = module.Utils.AppStorageUtilities
local getSignedOutAccounts = module.Utils.getSignedOutAccounts
local module2 = require("@luauforge/bundled/fDn")
local module3 = require("@luauforge/bundled/fCR")

local module4 = require("@luauforge/bundled/fCP")
local eventStreamConstants = module4.EventStreamConstants
local authAccountPickerAccountsFetched = module4.Events.authAccountPickerAccountsFetched
local getFFlagEnableAccountCarouselEvents = require("@luauforge/bundled/fDj").GetFFlagEnableAccountCarouselEvents

local getFFlagShowInvoluntarilySignedOutAccounts = require("@luauforge/bundled/fDj").GetFFlagShowInvoluntarilySignedOutAccounts

local defineFastInt = game:DefineFastInt("MaxTotalAccountListSize", 10)
local defineFastInt2 = game:DefineFastInt("AccountSwitcherSignedOutAccountsLimit", 5)

local function ensureAccountsNotSignedOut(logged_in_users_metadata)
	local previousAccountsList = appStorageUtilities.getPreviousAccountsList()

	if logged_in_users_metadata and #logged_in_users_metadata > 0 then
		for i, item in ipairs(logged_in_users_metadata) do
			if
				previousAccountsList
				and previousAccountsList[item.user_id]
				and previousAccountsList[item.user_id].signOutTimestamp
			then
				previousAccountsList[item.user_id].signOutTimestamp = nil
			end
		end
	end

	appStorageUtilities.setPreviousAccountsList(previousAccountsList)
end

local function fn(mapped, joined)
	local previousAccountsList = appStorageUtilities.getPreviousAccountsList()

	local keys = module3.Dictionary.keys(previousAccountsList)

	if #joined == 0 and #keys == 0 then
		return
	end

	local mapped2 = module3.List.map(mapped, function(p2)
		return p2 and p2.user_id
	end)

	local mapped3 = module3.List.map(joined, function(p2)
		return p2 and p2.user_id
	end)

	authAccountPickerAccountsFetched(
		eventStreamConstants.Context.AccountPickerAccountsFetched,
		mapped2,
		mapped3,
		keys
	)
end

return function(p2, data)
	return module2(p2, data.isAuthenticated):andThen(function(p3)
		local logged_in_users_metadata = p3.logged_in_users_metadata or {}
		ensureAccountsNotSignedOut(logged_in_users_metadata)
		local mapped = module3.List.map(logged_in_users_metadata, function(data2)
			return {
				user_id = data2.user_id,
				username = data2.username,
				display_name = data2.display_name or data2.username,
				has_valid_session = true
			}
		end)

		local v5 = mapped and #mapped or 0
		local user_idSet

		if getFFlagShowInvoluntarilySignedOutAccounts() then
			user_idSet = {}

			for k, v6 in mapped do
				user_idSet[v6.user_id] = true
			end
		end

		local v6 = if data.useAccountSwitcherSignedOutAccountsLimit then defineFastInt2 else defineFastInt

		local v7 = math.max(v6 - v5, 0)

		local filterUnauthenticatedSessionsForAccountPicker = getFFlagShowInvoluntarilySignedOutAccounts()
			and data.filterUnauthenticatedSessionsForAccountPicker

		local signedOutAccounts = getSignedOutAccounts(
			v7,
			user_idSet,
			filterUnauthenticatedSessionsForAccountPicker
		)

		if
			not filterUnauthenticatedSessionsForAccountPicker
			and data.filterUnauthenticatedSessionsForAccountPicker
		then
			signedOutAccounts = module3.List.filter(signedOutAccounts, function(p4)
				return p4 and p4.showInAccountPicker
			end)
		end

		local mapped2 = module3.List.map(signedOutAccounts, function(data2)
			return {
				user_id = data2.userId,
				username = data2.username,
				display_name = data2.displayName,
				has_valid_session = false
			}
		end)

		local joined = module3.List.join(mapped, mapped2)

		if getFFlagEnableAccountCarouselEvents() then
			pcall(function()
				fn(mapped, joined)
			end)
		end

		return joined
	end):catch(function(p3)
		warn(p3)
		return {}
	end)
end
