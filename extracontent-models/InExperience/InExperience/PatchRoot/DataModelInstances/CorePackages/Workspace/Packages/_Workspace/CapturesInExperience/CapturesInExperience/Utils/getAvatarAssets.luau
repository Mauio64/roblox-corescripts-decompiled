local parent = script.Parent.Parent

local Players = game:GetService("Players")

local Constants = require(parent.Constants)

local function getLocalPlayerCharacter() -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer

	return if localPlayer then localPlayer.Character else nil
end

return function(instance)
	local result = {}
	local set = {}

	if not instance then
		instance = getLocalPlayerCharacter() -- inferred equivalent call
	end

	if not instance then
		return result
	end

	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return result
	end

	local humanoidDescription = humanoid:FindFirstChildOfClass("HumanoidDescription")

	if not humanoidDescription then
		return result
	end

	for k, v in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants.AssetTypeIdToAccessoryTypeEnum[k] ~= nil then
			continue
		end

		local v2 = humanoidDescription[v] or ""

		for _, v3 in string.split(v2) do
			local v4 = tonumber(v3)

			if not v4 or v4 == 0 or set[v4] then
				continue
			end

			set[v4] = true
			table.insert(result, v4)
		end
	end

	local accessories = humanoidDescription:GetAccessories(true)

	for _, accessory in accessories do
		if not accessory.AssetId or accessory.AssetId == 0 or set[accessory.AssetId] then
			continue
		end

		set[accessory.AssetId] = true
		table.insert(result, accessory.AssetId)
	end

	return result
end
