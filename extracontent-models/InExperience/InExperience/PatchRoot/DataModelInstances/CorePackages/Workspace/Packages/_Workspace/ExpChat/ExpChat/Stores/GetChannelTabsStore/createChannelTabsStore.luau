local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local tutils = require(parent.tutils)
local ExpChatShared = require(parent.ExpChatShared)
local shouldRenderTextChannelInDefaultWindow = ExpChatShared.shouldRenderTextChannelInDefaultWindow
local getTextChannelDisplayMode = ExpChatShared.getTextChannelDisplayMode
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)

local shouldSuppressUnreadForTabMetadata = require(ExpChat.shouldSuppressUnreadForTabMetadata)

local SharedFlags = require(parent.SharedFlags)

local getFFlagExpChatFixChannelTabsMidExperienceToggle = require(ExpChat.Flags.getFFlagExpChatFixChannelTabsMidExperienceToggle)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

local GetFFlagExpChatSuppressWelcomeMessageTabUnread = ExpChatShared.Flags.GetFFlagExpChatSuppressWelcomeMessageTabUnread
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatFriendsTabRequireDefaultChannels = SharedFlags.FFlagExpChatFriendsTabRequireDefaultChannels

local isGlobalTabFirst = require(ExpChat.isGlobalTabFirst)
local getDefaultTabName = require(ExpChat.getDefaultTabName)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local getFixedTabPriority

local function reorderTabs(p)
	local clone = table.clone(p)

	local v = {}

	for _, v2 in pairs(clone) do
		table.insert(v, v2)
	end

	table.sort(v, function(a, b): boolean
		local v2 = getFixedTabPriority(a.name)
		local v3 = getFixedTabPriority(b.name)

		if v2 and v3 then
			return v2 < v3
		end

		if v2 then
			return true
		end

		return not v3 and a.tabIndex < b.tabIndex
	end)

	for i, v2 in ipairs(v) do
		clone[v2.name] = {
			type = v2.type,
			name = v2.name,
			tabIndex = i,
			HasUnreadMessages = v2.HasUnreadMessages
		}
	end

	return clone
end

local function insertTabAndReorder(p, p2) -- 2 equivalent calls inferred from this helper
	local clone = table.clone(p)
	clone[p2.name] = p2

	return reorderTabs(clone)
end

local function removeTabAndReorder(allChannelTabs, allChannelTab) -- 1 equivalent call inferred from this helper
	local clone = table.clone(allChannelTabs)
	clone[allChannelTab.name] = nil

	return reorderTabs(clone)
end

getFixedTabPriority = function(p: string?): nil | number
	if FFlagExpChatGlobalTabDefault and isGlobalTabFirst() then
		if p == "RBXGlobal" then
			return 1
		elseif p == "RBXGeneral" then
			return 2
		end
	else
		if p == "RBXGeneral" then
			return 1
		end

		if p == "RBXGlobal" and GetFFlagTextChatEnableUniverseChatTabs() then
			return 2
		end
	end

	if p == FriendsChatTabName and FFlagExpChatEnableFriendsTab then
		return 3
	end

	return nil
end

local function pruneNonSpecialTabs(allChannelTabs)
	local v = {}

	for k, item in allChannelTabs do
		if getFixedTabPriority(k) ~= nil then
			v[k] = item
		end
	end

	return reorderTabs(v)
end

local function isDefaultTabOnlyMode(p) -- 3 equivalent calls inferred from this helper
	return (GetFFlagTextChatEnableUniverseChatTabs() or FFlagExpChatFriendsTabRequireDefaultChannels and FFlagExpChatEnableFriendsTab)
		and not p.channelTabsConfigurationEnabled
end

local function markTabUnread(p, p2: string)
	local allChannelTab = p.allChannelTabs[p2]

	if allChannelTab == nil or allChannelTab.HasUnreadMessages or p2 == p.selectedTabName then
		return p
	end

	local clone = table.clone(p)
	clone.allChannelTabs = table.clone(p.allChannelTabs)
	local clone2 = table.clone(allChannelTab)
	clone2.HasUnreadMessages = true
	clone.allChannelTabs[p2] = clone2
	return clone
end

local function isTargetChannelNoOp(data, selectedTabName: string?, flag: boolean, flag2: boolean?)
	if FFlagExpChatGlobalTabDefault and flag2 and not data.hasUserSelectedTab then
		return false
	end

	local v

	if selectedTabName then
		v = data.allChannelTabs[selectedTabName]
	end

	if not v then
		return selectedTabName == nil
			or (isDefaultTabOnlyMode(data) and getFixedTabPriority(selectedTabName) == nil and true or data.selectedTabName == selectedTabName) -- inferred equivalent call
	end

	local v2 = not flag

	if v2 then
		if data.selectedTabName == selectedTabName then
			return v.type == "FriendsChat" or not v.HasUnreadMessages
		end

		return false
	end

	return v2
