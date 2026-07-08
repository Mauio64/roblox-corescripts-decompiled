local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local FFlagExpChatPresetChatEnabled = require(ChatLineReportingParent.ExpChatShared).Flags.FFlagExpChatPresetChatEnabled
local FFlagChatLineReportingMessageIdEnabled = require(ChatLineReporting.Flags.FFlagChatLineReportingMessageIdEnabled)
local t1 = {
	Variant = {
		CLRv1 = "CLRv1"
	}
}

function buildReport(n1: number, s1: string, s2: string, s3: string, s4: string?, s5: string?, s6: string?) -- line: 13
	-- upvalues: t1 (copy), FFlagChatLineReportingMessageIdEnabled (copy), FFlagExpChatPresetChatEnabled (copy)
	local t2 = {
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
					data = t1.Variant.CLRv1
				}}
			}
		}
	}

	if FFlagChatLineReportingMessageIdEnabled and s4 then
		t2.tags.REPORT_TARGET_MESSAGE_ID = {
			valueList = {{
				data = s4
			}}
		}
	end

	if FFlagExpChatPresetChatEnabled and s5 and s5 ~= "" then
		t2.tags.REPORT_TARGET_PRESET_ID = {
			valueList = {{
				data = s5
			}}
		}

		if s6 and s6 ~= "" then
			t2.tags.REPORT_TARGET_PRESET_VERSION = {
				valueList = {{
					data = s6
				}}
			}
		end
	end

	return t2
end

return buildReport
