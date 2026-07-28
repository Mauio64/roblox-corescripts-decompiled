local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local v7 = ExpChatShared.Logger:new("ExpChat/Reducers/" .. script.Name)
local Actions = ExpChat.Actions
local LocalTextChannelParticipantAdded = require(Actions.LocalTextChannelParticipantAdded)
local LocalTextChannelParticipantRemoved = ExpChatShared.Actions.LocalTextChannelParticipantRemoved
local TextChannelRemoved = ExpChatShared.Actions.TextChannelRemoved
local TargetTextChannelPropertyChanged = ExpChatShared.Actions.TargetTextChannelPropertyChanged
local IncomingMessageReceived = require(Actions.IncomingMessageReceived)
local UniverseChatSystemMessageAdded = require(Actions.UniverseChatSystemMessageAdded)
local UniverseChatChannelAdded = require(Actions.UniverseChatChannelAdded)
local UniverseChatChannelSelected = ExpChatShared.Actions.UniverseChatChannelSelected
local FriendsChatChannelAdded = require(Actions.FriendsChatChannelAdded)
local FriendsChatChannelRemoved = require(Actions.FriendsChatChannelRemoved)
local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local MarkChannelUnreadForSystemMessage = require(Actions.MarkChannelUnreadForSystemMessage)
local MarkChannelUnreadForIncomingMessage = require(Actions.MarkChannelUnreadForIncomingMessage)
local SetChannelUnreadStatus = require(Actions.SetChannelUnreadStatus)
local FFlagExpChatUnreadTabIndicatorV2Window = require(ExpChat.Flags.FFlagExpChatUnreadTabIndicatorV2Window)
local getFFlagExpChatFixChannelTabsMidExperienceToggle = require(ExpChat.Flags.getFFlagExpChatFixChannelTabsMidExperienceToggle)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local GetFFlagExpChatSuppressWelcomeMessageTabUnread = ExpChatShared.Flags.GetFFlagExpChatSuppressWelcomeMessageTabUnread
local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)
local shouldSuppressUnreadForTabMetadata = require(ExpChat.shouldSuppressUnreadForTabMetadata)
local t1 = {
	selectedTabName = nil,
	channelTabsConfigurationEnabled = false,
	allChannelTabs = {}
}

local function insertTabAndReorder(t2: {[any]: any}, t3: {[any]: any}) -- line: 63
	-- upvalues: Dictionary (copy)
	local t4 = {
		[t3.Name] = t3
	}

	for v47, v48 in t2 do
		local v49 = v48.TabIndex < t3.TabIndex and v48.TabIndex or v48.TabIndex + 1

		t4 = Dictionary.join(t4, {
			[v47] = Dictionary.set(t2[v47], "TabIndex", v49)
		})
	end

	return t4
end
local function hasFriendsTab(t5: {[any]: any}) -- line: 81
	-- upvalues: FFlagExpChatEnableFriendsTab (copy)
	if not FFlagExpChatEnableFriendsTab then
		return false
	end

	return t5.FriendsChat ~= nil
end
local function priorityTabCount(t6: {[any]: any}) -- line: 90
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy)
	local v52 = t6.RBXGeneral ~= nil
	local v53 = GetFFlagTextChatEnableUniverseChatTabs() and t6.RBXGlobal ~= nil

	return (not v52 and 0 or 1) + (not v53 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then t6.FriendsChat ~= nil else false) and 0 or 1)
end
local function nextDeveloperTabIndex(t7: {[any]: any}) -- line: 100
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy)
	local v55 = t7.RBXGeneral ~= nil
	local v56 = GetFFlagTextChatEnableUniverseChatTabs() and t7.RBXGlobal ~= nil

	return (not v55 and 0 or 1) + (not v56 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then t7.FriendsChat ~= nil else false) and 0 or 1) + 1
end
local function getFriendsTabIndex(t8: {[any]: any}) -- line: 104
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy)
	local v58 = t8.RBXGeneral ~= nil
	local v59 = GetFFlagTextChatEnableUniverseChatTabs() and t8.RBXGlobal ~= nil

	return (not v58 and 0 or 1) + 1 + (not v59 and 0 or 1)
