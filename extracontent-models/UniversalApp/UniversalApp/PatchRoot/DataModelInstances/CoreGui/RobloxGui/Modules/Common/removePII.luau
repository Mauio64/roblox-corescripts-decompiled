local Players = game:GetService("Players")
local StringReplaceAll = require(script.Parent.StringUtilities.StringReplaceAll)

local function defaultListOfPIIs() -- line: 6
	-- upvalues: Players (copy)
	local t1 = {}
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer ~= nil then
		if LocalPlayer.UserId and LocalPlayer.UserId > 0 then
			t1[tostring(LocalPlayer.UserId)] = "UserId"
		end

		if LocalPlayer.Name and LocalPlayer.Name ~= "" then
			t1[tostring(LocalPlayer.Name)] = "UserName"
		end
	end

	return t1
end
local function removePlayerPersonalData(p1, p2) -- line: 23
	-- upvalues: defaultListOfPIIs (copy), removePlayerPersonalData (copy), StringReplaceAll (copy)
	if not p2 then
		p2 = defaultListOfPIIs()
	end

	if type(p1) == "table" then
		local t2 = {}

		for k, v in pairs(p1) do
			t2[k] = removePlayerPersonalData(v, p2)
		end

		return t2
	end

	if type(p1) ~= "string" then
		for k, v in pairs(p2) do
			if k == tostring(p1) then
				return v
			end
		end

		return p1
	end

	return StringReplaceAll(p1, p2)
end

return removePlayerPersonalData
