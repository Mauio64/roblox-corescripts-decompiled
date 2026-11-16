local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Promise = require(CorePackages.Packages.Promise)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local ExpChatMessageHelpers = require(script.Parent.ExpChatMessageHelpers)
local inExpChatMessagesLoaderUsernameEnrichment = require(script.Parent.inExpChatMessagesLoaderUsernameEnrichment)
local enrichMissingUsernames = inExpChatMessagesLoaderUsernameEnrichment.enrichMissingUsernames

local ChannelTabDisplayLabel = ExpChatShared.ChannelTabDisplayLabel
local GetChannelTabsStore = ExpChat.Stores.GetChannelTabsStore

local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatUseSharedChannelTabDisplayLabel = SharedFlags.FFlagExpChatUseSharedChannelTabDisplayLabel

local v = Localization.new(LocalizationService.RobloxLocaleId)

local function getLocalizedChannelTabLabels()
	local localizationKeys = ChannelTabDisplayLabel.LocalizationKeys
	return {
		yourServer = v:Format(localizationKeys.yourServer),
		moreServers = v:Format(localizationKeys.moreServers),
		friends = v:Format(localizationKeys.friends),
		system = v:Format(localizationKeys.system),
		team = v:Format(localizationKeys.team)
	}
end

return {
	type = "groupedListItem",
	fetch = function(_)
		local store = ExpChatShared.context.store

		if not store then
			return Promise.resolve({})
		end

		local state = store:getState()

		local messagesStore = ExpChatShared.context.messagesStore

		if not messagesStore then
			return Promise.resolve({})
		end

		local v2 = messagesStore.getByMessageId(false) or {}
		local v3 = messagesStore.getWindowMessagesInOrder(false) or {}
		local v4 = messagesStore.getWindowMessagesInOrderByTabId(false) or {}

		local translator = ExpChatShared.context.translator

		if ExpChatMessageHelpers.areChannelTabsEnabled() then
			local allTextChannels = state.TextChannels and state.TextChannels.allTextChannels or {}

			local allChannelTabs = GetChannelTabsStore(false).getChannelTabsState(false).allChannelTabs
			local v5

			if FFlagExpChatUseSharedChannelTabDisplayLabel then
				v5 = getLocalizedChannelTabLabels()
			end

			local v6 = {}
			local v7 = {}

			for k, v8 in pairs(v4) do
				local items = ExpChatMessageHelpers.collectItems(v2, v8)

				if not (#items > 0) then
					continue
				end

				local label

				if FFlagExpChatUseSharedChannelTabDisplayLabel then
					local kind

					if FFlagExpChatUseChannelTabsStore then
						local allChannelTab = allChannelTabs[k]

						if allChannelTab then
							kind = allChannelTab.type
						end
					else
						local allChannelTabs2 = state.ChannelTabs and state.ChannelTabs.allChannelTabs
						local v9 = allChannelTabs2 and allChannelTabs2[k]

						if v9 then
							kind = v9.Type
						end
					end

					if kind then
						label = ChannelTabDisplayLabel.getDisplayLabel(
							kind,
							k,
							allTextChannels[k],
							Players.LocalPlayer,
							v5
						)
					else
						label = k
					end
				else
					label = ExpChatMessageHelpers.localizeString(
						translator,
						ExpChatMessageHelpers.formatChannelLabel(k, allTextChannels[k])
					)
				end

				table.insert(v6, k)
				v7[k] = { id = k, label = label, items = items }
			end

			table.sort(v6, function(a, b): boolean
				local allChannelTab = allChannelTabs[a]
				local allChannelTab2 = allChannelTabs[b]

				if allChannelTab and allChannelTab2 then
					return allChannelTab.tabIndex < allChannelTab2.tabIndex
				end

				if allChannelTab then
					return true
				end

				if allChannelTab2 then
					return false
				end

				if a == ExpChatMessageHelpers.CHANNEL_GENERAL then
					return true
				end

				return b ~= ExpChatMessageHelpers.CHANNEL_GENERAL and a < b
			end)

			local v8 = {}

			for _, v9 in ipairs(v6) do
				table.insert(v8, v7[v9])
			end

			return enrichMissingUsernames(v8)
		else
			local v5 = {}
			local v6 = {}

			for _, v7 in ipairs(v3) do
				local v8 = v2[v7]

				if not v8 then
					continue
				end

				if v8.textChannel then
					table.insert(v5, v7)
				else
					table.insert(v6, v7)
				end
			end

			local v7 = {}

			local items = ExpChatMessageHelpers.collectItems(v2, v5)
			ExpChatMessageHelpers.annotateWhisperItems(items, v2, v:Format("Feature.ReportAbuse.Label.SentPrivately"))

			if #items > 0 then
				table.insert(v7, {
					id = ExpChatMessageHelpers.CHANNEL_GENERAL,
					label = v:Format(not FFlagExpChatUseSharedChannelTabDisplayLabel and "CoreScripts.TextChat.ChannelTabs.Here" or ChannelTabDisplayLabel.LocalizationKeys.yourServer),
					items = items
				})
			end

			local items2 = ExpChatMessageHelpers.collectItems(v2, v6)

			if #items2 > 0 then
				table.insert(v7, {
					id = ExpChatMessageHelpers.CHANNEL_GLOBAL,
					label = v:Format("CoreScripts.TextChat.ChannelTabs.Global2"),
					items = items2
				})
			end

			return enrichMissingUsernames(v7)
		end
	end
}
