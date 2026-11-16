local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)
local shouldRenderTextChannelInDefaultWindow = ExpChatShared.shouldRenderTextChannelInDefaultWindow
local getTextChannelDisplayMode = ExpChatShared.getTextChannelDisplayMode
local SharedFlags = require(parent.SharedFlags)

local v = ExpChatShared.Logger:new("ExpChat/Reducers/" .. script.Name)

local Actions = ExpChat.Actions
local LocalTextChannelParticipantAdded = require(Actions.LocalTextChannelParticipantAdded)
local LocalTextChannelParticipantRemoved = ExpChatShared.Actions.LocalTextChannelParticipantRemoved
local TextChannelRemoved = ExpChatShared.Actions.TextChannelRemoved
local TargetTextChannelPropertyChanged = ExpChatShared.Actions.TargetTextChannelPropertyChanged
local TextChatChannelSelected = ExpChatShared.Actions.TextChatChannelSelected
local IncomingMessageReceived = require(Actions.IncomingMessageReceived)
local UniverseChatSystemMessageAdded = require(Actions.UniverseChatSystemMessageAdded)
local UniverseChatChannelAdded = require(Actions.UniverseChatChannelAdded)
local UniverseChatChannelSelected = ExpChatShared.Actions.UniverseChatChannelSelected
local FriendsChatChannelAdded = require(Actions.FriendsChatChannelAdded)
local FriendsChatChannelRemoved = require(Actions.FriendsChatChannelRemoved)
local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)
local MarkChannelUnreadForSystemMessage = require(Actions.MarkChannelUnreadForSystemMessage)
local MarkChannelUnreadForIncomingMessage = require(Actions.MarkChannelUnreadForIncomingMessage)
local SetChannelUnreadStatus = require(Actions.SetChannelUnreadStatus)

local FFlagExpChatUnreadTabIndicatorV2Window = require(ExpChat.Flags.FFlagExpChatUnreadTabIndicatorV2Window)

local getFFlagExpChatFixChannelTabsMidExperienceToggle = require(ExpChat.Flags.getFFlagExpChatFixChannelTabsMidExperienceToggle)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatFriendsTabRequireDefaultChannels = SharedFlags.FFlagExpChatFriendsTabRequireDefaultChannels
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

local GetFFlagExpChatSuppressWelcomeMessageTabUnread = ExpChatShared.Flags.GetFFlagExpChatSuppressWelcomeMessageTabUnread

local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)
local shouldSuppressUnreadForTabMetadata = require(ExpChat.shouldSuppressUnreadForTabMetadata)
local isGlobalTabFirst = require(ExpChat.isGlobalTabFirst)
local getDefaultTabName = require(ExpChat.getDefaultTabName)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)

local function insertTabAndReorder(items, p)
	local joined = { [p.Name] = p }

	for k, item in items do
		local tabIndex = item.TabIndex < p.TabIndex and item.TabIndex or item.TabIndex + 1
		joined = dictionary.join(joined, {
			[k] = dictionary.set(items[k], "TabIndex", tabIndex)
		})
	end

	return joined
end

local function hasFriendsTab(p): boolean -- 2 equivalent calls inferred from this helper
	if FFlagExpChatEnableFriendsTab then
		return p[FriendsChatTabName] ~= nil
	end

	return false
end

local function priorityTabCount(p) -- 3 equivalent calls inferred from this helper
	return (p.RBXGeneral ~= nil and 1 or 0) + (GetFFlagTextChatEnableUniverseChatTabs() and p.RBXGlobal ~= nil and 1 or 0) + (hasFriendsTab(p) and 1 or 0) -- inferred equivalent call
end

local function nextDeveloperTabIndex(p)
	return priorityTabCount(p) + 1 -- inferred equivalent call
end

local function getPlatformTabIndex(p: string, p2): number
	if FFlagExpChatGlobalTabDefault and isGlobalTabFirst() then
		if p == "RBXGlobal" then
			return 1
		end

		if p2.RBXGlobal then
			return 2
		end
	else
		if p == "RBXGeneral" then
			return 1
		end

		if p2.RBXGeneral then
			return 2
		end
	end

	return 1
