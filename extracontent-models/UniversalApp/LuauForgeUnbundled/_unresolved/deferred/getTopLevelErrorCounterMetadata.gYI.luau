local function truncate(value)
	return (string.sub(value, 1, 50))
end

local function collapseWhitespace(value)
	local v5 = string.gsub(value, "%s+", " ")
	return string.match(v5, "^%s*(.-)%s*$") or ""
end

local function getMessageAndStack(p2)
	if typeof(p2) ~= "table" then
		return tostring(p2), nil
	end

	local v5 = if p2.message == nil then tostring(p2) else tostring(p2.message)

	if p2.stack == nil then
		return v5, nil
	end

	return v5, (tostring(p2.stack))
end

local function getTopLevelErrorCounterMetadata(p2, p3, value, value2)
	local v5, stack

	if typeof(p2) == "table" then
		v5 = if p2.message == nil then tostring(p2) else tostring(p2.message)

		if p2.stack ~= nil then
			stack = tostring(p2.stack)
		end
	else
		v5 = tostring(p2)
	end

	local v6, v7, v8 = string.match(v5, "([%w_]+):(%d+):%s*(.*)$")
	local v9 = not (v6 and v7) and "Unknown" or `{v6}:{v7}`

	local v10 = not (p3 and p3.componentStack) and "" or p3.componentStack
	local v11 = string.match(v10, "in ([%w_]+)") or "Unknown"
	local v12 = string.gsub(stack or v10, "%s+", " ")
	local v13 = string.match(v12, "^%s*(.-)%s*$") or ""
	local v14 = string.gsub(v8 or v5, "%s+", " ")
	return {
		Component = v11,
		ErrorLine = v9,
		ErrorMessage = string.sub(string.match(v14, "^%s*(.-)%s*$") or "", 1, 50),
		StackTrace = v13 == "" and "Unknown" or string.sub(v13, 1, 50),
		Page = value or "Unknown",
		OpaquePage = value2 or "Unknown"
	}
end

return getTopLevelErrorCounterMetadata
