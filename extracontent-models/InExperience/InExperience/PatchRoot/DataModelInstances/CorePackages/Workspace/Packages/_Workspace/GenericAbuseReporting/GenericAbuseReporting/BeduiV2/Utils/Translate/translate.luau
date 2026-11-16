local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)

local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName

local FFlagUpdateTranslateInReportRevamp = SharedFlags.FFlagUpdateTranslateInReportRevamp

local function getWrappedText(wrapper, value: string)
	local v = "{" .. wrapper.type .. "Start}"
	local v2 = "{" .. wrapper.type .. "End}"

	if wrapper.type == "link" then
		if value:find(v) == nil or value:find(v2) == nil then
			return value, nil
		end

		return string.gsub(value, `{v}(.-){v2}`, "%1 " .. getIconRichText(IconName.ArrowUpRightFromSquare)), wrapper
	elseif wrapper.type == "strong" then
		local v3 = string.gsub(value, v, "<b>")
		return string.gsub(v3, v2, "</b>"), nil
	else
		warn("Unknown wrapper type: " .. tostring(wrapper.type))
		return value, nil
	end
end

local fn

local function resolveParams(p, params)
	if params == nil then
		return nil
	end

	local result = {}

	for k, item in pairs(params) do
		if type(item) == "string" then
			result[k] = item
		else
			result[k] = fn(p, item)
		end
	end

	return result
end

fn = function(p, item)
	if item == nil then
		return ""
	end

	if type(item) == "string" then
		return item
	end

	local translate = item["$translate"]
	local params = item.params
	local v

	if FFlagUpdateTranslateInReportRevamp then
		v = resolveParams(p, params)
	end

	local v2 = p[translate] or translate

	if FFlagUpdateTranslateInReportRevamp and v ~= nil then
		v2 = v2:gsub("{(.-)}", v)
	elseif params ~= nil then
		v2 = v2:gsub("{(.-)}", params)
	end

	return (v2:gsub("{%w+Start}(.-)({%w+End})", "%1"):gsub("{%w+Start}", ""):gsub("{%w+End}", ""))
end

local Translate = {}

function Translate.mergeTranslationParams(value, items)
	if type(value) == "string" then
		return value
	end

	local params = {}

	if value.params then
		for k, param in pairs(value.params) do
			params[k] = param
		end
	end

	for k, item in pairs(items) do
		params[k] = item
	end

	return { ["$translate"] = value["$translate"], params = params, wrappers = value.wrappers }
end

Translate.translateIntoString = fn

function Translate.translateIntoRichTextString(p, value)
	if value == nil then
		return "", nil
	end

	if type(value) == "string" then
		return value, nil
	end

	if type(value) ~= "table" then
		return tostring(value), nil
	end

	local translate = value["$translate"]

	if not translate or type(translate) ~= "string" then
		return "", nil
	end

	local params = value.params
	local v

	if FFlagUpdateTranslateInReportRevamp then
		v = resolveParams(p, params)
	end

	local v2 = p[translate] or translate
	local v3 = nil

	if FFlagUpdateTranslateInReportRevamp and v ~= nil then
		v2 = v2:gsub("{(.-)}", v)
	elseif params ~= nil then
		v2 = v2:gsub("{(.-)}", params)
	end

	if not value.wrappers then
		return v2, v3
	end

	for _, wrapper in pairs(value.wrappers) do
		local v4
		v2, v4 = getWrappedText(wrapper, v2)

		if v4 ~= nil and v3 == nil then
			v3 = v4
		end
	end

	return v2, v3
end

return Translate