end

local function getFriendsTabIndex(allChannelTabs) -- 1 equivalent call inferred from this helper
	local v2 = allChannelTabs.RBXGeneral ~= nil
	local v3 = GetFFlagTextChatEnableUniverseChatTabs() and allChannelTabs.RBXGlobal ~= nil
	return (v2 and 1 or 0) + 1 + (v3 and 1 or 0)
end

local function removeTabAndReorder(allChannelTabs, allChannelTab)
	if allChannelTab == nil then
		return allChannelTabs
	end

	local joined = {}

	for k, item in allChannelTabs do
		if k == allChannelTab.Name then
			continue
		end

		local tabIndex = item.TabIndex < allChannelTab.TabIndex and item.TabIndex or item.TabIndex - 1
		joined = dictionary.join(joined, {
			[k] = dictionary.set(allChannelTabs[k], "TabIndex", tabIndex)
		})
	end

	return joined
end

local function removeChannelTab(data, p: string)
	local allChannelTab = data.allChannelTabs[p]

	if allChannelTab == nil then
		return data
	end

	local joined = removeTabAndReorder(data.allChannelTabs, allChannelTab)
	local selectedTabName

	if allChannelTab.Name == data.selectedTabName then
		if FFlagExpChatGlobalTabDefault then
			selectedTabName = getDefaultTabName(joined)
		else
			selectedTabName = joined.RBXGeneral and "RBXGeneral" or nil
		end
	else
		selectedTabName = data.selectedTabName
	end

	if selectedTabName and joined[selectedTabName] then
		joined = dictionary.join(joined, {
			[selectedTabName] = dictionary.join(joined[selectedTabName], {
				HasUnreadMessages = false
			})
		})
	end

	local v2 = {
		allChannelTabs = joined,
		selectedTabName = selectedTabName,
		channelTabsConfigurationEnabled = data.channelTabsConfigurationEnabled,
		hasUserSelectedTab = 0
	}
	local hasUserSelectedTab

	if FFlagExpChatGlobalTabDefault then
		hasUserSelectedTab = data.hasUserSelectedTab
	end

	v2.hasUserSelectedTab = hasUserSelectedTab
	return v2
end

local function onChannelRemoved(data, textChannel)
	if FFlagExpChatEnableFriendsTab then
		return removeChannelTab(data, textChannel.Name)
	end

	local allChannelTab = data.allChannelTabs[textChannel.Name]

	if allChannelTab == nil then
		return data
	end

	local joined = removeTabAndReorder(data.allChannelTabs, allChannelTab)
	local selectedTabName

	if allChannelTab.Name == data.selectedTabName then
		if FFlagExpChatGlobalTabDefault then
			selectedTabName = getDefaultTabName(joined)
		else
			selectedTabName = joined.RBXGeneral and "RBXGeneral" or nil
		end
	else
		selectedTabName = data.selectedTabName
	end

	if selectedTabName and joined[selectedTabName] then
		joined = dictionary.join(joined, {
			[selectedTabName] = dictionary.join(joined[selectedTabName], {
				HasUnreadMessages = false
			})
		})
	end

	local v2 = {
		allChannelTabs = joined,
		selectedTabName = selectedTabName,
		channelTabsConfigurationEnabled = data.channelTabsConfigurationEnabled,
		hasUserSelectedTab = 0
	}
	local hasUserSelectedTab

	if FFlagExpChatGlobalTabDefault then
		hasUserSelectedTab = data.hasUserSelectedTab
	end

	v2.hasUserSelectedTab = hasUserSelectedTab
	return v2
end

