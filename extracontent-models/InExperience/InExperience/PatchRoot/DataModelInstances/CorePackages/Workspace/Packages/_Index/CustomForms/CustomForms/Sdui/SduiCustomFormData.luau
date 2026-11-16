local CustomForms = script:FindFirstAncestor("CustomForms")
require(CustomForms.Form.CustomFormSelection)

local function isId(value): boolean -- 8 equivalent calls inferred from this helper
	return type(value) == "string" and #value > 0
end

local function isOptionalText(value): boolean -- 4 equivalent calls inferred from this helper
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

local function listOrEmpty(p) -- 4 equivalent calls inferred from this helper
	if p == nil then
		return {}
	end

	return p
end

local function fieldType(fieldType2): nil | string -- 1 equivalent call inferred from this helper
	if fieldType2 == 1 or fieldType2 == "CUSTOM_FORM_FIELD_TYPE_RADIO" then
		return "Radio"
	end

	if fieldType2 == 2 or fieldType2 == "CUSTOM_FORM_FIELD_TYPE_CHECKBOX" then
		return "Checkbox"
	end

	return nil
end

local function indexFields(p)
	local fieldsByFieldId = {}

	for _, section in p.sections do
		for _, field in section.fields do
			fieldsByFieldId[field.fieldId] = field
		end
	end

	return fieldsByFieldId
end

local function hasOption(p, optionId: string): boolean -- 2 equivalent calls inferred from this helper
	for _, option in p.options do
		if option.optionId == optionId then
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

		local v = string.gsub(value, "^0+", "")
		local v2 = v == "" and "0" or v

		if #v2 < 19 or #v2 == 19 and v2 <= "9223372036854775807" then
			return v2
		end

		return nil
	end
end

local SduiCustomFormData = {}

function SduiCustomFormData.readDefinition(data)
	if type(data) ~= "table" then
		return nil
	end

	if not (isId(data.formId) and isArray(data.sections)) then -- inferred equivalent call
		return nil
	end

	if not isOptionalText(data.title) then -- inferred equivalent call
		return nil
	end

	if not isOptionalText(data.description) then -- inferred equivalent call
		return nil
	end

	local idSet = {}
	local fieldIdSet = {}
	local count = 0
	local sections = {}

	for _, section in data.sections do
		if type(section) ~= "table" then
			return nil
		end

		if not (isId(section.id) and not idSet[section.id]) then -- inferred equivalent call
			return nil
		end

		if not (isOptionalText(section.header) and isArray(section.fields)) then -- inferred equivalent call
			return nil
		end

		idSet[section.id] = true
		local fields = {}

		for _, field in section.fields do
			if type(field) ~= "table" then
				return nil
			end

			if not (isId(field.fieldId) and not fieldIdSet[field.fieldId]) then -- inferred equivalent call
				return nil
			end

			local fieldType2 = fieldType(field.fieldType) -- inferred equivalent call

			if not fieldType2 then
				return nil, true
			end

			if not isOptionalText(field.label) or not isArray(field.options) or #field.options == 0 then -- inferred equivalent call
				return nil
			end

			fieldIdSet[field.fieldId] = true
			count += 1

			local optionIdSet = {}
			local options = {}

			for _, option in field.options do
				if type(option) ~= "table" then
					return nil
				end

				if isId(option.optionId) and not optionIdSet[option.optionId] then -- inferred equivalent call
					if type(option.label) ~= "string" then
						return nil
					end

					optionIdSet[option.optionId] = true
					table.insert(options, { optionId = option.optionId, label = option.label })
					continue
				end

				return nil
			end

			table.insert(fields, {
				fieldId = field.fieldId,
				fieldType = fieldType2,
				label = field.label,
				options = options
			})
			continue
		end

		table.insert(sections, { id = section.id, header = section.header, fields = fields })
		continue
	end

	if count == 0 then
		return nil
	end

	return {
		formId = data.formId,
		title = data.title,
		description = data.description,
		sections = sections
	}
