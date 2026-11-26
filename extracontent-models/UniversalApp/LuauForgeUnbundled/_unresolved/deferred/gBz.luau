local module = require("@luauforge/deferred/gBA")
local setModerationStatus = require("@luauforge/deferred/gzN").SetModerationStatus
local module2 = require("@luauforge/deferred/gBp")

local fFlagUseSignalsForModeration = require("@luauforge/deferred/gAd").FFlagUseSignalsForModeration

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/deferred/gzN").GetModerationStore else nil

require("@luauforge/deferred/gzP")

local module3 = require("@luauforge/deferred/gzS")
local useState = module3.useState
local useCallback = module3.useCallback
local useDispatch = require("@luauforge/deferred/gAC").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/deferred/gAA").useRoactService
local useLocalization = require("@luauforge/deferred/gAn").Hooks.useLocalization

local roactNetworking = require("@luauforge/deferred/gAz").RoactNetworking
local GuiService = game:GetService("GuiService")
local notificationType = require("@luauforge/deferred/gAu").NotificationType

local module4 = require("@luauforge/deferred/gzT")
local view = module4.View
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize

local function AccountReactivationPromptButtons(p2)
	local state, setState = useState(false)
	local state2, setState2 = useState(false)

	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local v7 = module2(setState2, p2.LogoutThunk)

	local v8 = useCallback(function()
		p2.setErrorState(false)
		setState(true)

		module(v6):andThen(function(p3)
			if fFlagUseSignalsForModeration then
				getModerationStore(false).setModerationStatus(false)
			else
				v5(setModerationStatus(false))
			end

			GuiService:BroadcastNotification("", notificationType.RESTART_LUA_APP)
		end):catch(function(p3)
			p2.setErrorState(true)
			setState(false)
		end)
	end, { v5, v6, p2.setErrorState })

	local v9 = useLocalization({
		logoutButton = "Application.Logout.Action.Logout",
		reactivationButton = "Feature.AccountReactivation.Label.Reactivate"
	})

	return module3.createElement(
		view,
		{ tag = "flex-between size-full-0 auto-y col gap-small padding-x-xxlarge" },
		{
			ReactivationButton = module3.createElement(button, {
				text = v9.reactivationButton,
				onActivated = v8,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				width = UDim.new(1, 0),
				isLoading = state,
				LayoutOrder = 1
			}),
			LogoutButton = module3.createElement(button, {
				text = v9.logoutButton,
				onActivated = v7,
				variant = buttonVariant.Standard,
				size = inputSize.Medium,
				width = UDim.new(1, 0),
				isLoading = state2,
				LayoutOrder = 2
			})
		}
	)
end

return module3.memo(AccountReactivationPromptButtons)
