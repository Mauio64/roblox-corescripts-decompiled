local v5 = {
	Radio = "CUSTOM_FORM_FIELD_TYPE_RADIO",
	Checkbox = "CUSTOM_FORM_FIELD_TYPE_CHECKBOX"
}

local function list(p2)
	if type(p2) == "table" then
		return p2
	end

	return {}
end

local function toDefinition(p2, data)
	local v6 = {}
	local result = {}
	local formSpecs = if type(data) == "table" then data.formSpecs else nil
	local sections = if type(formSpecs) == "table" then formSpecs.sections else nil

	for k, v7 in type(sections) ~= "table" and {} or sections do
		local fieldSpecs = v7.fieldSpecs
		local v8 = {}

		for k2, v9 in type(fieldSpecs) ~= "table" and {} or fieldSpecs do
			local options = v9.options
			local v10 = {}

			for k3, v11 in type(options) ~= "table" and {} or options do
				table.insert(v10, { option_id = v11.optionId, label = v11.label })
			end

			local v11 = {
				field_id = v9.fieldId,
				field_type = v5[v9.type],
				label = v9.label,
				options = v10
			}

			table.insert(v8, v11)
			table.insert(result, v11)
		end

		table.insert(v6, { id = v7.id, header = v7.header, fields = v8 })
	end

	local v8 = if type(data) == "table" then data.title else nil
	local v9 = if type(data) == "table" then data.description else nil
	return { form_id = p2, title = v8, description = v9, sections = v6 }, result
end

local function toResults(p2)
	if type(p2) ~= "table" then
		return nil
	end

	local fieldResults = p2.fieldResults
	local v6 = {}

	for k, v7 in type(fieldResults) ~= "table" and {} or fieldResults do
		local optionResults = v7.optionResults
		local v8 = {}

		for k2, v9 in type(optionResults) ~= "table" and {} or optionResults do
			table.insert(v8, {
				option_id = v9.optionId,
				vote_count = v9.voteCount,
				percentage = v9.percentage
			})
		end

		table.insert(v6, { field_id = v7.fieldId, option_results = v8 })
	end

	return { total_responses = p2.totalResponses, field_results = v6 }
end

local function toViewerResponse(p2, items)
	local values = if type(p2) == "table" then p2.values else nil

	if type(values) ~= "table" then
		return nil
	end

	local v6 = {}

	for k, item in items do
		local value = values[item.field_id]

		if type(value) ~= "table" then
			continue
		end

		local set = {}

		if type(value.choiceOptionId) == "string" then
			set[value.choiceOptionId] = true
		end

		local multiChoiceOptionIds = value.multiChoiceOptionIds

		for k2, v7 in type(multiChoiceOptionIds) ~= "table" and {} or multiChoiceOptionIds do
			set[v7] = true
		end

		local option_ids = {}

		for k2, option in item.options do
			if set[option.option_id] then
				table.insert(option_ids, option.option_id)
			end
		end

		if #option_ids > 0 then
			table.insert(v6, { field_id = item.field_id, option_ids = option_ids })
		end
	end

	return { answers = v6 }
end

local function toCustomFormData(p2, data, p3)
	local v6 = if type(data) == "table" then data.form else nil
	local v7, v8 = toDefinition(p2, v6)

	local v10 = if type(data) == "table" then data.userResponse else nil
	local customFormData = {
		form_definition = v7,
		viewer_response = toViewerResponse(v10, v8),
		results = 0,
		is_editable = 0,
		disabled_message = 0
	}
	local v12 = if type(data) == "table" then data.results else nil
	customFormData.results = toResults(v12)
	local v13 = if p3 then p3.is_editable else nil
	customFormData.is_editable = v13
	local v14 = if p3 then p3.disabled_message else nil
	customFormData.disabled_message = v14
	return customFormData
end

return toCustomFormData