local function handleIncomingMessageReceived(p, data)
	v:trace("IncomingMessageReceived dispatched")

	local v2 = nil

	if GetFFlagTextChatEnableUniverseChatTabs() and data.channelNameOverride then
		v2 = data.channelNameOverride
	elseif data.textChatMessage.TextChannel then
		local name = data.textChatMessage.TextChannel.Name
		v2 = data.textChatMessage.TextChannel.Name == "RBXSystem" and "RBXGeneral" or name
	end

	local allChannelTab = p.allChannelTabs[v2]

	if
		allChannelTab == nil
		or (data.isSenderLocalPlayer or allChannelTab.Name == p.selectedTabName)
		or GetFFlagExpChatSuppressWelcomeMessageTabUnread()
		and shouldSuppressUnreadForTabMetadata(data.textChatMessage.Metadata)
	then
		return p
	end

	return dictionary.join(p, {
		allChannelTabs = dictionary.join(p.allChannelTabs, {
			[allChannelTab.Name] = dictionary.join(allChannelTab, { HasUnreadMessages = true })
		})
	})
end

local function handleUniverseChatSystemMessageAdded(p, p2)
	if not GetFFlagTextChatEnableUniverseChatTabs() then
		return p
	end

	local channelNameOverride = p2.channelNameOverride
	local allChannelTab = p.allChannelTabs[channelNameOverride]

	if
		allChannelTab == nil
		or allChannelTab.Name == p.selectedTabName
		or GetFFlagExpChatSuppressWelcomeMessageTabUnread() and shouldSuppressUnreadForTabMetadata(p2.metadata or "")
	then
		return p
	end

	return dictionary.join(p, {
		allChannelTabs = dictionary.join(p.allChannelTabs, {
			[allChannelTab.Name] = dictionary.join(allChannelTab, { HasUnreadMessages = true })
		})
	})
end

local function pruneNonSpecialTabs(allChannelTabs)
	local v2 = {}

	local v3 = allChannelTabs.RBXGeneral ~= nil

	if v3 then
		if FFlagExpChatGlobalTabDefault then
			v2.RBXGeneral = dictionary.set(
				allChannelTabs.RBXGeneral,
				"TabIndex",
				FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and allChannelTabs.RBXGlobal and 2 or 1
			)
		else
			v2.RBXGeneral = dictionary.set(allChannelTabs.RBXGeneral, "TabIndex", 1)
		end
	end

	if allChannelTabs.RBXGlobal ~= nil then
		if FFlagExpChatGlobalTabDefault then
			v2.RBXGlobal = dictionary.set(
				allChannelTabs.RBXGlobal,
				"TabIndex",
				FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and 1 or allChannelTabs.RBXGeneral and 2 or 1
			)
		else
			v2.RBXGlobal = dictionary.set(allChannelTabs.RBXGlobal, "TabIndex", v3 and 2 or 1)
		end
	end

	if hasFriendsTab(allChannelTabs) then -- inferred equivalent call
		v2[FriendsChatTabName] = allChannelTabs[FriendsChatTabName]
	end

	return v2
end

local function isDefaultTabOnlyMode(p) -- 2 equivalent calls inferred from this helper
	return (GetFFlagTextChatEnableUniverseChatTabs() or FFlagExpChatFriendsTabRequireDefaultChannels and FFlagExpChatEnableFriendsTab)
		and not p.channelTabsConfigurationEnabled
end

local function selectTextChannelTabByName(p, selectedTabName: string?, shouldReorderTabs: boolean)
	if selectedTabName and p.allChannelTabs[selectedTabName] then
		local allChannelTab = p.allChannelTabs[selectedTabName]

		local tabIndex = allChannelTab.TabIndex

		if shouldReorderTabs then
			if allChannelTab.Name == "RBXGeneral" then
				if FFlagExpChatGlobalTabDefault then
					local allChannelTabs = p.allChannelTabs
					tabIndex = FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and allChannelTabs.RBXGlobal and 2
						or 1
				else
					tabIndex = 1
				end
			elseif GetFFlagTextChatEnableUniverseChatTabs() and allChannelTab.Name == "RBXGlobal" then
				if FFlagExpChatGlobalTabDefault then
					local allChannelTabs = p.allChannelTabs
					tabIndex = FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and 1
						or allChannelTabs.RBXGeneral and 2
						or 1
				else
					tabIndex = p.allChannelTabs.RBXGeneral and 2 or 1
				end
			else
				local allChannelTabs = p.allChannelTabs
				tabIndex = priorityTabCount(allChannelTabs) + 1 -- inferred equivalent call
			end
		end

		local joined = dictionary.join(allChannelTab, {
			HasUnreadMessages = false,
			TabIndex = tabIndex
		})

		return dictionary.join(p, {
			allChannelTabs = insertTabAndReorder(removeTabAndReorder(p.allChannelTabs, allChannelTab), joined),
			selectedTabName = allChannelTab.Name
		})
	elseif isDefaultTabOnlyMode(p) then -- inferred equivalent call
		return p
	else
		return dictionary.join(p, { selectedTabName = selectedTabName })
	end
