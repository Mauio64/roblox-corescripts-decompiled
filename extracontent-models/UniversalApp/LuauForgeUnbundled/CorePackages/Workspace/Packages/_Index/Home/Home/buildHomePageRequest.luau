local HttpService = game:GetService("HttpService")

local buildHomePromptClientAttributes = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/buildHomePromptClientAttributes")
local buildHomeSystemContextFeatures = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/buildHomeSystemContextFeatures")

local FFlagLuaAppSduiHomePromptClientAttributes = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/Flags/FFlagLuaAppSduiHomePromptClientAttributes")
local v5 = FFlagLuaAppSduiHomePromptClientAttributes and "prompt_client_attributes" or nil

local function buildContextualFeatures(data)
	local result = buildHomeSystemContextFeatures()

	if FFlagLuaAppSduiHomePromptClientAttributes then
		local v6 = buildHomePromptClientAttributes()

		if next(v6) ~= nil then
			local success, result2 = pcall(HttpService.JSONEncode, HttpService, v6)

			if success and typeof(result2) == "string" then
				result[v5] = result2
			end
		end
	end

	if typeof(data.contextualFeatures) == "table" then
		for k, contextualFeature in data.contextualFeatures do
			if typeof(k) == "string" and contextualFeature ~= nil then
				result[k] = tostring(contextualFeature)
			end
		end
	end

	if data.requestIntent and data.requestIntent ~= "" then
		result.request_intent = data.requestIntent
	end

	if next(result) == nil then
		return nil
	end

	return result
end

local function buildHomePageRequest(p2, data)
	local v6 = {}

	if data then
		if data.sessionId and data.sessionId ~= "" then
			v6.session_id = data.sessionId
		end

		v6.topic_ids = data.topicIds

		v6.contextual_features = buildContextualFeatures(data)

		if data.cachedRobloxComponentToTemplateId then
			v6.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
		end

		if data.clientCapabilities then
			v6.client_capabilities = data.clientCapabilities
		end

		if data.collectionLayout then
			v6.collection_layout = p2.HomeCollectionLayoutInfo.new({
				items_per_row = data.collectionLayout.items_per_row,
				rows_above_fold = data.collectionLayout.rows_above_fold
			})
		end
	end

	return p2.HomePageRequest.new(v6)
end

return buildHomePageRequest
