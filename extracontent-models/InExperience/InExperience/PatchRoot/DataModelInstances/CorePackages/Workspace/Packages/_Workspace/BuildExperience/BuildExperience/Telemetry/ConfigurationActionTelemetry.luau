local BuildExperience = script:FindFirstAncestor("BuildExperience")

local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local function getEventParameters(action: string, p: string?, items)
	local eventParameters = {
		action = action,
		context = p == nil and "unknown" or p,
		isInExperience = game.GameId == 0 and "false" or "true"
	}

	if items ~= nil then
		for k, item in items do
			eventParameters[k] = item
		end
	end

	return eventParameters
end

local ConfigurationActionTelemetry = {}
ConfigurationActionTelemetry.Action = {
	ArchiveGame = "archive_game",
	AudienceChange = "audience_change",
	ExperienceDetailsSave = "experience_details_save",
	Publish = "publish",
	Share = "share",
	UpdateRating = "update_rating",
	VersionDetailsSave = "version_details_save"
}

ConfigurationActionTelemetry.Context = {
	AudienceBanner = "audience_banner",
	GamesList = "games_list",
	PublishFooter = "publish_footer",
	PublishSnackbar = "publish_snackbar",
	Settings = "settings"
}
ConfigurationActionTelemetry.FailureReason = {
	AccountTooNew = "account_too_new",
	AudienceNotPublic = "audience_not_public",
	ContentUnrated = "content_unrated",
	RatingRequired = "rating_required",
	RequestFailed = "request_failed"
}
ConfigurationActionTelemetry.Stage = {
	RefreshEligibility = "refresh_eligibility",
	RefreshSummary = "refresh_summary",
	SaveAndPublish = "save_and_publish",
	SetAudience = "set_audience"
}

function ConfigurationActionTelemetry.getChangedFields(flag: boolean, flag2: boolean): string
	if flag and flag2 then
		return "title,description"
	end

	return if flag then "title" else "description"
end

function ConfigurationActionTelemetry.sendClick(action: string, p, p2: string?, p3)
	sendBuildExperienceEvent("CONFIGURATION_ACTION_CLICK", p, getEventParameters(action, p2, p3))
end

function ConfigurationActionTelemetry.sendSuccess(action: string, p, p2: string?, p3)
	sendBuildExperienceEvent("CONFIGURATION_ACTION_SUCCESS", p, getEventParameters(action, p2, p3))
end

function ConfigurationActionTelemetry.sendFailure(action: string, p, data, p2: string?, p3)
	local eventParameters = getEventParameters(action, p2, p3)
	eventParameters.reason = data.reason
	local stage = data.stage

	if stage ~= nil then
		eventParameters.stage = stage
	end

	local err

	if type(data.error) == "table" then
		err = data.error
	end

	local responseCode

	if err ~= nil then
		responseCode = tonumber(err.responseCode)
	end

	local response

	if not (err == nil or type(err.response) ~= "table") then
		response = err.response
	end

	local statusCode

	if response ~= nil then
		statusCode = tonumber(response.statusCode)
	end

	if responseCode ~= nil then
		eventParameters.errorCode = tostring(responseCode)
	end

	if statusCode ~= nil then
		eventParameters.httpStatus = tostring(statusCode)
	end

	sendBuildExperienceEvent("CONFIGURATION_ACTION_FAILURE", p, eventParameters)
end

return ConfigurationActionTelemetry
