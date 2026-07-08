local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local ChatLineReporting = require(CorePackages.Workspace.Packages.ChatLineReporting)
local FFlagExpChatPresetChatEnabled = require(CorePackages.Workspace.Packages.ExpChatShared).Flags.FFlagExpChatPresetChatEnabled
local isSystemMessage = ChatLineReporting.Helpers.isSystemMessage
local FFlagEnableGlobalChatAbuseReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableGlobalChatAbuseReporting
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.Components.Types)

local function buildReportTags(n1: number, s1: string, s2: string, s3: string, s4: string?, s5: string?, s6: string?) -- line: 17
	-- upvalues: Constants (copy), FFlagExpChatPresetChatEnabled (copy)
	local t1 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = "in-experience"
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = tostring(n1)
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = s2
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = s3
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = "chat"
				}}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {{
					data = s1
				}}
			},
			VARIANT = {
				valueList = {{
					data = Constants.ChatLineReportingVariant.IGM_CLRv1
				}}
			}
		}
	}

	if s4 then
		t1.tags.REPORT_TARGET_MESSAGE_ID = {
			valueList = {{
				data = s4
			}}
		}
	end

	if FFlagExpChatPresetChatEnabled and s5 and s5 ~= "" then
		t1.tags.REPORT_TARGET_PRESET_ID = {
			valueList = {{
				data = s5
			}}
		}

		if s6 and s6 ~= "" then
			t1.tags.REPORT_TARGET_PRESET_VERSION = {
				valueList = {{
					data = s6
				}}
			}
		end
	end

	return t1
end

return function(t2: {[any]: any}) -- line: 106
	-- upvalues: buildReportTags (copy), FFlagEnableGlobalChatAbuseReporting (copy), isSystemMessage (copy), Players (copy)
	local v19 = buildReportTags(t2.localPlayerUserId, t2.reportTargetUser, t2.abuseReason, t2.abuseDescription, t2.selectedMessage.messageId, t2.selectedMessage.presetId, t2.selectedMessage.presetChatVersion)
	local t3 = {}

	for _, v in ipairs(t2.orderedMessages) do
		if v.userId ~= nil and (v.textChannel ~= nil or FFlagEnableGlobalChatAbuseReporting) then
			local t4 = {
				channel = v.textChannel,
				messageId = v.messageId
			}

			if not isSystemMessage({
				userId = v.userId,
				textChannel = v.textChannel
			}) then
				table.insert(t3, t4)
			end
		end
	end

	local t5 = {{
		channel = t2.selectedMessage.textChannel,
		messageId = t2.selectedMessage.messageId
	}}

	task.defer(function() -- line: 144
		-- upvalues: Players (copy), t3 (copy), t5 (copy), v19 (copy)
		Players:ReportChatAbuse(t3, t5, v19)
	end)
end
