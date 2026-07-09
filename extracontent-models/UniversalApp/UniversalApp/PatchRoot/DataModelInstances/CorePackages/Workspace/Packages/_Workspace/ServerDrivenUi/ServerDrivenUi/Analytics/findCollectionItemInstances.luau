local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local CollectionService = game:GetService("CollectionService")
local ItemIndex = require(Parent.Impressions).Constants.ItemIndex

local function findCollectionItemInstances(s1: string?) -- line: 14
	-- upvalues: CollectionService (copy), ItemIndex (copy)
	local t1 = {}

	if not s1 then
		return t1
	end

	for _, v8 in CollectionService:GetTagged(s1) do
		if v8:IsA("GuiObject") then
			local ItemIndex2 = v8:GetAttribute(ItemIndex)

			if typeof(ItemIndex2) == "number" then
				t1[ItemIndex2] = v8
			end
		end
	end

	return t1
end

return findCollectionItemInstances
