local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local Promise = require(CorePackages.Packages.Promise)
local ExpChatMessageHelpers = require(script.Parent.ExpChatMessageHelpers)
local enrichMissingUsernames = require(script.Parent.inExpChatMessagesLoaderUsernameEnrichment).enrichMissingUsernames
local GetChannelTabsStore = ExpChat.Stores.GetChannelTabsStore
local FFlagExpChatUseMessagesStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExpChatUseMessagesStore
local v11 = Localization.new(LocalizationService.RobloxLocaleId)

return {
	type = "groupedListItem",
	fetch = function(_) -- line: 23
		-- upvalues: ExpChatShared (copy), Promise (copy), FFlagExpChatUseMessagesStore (copy), ExpChatMessageHelpers (copy), v11 (copy), enrichMissingUsernames (copy), GetChannelTabsStore (copy)
		local store = ExpChatShared.context.store

		if not store then
			return Promise.resolve({})
		end

		local v14 = store:getState()
		local v16, v17, v18

		if FFlagExpChatUseMessagesStore then
			local messagesStore = ExpChatShared.context.messagesStore

			if not messagesStore then
				return Promise.resolve({})
			end

			v16 = messagesStore.getByMessageId(false) or {}
			v17 = messagesStore.getWindowMessagesInOrder(false) or {}
			v18 = messagesStore.getWindowMessagesInOrderByTabId(false) or {}
		else
			local v19 = v14 and v14.Messages

			if not v19 then
				return Promise.resolve({})
			end

			v16 = v19.byMessageId or {}
			v17 = v19.windowMessagesInOrder or {}
			v18 = v19.windowMessagesInOrderByTabId or {}
		end

		local translator = ExpChatShared.context.translator

		if not ExpChatMessageHelpers.areChannelTabsEnabled() then
			local t1 = {}
			local t2 = {}

			for _, v in ipairs(v17) do
				local v25 = v16[v]

				if v25 then
					if v25.textChannel then
						table.insert(t1, v)
					else
						table.insert(t2, v)
					end
				end
			end

			local t3 = {}
			local v27 = ExpChatMessageHelpers.collectItems(v16, t1)

			ExpChatMessageHelpers.annotateWhisperItems(v27, v16, v11:Format("Feature.ReportAbuse.Label.SentPrivately"))

			if #v27 > 0 then
				table.insert(t3, {
					id = ExpChatMessageHelpers.CHANNEL_GENERAL,
					label = v11:Format("CoreScripts.TextChat.ChannelTabs.Here"),
					items = v27
				})
			end

			local v28 = ExpChatMessageHelpers.collectItems(v16, t2)

			if #v28 > 0 then
				table.insert(t3, {
					id = ExpChatMessageHelpers.CHANNEL_GLOBAL,
					label = v11:Format("CoreScripts.TextChat.ChannelTabs.Global2"),
					items = v28
				})
			end

			return enrichMissingUsernames(t3)
		end

		local v29 = v14.TextChannels and v14.TextChannels.allTextChannels or {}
		local allChannelTabs = GetChannelTabsStore(false).getChannelTabsState(false).allChannelTabs
		local t4 = {}
		local t5 = {}

		for k, v in pairs(v18) do
			local v35 = ExpChatMessageHelpers.collectItems(v16, v)

			if #v35 > 0 then
				local v36 = ExpChatMessageHelpers.formatChannelLabel(k, v29[k])

				table.insert(t5, k)
				t4[k] = {
					id = k,
					label = ExpChatMessageHelpers.localizeString(translator, v36),
					items = v35
				}
			end
		end

		table.sort(t5, function(p2, p3) -- line: 124
			-- upvalues: allChannelTabs (copy), ExpChatMessageHelpers (copy)
			local v42 = allChannelTabs[p2]
			local v43 = allChannelTabs[p3]

			if v42 and v43 then
				return v42.tabIndex < v43.tabIndex
			end

			if v42 then
				return true
			end

			if v43 then
				return false
			end

			if p2 == ExpChatMessageHelpers.CHANNEL_GENERAL then
				return true
			end

			if p3 == ExpChatMessageHelpers.CHANNEL_GENERAL then
				return false
			end

			return p2 < p3
		end)

		local t6 = {}

		for _, v in ipairs(t5) do
			table.insert(t6, t4[v])
		end

		return enrichMissingUsernames(t6)
	end
}
