local HttpService = game:GetService("HttpService")

local function SearchUuid()
	return HttpService:GenerateGUID(true)
end

return SearchUuid
