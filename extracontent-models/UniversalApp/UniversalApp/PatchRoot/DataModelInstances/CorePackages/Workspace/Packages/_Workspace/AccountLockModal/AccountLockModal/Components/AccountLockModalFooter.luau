local AccountLockModal = script:FindFirstAncestor("AccountLockModal")
local AccountLockModalParent = AccountLockModal.Parent
local Enums = require(AccountLockModal.Common.Enums)
local GetFIntAccountUnlockDelayMs = require(AccountLockModal.Flags.GetFIntAccountUnlockDelayMs)
local AccountLockContext = require(AccountLockModal.Contexts.AccountLockContext)
local AccountLockEventContextEnum = require(AccountLockModal.Common.Enums).AccountLockEventContextEnum
local AccountLockClientEvent = require(AccountLockModal.Common.AccountLockClientEvent)
local unlockAccount = require(AccountLockModal.Utils.unlockAccount)
local useLogout = require(AccountLockModal.Utils.useLogout)
local React = require(AccountLockModalParent.React)
local useLocalization = require(AccountLockModalParent.Localization).Hooks.useLocalization
local useState = React.useState
local useCallback = React.useCallback
local useRoactService = require(AccountLockModalParent.RobloxAppHooks).useRoactService
local useDispatch = require(AccountLockModalParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Foundation = require(AccountLockModalParent.Foundation)
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FillBehavior = Foundation.Enums.FillBehavior
local RoactNetworking = require(AccountLockModalParent.RoactServiceTags).RoactNetworking
local AppLogging = require(AccountLockModalParent.RoactServiceTags).AppLogging
local AppPage = require(AccountLockModalParent.RobloxAppEnums).AppPage

local function AccountLockModalFooter(t1: {[any]: any}) -- line: 39
	-- upvalues: AccountLockContext (copy), useDispatch (copy), useLogout (copy), useState (copy), useRoactService (copy), RoactNetworking (copy), AppLogging (copy), useLocalization (copy), useCallback (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), unlockAccount (copy), GetFIntAccountUnlockDelayMs (copy), AppPage (copy), Enums (copy), React (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy), FillBehavior (copy)
	local v27 = AccountLockContext.useAccountLockContext()
	local state = v27.state
	local reducer = v27.reducer
	local v30 = useDispatch()
	local v31 = useLogout(t1.Logout)
	local v32, v33 = useState(false)
	local v34, v35 = useState(false)
	local v36 = useRoactService(RoactNetworking)
	local v37 = useRoactService(AppLogging)
	local v38 = useLocalization({
		signOutButton = "Feature.AccountLock.Action.Signout",
		continueButton = "Feature.AccountLock.Action.Continue"
	})
	local v39 = useCallback(function() -- line: 58
		-- upvalues: v33 (copy), v37 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), unlockAccount (copy), v36 (copy), GetFIntAccountUnlockDelayMs (copy), v30 (copy), t1 (copy), AppPage (copy), reducer (copy), Enums (copy)
		v33(true)
		v37:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
			context = AccountLockEventContextEnum.Unlock
		})
		unlockAccount(v36):andThen(function(_) -- line: 64
			-- upvalues: v37 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), GetFIntAccountUnlockDelayMs (copy), v30 (copy), t1 (copy), v36 (copy), AppPage (copy)
			task.spawn(function() -- line: 65
				-- upvalues: v37 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), GetFIntAccountUnlockDelayMs (copy), v30 (copy), t1 (copy), v36 (copy), AppPage (copy)
				v37:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
					context = AccountLockEventContextEnum.Success
				})
				task.wait(GetFIntAccountUnlockDelayMs() / 1000)
				v30(t1.ApiFetchAccessStatus(v36))
				v30(t1.ResetNavigationHistory({{
					name = AppPage.Home
				}}))
				v30(t1.closeCentralOverlayThunk())
			end)
		end):catch(function(p2) -- line: 82
			-- upvalues: t1 (copy), reducer (copy), Enums (copy), v37 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), v33 (copy)
			local v43 = t1.ChallengeError.matchRateLimited(p2)

			if v43 then
				reducer({
					status = Enums.AccountLockStatusEnum.RateLimited,
					retryTime = v43
				})
				v37:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
					context = AccountLockEventContextEnum.RateLimited
				})
			elseif t1.ChallengeError.matchAbandoned(p2) then
				v37:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
					context = AccountLockEventContextEnum.Abandoned
				})
			else
				reducer({
					status = Enums.AccountLockStatusEnum.Error
				})
				v37:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
					context = AccountLockEventContextEnum.Error
				})
			end

			v33(false)
		end)
	end, { v36 })
	local v40 = useCallback(function() -- line: 103
		-- upvalues: v35 (copy), v37 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), v31 (copy)
		v35(true)
		v37:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
			context = AccountLockEventContextEnum.Logout
		})
		v31()
	end, { v36 })

	return React.createElement(View, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = 3
	}, {
		LogoutButton = React.createElement(Button, {
			LayoutOrder = 1,
			text = v38.signOutButton,
			onActivated = v40,
			variant = ButtonVariant.Standard,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			isLoading = v34
		}),
		UnlockButton = React.createElement(Button, {
			LayoutOrder = 2,
			text = v38.continueButton,
			onActivated = v39,
			variant = ButtonVariant.Emphasis,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			isLoading = v32,
			isDisabled = state.timeUntilRetry and state.timeUntilRetry > 0
		})
	})
end

return React.memo(AccountLockModalFooter)
