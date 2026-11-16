local Home = script:FindFirstAncestor("Home")
local HttpService = game:GetService("HttpService")

local buildHomePromptClientAttributes = require(Home.buildHomePromptClientAttributes)
local buildHomeSystemContextFeatures = require(Home.buildHomeSystemContextFeatures)

local FFlagLuaAppSduiHomePromptClientAttributes = require(Home.Flags.FFlagLuaAppSduiHomePromptClientAttributes)
local v = FFlagLuaAppSduiHomePromptClientAttributes and "prompt_client_attributes" or nil

local function buildContextualFeatures(data)
	local homeSystemContextFeatures = buildHomeSystemContextFeatures()

	if FFlagLuaAppSduiHomePromptClientAttributes then
		local homePromptClientAttributes = buildHomePromptClientAttributes()

		if next(homePromptClientAttributes) ~= nil then
			local success, result = pcall(HttpService.JSONEncode, HttpService, homePromptClientAttributes)

			if success and typeof(result) == "string" then
				homeSystemContextFeatures[v] = result
			end
		end
	end

	if typeof(data.contextualFeatures) == "table" then
		for k, contextualFeature in data.contextualFeatures do
			if typeof(k) == "string" and contextualFeature ~= nil then
				homeSystemContextFeatures[k] = tostring(contextualFeature)
			end
		end
	end

	if data.requestIntent and data.requestIntent ~= "" then
		homeSystemContextFeatures.request_intent = data.requestIntent
	end

	if next(homeSystemContextFeatures) == nil then
		return nil
	end

	return homeSystemContextFeatures
end

local function buildHomePageRequest(p, data)
	local v2 = {}

	if data then
		if data.sessionId and data.sessionId ~= "" then
			v2.session_id = data.sessionId
		end

		v2.topic_ids = data.topicIds

		v2.contextual_features = buildContextualFeatures(data)

		if data.cachedRobloxComponentToTemplateId then
			v2.cached_roblox_component_to_template_id = data.cachedRobloxComponentToTemplateId
		end

		if data.clientCapabilities then
			v2.client_capabilities = data.clientCapabilities
		end

		if data.collectionLayout then
			v2.collection_layout = p.HomeCollectionLayoutInfo.new({
				items_per_row = data.collectionLayout.items_per_row,
				rows_above_fold = data.collectionLayout.rows_above_fold
			})
		end
	end

	return p.HomePageRequest.new(v2)
end

return buildHomePageRequest
