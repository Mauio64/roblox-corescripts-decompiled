local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local ReactRoblox = require(parent.ReactRoblox)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local defineFastFlag = game:DefineFastFlag("EnableToastNotificationsDeeplinkConfirmationModalHeightFix", false)

local RobloxTranslator = require(parent.RobloxTranslator)
local SharedFlags = require(parent.SharedFlags)
local FFlagGameInviteInExpJoinCta3 = SharedFlags.FFlagGameInviteInExpJoinCta3

return function(props)
	local state, setState = React.useState(Vector2.new(800, 600))

	local formatByKey = RobloxTranslator:FormatByKey(FFlagGameInviteInExpJoinCta3 and props.titleKey or "Notifications.ToastNotifications.Title.LeavingExperience")

	local formatByKey2 = RobloxTranslator:FormatByKey(FFlagGameInviteInExpJoinCta3 and props.bodyKey or "Notifications.ToastNotifications.Label.LeaveExperienceConfirmation")

	local formatByKey3 = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel")
	local formatByKey4 = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Confirm")
	local createElement = React.createElement
	local v = {
		Active = true,
		BackgroundTransparency = not props.backgroundTransparency and 0.5 or props.backgroundTransparency,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(1, 0, 1, not defineFastFlag and 0 or GuiService.TopbarInset.Height),
		[ReactRoblox.Change.AbsoluteSize] = function(p)
			setState(p.AbsoluteSize)
		end
	}
	local position

	if defineFastFlag then
		position = UDim2.fromOffset(0, -GuiService.TopbarInset.Height)
	end

	v.Position = position
	return createElement("Frame", v, {
		Alert = React.createElement(InteractiveAlert, {
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
						buttonType = ButtonType.PrimarySystem,
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