end

local createReducer = Rodux.createReducer
local v2 = {
	[ChannelTabsConfigurationEnabled.name] = function(data, p)
		if not GetFFlagTextChatEnableUniverseChatTabs() then
			return data
		end

		if not getFFlagExpChatFixChannelTabsMidExperienceToggle() or p.enabled then
			return dictionary.join(data, { channelTabsConfigurationEnabled = p.enabled })
		end

		local joined = pruneNonSpecialTabs(data.allChannelTabs)
		local selectedTabName = data.selectedTabName

		if selectedTabName == nil or joined[selectedTabName] == nil then
			if FFlagExpChatGlobalTabDefault then
				selectedTabName = getDefaultTabName(joined) or joined.RBXGlobal and "RBXGlobal" or nil
			else
				selectedTabName = joined.RBXGeneral and "RBXGeneral" or joined.RBXGlobal and "RBXGlobal" or nil
			end
		end

		if selectedTabName and joined[selectedTabName] then
			joined = dictionary.join(joined, {
				[selectedTabName] = dictionary.join(joined[selectedTabName], {
					HasUnreadMessages = false
				})
			})
		end

		local hasUserSelectedTab

		if FFlagExpChatGlobalTabDefault then
			hasUserSelectedTab = data.hasUserSelectedTab
		end

		return {
			allChannelTabs = joined,
			selectedTabName = selectedTabName,
			channelTabsConfigurationEnabled = false,
			hasUserSelectedTab = hasUserSelectedTab
		}
	end,
	[LocalTextChannelParticipantAdded.name] = function(p, p2)
		local name = p2.textChannel.Name

		v:trace("LocalTextChannelParticipantAdded dispatched: {}", name)

		if
			p.allChannelTabs[name] ~= nil
			or name == "RBXSystem"
			or not shouldRenderTextChannelInDefaultWindow(p2.textChannel, getTextChannelDisplayMode())
		then
			return p
		end

		if isDefaultTabOnlyMode(p) and name ~= "RBXGeneral" then -- inferred equivalent call
			return p
		end

		local tabIndex

		if name == "RBXGeneral" then
			if FFlagExpChatGlobalTabDefault then
				local allChannelTabs = p.allChannelTabs
				tabIndex = FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and allChannelTabs.RBXGlobal and 2 or 1
			else
				tabIndex = 1
			end
		elseif GetFFlagTextChatEnableUniverseChatTabs() and name == "RBXGlobal" then
			if FFlagExpChatGlobalTabDefault then
				local allChannelTabs = p.allChannelTabs
				tabIndex = FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and 1
					or allChannelTabs.RBXGeneral and 2
					or 1
			else
				tabIndex = p.allChannelTabs.RBXGeneral and 2 or 1
			end
		else
			local allChannelTabs = p.allChannelTabs
			tabIndex = priorityTabCount(allChannelTabs) + 1 -- inferred equivalent call
		end

		local v2 = { Name = name, HasUnreadMessages = false, TabIndex = tabIndex }

		v2.Type = "TextChat"

		local allChannelTabs = insertTabAndReorder(p.allChannelTabs, v2)

		if GetFFlagTextChatEnableUniverseChatTabs() then
			local selectedTabName = p.selectedTabName

			if
				selectedTabName == "RBXGlobal"
				and name == "RBXGeneral"
				and not (FFlagExpChatGlobalTabDefault and isGlobalTabFirst())
			then
				selectedTabName = "RBXGeneral"
			elseif
				FFlagExpChatEnableFriendsTab
				and selectedTabName == FriendsChatTabName
				and (name == "RBXGeneral" or name == "RBXGlobal")
			then
				selectedTabName = name
			end

			return dictionary.join(p, {
				allChannelTabs = allChannelTabs,
				selectedTabName = selectedTabName
			})
		elseif FFlagExpChatEnableFriendsTab and name == "RBXGeneral" and p.selectedTabName == FriendsChatTabName then
			return dictionary.join(p, {
				allChannelTabs = allChannelTabs,
				selectedTabName = "RBXGeneral"
			})
		else
			return dictionary.join(p, { allChannelTabs = allChannelTabs })
		end
	end,
	[LocalTextChannelParticipantRemoved.name] = function(p, p2)
		v:trace("LocalTextChannelParticipantRemoved dispatched: {}", p2.textChannel.Name)
		return onChannelRemoved(p, p2.textChannel)
	end,
	[TextChannelRemoved.name] = function(p, p2)
		v:trace("TextChannelRemoved dispatched: {}", p2.textChannel.Name)
		return onChannelRemoved(p, p2.textChannel)
	end,
	[TargetTextChannelPropertyChanged.name] = function(p, p2)
		v:trace("TargetTextChannelPropertyChanged dispatched")
		local v2

		if p2.textChannel then
			v2 = p2.textChannel.Name
		end

		return selectTextChannelTabByName(p, v2, p2.shouldReorderTabs)
	end,
	[TextChatChannelSelected.name] = function(p, p2)
		v:trace("TextChatChannelSelected dispatched: {}", p2.channelName)

		if FFlagExpChatGlobalTabDefault then
			return selectTextChannelTabByName(
				dictionary.join(p, { hasUserSelectedTab = true }),
				p2.channelName,
				p2.shouldReorderTabs
			)
		end

		return selectTextChannelTabByName(p, p2.channelName, p2.shouldReorderTabs)
	end,
	[IncomingMessageReceived.name] = handleIncomingMessageReceived
}

