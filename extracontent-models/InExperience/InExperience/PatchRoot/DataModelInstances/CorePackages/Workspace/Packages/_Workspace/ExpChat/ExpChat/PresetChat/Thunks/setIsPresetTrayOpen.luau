local HttpService = game:GetService("HttpService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatOpenExpressionTrayExperimentation = SocialExperiments.ExpChatOpenExpressionTrayExperimentation
local Constants = require(ExpChat.PresetChat.Constants)
require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)

local FFlagExpChatOpenExpressionTrayExposure = require(ExpChat.Flags.FFlagExpChatOpenExpressionTrayExposure)
local FFlagExpChatPresetTrayDismissAnalytics = require(ExpChat.Flags.FFlagExpChatPresetTrayDismissAnalytics)
local emojiUnicodeToId = require(ExpChat.PresetChat.emojiUnicodeToId)

local function buildPresetTrayItems(items, p, p2)
	local presetTrayItems = {}

	for _, item in items do
		if not (not FFlagExpChatPresetTrayDismissAnalytics or p2[item.categoryGroupId]) then
			continue
		end

		for _, category in item.categories do
			local name = category.name or category.categoryId
			local v

			if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
				v = category.contents
			else
				v = category.messages
			end

			for k, v2 in v do
				if FFlagExpChatPresetTrayDismissAnalytics then
					local preset_id

					if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint and v2.kind == "Emoji" then
						preset_id = emojiUnicodeToId(v2.unicode)
					else
						preset_id = v2.presetId
					end

					table.insert(presetTrayItems, {
						category = name,
						tab = item.name or item.categoryGroupId,
						preset_id = preset_id,
						index = k - 1,
						click = math.min(p[preset_id] or 0, 1)
					})
				elseif EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint and v2.kind == "Emoji" then
					table.insert(presetTrayItems, {
						category = name,
						emote_id = v2.emoteId,
						index = k - 1,
						click = p[v2.emoteId] or 0
					})
				else
					table.insert(presetTrayItems, {
						category = name,
						preset_id = v2.presetId,
						index = k - 1,
						click = p[v2.presetId] or 0
					})
				end
			end
		end
	end

	return presetTrayItems
end

local function setIsPresetTrayOpen(data, flag: boolean)
	if flag == data.getIsTrayOpen(false) then
		return
	end

	if FFlagExpChatPresetTrayDismissAnalytics and flag then
		data.setPresetClickCounts({})
		data.setViewedGroupIds({})
	end

	data.setIsTrayOpen(flag)

	if FFlagExpChatOpenExpressionTrayExposure and flag then
		ExpChatOpenExpressionTrayExperimentation.logExposure()
	end

	if flag then
		ExpChatShared.Analytics:TelemetryLogEvent(
			ExpChatShared.Analytics.ExpChatPresetActionConfig,
			{
				event_type = Constants.Analytics.EventTypes.Show,
				component = Constants.Analytics.Components.PresetTray
			},
			ExpChatShared.Analytics.DefaultStandardizedFields
		)
	else
		ExpChatShared.Analytics:TelemetryLogEvent(
			ExpChatShared.Analytics.ExpChatPresetActionConfig,
			{
				event_type = Constants.Analytics.EventTypes.Dismiss,
				component = Constants.Analytics.Components.PresetTray,
				preset_items = HttpService:JSONEncode(buildPresetTrayItems(
					data.getCategoryGroups(false),
					data.getPresetClickCounts(false),
					data.getViewedGroupIds(false)
				))
			},
			ExpChatShared.Analytics.DefaultStandardizedFields
		)
	end
end

return setIsPresetTrayOpen