end

function SduiCustomFormData.readResponse(p, p2)
	if type(p) ~= "table" then
		return nil
	end

	local v = listOrEmpty(p.answers) -- inferred equivalent call

	if not isArray(v) then
		return nil
	end

	local v2 = indexFields(p2)
	local result = {}

	for _, v3 in v do
		if type(v3) ~= "table" then
			return nil
		end

		if not (isId(v3.fieldId) and not result[v3.fieldId]) then -- inferred equivalent call
			return nil
		end

		local v4 = v2[v3.fieldId]

		if
			not v4
			or not isArray(v3.optionIds)
			or #v3.optionIds == 0
			or v4.fieldType == "Radio" and #v3.optionIds ~= 1
		then
			return nil
		end

		local optionIdSet = {}

		for _, optionId in v3.optionIds do
			if isId(optionId) and hasOption(v4, optionId) and not optionIdSet[optionId] then -- inferred equivalent call
				optionIdSet[optionId] = true
				continue
			end

			return nil
		end

		result[v3.fieldId] = optionIdSet
		continue
	end

	return result
end

function SduiCustomFormData.readResults(p, p2)
	if type(p) ~= "table" then
		return nil
	end

	local v = listOrEmpty(p.fieldResults) -- inferred equivalent call

	if not isArray(v) then
		return nil
	end

	local totalResponses = readCount(p.totalResponses == nil and 0 or p.totalResponses)

	if not totalResponses then
		return nil
	end

	local v2 = indexFields(p2)
	local v3 = { totalResponses = totalResponses, fields = {} }

	for _, v4 in v do
		if type(v4) ~= "table" then
			return nil
		end

		if not isId(v4.fieldId) then -- inferred equivalent call
			return nil
		end

		local v5 = v2[v4.fieldId]
		local v6 = listOrEmpty(v4.optionResults) -- inferred equivalent call

		if not v5 or v3.fields[v4.fieldId] or not isArray(v6) then
			return nil
		end

		local v7 = {}

		for _, v8 in v6 do
			if type(v8) ~= "table" then
				return nil
			end

			if not (isId(v8.optionId) and hasOption(v5, v8.optionId)) then -- inferred equivalent call
				return nil
			end

			local voteCount = readCount(v8.voteCount == nil and 0 or v8.voteCount)
			local percentage = v8.percentage == nil and 0 or v8.percentage

			if not voteCount or v7[v8.optionId] or type(percentage) ~= "number" then
				return nil
			end

			if percentage < 0 or percentage > 100 or percentage % 1 ~= 0 then
				return nil
			end

			v7[v8.optionId] = { voteCount = voteCount, percentage = percentage }
			continue
		end

		for _, option in v5.options do
			if not v7[option.optionId] then
				v7[option.optionId] = { voteCount = "0", percentage = 0 }
			end
		end

		v3.fields[v4.fieldId] = v7
		continue
	end

	return v3
end

function SduiCustomFormData.readErrors(p, p2, p3: string)
	local errors = { fields = {}, form = {} }

	if p == nil then
		return errors
	end

	local v

	if type(p) == "table" then
		v = listOrEmpty(p.errors) -- inferred equivalent call
	end

	if not isArray(v) then
		table.insert(errors.form, p3)
		return errors
	end

	local v2 = indexFields(p2)

	for _, v3 in v do
		local v4

		if type(v3) == "table" and type(v3.message) == "string" and v3.message ~= "" then
			v4 = v3.message
		else
			v4 = p3
		end

		local fieldId

		if type(v3) == "table" then
			fieldId = v3.fieldId
		end

		if type(fieldId) == "string" and v2[fieldId] then
			local v5 = errors.fields[fieldId] or {}
			table.insert(v5, v4)
			errors.fields[fieldId] = v5
		else
			table.insert(errors.form, v4)
		end
	end

	return errors
end

return SduiCustomFormData
