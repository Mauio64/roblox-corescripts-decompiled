local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local roactAnalytics = RoactServiceTags.RoactAnalytics
local appAppLifecycleObserverService = RoactServiceTags.AppAppLifecycleObserverService

local module2 = require("@luauforge/bundled/fBQ")

local module3 = require("@luauforge/bundled/fTv")

local module4 = require("@luauforge/bundled/fTy")
local module5 = require("@luauforge/bundled/fTz")
local module6 = require("@luauforge/bundled/ecW")

local module7 = require("@luauforge/bundled/fTB")

local module8 = require("@luauforge/bundled/fTC")

local module9 = require("@luauforge/bundled/fTD")
local module10 = require("@luauforge/bundled/fTw")
local module11 = require("@luauforge/bundled/fTE")
local pioneerAgeRestrictedView = module11.PioneerAgeRestrictedView
local blockedState = module11.BlockedState
local module12 = require("@luauforge/bundled/fTF")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local fFlagPioneerPreLaunchPlayabilityCheck = SharedFlags.FFlagPioneerPreLaunchPlayabilityCheck
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local v5 = if module9 then require("@luauforge/bundled/fRq") else nil

local user = if module9 then require("@game/CorePackages/Workspace/Packages/AuthCommon").Thunks.User else nil

local v6 = {
	fae_leave = blockedState.FaeDownAge,
	join_deny = blockedState.SignInBlocked
}

local function selectIsUserLoggedIn(p2): boolean
	return p2.AuthenticationStatus.status == module2.LOGGED_IN
end

local function PioneerPostAuthPage()
	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(roactAnalytics)

	local v10 = if module10 then useRoactService(appAppLifecycleObserverService) else nil
	local v11

	if fFlagUseSignalsForAuthenticationStatus then
		v11 = useSignalState(getAuthenticationStatusStore(false).getStatus) == module2.LOGGED_IN
	else
		v11 = useSelector(selectIsUserLoggedIn)
	end

	local state, setState = React.useState(nil)

	local v12 = React.useCallback(function(p2)
		module12.reportBlocked(p2)
		setState(p2)
	end, {})

	local state2, setState2 = React.useState(nil)
	local v13 = module9 and state == "fae_leave"
	React.useEffect(function()
		if v13 and v11 then
			local flag = true

			task.spawn(function()
				local availability = v5.Eligibility.getAvailability(v5.AccountUpgradeFlow.PioneerU13)

				if flag then
					setState2(function(p2)
						if p2 then
							return p2
						end

						if availability.granted then
							return "Form"
						end

						p2 = "Done"
						return p2
					end)
				end
			end)

			return function()
				flag = false
			end
		end

		return nil
	end, { v13, v11 })

	React.useEffect(function()
		if v13 and v11 then
			local thread = task.delay(10, function()
				setState2(function(value)
					return value or "Done"
				end)
			end)

			return function()
				pcall(task.cancel, thread)
			end
		end

		return nil
	end, { v13, v11 })

	local v14 = React.useCallback(function()
		setState2("Done")
	end, {})
	local v15 = v13 and state2 == "Form"
	local v16 = not (state == nil) and (not v13 or state2 == "Done")

	local v17 = React.useMemo(function()
		if v15 then
			return user.fromLocalStorage().username
		end

		return nil
	end, { v15 })

	React.useEffect(function()
		module3.onMount()
	end, {})

	React.useEffect(function()
		return module3.connect(v8)
	end, { v8 })
	local state3, setState3

	if module10 then
		state3, setState3 = React.useState(0)
	else
		setState3 = nil
	end

	if module10 then
		React.useEffect(function()
			local v18 = false
			local function requestRejoinIfVisible()
				if not v18 and module3.isRejoinPending() then
					module3.clearJoinKickedOff()
					setState3(function(p2)
						return p2 + 1
					end)
				end
			end

			local connections = {}

			if v10 and v10.OnHide and v10.OnUnhide then
				table.insert(connections, v10.OnHide:Connect(function()
					v18 = true
				end))

				table.insert(connections, v10.OnUnhide:Connect(function()
					v18 = false

					if not v18 and module3.isRejoinPending() then
						module3.clearJoinKickedOff()
						setState3(function(p2)
							return p2 + 1
						end)
					end
				end))
			end

			local v19 = module3.onRejoinPending(requestRejoinIfVisible)

			return function()
				v19()

				for k, connection in connections do
					connection:Disconnect()
				end
			end
		end, { v10 })
	end

	React.useEffect(function()
		if not v8 or not v11 or module3.hasKickedOffJoin() then
			return
		end

		local v18 = module10 and module3.isRejoinPending()
		module3.markJoinKickedOff()

		if not fFlagPioneerPreLaunchPlayabilityCheck then
			module4(v7, v8, v9)
			return
		end

		local function showGenericError()
			v7(module6({ HttpError = Enum.HttpError.OK }))
		end

		local function keepRejoinPending()
			if v18 then
				module3.restoreRejoinPending()
			end
		end
		module5(v7, v8, v9, {
			onBlocked = function(p2)
				if module8 and p2 == "AccountRestricted" then
					v12("join_deny")
					return
				end

				if v18 then
					module3.restoreRejoinPending()
				end

				v7(module6({ HttpError = Enum.HttpError.OK }))
			end,
			onComplianceError = function()
				if v18 then
					module3.restoreRejoinPending()
				end

				v7(module6({ HttpError = Enum.HttpError.OK }))
			end
		})
	end, { v7, v8, v9, v11, v12, state3 })

	React.useEffect(function()
		if not module7 then
			return nil
		end

		if module3.getBlockedReason() ~= nil then
			v12("fae_leave")
		end

		return module3.onBlocked(function()
			v12("fae_leave")
		end)
	end, { v12 })

	React.useEffect(function()
		if v16 and state ~= nil then
			module12.reportInterstitialImpression(state)
		end
	end, { v16, state })

	local createElement = React.createElement

	local v21 = if v15 then React.createElement(v5.AccountUpgradeAppShellFlow, {
		flow = v5.AccountUpgradeFlow.PioneerU13,
		currentUsername = v17,
		onComplete = v14,
		onUnrecoverableFailure = v14
	}) else nil

	local v22 = if v16 and state ~= nil then React.createElement(pioneerAgeRestrictedView, {
		blockedState = v6[state]
	}) else nil
	return createElement(view, { tag = "size-full bg-surface-0" }, {
		AccountUpgradeForm = v21,
		BlockedDialog = v22
	})
end

return PioneerPostAuthPage