end

local function createChannelTabsStore()
	local signal, v = createSignal({
		allChannelTabs = {},
		selectedTabName = nil,
		channelTabsConfigurationEnabled = false,
		hasUserSelectedTab = false
	})

	local getSelectedTabName = createComputed(function(p)
		return signal(p).selectedTabName
	end)

	local getUnreadChannels = createComputed(function(p)
		local v2 = signal(p)
		local result = {}

		for k, allChannelTab in pairs(v2.allChannelTabs) do
			if allChannelTab.HasUnreadMessages then
				result[k] = true
			end
		end

		return result
	end, tutils.deepEqual)

	local function addChannelTab(p, value: number?) -- 1 equivalent call inferred from this helper
		local name = p.name

		v(function(p2)
			if
				p2.allChannelTabs[name] ~= nil
				or p.type == "TextChat" and name ~= "RBXGeneral" and isDefaultTabOnlyMode(p2) -- inferred equivalent call
			then
				return p2
			end

			local clone = table.clone(p2)

			local v2 = clone.allChannelTabs

			if value ~= nil then
				v2 = {}

				for k, allChannelTab in clone.allChannelTabs do
					if value <= allChannelTab.tabIndex then
						local clone2 = table.clone(allChannelTab)
						clone2.tabIndex = allChannelTab.tabIndex + 1
						v2[k] = clone2
					else
						v2[k] = allChannelTab
					end
				end
			end

			clone.allChannelTabs = insertTabAndReorder(v2, { -- inferred equivalent call
				type = p.type,
				name = name,
				tabIndex = value or 0,
				HasUnreadMessages = false
			})

			local fixedTabPriority = getFixedTabPriority(name)
			local fixedTabPriority2 = getFixedTabPriority(clone.selectedTabName)

			if clone.selectedTabName == nil then
				if p.type ~= "TextChat" then
					if FFlagExpChatGlobalTabDefault then
						clone.selectedTabName = getDefaultTabName(clone.allChannelTabs) or name
						return clone
					end

					clone.selectedTabName = clone.allChannelTabs.RBXGeneral and "RBXGeneral" or name
					return clone
				end
			elseif
				fixedTabPriority ~= nil
				and fixedTabPriority < (fixedTabPriority2 or 1e999)
				and (not FFlagExpChatEnableFriendsTab or fixedTabPriority2 ~= nil)
				and (not FFlagExpChatGlobalTabDefault or not isGlobalTabFirst() or name ~= "RBXGlobal" or not clone.hasUserSelectedTab)
			then
				clone.selectedTabName = name
			end

			return clone
		end)
	end

	return {
		getChannelTabsState = signal,
		getSelectedTabName = getSelectedTabName,
		getUnreadChannels = getUnreadChannels,
		handleIncomingOrOutgoingMessage = function(p, flag: boolean, p2: string?)
			if
				not (GetFFlagTextChatEnableUniverseChatTabs() or p.TextChannel)
				or flag
				or GetFFlagExpChatSuppressWelcomeMessageTabUnread() and shouldSuppressUnreadForTabMetadata(p.Metadata)
			then
				return
			end

			if GetFFlagTextChatEnableUniverseChatTabs() then
				if not p2 then
					if not p.TextChannel then
						return
					end

					p2 = p.TextChannel.Name
				end
			else
				p2 = nil
			end

			v(function(p3)
				if not GetFFlagTextChatEnableUniverseChatTabs() then
					local textChannel = p.TextChannel

					if textChannel == nil then
						return p3
					end

					p2 = textChannel.Name
				end

				if p2 == "RBXSystem" then
					p2 = "RBXGeneral"
				end

				return markTabUnread(p3, p2)
			end)
		end,
		setSelectedTab = function(selectedTabName: string)
			v(function(p)
				local allChannelTab = p.allChannelTabs[selectedTabName]

				if
					p.selectedTabName == selectedTabName
					and (allChannelTab == nil or not allChannelTab.HasUnreadMessages)
				then
					return p
				end

				local clone = table.clone(p)
				clone.selectedTabName = selectedTabName

				if not clone.allChannelTabs[selectedTabName] then
					return clone
				end

				clone.allChannelTabs = table.clone(clone.allChannelTabs)
				local clone2 = table.clone(clone.allChannelTabs[selectedTabName])
				clone2.HasUnreadMessages = false
				clone.allChannelTabs[selectedTabName] = clone2

				return clone
			end)
		end,
		setTargetChannel = function(selectedTabName: string?, flag: boolean, flag2: boolean?)
			v(function(p)
				if isTargetChannelNoOp(p, selectedTabName, flag, flag2) then
					return p
				end

				local clone = table.clone(p)

				if FFlagExpChatGlobalTabDefault and flag2 then
					clone.hasUserSelectedTab = true
				end

				if selectedTabName and clone.allChannelTabs[selectedTabName] then
					local allChannelTab = clone.allChannelTabs[selectedTabName]

					local v2 = {
						type = allChannelTab.type,
						name = allChannelTab.name,
						tabIndex = flag and 0 or allChannelTab.tabIndex,
						HasUnreadMessages = allChannelTab.type == "FriendsChat" and allChannelTab.HasUnreadMessages
					}

					clone.allChannelTabs = insertTabAndReorder(clone.allChannelTabs, v2) -- inferred equivalent call
					clone.selectedTabName = allChannelTab.name
					return clone
				end

				if
					selectedTabName == nil
					or isDefaultTabOnlyMode(clone) and getFixedTabPriority(selectedTabName) == nil -- inferred equivalent call
				then
					return clone
				end

				clone.selectedTabName = selectedTabName

				return clone
			end)
		end,
		addChannelTab = addChannelTab,
		handleLocalTextChannelParticipantAdded = function(p)
			if not (p.Name ~= "RBXSystem" and shouldRenderTextChannelInDefaultWindow(p, getTextChannelDisplayMode())) then
				return
			end

			addChannelTab({ type = "TextChat", name = p.Name }) -- inferred equivalent call
		end,
		handleChannelRemoved = function(p: string)
			v(function(p2)
				local allChannelTab = p2.allChannelTabs[p]

				if allChannelTab == nil then
					return p2
				end

				local clone = table.clone(p2)

				clone.allChannelTabs = removeTabAndReorder(clone.allChannelTabs, allChannelTab) -- inferred equivalent call

				if allChannelTab.name == clone.selectedTabName then
					if FFlagExpChatGlobalTabDefault then
						clone.selectedTabName = getDefaultTabName(clone.allChannelTabs)
					else
						clone.selectedTabName = clone.allChannelTabs.RBXGeneral and "RBXGeneral" or nil
					end
				end

				if clone.selectedTabName and clone.allChannelTabs[clone.selectedTabName] then
					clone.allChannelTabs = table.clone(clone.allChannelTabs)
					local clone2 = table.clone(clone.allChannelTabs[clone.selectedTabName])
					clone2.HasUnreadMessages = false
					clone.allChannelTabs[clone.selectedTabName] = clone2
				end

				return clone
			end)
		end,
		markChannelUnread = function(p: string)
			v(function(p2)
				return markTabUnread(p2, p)
			end)
		end,
		setChannelUnreadStatus = function(p: string, hasUnreadMessages: boolean)
			v(function(p2)
				local allChannelTab = p2.allChannelTabs[p]

				if allChannelTab == nil or allChannelTab.HasUnreadMessages == hasUnreadMessages then
					return p2
				end

				local clone = table.clone(p2)
				clone.allChannelTabs = table.clone(clone.allChannelTabs)
				local clone2 = table.clone(clone.allChannelTabs[p])
				clone2.HasUnreadMessages = hasUnreadMessages
				clone.allChannelTabs[p] = clone2
				return clone
			end)
		end,
		setChannelTabsConfigurationEnabled = function(channelTabsConfigurationEnabled: boolean)
			v(function(data)
				if not GetFFlagTextChatEnableUniverseChatTabs() then
					return data
				end

				if getFFlagExpChatFixChannelTabsMidExperienceToggle() and not channelTabsConfigurationEnabled then
					local allChannelTabs = pruneNonSpecialTabs(data.allChannelTabs)

					local selectedTabName = data.selectedTabName

					if selectedTabName == nil or allChannelTabs[selectedTabName] == nil then
						if FFlagExpChatGlobalTabDefault then
							selectedTabName = getDefaultTabName(allChannelTabs)
								or allChannelTabs.RBXGlobal and "RBXGlobal"
								or nil
						else
							selectedTabName = allChannelTabs.RBXGeneral and "RBXGeneral"
								or allChannelTabs.RBXGlobal and "RBXGlobal"
								or nil
						end
					end

					if selectedTabName and allChannelTabs[selectedTabName] then
						allChannelTabs[selectedTabName].HasUnreadMessages = false
					end

					return {
						allChannelTabs = allChannelTabs,
						selectedTabName = selectedTabName,
						channelTabsConfigurationEnabled = false,
						hasUserSelectedTab = data.hasUserSelectedTab
					}
				else
					local clone = table.clone(data)
					clone.channelTabsConfigurationEnabled = channelTabsConfigurationEnabled
					return clone
				end
			end)
		end
	}
end

return createChannelTabsStore
