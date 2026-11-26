local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/Foundation")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/SduiCoreSystem")
local CustomFormContainer = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormContainer")
local CustomFormSelection = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormSelection")
local SduiCustomFormData = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/SduiCustomFormData")
require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/getSduiCustomFormVerticalRegistry")

local function getViewerUserId()
	local localPlayer = Players.LocalPlayer
	local userId = if localPlayer then localPlayer.UserId else nil

	if userId and userId > 0 then
		return userId
	end

	return nil
end

local function useResultsRefresh(p2, current, duration, current2)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2
	local v5 = type(current) == "function"
	React.useEffect(function()
		if p2 == nil or not v5 or type(duration) ~= "number" or duration <= 0 then
			return nil
		end

		local flag = true
		local thread = nil

		local v6 = false
		local function reportFailure(p3)
			local current3 = ref2.current

			if v6 or not current3 then
				return
			end

			v6 = true
			current3.dependencies.logger.reportError(
				SduiCoreSystem.SduiErrors.SduiErrorType.FailedToExecuteAction,
				{
					componentType = SduiCoreSystem.SduiComponentType.CustomForm,
					propName = "onRefreshResults",
					message = tostring(p3)
				},
				current3.appPage
			)
		end

		local function schedule()
			thread = task.delay(duration, function()
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
					end, function(p3)
						if flag then
							reportFailure(p3)
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

		thread = task.delay(duration, function()
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
				end, function(p3)
					if flag then
						reportFailure(p3)
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
	end, { p2, v5, duration })
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
	local definition, v5 = SduiCustomFormData.readDefinition(props.formDefinition)
	local v6 = props.viewerResponse ~= nil

	local v8 = if definition and v6 then CustomFormSelection.draftKey(definition) else nil
	useResultsRefresh(v8, props.onRefreshResults, props.resultsRefreshIntervalSeconds, props.sduiContext)

	if props.formDefinition == nil or v5 then
		return nil
	end

	if not definition then
		return errorText(props)
	end

	local v9 = if v6 then SduiCustomFormData.readResponse(props.viewerResponse, definition) else nil
	local v10 = if props.results ~= nil then SduiCustomFormData.readResults(props.results, definition) else nil
	local v11 = if v6 and v9 == nil then true else not (props.results == nil) and v10 == nil

	local onSubmit = props.onSubmit
	local sduiContext = props.sduiContext
	local fn = type(onSubmit) == "function" and function(p2, p3)
		local fieldTypesByFieldId = {}

		for k, section in definition.sections do
			for k2, field in section.fields do
				fieldTypesByFieldId[field.fieldId] = field.fieldType
			end
		end

		local v12 = {}

		for k, answer in p2.answers do
			table.insert(v12, {
				fieldId = answer.fieldId,
				fieldType = fieldTypesByFieldId[answer.fieldId],
				optionIds = answer.optionIds
			})
		end

		local success, result = pcall(onSubmit, nil, p3, {
			response = { answers = v12 }
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

	local createElement = React.createElement
	local v13 = {
		definition = definition,
		response = v6 and (v9 or {}) or nil,
		results = v10,
		hasInvalidData = v11,
		isEditable = props.isDisabled == false,
		disabledMessage = props.disabledMessage,
		isSubmitting = props.isSubmitting,
		errors = SduiCustomFormData.readErrors(props.validationErrors, definition, props.submissionErrorMessage or ""),
		submitLabel = props.submitLabel,
		resultsSummary = props.resultsSummary,
		requiredErrorMessage = props.requiredErrorMessage,
		submissionErrorMessage = props.submissionErrorMessage,
		viewerUserId = 0,
		onSubmit = 0,
		layoutOrder = 0,
		testId = 0
	}
	local localPlayer = Players.LocalPlayer
	local userId = if localPlayer then localPlayer.UserId else nil

	if not (userId and userId > 0) then
		userId = nil
	end

	v13.viewerUserId = userId
	v13.onSubmit = fn
	v13.layoutOrder = props.layoutOrder
	v13.testId = props.testId or "--sdui-custom-form"
	return createElement(CustomFormContainer, v13)
end

return React.memo(SduiCustomForm)
