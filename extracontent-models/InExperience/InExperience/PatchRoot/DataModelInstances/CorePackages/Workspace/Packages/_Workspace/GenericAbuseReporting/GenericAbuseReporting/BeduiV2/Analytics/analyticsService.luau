local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local LocalPlayer = game:GetService("Players").LocalPlayer
local TelemetryService = game:GetService("TelemetryService")
local Dash = require(Parent.Dash)
local FFlagFixAnalyticsForDynamicReportV2 = require(Parent.SharedFlags).FFlagFixAnalyticsForDynamicReportV2
local t1 = {
	ReportStarted = "OpenDialog",
	ReportAbandoned = "EarlyClose",
	ReportCompleted = "Close",
	Submit = "Submit",
	SubmitSuccess = "SubmitSuccess",
	SubmitFail = "SubmitFail",
	BackAction = "BackAction",
	NodeDone = "NodeDone",
	SelectItem = "SelectItem",
	IsUserBlockAvailable = "IsUserBlockAvailable",
	IsUserMuteAvailable = "IsUserMuteAvailable",
	DidBlockUser = "DidBlockUser",
	DidUnblockUser = "DidUnblockUser",
	DidMuteUser = "DidMuteUser",
	HelplineShown = "HelplineShown",
	HelplineOpened = "HelplineOpened",
	LinkOpened = "LinkOpened",
	Error = "Error",
	CommentInput = "CommentInput",
	TextChannelSwitch = "TextChannelSwitch",
	EmptyState = "EmptyState",
	SceneCaptureResult = "SceneCaptureResult",
	ConfigLoaded = "ConfigLoaded"
}
local t2 = {
	Footer = "footer",
	NextAction = "next_action"
}

local function isArray(t3: {[any]: any}) -- line: 92
	local n1 = 0

	for _ in t3 do
		n1 += 1
	end

	return n1 == #t3 and n1 > 0
end
local function flattenForTelemetry(t4: {[any]: any}) -- line: 105
	local t5 = {}

	for v16, v17 in t4 do
		if type(v17) == "table" then
			local n2 = 0

			for _ in v17 do
				n2 += 1
			end

			if n2 == #v17 and n2 > 0 then
				local t6 = {}

				for _, v22 in v17 do
					table.insert(t6, (tostring(v22)))
				end

				t5[v16] = "[" .. table.concat(t6, ", ") .. "]"
			else
				for v23, v24 in v17 do
					t5[tostring(v23)] = tostring(v24)
				end
			end
		else
			t5[v16] = tostring(v17)
		end
	end

	return t5
end

local t7 = {
	eventName = "DynamicAbuseReportEventV2",
	description = "Event to track dynamic abuse report v2",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8782",
	lastUpdated = {
		2026,
		5,
		20
	},
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("DynamicAbuseReportV2ThrottleHundredthsPercent", 0)
}

return {
	sendAnalyticsEvent = function(t8: {[any]: any}, t9: {[any]: any}) -- line: 141
		-- upvalues: FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), LocalPlayer (copy), TelemetryService (copy), t7 (copy), flattenForTelemetry (copy)
		if FFlagFixAnalyticsForDynamicReportV2 then
			local v27 = Dash.join(t8, t9, {
				user_id = LocalPlayer and LocalPlayer.UserId or nil
			})

			TelemetryService:LogEvent(t7, {
				customFields = flattenForTelemetry(v27),
				eventContext = t8.abuse_vector
			})

			return
		end

		TelemetryService:LogEvent(Dash.join(t7, {
			eventContext = t8.abuse_vector
		}), {
			customFields = Dash.join(t8, t9, {
				user_id = LocalPlayer and LocalPlayer.UserId or nil
			})
		})
	end,
	TelemetryEventType = t1,
	LinkOpenedSource = t2
}