end
local function removeTabAndReorder(t9: {[any]: any}, t10: {[any]: any}) -- line: 110
	-- upvalues: Dictionary (copy)
	if t10 == nil then
		return t9
	end

	local t11 = {}

	for v63, v64 in t9 do
		if v63 ~= t10.Name then
			local v65 = v64.TabIndex < t10.TabIndex and v64.TabIndex or v64.TabIndex - 1

			t11 = Dictionary.join(t11, {
				[v63] = Dictionary.set(t9[v63], "TabIndex", v65)
			})
		end
	end

	return t11
end
local function removeChannelTab(t12: {[any]: any}, s1: string) -- line: 134
	-- upvalues: removeTabAndReorder (copy), Dictionary (copy)
	local v68 = t12.allChannelTabs[s1]

	if v68 == nil then
		return t12
	end

	local v69 = removeTabAndReorder(t12.allChannelTabs, v68)
	local v70 = if v68.Name ~= t12.selectedTabName then t12.selectedTabName else if not v69.RBXGeneral then nil else "RBXGeneral"

	return {
		allChannelTabs = if not (v70 and v69[v70]) then v69 else Dictionary.join(v69, {
			[v70] = Dictionary.join(v69[v70], {
				HasUnreadMessages = false
			})
		}),
		selectedTabName = v70,
		channelTabsConfigurationEnabled = t12.channelTabsConfigurationEnabled
	}
end
local function onChannelRemoved(t13: {[any]: any}, p1) -- line: 159
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), removeTabAndReorder (copy), Dictionary (copy), removeChannelTab (copy)
	if not FFlagExpChatEnableFriendsTab then
		local v73 = t13.allChannelTabs[p1.Name]

		if v73 == nil then
			return t13
		end

		local v74 = removeTabAndReorder(t13.allChannelTabs, v73)
		local v75 = if v73.Name ~= t13.selectedTabName then t13.selectedTabName else if not v74.RBXGeneral then nil else "RBXGeneral"

		return {
			allChannelTabs = if not (v75 and v74[v75]) then v74 else Dictionary.join(v74, {
				[v75] = Dictionary.join(v74[v75], {
					HasUnreadMessages = false
				})
			}),
			selectedTabName = v75,
			channelTabsConfigurationEnabled = t13.channelTabsConfigurationEnabled
		}
	end

	return (removeChannelTab(t13, p1.Name))
end
local function handleIncomingMessageReceived(t14: {[any]: any}, p2) -- line: 188
	-- upvalues: v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), shouldSuppressUnreadForTabMetadata (copy), Dictionary (copy)
	v7:trace("IncomingMessageReceived dispatched")

	local channelNameOverride = nil

	if GetFFlagTextChatEnableUniverseChatTabs() and p2.channelNameOverride then
		channelNameOverride = p2.channelNameOverride
	elseif p2.textChatMessage.TextChannel then
		channelNameOverride = p2.textChatMessage.TextChannel.Name

		if p2.textChatMessage.TextChannel.Name == "RBXSystem" then
			channelNameOverride = "RBXGeneral"
		end
	end

	local v79 = t14.allChannelTabs[channelNameOverride]

	if v79 == nil then
		return t14
	end

	if p2.isSenderLocalPlayer or v79.Name == t14.selectedTabName then
		return t14
	end

	if GetFFlagExpChatSuppressWelcomeMessageTabUnread() and shouldSuppressUnreadForTabMetadata(p2.textChatMessage.Metadata) then
		return t14
	end

	return Dictionary.join(t14, {
		allChannelTabs = Dictionary.join(t14.allChannelTabs, {
			[v79.Name] = Dictionary.join(v79, {
				HasUnreadMessages = true
			})
		})
	})
end
local function handleUniverseChatSystemMessageAdded(t15: {[any]: any}, p3) -- line: 229
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), shouldSuppressUnreadForTabMetadata (copy), Dictionary (copy)
	if not GetFFlagTextChatEnableUniverseChatTabs() then
		return t15
	end

	local channelNameOverride = p3.channelNameOverride
	local v83 = t15.allChannelTabs[channelNameOverride]

	if v83 == nil then
		return t15
	end

	if v83.Name == t15.selectedTabName then
		return t15
	end

	if GetFFlagExpChatSuppressWelcomeMessageTabUnread() and shouldSuppressUnreadForTabMetadata(p3.metadata or "") then
		return t15
	end

	return Dictionary.join(t15, {
		allChannelTabs = Dictionary.join(t15.allChannelTabs, {
			[v83.Name] = Dictionary.join(v83, {
				HasUnreadMessages = true
			})
		})
	})
