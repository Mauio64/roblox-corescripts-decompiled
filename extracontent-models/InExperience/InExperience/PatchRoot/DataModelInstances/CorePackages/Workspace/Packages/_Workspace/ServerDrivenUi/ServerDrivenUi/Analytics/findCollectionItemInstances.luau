local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local CollectionService = game:GetService("CollectionService")
local Impressions = require(parent.Impressions)
local ItemIndex = Impressions.Constants.ItemIndex

local function findCollectionItemInstances(tag: string?)
	local guiObjectsByAttribute = {}

	if not tag then
		return guiObjectsByAttribute
	end

	for _, guiObject in CollectionService:GetTagged(tag) do
		if not guiObject:IsA("GuiObject") then
			continue
		end

		local attribute = guiObject:GetAttribute(ItemIndex)

		if typeof(attribute) == "number" then
			guiObjectsByAttribute[attribute] = guiObject
		end
	end

	return guiObjectsByAttribute
end

return findCollectionItemInstances
