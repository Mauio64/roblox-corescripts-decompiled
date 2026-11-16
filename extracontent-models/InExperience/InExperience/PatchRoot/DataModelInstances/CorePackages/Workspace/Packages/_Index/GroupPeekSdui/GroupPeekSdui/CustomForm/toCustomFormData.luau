local v = { Radio = "CUSTOM_FORM_FIELD_TYPE_RADIO", Checkbox = "CUSTOM_FORM_FIELD_TYPE_CHECKBOX" }

local function list(p) -- 6 equivalent calls inferred from this helper
	if type(p) == "table" then
		return p
	end

	return {}
end

local function toDefinition(form_id: string, data)
	local sections = {}
	local result = {}
	local formSpecs

	if type(data) == "table" then
		formSpecs = data.formSpecs
	end

	local v2

	if type(formSpecs) == "table" then
		v2 = formSpecs.sections
	end

	for _, v3 in list(v2) do -- inferred equivalent call
		local fields = {}

		for _, v4 in list(v3.fieldSpecs) do -- inferred equivalent call
			local options = {}

			for _, v5 in list(v4.options) do -- inferred equivalent call
				table.insert(options, { option_id = v5.optionId, label = v5.label })
			end

			local v5 = {
				field_id = v4.fieldId,
				field_type = v[v4.type],
				label = v4.label,
				options = options
			}

			table.insert(fields, v5)
			table.insert(result, v5)
		end

		table.insert(sections, { id = v3.id, header = v3.header, fields = fields })
	end

	local title

	if type(data) == "table" then
		title = data.title
	end

	local description

	if type(data) == "table" then
		description = data.description
	end

	return { form_id = form_id, title = title, description = description, sections = sections }, result
end

local function toResults(p)
	if type(p) ~= "table" then
		return nil
	end

	local field_results = {}

	for _, v2 in list(p.fieldResults) do -- inferred equivalent call
		local option_results = {}

		for _, v3 in list(v2.optionResults) do -- inferred equivalent call
			table.insert(option_results, {
				option_id = v3.optionId,
				vote_count = v3.voteCount,
				percentage = v3.percentage
			})
		end

		table.insert(field_results, { field_id = v2.fieldId, option_results = option_results })
	end

	return { total_responses = p.totalResponses, field_results = field_results }
end

local function toViewerResponse(p, items)
	local values

	if type(p) == "table" then
		values = p.values
	end

	if type(values) ~= "table" then
		return nil
	end

	local answers = {}

	for _, item in items do
		local value = values[item.field_id]

		if type(value) ~= "table" then
			continue
		end

		local set = {}

		if type(value.choiceOptionId) == "string" then
			set[value.choiceOptionId] = true
		end

		for _, v2 in list(value.multiChoiceOptionIds) do -- inferred equivalent call
			set[v2] = true
		end

		local option_ids = {}

		for _, option in item.options do
			if set[option.option_id] then
				table.insert(option_ids, option.option_id)
			end
		end

		if #option_ids > 0 then
			table.insert(answers, { field_id = item.field_id, option_ids = option_ids })
		end
	end

	return { answers = answers }
end

local function toCustomFormData(form_id: string, data, p)
	local v2

	if type(data) == "table" then
		v2 = data.form
	end

	local form_definition, v3 = toDefinition(form_id, v2)
	local v4

	if type(data) == "table" then
		v4 = data.userResponse
	end

	local customFormData = {
		form_definition = form_definition,
		viewer_response = toViewerResponse(v4, v3),
		results = 0,
		is_editable = 0,
		disabled_message = 0
	}
	local v5

	if type(data) == "table" then
		v5 = data.results
	end

	customFormData.results = toResults(v5)
	local is_editable

	if p then
		is_editable = p.is_editable
	end

	customFormData.is_editable = is_editable
	local disabled_message

	if p then
		disabled_message = p.disabled_message
	end

	customFormData.disabled_message = disabled_message
	return customFormData
end

return toCustomFormData
