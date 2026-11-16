local CustomForms = script:FindFirstAncestor("CustomForms")
local parent = CustomForms.Parent
local Players = game:GetService("Players")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local CustomFormContainer = require(CustomForms.Form.CustomFormContainer)
local CustomFormSelection = require(CustomForms.Form.CustomFormSelection)
local SduiCustomFormData = require(script.Parent.SduiCustomFormData)
require(script.Parent.getSduiCustomFormVerticalRegistry)

local function getViewerUserId() -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer
	local userId

	if localPlayer then
		userId = localPlayer.UserId
	end

	return if userId and userId > 0 then userId else nil
end

local function useResultsRefresh(p: string?, onRefreshResults, resultsRefreshIntervalSeconds, sduiContext)
	local ref = React.useRef(onRefreshResults)
	ref.current = onRefreshResults
	local ref2 = React.useRef(sduiContext)
	ref2.current = sduiContext
	local v = type(onRefreshResults) == "function"
	React.useEffect(function()
		if
			p == nil
			or not v
			or type(resultsRefreshIntervalSeconds) ~= "number"
			or resultsRefreshIntervalSeconds <= 0
		then
			return nil
		end

		local flag = true
		local thread = nil

		local v2 = false
		local function reportFailure(p2)
			local current = ref2.current

			if v2 or not current then
				return
			end

			v2 = true
			current.dependencies.logger.reportError(
				SduiCoreSystem.SduiErrors.SduiErrorType.FailedToExecuteAction,
				{
					componentType = SduiCoreSystem.SduiComponentType.CustomForm,
					propName = "onRefreshResults",
					message = tostring(p2)
				},
				current.appPage
			)
		end

		local function schedule()
			thread = task.delay(resultsRefreshIntervalSeconds, function()
				thread = nil

				if not flag then
					return
				end

				local success, result = pcall(ref.current, nil, nil, nil)

				if success and type(result) == "table" and type(result.andThen) == "function" then
					result:andThen(function()
						if flag then
							schedule()
						end
					end, function(p2)
						if flag then
							reportFailure(p2)
							schedule()
						end
					end)
					return
				end

				if not success then
					reportFailure(result)
				end

				schedule()
			end)
		end

		thread = task.delay(resultsRefreshIntervalSeconds, function()
			thread = nil

			if not flag then
				return
			end

			local success, result = pcall(ref.current, nil, nil, nil)

			if success and type(result) == "table" and type(result.andThen) == "function" then
				result:andThen(function()
					if flag then
						schedule()
					end
				end, function(p2)
					if flag then
						reportFailure(p2)
						schedule()
					end
				end)
				return
			end

			if not success then
				reportFailure(result)
			end

			schedule()
		end)

		return function()
			flag = false

			if thread then
				task.cancel(thread)
			end
		end
	end, { p, v, resultsRefreshIntervalSeconds })
end

local function errorText(props)
	local submissionErrorMessage = props.submissionErrorMessage

	if submissionErrorMessage and submissionErrorMessage ~= "" then
		return (React.createElement(Foundation.Text, {
			Text = submissionErrorMessage,
			LayoutOrder = props.layoutOrder or 0,
			testId = `{props.testId or "--sdui-custom-form"}--error`,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left content-alert"
		}))
	end

	return nil
end

local function SduiCustomForm(props)
	local definition, v = SduiCustomFormData.readDefinition(props.formDefinition)
	local v2 = props.viewerResponse ~= nil
	local v3

	if definition and v2 then
		v3 = CustomFormSelection.draftKey(definition)
	end

	useResultsRefresh(v3, props.onRefreshResults, props.resultsRefreshIntervalSeconds, props.sduiContext)

	if props.formDefinition == nil or v then
		return nil
	end

	if not definition then
		return errorText(props)
	end

	local v4

	if v2 then
		v4 = SduiCustomFormData.readResponse(props.viewerResponse, definition)
	end

	local results

	if props.results ~= nil then
		results = SduiCustomFormData.readResults(props.results, definition)
	end

	local hasInvalidData

	if v2 and v4 == nil then
		hasInvalidData = true
	elseif props.results == nil then
		hasInvalidData = false
	else
		hasInvalidData = results == nil
	end

	local onSubmit = props.onSubmit
	local sduiContext = props.sduiContext
	local fn = type(onSubmit) == "function" and function(p, p2)
		local fieldTypesByFieldId = {}

		for _, section in definition.sections do
			for _, field in section.fields do
				fieldTypesByFieldId[field.fieldId] = field.fieldType
			end
		end

		local answers = {}

		for _, answer in p.answers do
			table.insert(answers, {
				fieldId = answer.fieldId,
				fieldType = fieldTypesByFieldId[answer.fieldId],
				optionIds = answer.optionIds
			})
		end

		local success, result = pcall(onSubmit, nil, p2, {
			response = { answers = answers }
		})

		if not success then
			if sduiContext then
				sduiContext.dependencies.logger.reportError(
					SduiCoreSystem.SduiErrors.SduiErrorType.FailedToExecuteAction,
					{
						componentType = SduiCoreSystem.SduiComponentType.CustomForm,
						propName = "onSubmit",
						message = "CustomForm submit callback failed"
					},
					sduiContext.appPage
				)
			end

			error(result, 0)
		end

		return result
	end or nil

	return React.createElement(CustomFormContainer, {
		definition = definition,
		response = v2 and (v4 or {}) or nil,
		results = results,
		hasInvalidData = hasInvalidData,
		isEditable = props.isDisabled == false,
		disabledMessage = props.disabledMessage,
		isSubmitting = props.isSubmitting,
		errors = SduiCustomFormData.readErrors(props.validationErrors, definition, props.submissionErrorMessage or ""),
		submitLabel = props.submitLabel,
		resultsSummary = props.resultsSummary,
		requiredErrorMessage = props.requiredErrorMessage,
		submissionErrorMessage = props.submissionErrorMessage,
		viewerUserId = getViewerUserId(), -- inferred equivalent call
		onSubmit = fn,
		layoutOrder = props.layoutOrder,
		testId = props.testId or "--sdui-custom-form"
	})
end

return React.memo(SduiCustomForm)
