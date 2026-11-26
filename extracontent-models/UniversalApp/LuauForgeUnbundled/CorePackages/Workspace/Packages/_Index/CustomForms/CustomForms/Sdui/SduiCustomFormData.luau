require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormSelection")

local function isId(value): boolean
	return type(value) == "string" and #value > 0
end

local function isOptionalText(value): boolean
	return value == nil or type(value) == "string"
end

local function isArray(list): boolean
	if type(list) ~= "table" then
		return false
	end

	local count = 0

	for k in list do
		if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
			return false
		end

		count += 1
	end

	for i = 1, count do
		if list[i] == nil then
			return false
		end
	end

	return true
end

local function listOrEmpty(p2)
	if p2 == nil then
		return {}
	end

	return p2
end

local function fieldType(p2): nil | string
	if p2 == 1 or p2 == "CUSTOM_FORM_FIELD_TYPE_RADIO" then
		return "Radio"
	end

	if p2 == 2 or p2 == "CUSTOM_FORM_FIELD_TYPE_CHECKBOX" then
		return "Checkbox"
	end

	return nil
end

local function indexFields(p2)
	local fieldsByFieldId = {}

	for k, section in p2.sections do
		for k2, field in section.fields do
			fieldsByFieldId[field.fieldId] = field
		end
	end

	return fieldsByFieldId
end

local function hasOption(p2, p3): boolean
	for k, option in p2.options do
		if option.optionId == p3 then
			return true
		end
	end

	return false
end

local function readCount(value)
	if type(value) == "number" then
		if value < 0 or value > 9007199254740991 or value % 1 ~= 0 then
			return nil
		end

		return string.format("%.0f", value)
	else
		if type(value) ~= "string" or not string.match(value, "^%d+$") then
			return nil
		end

		local v5 = string.gsub(value, "^0+", "")
		local v6 = v5 == "" and "0" or v5

		if #v6 < 19 or #v6 == 19 and v6 <= "9223372036854775807" then
			return v6
		end

		return nil
	end
end

