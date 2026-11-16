local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")

local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName

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

	local v5 = if fFlagUpdateTranslateInReportRevamp then resolveParams(p2, params) else nil

	local v6 = p2[translate] or translate

	if fFlagUpdateTranslateInReportRevamp and v5 ~= nil then
		v6 = v6:gsub("{(.-)}", v5)
	elseif params ~= nil then
		v6 = v6:gsub("{(.-)}", params)
	end

	return (v6:gsub("{%w+Start}(.-)({%w+End})", "%1"):gsub("{%w+Start}", ""):gsub("{%w+End}", ""))
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
	translateIntoRichTextString = function(p2, value)
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

		local v5 = if fFlagUpdateTranslateInReportRevamp then resolveParams(p2, params) else nil

		local v6 = p2[translate] or translate
		local v7 = nil

		if fFlagUpdateTranslateInReportRevamp and v5 ~= nil then
			v6 = v6:gsub("{(.-)}", v5)
		elseif params ~= nil then
			v6 = v6:gsub("{(.-)}", params)
		end

		if not value.wrappers then
			return v6, v7
		end

		for k, wrapper in pairs(value.wrappers) do
			local v8
			v6, v8 = getWrappedText(wrapper, v6)

			if v8 ~= nil and v7 == nil then
				v7 = v8
			end
		end

		return v6, v7
	end
}
