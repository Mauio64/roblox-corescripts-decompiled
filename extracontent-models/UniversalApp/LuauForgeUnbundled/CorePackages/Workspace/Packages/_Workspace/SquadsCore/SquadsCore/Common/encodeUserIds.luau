local HttpService = game:GetService("HttpService")

local function encodeUserIds(p2)
	if p2 == nil then
		return "[]"
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success then
		return result
	end

	return "[]"
end

return encodeUserIds
