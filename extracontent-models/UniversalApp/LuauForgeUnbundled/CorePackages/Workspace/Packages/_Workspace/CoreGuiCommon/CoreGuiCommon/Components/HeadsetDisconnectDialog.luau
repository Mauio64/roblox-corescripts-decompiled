local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/React")

local dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

function LUAUFORGE_MODULE_GLOBALS_hQg_HeadsetDisconnectDialog(props)
	local mockGuiService = props.mockGuiService or GuiService
	local mockVRService = props.mockVRService or VRService

	local v5 = useLocalization({
		titleText = "InGame.ConnectionError.Heading.VRDisconnected",
		bodyText = "InGame.ConnectionError.Message.RestartApp",
		buttonText = "InGame.ConnectionError.Action.Restart"
	})

	local state, setState = React.useState(false)

	React.useEffect(function()
		local vRDeviceAvailableChangedConnection = mockVRService:GetPropertyChangedSignal("VRDeviceAvailable"):Connect(function(p2)
			setState(not p2)
		end)

		return function()
			vRDeviceAvailableChangedConnection:Disconnect()
		end
	end, {})

	local v6 = React.useCallback(function()
		local notificationTypeList = mockGuiService:GetNotificationTypeList()

		if game:GetEngineFeature("EnableLuaControlsRestartApp") then
			mockGuiService:BroadcastNotification("", notificationTypeList.RESTART_APP)
		else
			mockGuiService:BroadcastNotification("", notificationTypeList.NATIVE_EXIT)
		end
	end, {})

	React.useEffect(function()
		if state then
			mockGuiService:SetMenuIsOpen(true, "HeadsetDisconnectedDialog")

			ContextActionService:BindCoreAction("TopBarGamepadDisableMenuShortcut", function()
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonStart, Enum.KeyCode.Escape)

			ContextActionService:BindCoreAction("TopBarDialogConfirm", function(p2, p3, p4)
				if p3 ~= Enum.UserInputState.Begin then
					return Enum.ContextActionResult.Pass
				end

				v6()
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.Return, Enum.KeyCode.ButtonA)
		else
			mockGuiService:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
			ContextActionService:UnbindCoreAction("TopBarGamepadDisableMenuShortcut")
			ContextActionService:UnbindCoreAction("TopBarDialogConfirm")
		end

		return function()
			mockGuiService:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
			ContextActionService:UnbindCoreAction("TopBarGamepadDisableMenuShortcut")
			ContextActionService:UnbindCoreAction("TopBarDialogConfirm")
		end
	end, { state })

	if state then
		return (React.createElement(dialog.Root, {
			size = Foundation.Enums.DialogSize.Small,
			hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
			disablePortal = props.disablePortal,
			testId = "headset-disconnect-dialog"
		}, {
			DialogTitle = React.createElement(dialog.Title, { text = v5.titleText }),
			DialogContent = React.createElement(dialog.Content, nil, {
				DialogText = React.createElement(dialog.Text, { Text = v5.bodyText })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				actions = {
					{
						text = v5.buttonText,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = v6,
						testId = "restart-button"
					}
				}
			})
		}))
	end

	return nil
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hQg_HeadsetDisconnectDialog)
