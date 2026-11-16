local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/Promise")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local customFormEntry = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/customFormEntry")
local getSduiCustomFormVerticalRegistry = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/getSduiCustomFormVerticalRegistry")

local function isId(value): boolean
	return type(value) == "string" and value ~= ""
end

local function readAnswers(response)
	if type(response) ~= "table" or type(response.answers) ~= "table" then
		return nil
	end

	local result = {}

	for k, answer in response.answers do
		if type(answer) ~= "table" then
			return nil
		end

		local fieldId = answer.fieldId
		local v5 = type(fieldId) == "string" and fieldId ~= ""

		if not (v5 and type(answer.optionIds) == "table") then
			return nil
		end

		if answer.fieldType ~= "Radio" and answer.fieldType ~= "Checkbox" then
			return nil
		end

		local optionIds = {}

		for k2, optionId in answer.optionIds do
			local v6 = type(optionId) == "string" and optionId ~= ""

			if not v6 then
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

local function reportInvalid(data, p2)
	data.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.SubmitCustomFormResponse, message = p2 },
		data.appPage
	)
	return Promise.reject(p2)
end

local function SduiSubmitCustomFormResponseAction(p2, p3, data)
	local v5 = not (p2 and p2.actionParams) and {} or p2.actionParams
	local v6 = readAnswers(v5.response)
	local configKey = data.configKey

	local entityId = v5.entityId
	local v7 = type(entityId) == "string" and entityId ~= ""

	if v7 then
		local formId = v5.formId
		local v8 = type(formId) == "string" and formId ~= ""

		if v8 then
			local cfVertical = v5.cfVertical
			local v9 = type(cfVertical) == "string" and cfVertical ~= ""

			if v9 and v6 then
				local v10 = type(configKey) == "string" and configKey ~= ""

				if v10 then
					assert(v6 and configKey, "checked above")

					local vertical = getSduiCustomFormVerticalRegistry().getVertical(v5.cfVertical)

					if not vertical then
						return reportInvalid(data, `No CustomForm adapter for cfVertical: {v5.cfVertical}`)
					end

					local v11 = {
						entityId = v5.entityId,
						formId = v5.formId,
						cfVertical = v5.cfVertical,
						answers = v6,
						current = customFormEntry.findForm(configKey, v5.formId)
					}

					local fetchResults = vertical.fetchResults

					return Promise.try(vertical.submit, v11):catch(function(p4)
						data.dependencies.logger.reportError(
							sduiErrorType.FailedToExecuteAction,
							{
								name = sduiActionType.SubmitCustomFormResponse,
								message = tostring(p4)
							},
							data.appPage
						)

						return Promise.reject(p4)
					end):andThen(function()
						if fetchResults then
							return Promise.try(fetchResults, v11):catch(function(p4): nil
								data.dependencies.logger.reportError(
									sduiErrorType.FailedToExecuteAction,
									{
										name = sduiActionType.SubmitCustomFormResponse,
										message = `Results after submit failed: {tostring(p4)}`
									},
									data.appPage
								)
								return nil
							end)
						end

						return nil
					end):andThen(function(p4)
						if p4 ~= nil and not customFormEntry.isFormData(p4, v11.formId) then
							data.dependencies.logger.reportError(
								sduiErrorType.FailedToUpdateDataStores,
								{
									name = sduiActionType.SubmitCustomFormResponse,
									message = `Fresh data for form {v11.formId} is for another form`
								},
								data.appPage
							)
							p4 = nil
						end

						if not customFormEntry.updateForm(configKey, v11.formId, function(p5)
							if p4 ~= nil then
								return p4
							end

							local v12 = {}

							for k, v13 in v6 do
								table.insert(v12, {
									field_id = v13.fieldId,
									option_ids = v13.optionIds
								})
							end

							local clone = table.clone(p5)
							clone.viewer_response = { answers = v12 }
							clone.results = nil
							return clone
						end) then
							data.dependencies.logger.reportError(
								sduiErrorType.FailedToUpdateDataStores,
								{
									name = sduiActionType.SubmitCustomFormResponse,
									message = `No form {v11.formId} under {configKey} to show the response`
								},
								data.appPage
							)
						end
					end)
				end
			end
		end
	end

	return reportInvalid(data, "Missing entityId, formId, cfVertical, response answers, or configKey")
end

return SduiSubmitCustomFormResponseAction
