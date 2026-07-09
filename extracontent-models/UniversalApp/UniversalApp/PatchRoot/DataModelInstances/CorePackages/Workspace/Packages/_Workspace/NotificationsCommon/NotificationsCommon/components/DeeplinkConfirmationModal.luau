local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local UIBlox = require(ParentParent.UIBlox)
local ReactRoblox = require(ParentParent.ReactRoblox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v8 = game:DefineFastFlag("EnableToastNotificationsDeeplinkConfirmationModalHeightFix", false)
local RobloxTranslator = require(ParentParent.RobloxTranslator)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), RobloxTranslator (copy), v8 (copy), GuiService (copy), ReactRoblox (copy), InteractiveAlert (copy), ButtonType (copy)
	local v11, v12 = React.useState(Vector2.new(800, 600))
	local v13 = RobloxTranslator:FormatByKey("Notifications.ToastNotifications.Title.LeavingExperience")
	local v14 = RobloxTranslator:FormatByKey("Notifications.ToastNotifications.Label.LeaveExperienceConfirmation")
	local v15 = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel")
	local v16 = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Confirm")

	return React.createElement("Frame", {
		Active = true,
		BackgroundTransparency = not t1.backgroundTransparency and 0.5 or t1.backgroundTransparency,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(1, 0, 1, not v8 and 0 or GuiService.TopbarInset.Height),
		[ReactRoblox.Change.AbsoluteSize] = function(p1) -- line: 42
			-- upvalues: v12 (copy)
			v12(p1.AbsoluteSize)
		end,
		Position = if not v8 then nil else UDim2.fromOffset(0, -GuiService.TopbarInset.Height)
	}, {
		Alert = React.createElement(InteractiveAlert, {
			screenSize = v11,
			title = v13,
			bodyText = v14,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = function() -- line: 57
								-- upvalues: t1 (copy)
								t1.closeCallback(false)
							end,
							text = v15
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = function() -- line: 66
								-- upvalues: t1 (copy)
								t1.closeCallback(true)
							end,
							text = v16
						}
					}
				}
			}
		})
	})
end
