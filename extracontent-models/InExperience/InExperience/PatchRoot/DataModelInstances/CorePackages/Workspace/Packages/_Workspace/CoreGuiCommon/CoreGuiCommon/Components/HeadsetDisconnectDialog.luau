local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local Dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

function HeadsetDisconnectDialog(t1: {[any]: any}) -- line: 30
	-- upvalues: GuiService (copy), VRService (copy), useLocalization (copy), React (copy), ContextActionService (copy), Dialog (copy), Foundation (copy)
	local v11 = t1.mockGuiService or GuiService
	local v12 = t1.mockVRService or VRService
	local v13 = useLocalization({
		titleText = "InGame.ConnectionError.Heading.VRDisconnected",
		bodyText = "InGame.ConnectionError.Message.RestartApp",
		buttonText = "InGame.ConnectionError.Action.Restart"
	})
	local v14, v15 = React.useState(false)

	React.useEffect(function() -- line: 43
		-- upvalues: v12 (copy), v15 (copy)
		local connection = v12:GetPropertyChangedSignal("VRDeviceAvailable"):Connect(function(p1) -- line: 44
			-- upvalues: v15 (copy)
			v15(not p1)
		end)

		return function() -- line: 48
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v16 = React.useCallback(function() -- line: 53
		-- upvalues: v11 (copy)
		local NotificationTypeList = v11:GetNotificationTypeList()

		if game:GetEngineFeature("EnableLuaControlsRestartApp") then
			v11:BroadcastNotification("", NotificationTypeList.RESTART_APP)

			return
		end

		v11:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)
	end, {})

	React.useEffect(function() -- line: 63
		-- upvalues: v14 (copy), v11 (copy), ContextActionService (copy), v16 (copy)
		if v14 then
			v11:SetMenuIsOpen(true, "HeadsetDisconnectedDialog")
			ContextActionService:BindCoreAction("TopBarGamepadDisableMenuShortcut", function() -- line: 67
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonStart, Enum.KeyCode.Escape)
			ContextActionService:BindCoreAction("TopBarDialogConfirm", function(_, p3, _) -- line: 71
				-- upvalues: v16 (copy)
				if p3 ~= Enum.UserInputState.Begin then
					return Enum.ContextActionResult.Pass
				end

				v16()

				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.Return, Enum.KeyCode.ButtonA)
		else
			v11:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
			ContextActionService:UnbindCoreAction("TopBarGamepadDisableMenuShortcut")
			ContextActionService:UnbindCoreAction("TopBarDialogConfirm")
		end

		return function() -- line: 85
			-- upvalues: v11 (copy), ContextActionService (copy)
			v11:SetMenuIsOpen(false, "HeadsetDisconnectedDialog")
			ContextActionService:UnbindCoreAction("TopBarGamepadDisableMenuShortcut")
			ContextActionService:UnbindCoreAction("TopBarDialogConfirm")
		end
	end, { v14 })

	if v14 then
		return (React.createElement(Dialog.Root, {
			testId = "headset-disconnect-dialog",
			size = Foundation.Enums.DialogSize.Small,
			hasBackdrop = t1.hasBackdrop == nil or t1.hasBackdrop,
			disablePortal = t1.disablePortal
		}, {
			DialogTitle = React.createElement(Dialog.Title, {
				text = v13.titleText
			}),
			DialogContent = React.createElement(Dialog.Content, nil, {
				DialogText = React.createElement(Dialog.Text, {
					Text = v13.bodyText
				})
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				actions = {{
					testId = "restart-button",
					text = v13.buttonText,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = v16
				}}
			})
		}))
	end

	return nil
end

return React.memo(HeadsetDisconnectDialog)
