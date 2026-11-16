return {
	selectOption = function(p2, p3, p4)
		local clone = table.clone(p2)
		local v5 = p3.fieldType == "Radio" and {} or table.clone(p2[p3.fieldId] or {})
		v5[p4] = p3.fieldType == "Radio" or not v5[p4]
		clone[p3.fieldId] = v5
		return clone
	end,
	buildResponse = function(p2, p3)
		local fieldIds = {}
		local v5 = {}

		for k, section in p2.sections do
			for k2, field in section.fields do
				local optionIds = {}

				for k3, option in field.options do
					if (p3[field.fieldId] or {})[option.optionId] then
						table.insert(optionIds, option.optionId)
					end
				end

				if #optionIds == 0 or field.fieldType == "Radio" and #optionIds ~= 1 then
					table.insert(fieldIds, field.fieldId)
				end

				table.insert(v5, { fieldId = field.fieldId, optionIds = optionIds })
			end
		end

		return #fieldIds == 0 and { answers = v5 } or nil, fieldIds
	end,
	draftKey = function(p2)
		local v5 = {}
		local function append(list)
			table.insert(v5, `{#list}:{list}`)
		end
		local formId = p2.formId
		table.insert(v5, `{#formId}:{formId}`)

		local v6 = tostring(#p2.sections)
		table.insert(v5, `{#v6}:{v6}`)

		for k, section in p2.sections do
			local id = section.id
			table.insert(v5, `{#id}:{id}`)

			local v7 = tostring(#section.fields)
			table.insert(v5, `{#v7}:{v7}`)

			for k2, field in section.fields do
				local fieldId = field.fieldId
				table.insert(v5, `{#fieldId}:{fieldId}`)

				local fieldType = field.fieldType
				table.insert(v5, `{#fieldType}:{fieldType}`)

				local v8 = tostring(#field.options)
				table.insert(v5, `{#v8}:{v8}`)

				for k3, option in field.options do
					local optionId = option.optionId
					table.insert(v5, `{#optionId}:{optionId}`)
				end
			end
		end

		return table.concat(v5, ":")
	end
}
