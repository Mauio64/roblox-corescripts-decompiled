local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/UIBlox")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/ReactRoblox")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local defineFastFlag = game:DefineFastFlag(
	"EnableToastNotificationsDeeplinkConfirmationModalHeightFix",
	false
)

local RobloxTranslator = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/RobloxTranslator")
local fFlagGameInviteInExpJoinCta3 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/SharedFlags").FFlagGameInviteInExpJoinCta3

return function(props)
	local state, setState = React.useState(Vector2.new(800, 600))

	local formatByKey = RobloxTranslator:FormatByKey(fFlagGameInviteInExpJoinCta3 and props.titleKey or "Notifications.ToastNotifications.Title.LeavingExperience")

	local formatByKey2 = RobloxTranslator:FormatByKey(fFlagGameInviteInExpJoinCta3 and props.bodyKey or "Notifications.ToastNotifications.Label.LeaveExperienceConfirmation")

	local formatByKey3 = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel")
	local formatByKey4 = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Confirm")
	local createElement = React.createElement
	local v6 = {
		Active = true,
		BackgroundTransparency = not props.backgroundTransparency and 0.5 or props.backgroundTransparency,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(1, 0, 1, not defineFastFlag and 0 or GuiService.TopbarInset.Height),
		[ReactRoblox.Change.AbsoluteSize] = function(p2)
			setState(p2.AbsoluteSize)
		end
	}

	local v7 = if defineFastFlag then UDim2.fromOffset(0, -GuiService.TopbarInset.Height) else nil
	v6.Position = v7
	return createElement("Frame", v6, {
		Alert = React.createElement(interactiveAlert, {
			screenSize = state,
			title = formatByKey,
			bodyText = formatByKey2,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = function()
								props.closeCallback(false)
							end,
							text = formatByKey3
						}
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = function()
								props.closeCallback(true)
							end,
							text = formatByKey4
						}
					}
				}
			}
		})
	})
end
