local CollectionService = game:GetService("CollectionService")
local itemIndex = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Impressions").Constants.ItemIndex

local function findCollectionItemInstances(tag)
	local guiObjectsByAttribute = {}

	if not tag then
		return guiObjectsByAttribute
	end

	for k, guiObject in CollectionService:GetTagged(tag) do
		if not guiObject:IsA("GuiObject") then
			continue
		end

		local attribute = guiObject:GetAttribute(itemIndex)

		if typeof(attribute) == "number" then
			guiObjectsByAttribute[attribute] = guiObject
		end
	end

	return guiObjectsByAttribute
end

return findCollectionItemInstances