end
local function pruneNonSpecialTabs(t16: {[any]: any}) -- line: 262
	-- upvalues: Dictionary (copy), FFlagExpChatEnableFriendsTab (copy)
	local t17 = {}
	local v86 = t16.RBXGeneral ~= nil

	if v86 then
		t17.RBXGeneral = Dictionary.set(t16.RBXGeneral, "TabIndex", 1)
	end

	if t16.RBXGlobal ~= nil then
		t17.RBXGlobal = Dictionary.set(t16.RBXGlobal, "TabIndex", not v86 and 1 or 2)
	end

	if if FFlagExpChatEnableFriendsTab then t16.FriendsChat ~= nil else false then
		t17.FriendsChat = t16.FriendsChat
	end

	return t17
end

return Rodux.createReducer(t1, {
	[ChannelTabsConfigurationEnabled.name] = function(t18: {[any]: any}, p4) -- line: 283
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), getFFlagExpChatFixChannelTabsMidExperienceToggle (copy), Dictionary (copy), pruneNonSpecialTabs (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() then
			return t18
		end

		if not getFFlagExpChatFixChannelTabsMidExperienceToggle() or p4.enabled then
			return Dictionary.join(t18, {
				channelTabsConfigurationEnabled = p4.enabled
			})
		end

		local v89 = pruneNonSpecialTabs(t18.allChannelTabs)
		local selectedTabName = t18.selectedTabName

		if selectedTabName == nil or v89[selectedTabName] == nil then
			selectedTabName = if not v89.RBXGeneral then if not v89.RBXGlobal then nil else "RBXGlobal" else "RBXGeneral"
		end

		if selectedTabName and v89[selectedTabName] then
			v89 = Dictionary.join(v89, {
				[selectedTabName] = Dictionary.join(v89[selectedTabName], {
					HasUnreadMessages = false
				})
			})
		end

		return {
			channelTabsConfigurationEnabled = false,
			allChannelTabs = v89,
			selectedTabName = selectedTabName
		}
	end,
	[LocalTextChannelParticipantAdded.name] = function(t19: {[any]: any}, p5) -- line: 318
		-- upvalues: v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy), FFlagExpChatChannelTabRefactor (copy), insertTabAndReorder (copy), Dictionary (copy)
		local textChannelName = p5.textChannel.Name

		v7:trace("LocalTextChannelParticipantAdded dispatched: {}", textChannelName)

		if t19.allChannelTabs[textChannelName] ~= nil or textChannelName == "RBXSystem" then
			return t19
		end

		if GetFFlagTextChatEnableUniverseChatTabs() and not t19.channelTabsConfigurationEnabled and textChannelName ~= "RBXGeneral" then
			return t19
		end

		local n1

		if textChannelName == "RBXGeneral" then
			n1 = 1
		elseif GetFFlagTextChatEnableUniverseChatTabs() and textChannelName == "RBXGlobal" then
			n1 = not t19.allChannelTabs.RBXGeneral and 1 or 2
		else
			local allChannelTabs = t19.allChannelTabs
			local v96 = allChannelTabs.RBXGeneral ~= nil
			local v97 = GetFFlagTextChatEnableUniverseChatTabs() and allChannelTabs.RBXGlobal ~= nil

			n1 = (not v96 and 0 or 1) + (not v97 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then allChannelTabs.FriendsChat ~= nil else false) and 0 or 1) + 1
		end

		local t20 = {
			HasUnreadMessages = false,
			Name = textChannelName,
			TabIndex = n1
		}

		if FFlagExpChatChannelTabRefactor then
			t20.Type = "TextChat"
		end

		local v99 = insertTabAndReorder(t19.allChannelTabs, t20)

		if GetFFlagTextChatEnableUniverseChatTabs() then
			local selectedTabName = t19.selectedTabName

			if selectedTabName == "RBXGlobal" and textChannelName == "RBXGeneral" then
				selectedTabName = "RBXGeneral"
			elseif FFlagExpChatEnableFriendsTab and selectedTabName == "FriendsChat" and (textChannelName == "RBXGeneral" or textChannelName == "RBXGlobal") then
				selectedTabName = textChannelName
			end

			return Dictionary.join(t19, {
				allChannelTabs = v99,
				selectedTabName = selectedTabName
			})
		end

		if FFlagExpChatEnableFriendsTab and textChannelName == "RBXGeneral" and t19.selectedTabName == "FriendsChat" then
			return Dictionary.join(t19, {
				selectedTabName = "RBXGeneral",
				allChannelTabs = v99
			})
		end

		return Dictionary.join(t19, {
			allChannelTabs = v99
		})
	end,
	[LocalTextChannelParticipantRemoved.name] = function(t21: {[any]: any}, p6) -- line: 387
		-- upvalues: v7 (copy), onChannelRemoved (copy)
		v7:trace("LocalTextChannelParticipantRemoved dispatched: {}", p6.textChannel.Name)

		return (onChannelRemoved(t21, p6.textChannel))
	end,
	[TextChannelRemoved.name] = function(t22: {[any]: any}, p7) -- line: 395
		-- upvalues: v7 (copy), onChannelRemoved (copy)
		v7:trace("TextChannelRemoved dispatched: {}", p7.textChannel.Name)

		return (onChannelRemoved(t22, p7.textChannel))
	end,
	[TargetTextChannelPropertyChanged.name] = function(t23: {[any]: any}, p8) -- line: 400
		-- upvalues: v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy), Dictionary (copy), insertTabAndReorder (copy), removeTabAndReorder (copy)
		v7:trace("TargetTextChannelPropertyChanged dispatched")

		if p8.textChannel and t23.allChannelTabs[p8.textChannel.Name] then
			local v107 = t23.allChannelTabs[p8.textChannel.Name]
			local TabIndex = v107.TabIndex

			if p8.shouldReorderTabs then
				if v107.Name == "RBXGeneral" then
					TabIndex = 1
				elseif GetFFlagTextChatEnableUniverseChatTabs() and v107.Name == "RBXGlobal" then
					TabIndex = not t23.allChannelTabs.RBXGeneral and 1 or 2
				else
					local allChannelTabs = t23.allChannelTabs
					local v110 = allChannelTabs.RBXGeneral ~= nil
					local v111 = GetFFlagTextChatEnableUniverseChatTabs() and allChannelTabs.RBXGlobal ~= nil

					TabIndex = (not v110 and 0 or 1) + (not v111 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then allChannelTabs.FriendsChat ~= nil else false) and 0 or 1) + 1
				end
			end

			local v112 = Dictionary.join(v107, {
				HasUnreadMessages = false,
				TabIndex = TabIndex
			})

			return Dictionary.join(t23, {
				allChannelTabs = insertTabAndReorder(removeTabAndReorder(t23.allChannelTabs, v107), v112),
				selectedTabName = v107.Name
			})
		end

		if GetFFlagTextChatEnableUniverseChatTabs() and not t23.channelTabsConfigurationEnabled then
			return t23
		end

		return Dictionary.join(t23, {
			selectedTabName = if not p8.textChannel then nil else p8.textChannel.Name
		})
	end,
	[IncomingMessageReceived.name] = handleIncomingMessageReceived,
	[MarkChannelUnreadForIncomingMessage.name] = if not FFlagExpChatUseMessagesStore or not FFlagExpChatUnreadTabIndicatorV2Window then nil else handleIncomingMessageReceived,
	[UniverseChatSystemMessageAdded.name] = handleUniverseChatSystemMessageAdded,
	[MarkChannelUnreadForSystemMessage.name] = if not FFlagExpChatUseMessagesStore or not FFlagExpChatUnreadTabIndicatorV2Window then nil else handleUniverseChatSystemMessageAdded,
	[UniverseChatChannelAdded.name] = function(t24: {[any]: any}, p9) -- line: 458
		-- upvalues: v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatChannelTabRefactor (copy), insertTabAndReorder (copy), FFlagExpChatEnableFriendsTab (copy), Dictionary (copy)
		v7:trace("UniverseChatChannelAdded dispatched: {}", p9.channelName)

		if t24.allChannelTabs[p9.channelName] ~= nil then
			return t24
		end

		local tabIndex = p9.tabIndex

		if GetFFlagTextChatEnableUniverseChatTabs() and p9.channelName == "RBXGlobal" then
			tabIndex = not t24.allChannelTabs.RBXGeneral and 1 or 2
		end

		local t25 = {
			HasUnreadMessages = false,
			Name = p9.channelName,
			TabIndex = tabIndex
		}

		if FFlagExpChatChannelTabRefactor then
			t25.Type = "UniverseChat"
		end

		local v117 = insertTabAndReorder(t24.allChannelTabs, t25)
		local selectedTabName

		if GetFFlagTextChatEnableUniverseChatTabs() then
			selectedTabName = t24.selectedTabName

			if selectedTabName == nil then
				selectedTabName = if not v117.RBXGeneral then p9.channelName else "RBXGeneral"
			elseif FFlagExpChatEnableFriendsTab and selectedTabName == "FriendsChat" then
				selectedTabName = p9.channelName
			end
		else
			selectedTabName = t24.selectedTabName or p9.channelName
		end

		return Dictionary.join(t24, {
			allChannelTabs = v117,
			selectedTabName = selectedTabName
		})
	end,
	[FriendsChatChannelAdded.name] = function(t26: {[any]: any}, p10) -- line: 499
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), insertTabAndReorder (copy), Dictionary (copy)
		if not FFlagExpChatEnableFriendsTab then
			return t26
		end

		v7:trace("FriendsChatChannelAdded dispatched: {}", p10.channelName)

		if t26.allChannelTabs[p10.channelName] ~= nil then
			return t26
		end

		local t27 = {
			HasUnreadMessages = false,
			Type = "FriendsChat",
			Name = p10.channelName
		}
		local allChannelTabs = t26.allChannelTabs
		local v123 = allChannelTabs.RBXGeneral ~= nil
		local v124 = GetFFlagTextChatEnableUniverseChatTabs() and allChannelTabs.RBXGlobal ~= nil

		t27.TabIndex = (not v123 and 0 or 1) + 1 + (not v124 and 0 or 1)

		local v125 = insertTabAndReorder(t26.allChannelTabs, t27)
		local selectedTabName = t26.selectedTabName

		if selectedTabName == nil then
			selectedTabName = if not v125.RBXGeneral then p10.channelName else "RBXGeneral"
		end

		return Dictionary.join(t26, {
			allChannelTabs = v125,
			selectedTabName = selectedTabName
		})
	end,
	[FriendsChatChannelRemoved.name] = function(t28: {[any]: any}, p11) -- line: 528
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), v7 (copy), removeChannelTab (copy)
		if not FFlagExpChatEnableFriendsTab then
			return t28
		end

		v7:trace("FriendsChatChannelRemoved dispatched: {}", p11.channelName)

		return (removeChannelTab(t28, p11.channelName))
	end,
	[FriendsChatChannelSelected.name] = function(t29: {[any]: any}, p12) -- line: 536
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), v7 (copy), Dictionary (copy)
		if not FFlagExpChatEnableFriendsTab then
			return t29
		end

		v7:trace("FriendsChatChannelSelected dispatched: {}", p12.channelName)

		return Dictionary.join(t29, {
			selectedTabName = p12.channelName
		})
	end,
	[SetChannelUnreadStatus.name] = function(t30: {[any]: any}, p13) -- line: 548
		-- upvalues: Dictionary (copy)
		local v133 = t30.allChannelTabs[p13.channelName]

		if v133 == nil then
			return t30
		end

		return Dictionary.join(t30, {
			allChannelTabs = Dictionary.join(t30.allChannelTabs, {
				[p13.channelName] = Dictionary.join(v133, {
					HasUnreadMessages = p13.hasUnreadMessages
				})
			})
		})
	end,
	[UniverseChatChannelSelected.name] = function(t31: {[any]: any}, p14) -- line: 563
		-- upvalues: v7 (copy), Dictionary (copy)
		v7:trace("UniverseChatChannelSelected dispatched: {}", p14.channelName)

		local v136 = t31.allChannelTabs[p14.channelName]

		if v136 == nil then
			return Dictionary.join(t31, {
				selectedTabName = p14.channelName
			})
		end

		return Dictionary.join(t31, {
			allChannelTabs = Dictionary.join(t31.allChannelTabs, {
				[p14.channelName] = Dictionary.join(v136, {
					HasUnreadMessages = false
				})
			}),
			selectedTabName = p14.channelName
		})
	end
})
