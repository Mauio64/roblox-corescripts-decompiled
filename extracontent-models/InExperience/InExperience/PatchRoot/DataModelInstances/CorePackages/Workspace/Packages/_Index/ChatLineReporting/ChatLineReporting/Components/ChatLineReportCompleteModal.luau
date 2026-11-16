local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent

local React = require(parent.React)
local ExpChatShared = require(parent.ExpChatShared)
local UIBlox = require(parent.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ReportCompleteDialog = require(parent.GenericAbuseReporting.ReportCompleteDialog)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Constants = require(ChatLineReporting.Common.Constants)
local getDisplayNameFromUserId = require(ChatLineReporting.Common.getDisplayNameFromUserId)
local getPlayer = require(ChatLineReporting.Common.getPlayer)
local mutePlayer = require(ChatLineReporting.Common.mutePlayer)
local sendSystemMessage = require(ChatLineReporting.Common.sendSystemMessage)

local function ChatLineReportCompleteModal(props)
	local context = ExpChatShared.context
	local v = useLocalization(props.localizationKeys)
	local v2

	if context.store then
		local player = getPlayer(context.store:getState().Players.byUserId, props.selectedMessage.userId)
		v2 = player == nil
			and {
				displayName = getDisplayNameFromUserId(props.selectedMessage.userId),
				userId = props.selectedMessage.userId,
				username = ""
			}
			or player
	else
		v2 = nil
	end

	local v3 = useLocalization({
		completeMute = {
			"Feature.ReportAbuse.Action.TextMute",
			name = v2 and v2.displayName or ""
		},
		systemMuteMessage = {
			"Feature.ReportAbuse.Message.UserTextMutedSystem",
			name = v2 and v2.displayName or ""
		}
	})

	local v4 = {
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = function()
				props.onDismiss(nil, "")
			end,
			text = v.completeClose
		}
	}

	local createElement = React.createElement
	local buttonStackInfo = { forceFillDirection = Enum.FillDirection.Vertical, buttons = 0 }
	local buttons

	if LocalPlayer then
		buttons = {
			{
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = function()
						local v5 = mutePlayer(v2, LocalPlayer, props.selectedMessage.isUniverseChat)

						if v5 and v5.key == Constants.SuccessfulMuteKey then
							sendSystemMessage(v3.systemMuteMessage)
						end

						props.onDismiss(v5)
					end,
					text = v3.completeMute
				}
			},
			v4
		}
	else
		buttons = { v4 }
	end

	buttonStackInfo.buttons = buttons
	return createElement(ReportCompleteDialog, {
		buttonStackInfo = buttonStackInfo,
		localizationKeys = props.localizationKeys,
		onDismiss = function()
			props.onDismiss(nil, "")
		end
	})
end

return ChatLineReportCompleteModal
