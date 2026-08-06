local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")
local Dash = require(GenericAbuseReportingParent.Dash)
local FFlagAbuseReportClientVersion = require(GenericAbuseReporting.Flags.FFlagAbuseReportClientVersion)
local FFlagFixAnalyticsForDynamicReportV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagFixAnalyticsForDynamicReportV2
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
local t3 = {
	Flow = "flow",
	SceneSelection = "sceneSelection"
}

local function isArray(t4: {[any]: any}) -- line: 107
	local n1 = 0

	for _ in t4 do
		n1 += 1
	end

	return n1 == #t4 and n1 > 0
end
local function flattenForTelemetry(t5: {[any]: any}) -- line: 120
	local t6 = {}

	for v25, v26 in t5 do
		if type(v26) == "table" then
			local n2 = 0

			for _ in v26 do
				n2 += 1
			end

			if n2 == #v26 and n2 > 0 then
				local t7 = {}

				for _, v31 in v26 do
					table.insert(t7, (tostring(v31)))
				end

				t6[v25] = "[" .. table.concat(t7, ", ") .. "]"
			else
				for v32, v33 in v26 do
					t6[tostring(v32)] = tostring(v33)
				end
			end
		else
			t6[v25] = tostring(v26)
		end
	end

	return t6
end

local t8 = {
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

local function getCoreScriptVersion() -- line: 162
	-- upvalues: RunService (copy)
	if not game:GetEngineFeature("CoreScriptVersionEnabled") then
		return nil
	end

	local ok, result = pcall(function() -- line: 167
		-- upvalues: RunService (copy)
		return RunService:GetCoreScriptVersion()
	end)

	if ok then
		return result
	end

	return nil
end

local v16

if FFlagAbuseReportClientVersion then
	if not game:GetEngineFeature("CoreScriptVersionEnabled") then
		v16 = nil
	else
		local ok, result = pcall(function() -- line: 167
			-- upvalues: RunService (copy)
			return RunService:GetCoreScriptVersion()
		end)

		v16 = if not ok then nil else result
	end
else
	v16 = nil
end

local v19 = v16

return {
	sendAnalyticsEvent = function(t9: {[any]: any}, t10: {[any]: any}) -- line: 176
		-- upvalues: LocalPlayer (copy), FFlagAbuseReportClientVersion (copy), v19 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), TelemetryService (copy), t8 (copy), flattenForTelemetry (copy)
		local t11 = {
			user_id = LocalPlayer and LocalPlayer.UserId or nil
		}

		if FFlagAbuseReportClientVersion then
			t11.client_version = v19
		end

		if FFlagFixAnalyticsForDynamicReportV2 then
			local v39 = Dash.join(t9, t10, t11)

			TelemetryService:LogEvent(t8, {
				customFields = flattenForTelemetry(v39),
				eventContext = t9.abuse_vector
			})

			return
		end

		TelemetryService:LogEvent(Dash.join(t8, {
			eventContext = t9.abuse_vector
		}), {
			customFields = Dash.join(t9, t10, t11)
		})
	end,
	TelemetryEventType = t1,
	LinkOpenedSource = t2,
	SubmitSource = t3
}
