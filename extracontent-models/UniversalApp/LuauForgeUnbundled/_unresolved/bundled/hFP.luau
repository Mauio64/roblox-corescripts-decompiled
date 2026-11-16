local EventIngestService = game:GetService("EventIngestService")

local eventIngest = require("@luauforge/bundled/bXw").AnalyticsReporters.EventIngest
local v5 = require("@luauforge/bundled/hFQ").CoreLogger:new("ApiFetchReminderOfNorms")
local module = require("@luauforge/bundled/hFR")
local module2 = require("@luauforge/bundled/hFS")
local module3 = require("@luauforge/bundled/edO")
local module4 = require("@luauforge/bundled/ecV")
local module5 = require("@luauforge/bundled/edP")

local defineFastFlag = game:DefineFastFlag("ReminderAPIFetchErrorLogging", false)

local v6 = eventIngest.new(EventIngestService)

local function verifyReminderOfNormsResponse(data): boolean
	local contentVariant = data.contentVariant

	if
		not contentVariant
		or contentVariant ~= "positive" and contentVariant ~= module2.ContentVariant.ReminderOfNormsWarning
	then
		return false
	end

	if data.policyViolation and data.interventionId and data.reminderNumber and data.experimentVariant then
		return true
	end

	return false
end

local function verifyTextFilterEducationResponse(p2): boolean
	local experimentVariant = p2.experimentVariant

	if
		experimentVariant == module2.ExperimentVariant.ChangeOrBlock
		or experimentVariant == module2.ExperimentVariant.Warning
	then
		return p2.interventionId ~= nil
	end

	return false
end

local function VerifyReminderOfNormsResponse(data): boolean
	local nudgeType = data.nudgeType

	if nudgeType == nil or nudgeType == module2.NudgeType.ReminderOfNorms then
		local contentVariant = data.contentVariant

		if
			not contentVariant
			or contentVariant ~= "positive"
			and contentVariant ~= module2.ContentVariant.ReminderOfNormsWarning
		then
			return false
		end

		if
			data.policyViolation
			and data.interventionId
			and data.reminderNumber
			and data.experimentVariant
		then
			return true
		end

		return false
	else
		if nudgeType ~= module2.NudgeType.TextFilterEducation then
			return false
		end

		local experimentVariant = data.experimentVariant

		if
			experimentVariant == module2.ExperimentVariant.ChangeOrBlock
			or experimentVariant == module2.ExperimentVariant.Warning
		then
			return data.interventionId ~= nil
		end

		return false
	end
end

return function(p2)
	return function(object)
		return module(p2):andThen(function(p3)
			local responseBody = p3.responseBody

			if not (responseBody and responseBody.shouldSurfaceReminder) then
				return module4.resolve()
			end

			local nudgeType = responseBody.nudgeType
			local nudgeType2 = responseBody.nudgeType
			local v7

			if nudgeType2 == nil or nudgeType2 == module2.NudgeType.ReminderOfNorms then
				local contentVariant = responseBody.contentVariant

				if
					contentVariant
					and (contentVariant == "positive" or contentVariant == module2.ContentVariant.ReminderOfNormsWarning)
				then
					v7 = responseBody.policyViolation
						and responseBody.interventionId
						and responseBody.reminderNumber
						and responseBody.experimentVariant
						and true
						or false
				else
					v7 = false
				end
			elseif nudgeType2 == module2.NudgeType.TextFilterEducation then
				local experimentVariant = responseBody.experimentVariant

				if
					experimentVariant == module2.ExperimentVariant.ChangeOrBlock
					or experimentVariant == module2.ExperimentVariant.Warning
				then
					v7 = responseBody.interventionId ~= nil
				else
					v7 = false
				end
			else
				v7 = false
			end

			if not v7 then
				return module4.reject(nil, responseBody)
			end

			object:dispatch(module5(module3.ReminderOfNormsPopup, {
				interventionId = responseBody.interventionId,
				contentVariant = responseBody.contentVariant,
				policyViolation = responseBody.policyViolation,
				reminderNumber = responseBody.reminderNumber,
				experimentVariant = responseBody.experimentVariant,
				nudgeType = nudgeType,
				eventIngest = v6
			}))

			return module4.resolve()
		end):catch(function(p3)
			if defineFastFlag then
				v5:warning("(Moderation) Failed to fetch reminder {}", p3)
			end
		end)
	end
end
