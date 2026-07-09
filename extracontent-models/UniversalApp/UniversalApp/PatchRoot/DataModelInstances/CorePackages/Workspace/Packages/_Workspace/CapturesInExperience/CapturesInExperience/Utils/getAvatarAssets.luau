local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local Constants = require(ParentParent.Constants)

local function getLocalPlayerCharacter() -- line: 9
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return nil
	end

	return LocalPlayer.Character
end

return function(p1) -- line: 18
	-- upvalues: Players (copy), Constants (copy)
	local t1 = {}
	local t2 = {}

	if not p1 then
		local LocalPlayer = Players.LocalPlayer

		p1 = if LocalPlayer then LocalPlayer.Character else nil
	end

	if not p1 then
		return t1
	end

	local Humanoid = p1:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return t1
	end

	local HumanoidDescription = Humanoid:FindFirstChildOfClass("HumanoidDescription")

	if not HumanoidDescription then
		return t1
	end

	for v12, v13 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants.AssetTypeIdToAccessoryTypeEnum[v12] == nil then
			local v14 = HumanoidDescription[v13] or ""

			for _, v16 in string.split(v14) do
				local num = tonumber(v16)

				if num and num ~= 0 and not t2[num] then
					t2[num] = true
					table.insert(t1, num)
				end
			end
		end
	end

	for _, v19 in (HumanoidDescription:GetAccessories(true)) do
		if v19.AssetId and v19.AssetId ~= 0 and not t2[v19.AssetId] then
			t2[v19.AssetId] = true
			table.insert(t1, v19.AssetId)
		end
	end

	return t1
end
