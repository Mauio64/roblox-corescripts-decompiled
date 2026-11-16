local CustomFormSelection = {}

function CustomFormSelection.selectOption(p, p2, p3: string)
	local clone = table.clone(p)
	local v = p2.fieldType == "Radio" and {} or table.clone(p[p2.fieldId] or {})
	v[p3] = p2.fieldType == "Radio" or not v[p3]
	clone[p2.fieldId] = v
	return clone
end

function CustomFormSelection.buildResponse(p, p2)
	local fieldIds = {}
	local answers = {}

	for _, section in p.sections do
		for _, field in section.fields do
			local optionIds = {}

			for _, option in field.options do
				if (p2[field.fieldId] or {})[option.optionId] then
					table.insert(optionIds, option.optionId)
				end
			end

			if #optionIds == 0 or field.fieldType == "Radio" and #optionIds ~= 1 then
				table.insert(fieldIds, field.fieldId)
			end

			table.insert(answers, { fieldId = field.fieldId, optionIds = optionIds })
		end
	end

	return #fieldIds == 0 and { answers = answers } or nil, fieldIds
end

function CustomFormSelection.draftKey(p)
	local v = {}
	local function append(list: string) -- 8 equivalent calls inferred from this helper
		table.insert(v, `{#list}:{list}`)
	end
	append(p.formId) -- inferred equivalent call
	append(tostring(#p.sections)) -- inferred equivalent call

	for _, section in p.sections do
		append(section.id) -- inferred equivalent call
		append(tostring(#section.fields)) -- inferred equivalent call

		for _, field in section.fields do
			append(field.fieldId) -- inferred equivalent call
			append(field.fieldType) -- inferred equivalent call
			append(tostring(#field.options)) -- inferred equivalent call

			for _, option in field.options do
				append(option.optionId) -- inferred equivalent call
			end
		end
	end

	return table.concat(v, ":")
end

return CustomFormSelection
