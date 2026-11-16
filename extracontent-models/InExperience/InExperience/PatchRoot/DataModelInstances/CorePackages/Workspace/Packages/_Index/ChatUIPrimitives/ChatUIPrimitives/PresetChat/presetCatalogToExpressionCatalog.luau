local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint
require(script.Parent.Types)
require(script.Parent.Parent.UniversalMessage.Types)
local presetMessageToContent = require(script.Parent.presetMessageToContent)

local function accessLevelToStatus(accessLevel): string -- 1 equivalent call inferred from this helper
	return if accessLevel == "Enabled" then "enabled" else "disabled"
end

local function presetCategoryToExpressionCategory(category)
	local v

	if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
		v = category.contents
	else
		v = category.messages
	end

	local presetMessageToExpressionItems = {}

	for _, v2 in v do
		local presetMessageToExpressionItem = presetMessageToContent.presetMessageToExpressionItem(v2)

		if presetMessageToExpressionItem ~= nil then
			table.insert(presetMessageToExpressionItems, presetMessageToExpressionItem)
		end
	end

	return {
		categoryId = category.categoryId,
		name = category.name,
		items = presetMessageToExpressionItems
	}
end

local function presetCategoryGroupToExpressionGroup(categoryGroup)
	local categories = {}

	for _, category in categoryGroup.categories do
		table.insert(categories, presetCategoryToExpressionCategory(category))
	end

	return {
		categoryGroupId = categoryGroup.categoryGroupId,
		name = categoryGroup.name,
		categories = categories
	}
end

local function presetCatalogToExpressionCatalog(data)
	local categoryGroups = {}

	for _, categoryGroup in data.categoryGroups do
		table.insert(categoryGroups, presetCategoryGroupToExpressionGroup(categoryGroup))
	end

	return {
		status = accessLevelToStatus(data.accessLevel), -- inferred equivalent call
		categoryGroups = categoryGroups,
		version = data.version
	}
end

return presetCatalogToExpressionCatalog
