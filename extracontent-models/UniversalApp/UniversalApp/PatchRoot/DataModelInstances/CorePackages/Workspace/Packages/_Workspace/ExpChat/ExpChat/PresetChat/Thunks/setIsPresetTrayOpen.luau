local HttpService = game:GetService("HttpService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Constants = require(ExpChat.PresetChat.Constants)

require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)

local function buildPresetTrayItems(t1: {[any]: any}, p1) -- line: 12
	local t2 = {}

	for _, v12 in t1 do
		for _, v14 in v12.categories do
			local v15 = v14.name or v14.categoryId

			for v16, v17 in v14.messages do
				table.insert(t2, {
					category = v15,
					preset_id = v17.presetId,
					index = v16 - 1,
					click = p1[v17.presetId] or 0
				})
			end
		end
	end

	return t2
end
local function setIsPresetTrayOpen(p2, b1: boolean) -- line: 34
	-- upvalues: ExpChatShared (copy), Constants (copy), HttpService (copy), buildPresetTrayItems (copy)
	if b1 == p2.getIsTrayOpen(false) then
		return
	end

	p2.setIsTrayOpen(b1)

	if b1 then
		ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.ExpChatPresetActionConfig, {
			event_type = Constants.Analytics.EventTypes.Show,
			component = Constants.Analytics.Components.PresetTray
		}, ExpChatShared.Analytics.DefaultStandardizedFields)

		return
	end

	ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.ExpChatPresetActionConfig, {
		event_type = Constants.Analytics.EventTypes.Dismiss,
		component = Constants.Analytics.Components.PresetTray,
		preset_items = HttpService:JSONEncode((buildPresetTrayItems(p2.getCategoryGroups(false), p2.getPresetClickCounts(false))))
	}, ExpChatShared.Analytics.DefaultStandardizedFields)
end

return setIsPresetTrayOpen
