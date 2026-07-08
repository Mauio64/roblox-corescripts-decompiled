local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Cryo = require(Parent.Cryo)
local Categories = require(script.Parent.Parent.Enums.Categories)

require(script.Parent.Parent.Types)

local BodyAssetTypes = require(script.Parent.Parent.Constants).BodyAssetTypes

local function getAssetTypesByCategory(p1, t1: {[any]: any}) -- line: 11
	-- upvalues: Categories (copy), Cryo (copy), BodyAssetTypes (copy)
	local t2 = {}
	local t3 = {}

	if p1 == Categories.Body then
		t3 = Cryo.List.map(BodyAssetTypes, function(p2) -- line: 18
			return (tostring(p2.Value))
		end)
	end

	for _, v11 in t1 do
		t3 = Cryo.List.join(t3 or {}, Cryo.List.map(Cryo.List.filter(v11.assetTypes, function(p3) -- line: 32
			-- upvalues: t2 (copy)
			if not t2[p3] then
				t2[p3] = true

				return true
			end

			return false
		end), function(p4) -- line: 39
			return (tostring(p4.Value))
		end))
	end

	if Cryo.List.find(t3, (tostring(Enum.AssetType.RightShoeAccessory.Value))) then
		table.insert(t3, (tostring(Enum.AssetType.LeftShoeAccessory.Value)))
	end

	return t3
end

return getAssetTypesByCategory
