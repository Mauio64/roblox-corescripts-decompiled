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
	Error = "Error",
	CommentInput = "CommentInput",
	TextChannelSwitch = "TextChannelSwitch",
	EmptyState = "EmptyState",
	SceneCaptureResult = "SceneCaptureResult",
	ConfigLoaded = "ConfigLoaded"
}

local function isArray(t2: {[any]: any}) -- line: 84
	local n1 = 0

	for _ in t2 do
		n1 += 1
	end

	return n1 == #t2 and n1 > 0
end
local function flattenForTelemetry(t3: {[any]: any}) -- line: 97
	local t4 = {}

	for v15, v16 in t3 do
		if type(v16) == "table" then
			local n2 = 0

			for _ in v16 do
				n2 += 1
			end

			if n2 == #v16 and n2 > 0 then
				local t5 = {}

				for _, v21 in v16 do
					table.insert(t5, (tostring(v21)))
				end

				t4[v15] = "[" .. table.concat(t5, ", ") .. "]"
			else
				for v22, v23 in v16 do
					t4[tostring(v22)] = tostring(v23)
				end
			end
		else
			t4[v15] = tostring(v16)
		end
	end

	return t4
end

local t6 = {
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
	sendAnalyticsEvent = function(t7: {[any]: any}, t8: {[any]: any}) -- line: 133
		-- upvalues: FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), LocalPlayer (copy), TelemetryService (copy), t6 (copy), flattenForTelemetry (copy)
		if FFlagFixAnalyticsForDynamicReportV2 then
			local v26 = Dash.join(t7, t8, {
				user_id = LocalPlayer and LocalPlayer.UserId or nil
			})

			TelemetryService:LogEvent(t6, {
				customFields = flattenForTelemetry(v26),
				eventContext = t7.abuse_vector
			})

			return
		end

		TelemetryService:LogEvent(Dash.join(t6, {
			eventContext = t7.abuse_vector
		}), {
			customFields = Dash.join(t7, t8, {
				user_id = LocalPlayer and LocalPlayer.UserId or nil
			})
		})
	end,
	TelemetryEventType = t1
}
