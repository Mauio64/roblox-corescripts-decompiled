local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")

local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName

local FFlagAbuseReportTranslateColorWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportTranslateColorWrapper")
local fFlagUpdateTranslateInReportRevamp = SharedFlags.FFlagUpdateTranslateInReportRevamp

local function getWrappedText(wrapper, value)
	local v5 = "{" .. wrapper.type .. "Start}"
	local v6 = "{" .. wrapper.type .. "End}"

	if wrapper.type == "link" then
		if value:find(v5) == nil or value:find(v6) == nil then
			return value, nil
		end

		return
			string.gsub(value, `{v5}(.-){v6}`, "%1 " .. getIconRichText(iconName.ArrowUpRightFromSquare)),
			wrapper
	elseif wrapper.type == "strong" then
		local v7 = string.gsub(value, v5, "<b>")
		return string.gsub(v7, v6, "</b>"), nil
	else
		warn("Unknown wrapper type: " .. tostring(wrapper.type))
		return value, nil
	end
end

local function getWrappedTextByKey(value, wrapper, value2, p2, p3)
	local v5 = string.gsub(value, "%p", "%%%0")
	local v6 = "{" .. v5 .. "Start}"
	local v7 = "{" .. v5 .. "End}"

	if wrapper.type == "link" then
		if value2:find(v6) == nil or value2:find(v7) == nil then
			return value2, nil
		end

		local v8 = (p3 and "<u>%1</u>" or "%1") .. " " .. getIconRichText(iconName.ArrowUpRightFromSquare)

		if wrapper.variant == "link" and p2 then
			v8 = `<font color="{p2}">{v8}</font>`
		end

		return string.gsub(value2, `{v6}(.-){v7}`, v8), wrapper
	else
		if wrapper.type ~= "strong" then
			return value2, nil
		end

		local v8 = string.gsub(value2, v6, "<b>")
		return string.gsub(v8, v7, "</b>"), nil
	end
end

local v5 = FFlagAbuseReportTranslateColorWrapper and "[%w_%.%-]+" or "%w+"
local v6 = "{" .. v5 .. "Start}"
local v7 = "{" .. v5 .. "End}"

local function stripWrapperTags(value)
	return (value:gsub(v6 .. "(.-)(" .. v7 .. ")", "%1"):gsub(v6, ""):gsub(v7, ""))
end

local fn

local function resolveParams(p2, params)
	if params == nil then
		return nil
	end

	local result = {}

	for k, item in pairs(params) do
		if type(item) == "string" then
			result[k] = item
		else
			result[k] = fn(p2, item)
		end
	end

	return result
end

fn = function(p2, item)
	if item == nil then
		return ""
	end

	if type(item) == "string" then
		return item
	end

	local translate = item["$translate"]
	local params = item.params

	local v8 = if fFlagUpdateTranslateInReportRevamp then resolveParams(p2, params) else nil

	local v9 = p2[translate] or translate

	if fFlagUpdateTranslateInReportRevamp and v8 ~= nil then
		v9 = v9:gsub("{(.-)}", v8)
	elseif params ~= nil then
		v9 = v9:gsub("{(.-)}", params)
	end

	return (v9:gsub(v6 .. "(.-)(" .. v7 .. ")", "%1"):gsub(v6, ""):gsub(v7, ""))
end

return {
	mergeTranslationParams = function(value, items)
		if type(value) == "string" then
			return value
		end

		local v5 = {}

		if value.params then
			for k, param in pairs(value.params) do
				v5[k] = param
			end
		end

		for k, item in pairs(items) do
			v5[k] = item
		end

		return {
			["$translate"] = value["$translate"],
			params = v5,
			wrappers = value.wrappers
		}
	end,
	translateIntoString = fn,
	translateIntoRichTextString = function(p2, value, p3, p4)
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

		local v8 = if fFlagUpdateTranslateInReportRevamp then resolveParams(p2, params) else nil

		local v9 = p2[translate] or translate
		local v10 = nil

		if fFlagUpdateTranslateInReportRevamp and v8 ~= nil then
			v9 = v9:gsub("{(.-)}", v8)
		elseif params ~= nil then
			v9 = v9:gsub("{(.-)}", params)
		end

		if FFlagAbuseReportTranslateColorWrapper then
			if value.wrappers then
				for k, wrapper in pairs(value.wrappers) do
					local v11
					v9, v11 = getWrappedTextByKey(k, wrapper, v9, p3, p4)

					if v11 ~= nil and v10 == nil then
						v10 = v11
					end
				end
			end

			return v9:gsub(v6 .. "(.-)(" .. v7 .. ")", "%1"):gsub(v6, ""):gsub(v7, ""), v10
		end

		if not value.wrappers then
			return v9, v10
		end

		for k, wrapper in pairs(value.wrappers) do
			local v11
			v9, v11 = getWrappedText(wrapper, v9)

			if v11 ~= nil and v10 == nil then
				v10 = v11
			end
		end

		return v9, v10
	end
}
