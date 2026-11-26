local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/React")

require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormView")
local CustomFormSelection = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormSelection")

local function isPromise(p2): boolean
	return type(p2) == "table" and type(p2.andThen) == "function"
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

	local v5 = data.response
	local v6 = v5 ~= nil
	local hasInvalidData = data.hasInvalidData == true
	local v7 = data.isSubmitting == true or state4

	if v5 == nil then
		v5 = state
	end

	local errors = data.errors or { fields = {}, form = {} }
	local onSubmit = data.onSubmit
	local v8

	if data.isEditable == true then
		v8 = not (v7 or v6) and not hasInvalidData and type(onSubmit) == "function"
	else
		v8 = false
	end

	local response, v9 = CustomFormSelection.buildResponse(definition, v5)
	local set = {}

	for k, v10 in v9 do
		set[v10] = true
	end

	local testId = data.testId or "--custom-form"

	local function change(p2, p3)
		if v8 then
			setState(function(p4)
				return CustomFormSelection.selectOption(p4, p2, p3)
			end)

			setState3(false)
		end
	end

	local function submit()
		if not v8 then
			return
		end

		setState2(true)

		if response and onSubmit then
			local success, result = pcall(onSubmit, response, ref2.current)
			setState3(not success)

			if success then
				local v10 = type(result) == "table" and type(result.andThen) == "function"

				if v10 then
					ref.current += 1
					local current = ref.current
					setState4(true)
					local function settle()
						if ref.current == current then
							setState4(false)
						end
					end
					local v12 = result:andThen(settle, function()
						if ref.current == current then
							setState4(false)
						end

						if ref.current == current then
							setState3(true)
						end
					end)

					if type(v12) == "table" and type(v12.finally) == "function" then
						v12:finally(settle)
					end
				end
			end
		end
	end

	local results = data.results
	local v10 = {}

	for k, section in definition.sections do
		local v11 = {}

		for k2, field in section.fields do
			local formatted = `{testId}--field-{field.fieldId}`
			local v12 = v5[field.fieldId] or {}
			local v13 = if results then results.fields[field.fieldId] else nil
			local v14 = v6 and v13 ~= nil
			local v15 = field.fieldType == "Radio" and (not v14 and state5 > 0)
			local v16 = {}
			local v17 = ""

			for k3, option in field.options do
				local v18 = v12[option.optionId] == true

				if v18 then
					v17 = option.optionId
				end

				local v19 = v14 and v13 and (v13[option.optionId] or {
						voteCount = "0",
						percentage = 0
					})
					or nil
				local v20 = field
				local v21 = option
				table.insert(v16, {
					optionId = option.optionId,
					label = option.label,
					isChosen = v18,
					result = v19 and { percentage = v19.percentage } or nil,
					onActivated = function()
						local v22 = v20
						local optionId = v21.optionId

						if v8 then
							setState(function(p2)
								return CustomFormSelection.selectOption(p2, v22, optionId)
							end)

							setState3(false)
						end
					end,
					testId = `{formatted}--option-{option.optionId}`
				})
			end

			local v18 = {
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
			local v19 = if field.label ~= definition.title then field.label else nil
			v18.label = v19
			v18.options = v16
			v18.showResults = v14
			v18.rowWidth = if v15 then state5 else nil
			v18.selectedRadio = v17
			local v21 = field

			function v18.onRadioChanged(p2)
				local v22 = v21

				if v8 then
					setState(function(p3)
						return CustomFormSelection.selectOption(p3, v22, p2)
					end)

					setState3(false)
				end
			end
			v18.errors = errors.fields[field.fieldId] or {}

			local v22 = if state2 and set[field.fieldId] and not v6 then data.requiredErrorMessage else nil
			v18.requiredMessage = v22

			v18.testId = formatted
			table.insert(v11, v18)
		end

		table.insert(v10, {
			id = section.id,
			header = section.header,
			fields = v11,
			testId = `{testId}--section-{section.id}`
		})
	end

	local resultsSummary = data.resultsSummary
	local v11 = {
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

	local v12 = if definition.description ~= definition.title then definition.description else nil
	v11.description = v12
	v11.sections = v10
	v11.isEditable = v8
	v11.isSubmitting = v7

	if not v6 or not results or type(resultsSummary) ~= "string" or resultsSummary == "" then
		resultsSummary = nil
	end

	v11.summary = resultsSummary
	local v13 = if data.isEditable ~= true and not v6 then data.disabledMessage else nil
	v11.disabledMessage = v13
	v11.formErrors = errors.form
	local v14 = if hasInvalidData or state3 then data.submissionErrorMessage else nil
	v11.failureMessage = v14
	local v15 = if not v6 then data.submitLabel else nil
	v11.submitLabel = v15
	v11.submitRef = ref2
	v11.onSubmit = submit
	function v11.onSectionsSizeChanged(p2)
		setState5(p2.AbsoluteSize.X)
	end
	v11.viewerUserId = data.viewerUserId
	v11.layoutOrder = data.layoutOrder
	v11.testId = testId
	return v11
end

return useCustomFormViewModel
