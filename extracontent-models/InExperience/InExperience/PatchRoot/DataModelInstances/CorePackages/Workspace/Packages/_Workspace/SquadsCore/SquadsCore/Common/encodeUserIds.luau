local HttpService = game:GetService("HttpService")

local function encodeUserIds(p)
	if p == nil then
		return "[]"
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)
	return if success then result else "[]"
end

return encodeUserIds