return {
	readDefinition = function(data)
		if type(data) ~= "table" then
			return nil
		end

		local formId = data.formId
		local v5 = type(formId) == "string" and #formId > 0

		if not (v5 and isArray(data.sections)) then
			return nil
		end

		local title = data.title

		if title ~= nil and type(title) ~= "string" then
			return nil
		end

		local description = data.description

		if not (description == nil or type(description) == "string") then
			return nil
		end

		local idSet = {}
		local fieldIdSet = {}
		local count = 0
		local v6 = {}

		for k, section in data.sections do
			if type(section) ~= "table" then
				return nil
			end

			local id = section.id
			local v7 = type(id) == "string" and #id > 0

			if not (v7 and not idSet[section.id]) then
				return nil
			end

			local header = section.header

			if header ~= nil and type(header) ~= "string" or not isArray(section.fields) then
				return nil
			end

			idSet[section.id] = true
			local v8 = {}

			for k2, field in section.fields do
				if type(field) ~= "table" then
					return nil
				end

				local fieldId = field.fieldId
				local v9 = type(fieldId) == "string" and #fieldId > 0

				if not (v9 and not fieldIdSet[field.fieldId]) then
					return nil
				end

				local fieldType2 = field.fieldType
				local v10 = (fieldType2 == 1 or fieldType2 == "CUSTOM_FORM_FIELD_TYPE_RADIO") and "Radio"
					or (fieldType2 == 2 or fieldType2 == "CUSTOM_FORM_FIELD_TYPE_CHECKBOX") and "Checkbox"
					or nil

				if not v10 then
					return nil, true
				end

				local label = field.label

				if
					label ~= nil and type(label) ~= "string"
					or not isArray(field.options)
					or #field.options == 0
				then
					return nil
				end

				fieldIdSet[field.fieldId] = true
				count += 1

				local optionIdSet = {}
				local v11 = {}

				for k3, option in field.options do
					if type(option) ~= "table" then
						return nil
					end

					local optionId = option.optionId
					local v12 = type(optionId) == "string" and #optionId > 0

					if v12 and not optionIdSet[option.optionId] then
						if type(option.label) ~= "string" then
							return nil
						end

						optionIdSet[option.optionId] = true
						table.insert(v11, {
							optionId = option.optionId,
							label = option.label
						})
						continue
					end

					return nil
				end

				table.insert(v8, {
					fieldId = field.fieldId,
					fieldType = v10,
					label = field.label,
					options = v11
				})
				continue
			end

			table.insert(v6, { id = section.id, header = section.header, fields = v8 })
			continue
		end

		if count == 0 then
			return nil
		end

		return {
			formId = data.formId,
			title = data.title,
			description = data.description,
			sections = v6
		}
	end,
	readResponse = function(p2, p3)
		if type(p2) ~= "table" then
			return nil
		end

		local answers = p2.answers
		local v5 = answers == nil and {} or answers

		if not isArray(v5) then
			return nil
		end

		local v6 = indexFields(p3)
		local result = {}

		for k, v7 in v5 do
			if type(v7) ~= "table" then
				return nil
			end

			local fieldId = v7.fieldId
			local v8 = type(fieldId) == "string" and #fieldId > 0

			if not (v8 and not result[v7.fieldId]) then
				return nil
			end

			local v9 = v6[v7.fieldId]

			if
				not v9
				or not isArray(v7.optionIds)
				or #v7.optionIds == 0
				or v9.fieldType == "Radio" and #v7.optionIds ~= 1
			then
				return nil
			end

			local optionIdSet = {}

			for k2, optionId in v7.optionIds do
				local v10 = type(optionId) == "string" and #optionId > 0

				if not v10 then
					return nil
				end

				local flag = true
				local v11

				for k3, option in v9.options do
					if option.optionId == optionId then
						v11 = true
						flag = false
						break
					end
				end

				if flag then
					v11 = false
				end

				if v11 and not optionIdSet[optionId] then
					optionIdSet[optionId] = true
					continue
				end

				return nil
			end

			result[v7.fieldId] = optionIdSet
			continue
		end

		return result
	end,
	readResults = function(p2, p3)
		if type(p2) ~= "table" then
			return nil
		end

		local fieldResults = p2.fieldResults
		local v5 = fieldResults == nil and {} or fieldResults

		if not isArray(v5) then
			return nil
		end

		local v6 = readCount(p2.totalResponses == nil and 0 or p2.totalResponses)

		if not v6 then
			return nil
		end

		local v7 = indexFields(p3)
		local v8 = { totalResponses = v6, fields = {} }

		for k, v9 in v5 do
			if type(v9) ~= "table" then
				return nil
			end

			local fieldId = v9.fieldId
			local v10 = type(fieldId) == "string" and #fieldId > 0

			if not v10 then
				return nil
			end

			local v11 = v7[v9.fieldId]
			local optionResults = v9.optionResults
			local v12 = optionResults == nil and {} or optionResults

			if not v11 or v8.fields[v9.fieldId] or not isArray(v12) then
				return nil
			end

			local v13 = {}

			for k2, v14 in v12 do
				if type(v14) ~= "table" then
					return nil
				end

				local optionId = v14.optionId
				local v15 = type(optionId) == "string" and #optionId > 0

				if not v15 then
					return nil
				end

				local optionId2 = v14.optionId
				local flag = true
				local flag2

				for k3, option in v11.options do
					if option.optionId == optionId2 then
						flag2 = true
						flag = false
						break
					end
				end

				if flag then
					flag2 = false
				end

				if flag2 then
					local v16 = readCount(v14.voteCount == nil and 0 or v14.voteCount)
					local v17 = v14.percentage == nil and 0 or v14.percentage

					if not v16 or v13[v14.optionId] or type(v17) ~= "number" then
						return nil
					end

					if v17 < 0 or v17 > 100 or v17 % 1 ~= 0 then
						return nil
					end

					v13[v14.optionId] = { voteCount = v16, percentage = v17 }
					continue
				end

				return nil
			end

			for k2, option in v11.options do
				if not v13[option.optionId] then
					v13[option.optionId] = { voteCount = "0", percentage = 0 }
				end
			end

			v8.fields[v9.fieldId] = v13
			continue
		end

		return v8
	end,
	readErrors = function(p2, p3, p4)
		local errors = { fields = {}, form = {} }

		if p2 == nil then
			return errors
		end

		local v5

		if type(p2) == "table" then
			local errors2 = p2.errors
			v5 = errors2 == nil and {} or errors2
		end

		if not isArray(v5) then
			table.insert(errors.form, p4)
			return errors
		end

		local v6 = indexFields(p3)

		for k, v7 in v5 do
			local v8

			if type(v7) == "table" and type(v7.message) == "string" and v7.message ~= "" then
				v8 = v7.message
			else
				v8 = p4
			end

			local fieldId = if type(v7) == "table" then v7.fieldId else nil

			if type(fieldId) == "string" and v6[fieldId] then
				local v9 = errors.fields[fieldId] or {}
				table.insert(v9, v8)
				errors.fields[fieldId] = v9
			else
				table.insert(errors.form, v8)
			end
		end

		return errors
	end
}
