local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local function getEventParameters(p2, p3, items)
	local eventParameters = {
		action = p2,
		context = p3 == nil and "unknown" or p3,
		isInExperience = game.GameId == 0 and "false" or "true"
	}

	if items ~= nil then
		for k, item in items do
			eventParameters[k] = item
		end
	end

	return eventParameters
end

return {
	Action = {
		ArchiveGame = "archive_game",
		AudienceChange = "audience_change",
		ExperienceDetailsSave = "experience_details_save",
		Publish = "publish",
		Share = "share",
		UpdateRating = "update_rating",
		VersionDetailsSave = "version_details_save"
	},
	Context = {
		AudienceBanner = "audience_banner",
		GamesList = "games_list",
		PublishFooter = "publish_footer",
		PublishSnackbar = "publish_snackbar",
		Settings = "settings"
	},
	FailureReason = {
		AccountTooNew = "account_too_new",
		AudienceNotPublic = "audience_not_public",
		ContentUnrated = "content_unrated",
		RatingRequired = "rating_required",
		RequestFailed = "request_failed"
	},
	Stage = {
		RefreshEligibility = "refresh_eligibility",
		RefreshSummary = "refresh_summary",
		SaveAndPublish = "save_and_publish",
		SetAudience = "set_audience"
	},
	getChangedFields = function(p2, p3): string
		if p2 and p3 then
			return "title,description"
		end

		if p2 then
			return "title"
		end

		return "description"
	end,
	sendClick = function(p2, p3, p4, p5)
		sendBuildExperienceEvent("CONFIGURATION_ACTION_CLICK", p3, getEventParameters(p2, p4, p5))
	end,
	sendSuccess = function(p2, p3, p4, p5)
		sendBuildExperienceEvent("CONFIGURATION_ACTION_SUCCESS", p3, getEventParameters(p2, p4, p5))
	end,
	sendFailure = function(p2, p3, data, p4, p5)
		local eventParameters = getEventParameters(p2, p4, p5)
		eventParameters.reason = data.reason
		local stage = data.stage

		if stage ~= nil then
			eventParameters.stage = stage
		end

		local err = if type(data.error) == "table" then data.error else nil
		local responseCode = if err ~= nil then tonumber(err.responseCode) else nil
		local response = if not (err == nil or type(err.response) ~= "table") then err.response else nil

		local statusCode = if response ~= nil then tonumber(response.statusCode) else nil

		if responseCode ~= nil then
			eventParameters.errorCode = tostring(responseCode)
		end

		if statusCode ~= nil then
			eventParameters.httpStatus = tostring(statusCode)
		end

		sendBuildExperienceEvent("CONFIGURATION_ACTION_FAILURE", p3, eventParameters)
	end
}
