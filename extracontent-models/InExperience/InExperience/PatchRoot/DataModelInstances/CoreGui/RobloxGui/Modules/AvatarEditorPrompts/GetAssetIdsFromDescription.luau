local t1 = {
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

return function(p1) -- line: 23
	-- upvalues: t1 (copy)
	local t2 = {}

	for _, v in ipairs(t1) do
		local v6 = p1[v]

		if typeof(v6) == "number" and v6 > 0 then
			table.insert(t2, v6)
		elseif typeof(v6) == "string" and v6 ~= "" then
			for match in v6:gmatch("([%d]+),?") do
				table.insert(t2, (tonumber(match)))
			end
		end
	end

	local Accessories = p1:GetAccessories(true)

	for _, v in ipairs(Accessories) do
		table.insert(t2, v.AssetId)
	end

	for _, child in (p1:GetChildren()) do
		if child:IsA("MakeupDescription") and child.AssetId > 0 then
			table.insert(t2, child.AssetId)
		end
	end

	local Emotes = p1:GetEmotes()
	local EquippedEmotes = p1:GetEquippedEmotes()

	for _, v in ipairs(EquippedEmotes) do
		local v17 = Emotes[v.Name]

		if v17 then
			for _, v2 in ipairs(v17) do
				table.insert(t2, v2)
			end
		end
	end

	return t2
end
