local Parent = script:FindFirstAncestor("AccountSwitching").Parent
local AuthCommon = require(Parent.AuthCommon)
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local getSignedOutAccounts = AuthCommon.Utils.getSignedOutAccounts
local GetAccountsList = require(script.Parent.GetAccountsList)
local Cryo = require(Parent.Cryo)
local AuthAnalytics = require(Parent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authAccountPickerAccountsFetched = AuthAnalytics.Events.authAccountPickerAccountsFetched
local GetFFlagEnableAccountCarouselEvents = require(Parent.SharedFlags).GetFFlagEnableAccountCarouselEvents
local GetFFlagShowInvoluntarilySignedOutAccounts = require(Parent.SharedFlags).GetFFlagShowInvoluntarilySignedOutAccounts
local v12 = game:DefineFastInt("MaxTotalAccountListSize", 10)
local v13 = game:DefineFastInt("AccountSwitcherSignedOutAccountsLimit", 5)
local v14 = game:DefineFastFlag("EnableAccountSwitcherSignedOutLimit", false)

local function ensureAccountsNotSignedOut(t1: {[any]: any}) -- line: 29
	-- upvalues: AppStorageUtilities (copy)
	local v18 = AppStorageUtilities.getPreviousAccountsList()

	if t1 and #t1 > 0 then
		for _, v in ipairs(t1) do
			if v18 and v18[v.user_id] and v18[v.user_id].signOutTimestamp then
				v18[v.user_id].signOutTimestamp = nil
			end
		end
	end

	AppStorageUtilities.setPreviousAccountsList(v18)
end
local function v16(t2: {[any]: any}, t3: {[any]: any}) -- line: 45
	-- upvalues: AppStorageUtilities (copy), Cryo (copy), authAccountPickerAccountsFetched (copy), EventStreamConstants (copy)
	local v23 = AppStorageUtilities.getPreviousAccountsList()
	local v24 = Cryo.Dictionary.keys(v23)

	if #t3 == 0 and #v24 == 0 then
		return
	end

	local v25 = Cryo.List.map(t2, function(p1) -- line: 56
		return p1 and p1.user_id
	end)
	local v26 = Cryo.List.map(t3, function(p2) -- line: 59
		return p2 and p2.user_id
	end)

	authAccountPickerAccountsFetched(EventStreamConstants.Context.AccountPickerAccountsFetched, v25, v26, v24)
end

return function(p3, t4: {[any]: any}) -- line: 70
	-- upvalues: GetAccountsList (copy), ensureAccountsNotSignedOut (copy), Cryo (copy), GetFFlagShowInvoluntarilySignedOutAccounts (copy), v14 (copy), v13 (copy), v12 (copy), getSignedOutAccounts (copy), GetFFlagEnableAccountCarouselEvents (copy), v16 (copy)
	return GetAccountsList(p3, t4.isAuthenticated):andThen(function(t5: {[any]: any}) -- line: 79
		-- upvalues: ensureAccountsNotSignedOut (copy), Cryo (copy), GetFFlagShowInvoluntarilySignedOutAccounts (copy), t4 (copy), v14 (copy), v13 (copy), v12 (copy), getSignedOutAccounts (copy), GetFFlagEnableAccountCarouselEvents (copy), v16 (copy)
		local v32 = t5.logged_in_users_metadata or {}

		ensureAccountsNotSignedOut(v32)

		local u33 = Cryo.List.map(v32, function(p4) -- line: 82
			return {
				has_valid_session = true,
				user_id = p4.user_id,
				username = p4.username,
				display_name = p4.display_name or p4.username
			}
		end)
		local n1 = 0

		if u33 then
			n1 = #u33
		end

		local t6 = nil

		if GetFFlagShowInvoluntarilySignedOutAccounts() then
			t6 = {}

			for _, v37 in u33 do
				t6[v37.user_id] = true
			end
		end

		local v38 = math.max(((if not t4.useAccountSwitcherSignedOutAccountsLimit or not v14 then v12 else v13)) - n1, 0)
		local v39 = GetFFlagShowInvoluntarilySignedOutAccounts() and t4.filterUnauthenticatedSessionsForAccountPicker
		local v40 = getSignedOutAccounts(v38, t6, v39)

		if not v39 and t4.filterUnauthenticatedSessionsForAccountPicker then
			v40 = Cryo.List.filter(v40, function(p5) -- line: 113
				return p5 and p5.showInAccountPicker
			end)
		end

		local v41 = Cryo.List.map(v40, function(p6) -- line: 117
			return {
				has_valid_session = false,
				user_id = p6.userId,
				username = p6.username,
				display_name = p6.displayName
			}
		end)
		local v42 = Cryo.List.join(u33, v41)

		if GetFFlagEnableAccountCarouselEvents() then
			pcall(function() -- line: 128
				-- upvalues: v16 (copy), u33 (ref), v42 (copy)
				v16(u33, v42)
			end)
		end

		return v42
	end):catch(function(p7) -- line: 134
		warn(p7)

		return {}
	end)
end
