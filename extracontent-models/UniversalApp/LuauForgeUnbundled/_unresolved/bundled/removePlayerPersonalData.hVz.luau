local Players = game:GetService("Players")
local module = require("@luauforge/bundled/vO")

local function defaultListOfPIIs()
	local v5 = {}

	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return v5
	end

	if localPlayer.UserId and localPlayer.UserId > 0 then
		v5[tostring(localPlayer.UserId)] = "UserId"
	end

	if localPlayer.Name and localPlayer.Name ~= "" then
		v5[tostring(localPlayer.Name)] = "UserName"
	end

	return v5
end

local function removePlayerPersonalData(item, p2)
	local v5 = p2 or defaultListOfPIIs()

	if type(item) == "table" then
		local result = {}

		for k, item2 in pairs(item) do
			result[k] = removePlayerPersonalData(item2, v5)
		end

		return result
	end

	if type(item) == "string" then
		return module(item, v5)
	end

	for k, v6 in pairs(v5) do
		if tostring(item) == k then
			return v6
		end
	end

	return item
end

return removePlayerPersonalData
