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

local function TraversalLeaveConfirmation(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), useLocalization (copy), SignalsReact (copy), getGameInfoStore (copy), Signals (copy), UserInputService (copy), GetInputModeStore (copy), Input (copy), Constants (copy), ContextActionService (copy), GuiService (copy), View (copy), TeleportLeaveConfirmation (copy)
	local v23 = React.useRef(nil)
	local v24 = useLocalization({
		previous = "CoreScripts.TopBar.Traversal.BackButtonDefault"
	})
	local v25 = SignalsReact.useSignalState(getGameInfoStore(false).getAndFetchGameInfo((tostring(t1.universeId))).data)
	local num = nil
	local name

	if typeof(v25) == "table" then
		name = v25.name
		num = tonumber(v25.rootPlaceId)
	else
		name = v24.previous
	end

	local v28 = React.useCallback(function(_, p2) -- line: 53
		-- upvalues: t1 (copy)
		if p2 == Enum.UserInputState.End then
			t1.onCancel()

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, { t1.onCancel })

	React.useEffect(function() -- line: 61
		-- upvalues: Signals (copy), UserInputService (copy), GetInputModeStore (copy), Input (copy), num (ref), Constants (copy), ContextActionService (copy), v28 (copy), GuiService (copy), v23 (copy)
		local v31 = Signals.createEffect(function(p3) -- line: 62
			-- upvalues: UserInputService (copy), GetInputModeStore (copy), Input (copy), num (ref), Constants (copy), ContextActionService (copy), v28 (copy), GuiService (copy), v23 (copy)
			local LastInputType = UserInputService:GetLastInputType()
			local v34 = GetInputModeStore(p3).getLastInputType(p3)
			local v35 = v34 == Input.Directional or v34 == Input.Pointer and LastInputType == Enum.UserInputType.Keyboard

			if num ~= nil and num > Constants.NO_PLACE_ID then
				if v35 then
					ContextActionService:BindCoreAction("FREEZE_CONTROLLER", function() -- line: 68
					end, false, Enum.UserInputType.Gamepad1)
					ContextActionService:BindCoreAction("EXIT_DIALOG", v28, false, Enum.KeyCode.ButtonB)
					GuiService.SelectedCoreObject = v23.current

					return
				end
			elseif v35 then
				ContextActionService:UnbindCoreAction("FREEZE_CONTROLLER")
				ContextActionService:UnbindCoreAction("EXIT_DIALOG")
			end
		end)

		return function() -- line: 79
			-- upvalues: v31 (copy)
			v31()
		end
	end, { num })

	return t1.isDialogOpen and (num and React.createElement("ScreenGui", {
		DisplayOrder = 10,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
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
				onCancel = t1.onCancel,
				onClose = t1.onClose,
				placeId = num,
				teleportName = name,
				source = t1.source,
				ref = v23
			})
		})
	}))
end

return React.memo(TraversalLeaveConfirmation)
