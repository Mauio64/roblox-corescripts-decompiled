local parent = script:FindFirstAncestor("ChatLineReporting").Parent
local ExpChatShared = require(parent.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableChatReportingTextChannelTag = SharedFlags.FFlagEnableChatReportingTextChannelTag

local defineFastFlag = game:DefineFastFlag("ChangePresetTagName", false)

local v = {
	Variant = { CLRv1 = "CLRv1" }
}

function buildReport(p: number, p2: string, p3: string, p4: string, p5: string?, p6: string?, p7: string?, value: string?)
	local report = {
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = "in-experience" }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = tostring(p) }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = p3 }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = p4 }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = "chat" }
				}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {
					{ data = p2 }
				}
			},
			VARIANT = {
				valueList = {
					{ data = v.Variant.CLRv1 }
				}
			}
		}
	}

	if p5 then
		report.tags.REPORT_TARGET_MESSAGE_ID = {
			valueList = {
				{ data = p5 }
			}
		}
	end

	if FFlagExpChatPresetChatEnabled and p6 and p6 ~= "" then
		if defineFastFlag then
			report.tags.PRESET_ID = {
				valueList = {
					{ data = p6 }
				}
			}
		else
			report.tags.REPORT_TARGET_PRESET_ID = {
				valueList = {
					{ data = p6 }
				}
			}
		end

		if p7 and p7 ~= "" then
			if defineFastFlag then
				report.tags.PRESET_CHAT_VERSION = {
					valueList = {
						{ data = p7 }
					}
				}
			else
				report.tags.REPORT_TARGET_PRESET_VERSION = {
					valueList = {
						{ data = p7 }
					}
				}
			end
		end
	end

	if FFlagEnableChatReportingTextChannelTag then
		report.tags.IN_GAME_CHAT_TEXT_CHANNEL = {
			valueList = {
				{
					data = value or "RBXGlobal"
				}
			}
		}
	end

	return report
end

return buildReport
