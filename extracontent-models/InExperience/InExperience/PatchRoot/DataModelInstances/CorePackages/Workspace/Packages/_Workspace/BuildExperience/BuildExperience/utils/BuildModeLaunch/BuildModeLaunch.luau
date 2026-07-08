local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 19
	-- upvalues: t1 (copy)
	return (setmetatable({
		cachedResult = nil
	}, t1))
end
function t1.set(p1) -- line: 26
	-- upvalues: MemStorageService (copy), HttpService (copy)
	p1.cachedResult = nil
	MemStorageService:SetItem("BuildExperienceLaunchData", HttpService:JSONEncode({
		hasBuildMode = true
	}))
end
function t1.hasBuildMode(p2) -- line: 31
	-- upvalues: MemStorageService (copy), HttpService (copy)
	if p2.cachedResult ~= nil then
		return p2.cachedResult
	end

	local Item = MemStorageService:GetItem("BuildExperienceLaunchData")

	if Item == "" then
		p2.cachedResult = false

		return false
	end

	local ok, result = pcall(HttpService.JSONDecode, HttpService, Item)

	if not ok or type(result) ~= "table" then
		p2.cachedResult = false

		return false
	end

	MemStorageService:SetItem("BuildExperienceLaunchData", "")
	p2.cachedResult = result.hasBuildMode == true

	return p2.cachedResult
end

return t1
