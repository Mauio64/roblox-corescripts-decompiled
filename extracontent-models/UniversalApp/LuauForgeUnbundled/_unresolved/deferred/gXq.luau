local module = require("@luauforge/deferred/gXi")
local module2 = require("@luauforge/deferred/gXr")

local module3 = require("@luauforge/deferred/gXj")
local accountLockEventContextEnum = require("@luauforge/deferred/gXi").AccountLockEventContextEnum
local module4 = require("@luauforge/deferred/gXs")
local module5 = require("@luauforge/deferred/gXu")
local module6 = require("@luauforge/deferred/gXw")

local module7 = require("@luauforge/deferred/gXk")
local useLocalization = require("@luauforge/deferred/gXn").Hooks.useLocalization
local useState = module7.useState
local useCallback = module7.useCallback
local useRoactService = require("@luauforge/deferred/gXy").useRoactService
local useDispatch = require("@luauforge/deferred/gXx").Hooks.RoactRodux.useDispatch

local module8 = require("@luauforge/deferred/gXo")
local view = module8.View
local button = module8.Button
local buttonVariant = module8.Enums.ButtonVariant
local inputSize = module8.Enums.InputSize
local fillBehavior = module8.Enums.FillBehavior

local roactNetworking = require("@luauforge/deferred/gXz").RoactNetworking
local appLogging = require("@luauforge/deferred/gXz").AppLogging
local appPage = require("@luauforge/deferred/gXC").AppPage

local function AccountLockModalFooter(props)
	local v5 = module3.useAccountLockContext()
	local state = v5.state
	local reducer = v5.reducer

	local v6 = useDispatch()

	local v7 = module6(props.Logout)
	local state2, setState = useState(false)
	local state3, setState2 = useState(false)

	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(appLogging)

	local v10 = useLocalization({
		signOutButton = "Feature.AccountLock.Action.Signout",
		continueButton = "Feature.AccountLock.Action.Continue"
	})

	local v11 = useCallback(function()
		setState(true)
		v9:logRobloxTelemetryEvent(module4, {}, {
			context = accountLockEventContextEnum.Unlock
		})

		module5(v8):andThen(function(p2)
			task.spawn(function()
				v9:logRobloxTelemetryEvent(module4, {}, {
					context = accountLockEventContextEnum.Success
				})

				task.wait(module2() / 1000)

				v6(props.ApiFetchAccessStatus(v8))
				v6(props.ResetNavigationHistory({
					{ name = appPage.Home }
				}))
				v6(props.closeCentralOverlayThunk())
			end)
		end):catch(function(p2)
			local matchRateLimited = props.ChallengeError.matchRateLimited(p2)

			if matchRateLimited then
				reducer({
					status = module.AccountLockStatusEnum.RateLimited,
					retryTime = matchRateLimited
				})
				v9:logRobloxTelemetryEvent(module4, {}, {
					context = accountLockEventContextEnum.RateLimited
				})
			elseif props.ChallengeError.matchAbandoned(p2) then
				v9:logRobloxTelemetryEvent(module4, {}, {
					context = accountLockEventContextEnum.Abandoned
				})
			else
				reducer({ status = module.AccountLockStatusEnum.Error })
				v9:logRobloxTelemetryEvent(module4, {}, {
					context = accountLockEventContextEnum.Error
				})
			end

			setState(false)
		end)
	end, { v8 })

	local v12 = useCallback(function()
		setState2(true)
		v9:logRobloxTelemetryEvent(module4, {}, {
			context = accountLockEventContextEnum.Logout
		})

		v7()
	end, { v8 })

	return module7.createElement(view, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = 3
	}, {
		LogoutButton = module7.createElement(button, {
			text = v10.signOutButton,
			onActivated = v12,
			variant = buttonVariant.Standard,
			size = inputSize.Medium,
			fillBehavior = fillBehavior.Fill,
			isLoading = state3,
			LayoutOrder = 1
		}),
		UnlockButton = module7.createElement(button, {
			text = v10.continueButton,
			onActivated = v11,
			variant = buttonVariant.Emphasis,
			size = inputSize.Medium,
			fillBehavior = fillBehavior.Fill,
			isLoading = state2,
			isDisabled = state.timeUntilRetry and state.timeUntilRetry > 0,
			LayoutOrder = 2
		})
	})
end

return module7.memo(AccountLockModalFooter)
