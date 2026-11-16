local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local SwitchServer = script:FindFirstAncestor("SwitchServer")
local parent = SwitchServer.Parent
local RunService = game:GetService("RunService")

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local Constants = require(SwitchServer.Constants)

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation
local useLocalization = Localization.Hooks.useLocalization

local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local navigateBacksByButtonB = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local GameLaunch = require(parent.GameLaunch)
local LaunchGame = GameLaunch.LaunchGame
local ExperienceService = require(parent.ExperienceService)
local default = ExperienceService.GameProtocol.default

local RecentServerHistory = require(SwitchServer.RecentServerHistory)
local callTeleportSwitchServer = require(SwitchServer.Utils.callTeleportSwitchServer)

local SwitchServerTelemetry = require(SwitchServer.Telemetry.SwitchServerTelemetry)
local FFlagUseTeleportForLuaSwitchServerImpl = require(SwitchServer.Flags.FFlagUseTeleportForLuaSwitchServerImpl)
local FFlagUseMultipleServerIdsForSwitchServer = require(SwitchServer.Flags.FFlagUseMultipleServerIdsForSwitchServer)

local function simpleLeaveGame() -- 1 equivalent call inferred from this helper
	GuiService.SelectedCoreObject = nil

	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()

	game:Shutdown()
end

local function SwitchServerConfirmationDialog(p)
	local v = useLocalization({
		title = Constants.CONFIRMATION.TITLE,
		body = Constants.CONFIRMATION.BODY,
		confirm = Constants.CONFIRMATION.CONFIRM,
		cancel = Constants.CONFIRMATION.CANCEL
	})

	local onActivated = React.useCallback(function()
		SwitchServerTelemetry.sendSwitchServerConfirmationActions({ event_type = "confirm" })

		p.setSwitchServerConfirmationOpen(false)

		if FFlagUseTeleportForLuaSwitchServerImpl and game:GetEngineFeature("SwitchServerAvailable") then
			if FFlagUseMultipleServerIdsForSwitchServer then
				callTeleportSwitchServer(RecentServerHistory.default:getRecentServerIds())
			else
				callTeleportSwitchServer()
			end
		else
			LaunchGame(
				tostring(game.PlaceId),
				Constants.REFERRAL_PAGE,
				{ gameIdToExclude = tostring(game.JobId) },
				default,
				Constants.SOURCE
			)
			simpleLeaveGame() -- inferred equivalent call
		end
	end, { p.setSwitchServerConfirmationOpen, game.PlaceId, game.JobId })

	local ref = React.useRef(false)
	local v2 = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		SwitchServerTelemetry.sendSwitchServerConfirmationActions({ event_type = "cancel" })

		p.setSwitchServerConfirmationOpen(false)
	end, { p.setSwitchServerConfirmationOpen })

	React.useEffect(function()
		ContextActionService:BindCoreAction("SwitchServerConfirmationCloseOnBack", function(_, p2)
			if p2 == Enum.UserInputState.Begin then
				v2()
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB)

		return function()
			ContextActionService:UnbindCoreAction("SwitchServerConfirmationCloseOnBack")
		end
	end, { v2 })

	React.useEffect(function()
		GuiService:SetMenuIsOpen(true, "SwitchServerConfirmation")
		return function()
			GuiService:SetMenuIsOpen(false, "SwitchServerConfirmation")
		end
	end, {})

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v2()
					object:cancel()
				end)
			}
		}
	end, { v2 })

	local ref2 = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacksByButtonB,
		eventHandlers = eventHandlers
	})

	return React.createElement(Dialog.Root, {
		ref = ref2,
		size = DialogSize.Small,
		hasBackdrop = true,
		disablePortal = false,
		onClose = v2
	}, {
		DialogTitle = React.createElement(Dialog.Title, { text = v.title, LayoutOrder = 1 }),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(Dialog.Text, { Text = v.body })
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = Orientation.Vertical,
			LayoutOrder = 3,
			actions = {
				{ text = v.confirm, variant = ButtonVariant.Emphasis, onActivated = onActivated },
				{ text = v.cancel, variant = ButtonVariant.Standard, onActivated = v2 }
			}
		})
	})
end

local function SwitchServerConfirmation(p)
	local v = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function()
		return function()
			v:teardown()
		end
	end, { v })

	return React.createElement(
		ReactFocusNavigation.FocusNavigationContext.Provider,
		{ value = v },
		React.createElement(SwitchServerConfirmationDialog, p)
	)
end

return React.memo(SwitchServerConfirmation)
