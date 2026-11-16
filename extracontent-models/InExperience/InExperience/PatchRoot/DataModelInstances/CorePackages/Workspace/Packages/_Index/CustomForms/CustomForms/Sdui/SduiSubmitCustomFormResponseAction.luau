local CustomForms = script:FindFirstAncestor("CustomForms")
local parent = CustomForms.Parent

local Promise = require(parent.Promise)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local customFormEntry = require(CustomForms.Sdui.customFormEntry)
local getSduiCustomFormVerticalRegistry = require(CustomForms.Sdui.getSduiCustomFormVerticalRegistry)

local function isId(value): boolean -- 6 equivalent calls inferred from this helper
	return type(value) == "string" and value ~= ""
end

local function readAnswers(response)
	if type(response) ~= "table" or type(response.answers) ~= "table" then
		return nil
	end

	local result = {}

	for _, answer in response.answers do
		if type(answer) ~= "table" then
			return nil
		end

		if not (isId(answer.fieldId) and type(answer.optionIds) == "table") then -- inferred equivalent call
			return nil
		end

		if answer.fieldType ~= "Radio" and answer.fieldType ~= "Checkbox" then
			return nil
		end

		local optionIds = {}

		for _, optionId in answer.optionIds do
			if not isId(optionId) then -- inferred equivalent call
				return nil
			end

			table.insert(optionIds, optionId)
		end

		table.insert(result, {
			fieldId = answer.fieldId,
			fieldType = answer.fieldType,
			optionIds = optionIds
		})
		continue
	end

	return result
end

local function reportInvalid(data, message: string)
	data.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.SubmitCustomFormResponse, message = message },
		data.appPage
	)
	return Promise.reject(message)
end

local function SduiSubmitCustomFormResponseAction(p, _, data)
	local v = not (p and p.actionParams) and {} or p.actionParams
	local answers = readAnswers(v.response)
	local configKey = data.configKey

	if isId(v.entityId) and isId(v.formId) and isId(v.cfVertical) and answers and isId(configKey) then -- inferred equivalent call
		assert(answers and configKey, "checked above")

		local vertical = getSduiCustomFormVerticalRegistry().getVertical(v.cfVertical)

		if not vertical then
			return reportInvalid(data, `No CustomForm adapter for cfVertical: {v.cfVertical}`)
		end

		local v2 = {
			entityId = v.entityId,
			formId = v.formId,
			cfVertical = v.cfVertical,
			answers = answers,
			current = customFormEntry.findForm(configKey, v.formId)
		}

		local fetchResults = vertical.fetchResults

		return Promise.try(vertical.submit, v2):catch(function(p2)
			data.dependencies.logger.reportError(
				SduiErrorType.FailedToExecuteAction,
				{ name = SduiActionType.SubmitCustomFormResponse, message = tostring(p2) },
				data.appPage
			)

			return Promise.reject(p2)
		end):andThen(function()
			if fetchResults then
				return Promise.try(fetchResults, v2):catch(function(p2): nil
					data.dependencies.logger.reportError(
						SduiErrorType.FailedToExecuteAction,
						{
							name = SduiActionType.SubmitCustomFormResponse,
							message = `Results after submit failed: {tostring(p2)}`
						},
						data.appPage
					)
					return nil
				end)
			end

			return nil
		end):andThen(function(p2)
			if p2 ~= nil and not customFormEntry.isFormData(p2, v2.formId) then
				data.dependencies.logger.reportError(
					SduiErrorType.FailedToUpdateDataStores,
					{
						name = SduiActionType.SubmitCustomFormResponse,
						message = `Fresh data for form {v2.formId} is for another form`
					},
					data.appPage
				)
				p2 = nil
			end

			if not customFormEntry.updateForm(configKey, v2.formId, function(p3)
				if p2 ~= nil then
					return p2
				end

				local answers2 = {}

				for _, v3 in answers do
					table.insert(answers2, { field_id = v3.fieldId, option_ids = v3.optionIds })
				end

				local clone = table.clone(p3)
				clone.viewer_response = { answers = answers2 }
				clone.results = nil
				return clone
			end) then
				data.dependencies.logger.reportError(
					SduiErrorType.FailedToUpdateDataStores,
					{
						name = SduiActionType.SubmitCustomFormResponse,
						message = `No form {v2.formId} under {configKey} to show the response`
					},
					data.appPage
				)
			end
		end)
	end

	return reportInvalid(data, "Missing entityId, formId, cfVertical, response answers, or configKey")
end

return SduiSubmitCustomFormResponseAction
