local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)

local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName

local FFlagAbuseReportTranslateColorWrapper = require(GenericAbuseReporting.Flags.FFlagAbuseReportTranslateColorWrapper)
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

local function getWrappedTextByKey(value: string, wrapper, value2: string, p: string?, flag: boolean?)
	local v = string.gsub(value, "%p", "%%%0")
	local v2 = "{" .. v .. "Start}"
	local v3 = "{" .. v .. "End}"

	if wrapper.type == "link" then
		if value2:find(v2) == nil or value2:find(v3) == nil then
			return value2, nil
		end

		local v4 = (flag and "<u>%1</u>" or "%1") .. " " .. getIconRichText(IconName.ArrowUpRightFromSquare)

		if wrapper.variant == "link" and p then
			v4 = `<font color="{p}">{v4}</font>`
		end

		return string.gsub(value2, `{v2}(.-){v3}`, v4), wrapper
	else
		if wrapper.type ~= "strong" then
			return value2, nil
		end

		local v4 = string.gsub(value2, v2, "<b>")
		return string.gsub(v4, v3, "</b>"), nil
	end
end

local v = FFlagAbuseReportTranslateColorWrapper and "[%w_%.%-]+" or "%w+"
local v2 = "{" .. v .. "Start}"
local v3 = "{" .. v .. "End}"

local function stripWrapperTags(value: string) -- 2 equivalent calls inferred from this helper
	return (value:gsub(v2 .. "(.-)(" .. v3 .. ")", "%1"):gsub(v2, ""):gsub(v3, ""))
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
	local v4

	if FFlagUpdateTranslateInReportRevamp then
		v4 = resolveParams(p, params)
	end

	local v5 = p[translate] or translate

	if FFlagUpdateTranslateInReportRevamp and v4 ~= nil then
		v5 = v5:gsub("{(.-)}", v4)
	elseif params ~= nil then
		v5 = v5:gsub("{(.-)}", params)
	end

	return stripWrapperTags(v5) -- inferred equivalent call
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

function Translate.translateIntoRichTextString(p, value, p2: string?, flag: boolean?)
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
	local v4

	if FFlagUpdateTranslateInReportRevamp then
		v4 = resolveParams(p, params)
	end

	local v5 = p[translate] or translate
	local v6 = nil

	if FFlagUpdateTranslateInReportRevamp and v4 ~= nil then
		v5 = v5:gsub("{(.-)}", v4)
	elseif params ~= nil then
		v5 = v5:gsub("{(.-)}", params)
	end

	if FFlagAbuseReportTranslateColorWrapper then
		if value.wrappers then
			for k, wrapper in pairs(value.wrappers) do
				local v7
				v5, v7 = getWrappedTextByKey(k, wrapper, v5, p2, flag)

				if v7 ~= nil and v6 == nil then
					v6 = v7
				end
			end
		end

		return stripWrapperTags(v5), v6 -- inferred equivalent call
	end

	if not value.wrappers then
		return v5, v6
	end

	for _, wrapper in pairs(value.wrappers) do
		local v7
		v5, v7 = getWrappedText(wrapper, v5)

		if v7 ~= nil and v6 == nil then
			v6 = v7
		end
	end

	return v5, v6
end

return Translate
