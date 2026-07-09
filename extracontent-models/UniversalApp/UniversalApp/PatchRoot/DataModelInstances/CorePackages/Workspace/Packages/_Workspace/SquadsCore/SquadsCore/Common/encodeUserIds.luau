local HttpService = game:GetService("HttpService")

local function encodeUserIds(p1) -- line: 3
	-- upvalues: HttpService (copy)
	if p1 == nil then
		return "[]"
	end

	local ok, result = pcall(function() -- line: 8
		-- upvalues: HttpService (copy), p1 (copy)
		return HttpService:JSONEncode(p1)
	end)

	if ok then
		return result
	end

	return "[]"
end

return encodeUserIds
