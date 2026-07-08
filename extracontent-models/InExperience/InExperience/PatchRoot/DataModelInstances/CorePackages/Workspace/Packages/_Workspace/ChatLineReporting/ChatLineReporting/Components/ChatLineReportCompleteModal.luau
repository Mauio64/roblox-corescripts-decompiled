local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local React = require(ChatLineReportingParent.React)
local ExpChatShared = require(ChatLineReportingParent.ExpChatShared)
local ButtonType = require(ChatLineReportingParent.UIBlox).App.Button.Enum.ButtonType
local ReportCompleteDialog = require(ChatLineReportingParent.GenericAbuseReporting.ReportCompleteDialog)
local LocalPlayer = game:GetService("Players").LocalPlayer
local useLocalization = require(ChatLineReportingParent.Localization).Hooks.useLocalization
local Constants = require(ChatLineReporting.Common.Constants)
local getDisplayNameFromUserId = require(ChatLineReporting.Common.getDisplayNameFromUserId)
local getPlayer = require(ChatLineReporting.Common.getPlayer)
local mutePlayer = require(ChatLineReporting.Common.mutePlayer)
local sendSystemMessage = require(ChatLineReporting.Common.sendSystemMessage)

local function ChatLineReportCompleteModal(t1: {[any]: any}) -- line: 40
	-- upvalues: ExpChatShared (copy), useLocalization (copy), getPlayer (copy), getDisplayNameFromUserId (copy), ButtonType (copy), React (copy), ReportCompleteDialog (copy), LocalPlayer (copy), mutePlayer (copy), Constants (copy), sendSystemMessage (copy)
	local context = ExpChatShared.context
	local v17 = useLocalization(t1.localizationKeys)
	local u18 = nil

	if context.store then
		u18 = getPlayer(context.store:getState().Players.byUserId, t1.selectedMessage.userId)

		if u18 == nil then
			u18 = {
				username = "",
				displayName = getDisplayNameFromUserId(t1.selectedMessage.userId),
				userId = t1.selectedMessage.userId
			}
		end
	end

	local v19 = useLocalization({
		completeMute = {
			"Feature.ReportAbuse.Action.TextMute",
			name = u18 and u18.displayName or ""
		},
		systemMuteMessage = {
			"Feature.ReportAbuse.Message.UserTextMutedSystem",
			name = u18 and u18.displayName or ""
		}
	})
	local t2 = {
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = function() -- line: 67
				-- upvalues: t1 (copy)
				t1.onDismiss(nil, "")
			end,
			text = v17.completeClose
		}
	}

	return React.createElement(ReportCompleteDialog, {
		buttonStackInfo = {
			forceFillDirection = Enum.FillDirection.Vertical,
			buttons = if not LocalPlayer then { t2 } else {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = function() -- line: 82
							-- upvalues: mutePlayer (copy), u18 (ref), LocalPlayer (copy), t1 (copy), Constants (copy), sendSystemMessage (copy), v19 (copy)
							local v21 = mutePlayer(u18, LocalPlayer, t1.selectedMessage.isUniverseChat)

							if v21 and v21.key == Constants.SuccessfulMuteKey then
								sendSystemMessage(v19.systemMuteMessage)
							end

							t1.onDismiss(v21)
						end,
						text = v19.completeMute
					}
				},
				t2
			}
		},
		localizationKeys = t1.localizationKeys,
		onDismiss = function() -- line: 98
			-- upvalues: t1 (copy)
			t1.onDismiss(nil, "")
		end
	})
end

return ChatLineReportCompleteModal
