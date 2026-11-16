local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint
require(ChatUIPrimitives.UniversalMessage.Types)

local function mapPreset(presetId, text, presetVersion)
	if type(presetId) ~= "string" or presetId == "" or type(text) ~= "string" then
		return nil
	end

	local content = { kind = "preset", presetId = presetId, text = text }

	if (type)(presetVersion) == "string" then
		content.presetVersion = presetVersion
	end

	return { content = content }
end

local function mapEmoji(data)
	local emoteId = data.emoteId

	if type(emoteId) ~= "string" or emoteId == "" then
		return nil
	end

	local content = { kind = "emoji", emojiId = emoteId }

	if type(data.unicode) == "string" then
		content.unicode = data.unicode
	end

	if type(data.name) == "string" then
		content.name = data.name
	end

	return { content = content }
end

local function mapContentsItem(data) -- 1 equivalent call inferred from this helper
	if type(data) ~= "table" then
		return nil
	end

	if data.kind == "Preset" then
		return mapPreset(data.presetId, data.text, data.presetVersion)
	end

	if data.kind == "Emoji" then
		return mapEmoji(data)
	end

	return nil
end

local function mapMessageItem(p) -- 1 equivalent call inferred from this helper
	if type(p) == "table" then
		return mapPreset(p.presetId, p.value, nil)
	end

	return nil
end

local function mapCategory(category)
	if type(category) ~= "table" then
		return nil
	end

	local categoryId = category.categoryId

	if type(categoryId) ~= "string" or categoryId == "" then
		return nil
	end

	local v

	if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
		v = category.contents
	else
		v = category.messages
	end

	if type(v) ~= "table" then
		return nil
	end

	local items = {}

	for _, v2 in v do
		local v3

		if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
			v3 = mapContentsItem(v2) -- inferred equivalent call
		else
			v3 = mapMessageItem(v2) -- inferred equivalent call
		end

		if v3 ~= nil then
			table.insert(items, v3)
		end
	end

	if #items == 0 then
		return nil
	end

	local v2 = { categoryId = categoryId, items = items }

	local name = category.name

	if type(name) == "string" then
		v2.name = name
	end

	return v2
end

local function mapGroup(categoryGroup)
	if type(categoryGroup) ~= "table" then
		return nil
	end

	local categoryGroupId = categoryGroup.categoryGroupId

	if type(categoryGroupId) ~= "string" or categoryGroupId == "" or type(categoryGroup.categories) ~= "table" then
		return nil
	end

	local categories = {}

	for _, category in categoryGroup.categories do
		local v = mapCategory(category)

		if v ~= nil then
			table.insert(categories, v)
		end
	end

	if #categories == 0 then
		return nil
	end

	local v = { categoryGroupId = categoryGroupId, categories = categories }

	local name = categoryGroup.name

	if type(name) == "string" then
		v.name = name
	end

	local footerText = categoryGroup.footerText

	if type(footerText) == "string" and footerText ~= "" then
		v.footerText = footerText
	end

	return v
end

local function statusFromAccessLevel(p: string): nil | string -- 1 equivalent call inferred from this helper
	if p == "Enabled" then
		return "enabled"
	end

	if p == "ReadOnly" or p == "Disabled" then
		return "disabled"
	end

	return nil
end

local function normalizeExpressionCatalog(data)
	if type(data) ~= "table" then
		return nil
	end

	local v

	if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
		v = data.status
	else
		v = data.accessLevel
	end

	if type(v) ~= "string" then
		return nil
	end

	local status = statusFromAccessLevel(v) -- inferred equivalent call

	if status == nil then
		return nil
	end

	local version = data.version

	if
		not EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint
		and v ~= "Disabled"
		and (type(version) ~= "string" or version == "")
	then
		return nil
	end

	local categoryGroups = {}

	if type(data.categoryGroups) == "table" then
		for _, categoryGroup in data.categoryGroups do
			local v2 = mapGroup(categoryGroup)

			if v2 ~= nil then
				table.insert(categoryGroups, v2)
			end
		end
	end

	return {
		status = status,
		categoryGroups = categoryGroups,
		version = type(version) ~= "string" and "" or version
	}
end

return normalizeExpressionCatalog