local name = MarkChannelUnreadForIncomingMessage.name

if not FFlagExpChatUnreadTabIndicatorV2Window then
	handleIncomingMessageReceived = nil
end

v2[name] = handleIncomingMessageReceived

v2[UniverseChatSystemMessageAdded.name] = handleUniverseChatSystemMessageAdded

local name2 = MarkChannelUnreadForSystemMessage.name

if not FFlagExpChatUnreadTabIndicatorV2Window then
	handleUniverseChatSystemMessageAdded = nil
end

v2[name2] = handleUniverseChatSystemMessageAdded

v2[UniverseChatChannelAdded.name] = function(data, p)
	v:trace("UniverseChatChannelAdded dispatched: {}", p.channelName)

	if data.allChannelTabs[p.channelName] ~= nil then
		return data
	end

	local tabIndex = p.tabIndex

	if GetFFlagTextChatEnableUniverseChatTabs() and p.channelName == "RBXGlobal" then
		if FFlagExpChatGlobalTabDefault then
			local allChannelTabs = data.allChannelTabs
			tabIndex = FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and 1 or allChannelTabs.RBXGeneral and 2 or 1
		else
			tabIndex = data.allChannelTabs.RBXGeneral and 2 or 1
		end
	end

	local v3 = { Name = p.channelName, HasUnreadMessages = false, TabIndex = tabIndex }

	v3.Type = "UniverseChat"

	local allChannelTabs = insertTabAndReorder(data.allChannelTabs, v3)
	local selectedTabName

	if GetFFlagTextChatEnableUniverseChatTabs() then
		selectedTabName = data.selectedTabName

		if selectedTabName == nil then
			if FFlagExpChatGlobalTabDefault then
				selectedTabName = getDefaultTabName(allChannelTabs) or p.channelName
			else
				selectedTabName = allChannelTabs.RBXGeneral and "RBXGeneral" or p.channelName
			end
		elseif
			FFlagExpChatGlobalTabDefault
			and isGlobalTabFirst()
			and p.channelName == "RBXGlobal"
			and not data.hasUserSelectedTab
		then
			selectedTabName = p.channelName
		elseif FFlagExpChatEnableFriendsTab and selectedTabName == FriendsChatTabName then
			selectedTabName = p.channelName
		end
	else
		selectedTabName = data.selectedTabName or p.channelName
	end

	return dictionary.join(data, {
		allChannelTabs = allChannelTabs,
		selectedTabName = selectedTabName
	})
