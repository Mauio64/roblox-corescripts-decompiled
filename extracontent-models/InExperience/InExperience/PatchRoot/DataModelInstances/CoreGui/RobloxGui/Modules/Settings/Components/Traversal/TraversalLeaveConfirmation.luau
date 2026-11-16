local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

local View = Foundation.View
local getGameInfoStore = DataHydration.Game.getGameInfoStore
local Traversal = CoreScriptsRoactCommon.Traversal
local Constants = Traversal.Constants
local TeleportLeaveConfirmation = Traversal.TeleportLeaveConfirmation
local useLocalization = Localization.Hooks.useLocalization
local GetInputModeStore = Responsive.GetInputModeStore
local Input = Responsive.Input

local function TraversalLeaveConfirmation(props)
	local ref = React.useRef(nil)

	local v = useLocalization({ previous = "CoreScripts.TopBar.Traversal.BackButtonDefault" })

	local v2 = SignalsReact.useSignalState(getGameInfoStore(false).getAndFetchGameInfo((tostring(props.universeId))).data)

	local rootPlaceId = nil
	local teleportName

	if typeof(v2) == "table" then
		teleportName = v2.name
		rootPlaceId = tonumber(v2.rootPlaceId)
	else
		teleportName = v.previous
	end

	local v3 = React.useCallback(function(_, p)
		if p ~= Enum.UserInputState.End then
			return Enum.ContextActionResult.Pass
		end

		props.onCancel()
		return Enum.ContextActionResult.Sink
	end, { props.onCancel })

	React.useEffect(function()
		local effect = Signals.createEffect(function(p)
			local lastInputType = UserInputService:GetLastInputType()
			local lastInputType2 = GetInputModeStore(p).getLastInputType(p)
			local v4

			if lastInputType2 == Input.Directional then
				v4 = true
			elseif lastInputType2 == Input.Pointer then
				v4 = lastInputType == Enum.UserInputType.Keyboard
			else
				v4 = false
			end

			if rootPlaceId == nil or not (rootPlaceId > Constants.NO_PLACE_ID) then
				if v4 then
					ContextActionService:UnbindCoreAction("FREEZE_CONTROLLER")
					ContextActionService:UnbindCoreAction("EXIT_DIALOG")
				end
			elseif v4 then
				ContextActionService:BindCoreAction(
					"FREEZE_CONTROLLER",
					function() end,
					false,
					Enum.UserInputType.Gamepad1
				)
				ContextActionService:BindCoreAction("EXIT_DIALOG", v3, false, Enum.KeyCode.ButtonB)
				GuiService.SelectedCoreObject = ref.current
			end
		end)
		return function()
			effect()
		end
	end, { rootPlaceId })

	return props.isDialogOpen
		and rootPlaceId
		and React.createElement(
			"ScreenGui",
			{
				DisplayOrder = 10,
				IgnoreGuiInset = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			},
			{
				NoEscapeZone = React.createElement(View, {
					tag = "auto-xy size-full",
					selectionGroup = {
						SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
						SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
						SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
						SelectionBehaviorRight = Enum.SelectionBehavior.Stop
					}
				}, {
					Dialog = React.createElement(TeleportLeaveConfirmation, {
						onCancel = props.onCancel,
						onClose = props.onClose,
						placeId = rootPlaceId,
						teleportName = teleportName,
						source = props.source,
						ref = ref
					})
				})
			}
		)
end

return React.memo(TraversalLeaveConfirmation)
