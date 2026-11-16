local parent = script:FindFirstAncestor("CustomForms").Parent
local React = require(parent.React)

require(script.Parent.CustomFormView)
local CustomFormSelection = require(script.Parent.CustomFormSelection)

local function isPromise(result): boolean -- 1 equivalent call inferred from this helper
	return type(result) == "table" and type(result.andThen) == "function"
end

local function useCustomFormViewModel(data)
	local definition = data.definition
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local state4, setState4 = React.useState(false)
	local ref = React.useRef(0)
	React.useEffect(function()
		return function()
			ref.current += 1
		end
	end, {})
	local ref2 = React.useRef(nil)

	local state5, setState5 = React.useState(0)

	local v = data.response
	local v2 = v ~= nil
	local hasInvalidData = data.hasInvalidData == true
	local isSubmitting = data.isSubmitting == true or state4

	if v == nil then
		v = state
	end

	local errors = data.errors or { fields = {}, form = {} }
	local onSubmit = data.onSubmit
	local isEditable

	if data.isEditable == true then
		isEditable = not (isSubmitting or v2) and not hasInvalidData and type(onSubmit) == "function"
	else
		isEditable = false
	end

	local response, v3 = CustomFormSelection.buildResponse(definition, v)
	local set = {}

	for _, v4 in v3 do
		set[v4] = true
	end

	local testId = data.testId or "--custom-form"

	local function change(p, p2: string) -- 2 equivalent calls inferred from this helper
		if isEditable then
			setState(function(p3)
				return CustomFormSelection.selectOption(p3, p, p2)
			end)

			setState3(false)
		end
	end

	local function submit()
		if not isEditable then
			return
		end

		setState2(true)

		if response and onSubmit then
			local success, result = pcall(onSubmit, response, ref2.current)
			setState3(not success)

			if success and isPromise(result) then -- inferred equivalent call
				ref.current += 1
				local current = ref.current
				setState4(true)
				local function settle() -- 1 equivalent call inferred from this helper
					if ref.current == current then
						setState4(false)
					end
				end
				local v4 = result:andThen(settle, function()
					settle() -- inferred equivalent call

					if ref.current == current then
						setState3(true)
					end
				end)

				if type(v4) == "table" and type(v4.finally) == "function" then
					v4:finally(settle)
				end
			end
		end
	end

	local results = data.results
	local sections = {}

	for _, section in definition.sections do
		local fields = {}

		for _, field in section.fields do
			local formatted = `{testId}--field-{field.fieldId}`
			local v4 = v[field.fieldId] or {}
			local v5

			if results then
				v5 = results.fields[field.fieldId]
			end

			local showResults = v2 and v5 ~= nil
			local v6

			if field.fieldType == "Radio" then
				v6 = not showResults and state5 > 0
			else
				v6 = false
			end

			local options = {}
			local selectedRadio = ""

			for _, option in field.options do
				local isChosen = v4[option.optionId] == true

				if isChosen then
					selectedRadio = option.optionId
				end

				local v7 = showResults and v5 and (v5[option.optionId] or {
					voteCount = "0",
					percentage = 0
				}) or nil
				local v8 = field
				local v9 = option
				table.insert(options, {
					optionId = option.optionId,
					label = option.label,
					isChosen = isChosen,
					result = v7 and { percentage = v7.percentage } or nil,
					onActivated = function()
						change(v8, v9.optionId) -- inferred equivalent call
					end,
					testId = `{formatted}--option-{option.optionId}`
				})
			end

			local v7 = {
				fieldId = field.fieldId,
				fieldType = field.fieldType,
				label = 0,
				options = 0,
				showResults = 0,
				rowWidth = 0,
				selectedRadio = 0,
				onRadioChanged = 0,
				errors = 0,
				requiredMessage = 0,
				testId = 0
			}
			local label

			if field.label ~= definition.title then
				label = field.label
			end

			v7.label = label
			v7.options = options
			v7.showResults = showResults
			local rowWidth

			if v6 then
				rowWidth = state5
			end

			v7.rowWidth = rowWidth
			v7.selectedRadio = selectedRadio
			local v8 = field

			function v7.onRadioChanged(p: string)
				change(v8, p) -- inferred equivalent call
			end
			v7.errors = errors.fields[field.fieldId] or {}
			local requiredMessage

			if state2 and set[field.fieldId] and not v2 then
				requiredMessage = data.requiredErrorMessage
			end

			v7.requiredMessage = requiredMessage

			v7.testId = formatted
			table.insert(fields, v7)
		end

		table.insert(sections, {
			id = section.id,
			header = section.header,
			fields = fields,
			testId = `{testId}--section-{section.id}`
		})
	end

	local resultsSummary = data.resultsSummary
	local v4 = {
		title = definition.title,
		description = 0,
		sections = 0,
		isEditable = 0,
		isSubmitting = 0,
		summary = 0,
		disabledMessage = 0,
		formErrors = 0,
		failureMessage = 0,
		submitLabel = 0,
		submitRef = 0,
		onSubmit = 0,
		onSectionsSizeChanged = 0,
		viewerUserId = 0,
		layoutOrder = 0,
		testId = 0
	}
	local description

	if definition.description ~= definition.title then
		description = definition.description
	end

	v4.description = description
	v4.sections = sections
	v4.isEditable = isEditable
	v4.isSubmitting = isSubmitting

	if not v2 or not results or type(resultsSummary) ~= "string" or resultsSummary == "" then
		resultsSummary = nil
	end

	v4.summary = resultsSummary
	local disabledMessage

	if not (data.isEditable == true or v2) then
		disabledMessage = data.disabledMessage
	end

	v4.disabledMessage = disabledMessage
	v4.formErrors = errors.form
	local failureMessage

	if hasInvalidData or state3 then
		failureMessage = data.submissionErrorMessage
	end

	v4.failureMessage = failureMessage
	local submitLabel

	if not v2 then
		submitLabel = data.submitLabel
	end

	v4.submitLabel = submitLabel
	v4.submitRef = ref2
	v4.onSubmit = submit
	function v4.onSectionsSizeChanged(p)
		setState5(p.AbsoluteSize.X)
	end
	v4.viewerUserId = data.viewerUserId
	v4.layoutOrder = data.layoutOrder
	v4.testId = testId
	return v4
end

return useCustomFormViewModel
