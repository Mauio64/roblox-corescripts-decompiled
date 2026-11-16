local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")

local parent = script:FindFirstAncestor("CoreGuiCommon").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

function HeadsetDisconnectDialog(props)
	local mockGuiService = props.mockGuiService or GuiService
	local mockVRService = props.mockVRService or VRService

	local v = useLocalization({
		titleText = "InGame.ConnectionError.Heading.VRDisconnected",
		bodyText = "InGame.ConnectionError.Message.RestartApp",
		buttonText = "InGame.ConnectionError.Action.Restart"
	})

	local state, setState = React.useState(false)

	React.useEffect(function()
		local vRDeviceAvailableChangedConnection = mockVRService:GetPropertyChangedSignal("VRDeviceAvailable"):Connect(function(p)
			setState(not p)
		end)

		return function()
			vRDeviceAvailableChangedConnection:Disconnect()
		end
	end, {})

	local onActivated = React.useCallback(function()
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

			ContextActionService:BindCoreAction("TopBarDialogConfirm", function(_, p, _)
				if p ~= Enum.UserInputState.Begin then
					return Enum.ContextActionResult.Pass
				end

				onActivated()
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
		return (React.createElement(Dialog.Root, {
			size = Foundation.Enums.DialogSize.Small,
			hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
			disablePortal = props.disablePortal,
			testId = "headset-disconnect-dialog"
		}, {
			DialogTitle = React.createElement(Dialog.Title, { text = v.titleText }),
			DialogContent = React.createElement(Dialog.Content, nil, {
				DialogText = React.createElement(Dialog.Text, { Text = v.bodyText })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				actions = {
					{
						text = v.buttonText,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = onActivated,
						testId = "restart-button"
					}
				}
			})
		}))
	end

	return nil
end

return React.memo(HeadsetDisconnectDialog)
