local v = {
	"ClimbAnimation",
	"Face",
	"FallAnimation",
	"GraphicTShirt",
	"Head",
	"IdleAnimation",
	"JumpAnimation",
	"LeftArm",
	"LeftLeg",
	"Pants",
	"RightArm",
	"RightLeg",
	"RunAnimation",
	"Shirt",
	"SwimAnimation",
	"Torso",
	"WalkAnimation"
}

return function(instance)
	local result = {}

	for _, v2 in ipairs(v) do
		local v3 = instance[v2]

		if typeof(v3) == "number" and v3 > 0 then
			table.insert(result, v3)
		elseif typeof(v3) == "string" and v3 ~= "" then
			for k in v3:gmatch("([%d]+),?") do
				table.insert(result, (tonumber(k)))
			end
		end
	end

	local accessories = instance:GetAccessories(true)

	for _, accessory in ipairs(accessories) do
		table.insert(result, accessory.AssetId)
	end

	local children = instance:GetChildren()

	for _, makeupDescription in children do
		if makeupDescription:IsA("MakeupDescription") and makeupDescription.AssetId > 0 then
			table.insert(result, makeupDescription.AssetId)
		end
	end

	local emotes = instance:GetEmotes()
	local equippedEmotes = instance:GetEquippedEmotes()

	for _, equippedEmote in ipairs(equippedEmotes) do
		local emote = emotes[equippedEmote.Name]

		if not emote then
			continue
		end

		for _, v2 in ipairs(emote) do
			table.insert(result, v2)
		end
	end

	return result
end
