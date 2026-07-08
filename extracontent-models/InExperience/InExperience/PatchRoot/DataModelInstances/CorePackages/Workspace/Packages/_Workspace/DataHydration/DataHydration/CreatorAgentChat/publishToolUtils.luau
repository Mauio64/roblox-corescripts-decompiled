local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local t1 = {
	"studio_save_and_publish",
	"cas_save_and_publish",
	"save_and_publish"
}
local t2 = {}

for _, v5 in t1 do
	local v6 = string.gsub(v5, "[_%-%s]", "")

	t2[string.lower(v6)] = true
end

local t3 = {
	save_and_publish = true,
	cas_save_and_publish = true,
	studio_save_and_publish = true
}

local function normalizeToolIdentifier(s1: string) -- line: 40
	local v18 = string.gsub(s1, "[_%-%s]", "")

	return string.lower(v18)
end
local function identifierMatchesPublish(s2: string) -- line: 45
	-- upvalues: t2 (copy)
	local v20 = string.gsub(s2, "[_%-%s]", "")
	local v21 = string.lower(v20)

	if t2[v21] then
		return true
	end

	return string.find(v21, "publishplace", 1, true) ~= nil
end
local function valueLooksLikePublishTool(p1) -- line: 53
	-- upvalues: t2 (copy)
	local v23 = false

	if typeof(p1) == "string" then
		v23 = false

		if p1 ~= "" then
			local v24 = string.gsub(p1, "[_%-%s]", "")
			local v25 = string.lower(v24)

			if t2[v25] then
				return true
			end

			v23 = string.find(v25, "publishplace", 1, true) ~= nil
		end
	end

	return v23
end
local function isSaveAndPublishValue(p2) -- line: 57
	-- upvalues: t3 (copy)
	if typeof(p2) ~= "string" then
		return false
	end

	return t3[string.lower(p2)] == true
end
local function toolCallMatchesPublishPlace(p3) -- line: 64
	-- upvalues: t2 (copy)
	local kind = p3.kind
	local v29 = false

	if typeof(kind) == "string" then
		v29 = false

		if kind ~= "" then
			local v30 = string.gsub(kind, "[_%-%s]", "")
			local v31 = string.lower(v30)

			v29 = not not t2[v31] or string.find(v31, "publishplace", 1, true) ~= nil
		end
	end

	if not v29 then
		local title = p3.title
		local v33 = false

		if typeof(title) == "string" then
			v33 = false

			if title ~= "" then
				local v34 = string.gsub(title, "[_%-%s]", "")
				local v35 = string.lower(v34)

				v33 = not not t2[v35] or string.find(v35, "publishplace", 1, true) ~= nil
			end
		end

		if not v33 then
			local rawInput = p3.rawInput

			if typeof(rawInput) ~= "table" then
				return false
			end

			for _, v38 in {
				"tool",
				"name",
				"action",
				"command",
				"toolName"
			} do
				local v39 = rawInput[v38]
				local v40 = false

				if typeof(v39) == "string" then
					v40 = false

					if v39 ~= "" then
						local v41 = string.gsub(v39, "[_%-%s]", "")
						local v42 = string.lower(v41)

						v40 = not not t2[v42] or string.find(v42, "publishplace", 1, true) ~= nil
					end
				end

				if v40 then
					return true
				end
			end

			return false
		end
	end

	return true
end
local function isSaveAndPublishToolCall(p4) -- line: 83
	-- upvalues: t3 (copy)
	local title = p4.title

	if typeof(title) ~= "string" or t3[string.lower(title)] ~= true then
		local kind = p4.kind

		if not (typeof(kind) == "string" and t3[string.lower(kind)] == true) then
			local rawInput = p4.rawInput

			if typeof(rawInput) ~= "table" then
				return false
			end

			for _, v48 in {
				"tool",
				"name",
				"action",
				"command",
				"toolName"
			} do
				local v49 = rawInput[v48]

				if typeof(v49) == "string" and t3[string.lower(v49)] == true then
					return true
				end
			end

			return false
		end
	end

	return true
end
local function parsePublishedVersionNumber(s3: string) -- line: 112
	local match = string.match(s3, "^%s*Saved as version%s+(%d+)%s*%.?%s*$")

	if match == nil then
		return nil
	end

	return (tonumber(match))
end
local function parseTextResult(s4: string) -- line: 120
	-- upvalues: HttpService (copy)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, s4)

	if not ok or typeof(result) ~= "table" then
		return nil
	end

	if result.type ~= "text" or typeof(result.text) ~= "string" then
		return nil
	end

	return result
end
local function getToolCallPublishedVersionNumber(p5) -- line: 131
	-- upvalues: HttpService (copy)
	local content = p5.content

	if typeof(content) ~= "table" then
		return nil
	end

	for _, v61 in content do
		local v62 = if typeof(v61.content) ~= "table" then v61.text else v61.content.text

		if typeof(v62) ~= "string" then
			continue
		end

		local ok, result = pcall(HttpService.JSONDecode, HttpService, v62)
		local v65 = if not not ok and typeof(result) == "table" then if result.type == "text" and typeof(result.text) == "string" then result else nil else nil

		if v65 ~= nil then
			local text = v65.text
			local match = string.match(text, "^%s*Saved as version%s+(%d+)%s*%.?%s*$")
			local v68 = if match ~= nil then tonumber(match) else nil

			if v68 == nil then
				continue
			end

			return v68
		end
	end

	return nil
end

return {
	PUBLISH_PLACE_TOOL_IDENTIFIERS = t1,
	includesPublishPlaceTool = function(p6) -- line: 100
		-- upvalues: toolCallMatchesPublishPlace (copy)
		for _, v52 in p6.toolCalls do
			if v52.status ~= "failed" and toolCallMatchesPublishPlace(v52) then
				return true
			end
		end

		return false
	end,
	toolCallMatchesPublishPlace = toolCallMatchesPublishPlace,
	getLatestSuccessfulResult = function(p7) -- line: 159
		-- upvalues: isSaveAndPublishToolCall (copy), getToolCallPublishedVersionNumber (copy)
		if p7 == nil then
			return nil
		end

		local t4 = nil

		for v71, v72 in p7.toolCalls do
			if v72.status == "completed" and isSaveAndPublishToolCall(v72) then
				local v73 = getToolCallPublishedVersionNumber(v72)

				if v73 ~= nil then
					t4 = {
						toolCallId = v71,
						publishedVersionNumber = v73,
						rollbackTargetVersionNumber = if not (v73 > 1) then nil else v73 - 1
					}
				end
			end
		end

		return t4
	end
}