end

v2[FriendsChatChannelAdded.name] = function(p, p2)
	if not FFlagExpChatEnableFriendsTab then
		return p
	end

	v:trace("FriendsChatChannelAdded dispatched: {}", p2.channelName)

	if p.allChannelTabs[p2.channelName] ~= nil then
		return p
	end

	local v3 = {
		Name = p2.channelName,
		HasUnreadMessages = false,
		TabIndex = getFriendsTabIndex(p.allChannelTabs), -- inferred equivalent call
		Type = "FriendsChat"
	}

	local allChannelTabs = insertTabAndReorder(p.allChannelTabs, v3)
	local selectedTabName = p.selectedTabName

	if selectedTabName == nil then
		if FFlagExpChatGlobalTabDefault then
			selectedTabName = getDefaultTabName(allChannelTabs) or p2.channelName
		else
			selectedTabName = allChannelTabs.RBXGeneral and "RBXGeneral" or p2.channelName
		end
	end

	return dictionary.join(p, { allChannelTabs = allChannelTabs, selectedTabName = selectedTabName })
end

v2[FriendsChatChannelRemoved.name] = function(p, p2)
	if not FFlagExpChatEnableFriendsTab then
		return p
	end

	v:trace("FriendsChatChannelRemoved dispatched: {}", p2.channelName)
	return removeChannelTab(p, p2.channelName)
end

v2[FriendsChatChannelSelected.name] = function(p, p2)
	if not FFlagExpChatEnableFriendsTab then
		return p
	end

	v:trace("FriendsChatChannelSelected dispatched: {}", p2.channelName)

	return dictionary.join(p, { selectedTabName = p2.channelName })
end

v2[SetChannelUnreadStatus.name] = function(p, p2)
	local allChannelTab = p.allChannelTabs[p2.channelName]

	if allChannelTab == nil then
		return p
	end

	return dictionary.join(p, {
		allChannelTabs = dictionary.join(p.allChannelTabs, {
			[p2.channelName] = dictionary.join(allChannelTab, {
				HasUnreadMessages = p2.hasUnreadMessages
			})
		})
	})
end

v2[UniverseChatChannelSelected.name] = function(p, p2)
	v:trace("UniverseChatChannelSelected dispatched: {}", p2.channelName)

	local allChannelTab = p.allChannelTabs[p2.channelName]

	if allChannelTab == nil then
		if FFlagExpChatGlobalTabDefault then
			return dictionary.join(p, {
				selectedTabName = p2.channelName,
				hasUserSelectedTab = p2.isUserInitiated and true or nil
			})
		end

		return dictionary.join(p, { selectedTabName = p2.channelName })
	end

	return dictionary.join(p, {
		allChannelTabs = dictionary.join(p.allChannelTabs, {
			[p2.channelName] = dictionary.join(allChannelTab, { HasUnreadMessages = false })
		}),
		selectedTabName = p2.channelName,
		hasUserSelectedTab = FFlagExpChatGlobalTabDefault and p2.isUserInitiated and true or nil
	})
end

return createReducer(
	{
		allChannelTabs = {},
		selectedTabName = nil,
		channelTabsConfigurationEnabled = false,
		hasUserSelectedTab = false
	},
	v2
)
