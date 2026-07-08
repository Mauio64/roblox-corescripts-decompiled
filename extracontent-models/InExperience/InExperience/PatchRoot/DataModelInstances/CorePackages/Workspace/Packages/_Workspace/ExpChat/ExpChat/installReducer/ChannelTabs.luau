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

local function insertTabAndReorder(t2: {[any]: any}, t3: {[any]: any}) -- line: 62
	-- upvalues: Dictionary (copy)
	local t4 = {
		[t3.Name] = t3
	}

	for v44, v45 in t2 do
		local v46 = v45.TabIndex < t3.TabIndex and v45.TabIndex or v45.TabIndex + 1

		t4 = Dictionary.join(t4, {
			[v44] = Dictionary.set(t2[v44], "TabIndex", v46)
		})
	end

	return t4
end
local function hasFriendsTab(t5: {[any]: any}) -- line: 80
	-- upvalues: FFlagExpChatEnableFriendsTab (copy)
	if not FFlagExpChatEnableFriendsTab then
		return false
	end

	return t5.FriendsChat ~= nil
end
local function priorityTabCount(t6: {[any]: any}) -- line: 89
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy)
	local v49 = t6.RBXGeneral ~= nil
	local v50 = GetFFlagTextChatEnableUniverseChatTabs() and t6.RBXGlobal ~= nil

	return (not v49 and 0 or 1) + (not v50 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then t6.FriendsChat ~= nil else false) and 0 or 1)
end
local function nextDeveloperTabIndex(t7: {[any]: any}) -- line: 99
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy)
	local v52 = t7.RBXGeneral ~= nil
	local v53 = GetFFlagTextChatEnableUniverseChatTabs() and t7.RBXGlobal ~= nil

	return (not v52 and 0 or 1) + (not v53 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then t7.FriendsChat ~= nil else false) and 0 or 1) + 1
end
local function removeTabAndReorder(t8: {[any]: any}, t9: {[any]: any}) -- line: 103
	-- upvalues: Dictionary (copy)
	if t9 == nil then
		return t8
	end

	local t10 = {}

	for v57, v58 in t8 do
		if v57 ~= t9.Name then
			local v59 = v58.TabIndex < t9.TabIndex and v58.TabIndex or v58.TabIndex - 1

			t10 = Dictionary.join(t10, {
				[v57] = Dictionary.set(t8[v57], "TabIndex", v59)
			})
		end
	end

	return t10
end
local function onChannelRemoved(t11: {[any]: any}, p1) -- line: 127
	-- upvalues: removeTabAndReorder (copy), Dictionary (copy)
	local v62 = t11.allChannelTabs[p1.Name]

	if v62 == nil then
		return t11
	end

	local v63 = removeTabAndReorder(t11.allChannelTabs, v62)
	local v64 = if v62.Name ~= t11.selectedTabName then t11.selectedTabName else if not v63.RBXGeneral then nil else "RBXGeneral"

	return {
		allChannelTabs = if not (v64 and v63[v64]) then v63 else Dictionary.join(v63, {
			[v64] = Dictionary.join(v63[v64], {
				HasUnreadMessages = false
			})
		}),
		selectedTabName = v64,
		channelTabsConfigurationEnabled = t11.channelTabsConfigurationEnabled
	}
end
local function handleIncomingMessageReceived(t12: {[any]: any}, p2) -- line: 152
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

	local v68 = t12.allChannelTabs[channelNameOverride]

	if v68 == nil then
		return t12
	end

	if p2.isSenderLocalPlayer or v68.Name == t12.selectedTabName then
		return t12
	end

	if GetFFlagExpChatSuppressWelcomeMessageTabUnread() and shouldSuppressUnreadForTabMetadata(p2.textChatMessage.Metadata) then
		return t12
	end

	return Dictionary.join(t12, {
		allChannelTabs = Dictionary.join(t12.allChannelTabs, {
			[v68.Name] = Dictionary.join(v68, {
				HasUnreadMessages = true
			})
		})
	})
end
local function handleUniverseChatSystemMessageAdded(t13: {[any]: any}, p3) -- line: 193
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), shouldSuppressUnreadForTabMetadata (copy), Dictionary (copy)
	if not GetFFlagTextChatEnableUniverseChatTabs() then
		return t13
	end

	local channelNameOverride = p3.channelNameOverride
	local v72 = t13.allChannelTabs[channelNameOverride]

	if v72 == nil then
		return t13
	end

	if v72.Name == t13.selectedTabName then
		return t13
	end

	if GetFFlagExpChatSuppressWelcomeMessageTabUnread() and shouldSuppressUnreadForTabMetadata(p3.metadata or "") then
		return t13
	end

	return Dictionary.join(t13, {
		allChannelTabs = Dictionary.join(t13.allChannelTabs, {
			[v72.Name] = Dictionary.join(v72, {
				HasUnreadMessages = true
			})
		})
	})
end
local function pruneNonSpecialTabs(t14: {[any]: any}) -- line: 226
	-- upvalues: Dictionary (copy), FFlagExpChatEnableFriendsTab (copy)
	local t15 = {}
	local v75 = t14.RBXGeneral ~= nil

	if v75 then
		t15.RBXGeneral = Dictionary.set(t14.RBXGeneral, "TabIndex", 1)
	end

	if t14.RBXGlobal ~= nil then
		t15.RBXGlobal = Dictionary.set(t14.RBXGlobal, "TabIndex", not v75 and 1 or 2)
	end

	if if FFlagExpChatEnableFriendsTab then t14.FriendsChat ~= nil else false then
		t15.FriendsChat = t14.FriendsChat
	end

	return t15
end

return Rodux.createReducer(t1, {
	[ChannelTabsConfigurationEnabled.name] = function(t16: {[any]: any}, p4) -- line: 247
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), getFFlagExpChatFixChannelTabsMidExperienceToggle (copy), Dictionary (copy), pruneNonSpecialTabs (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() then
			return t16
		end

		if not getFFlagExpChatFixChannelTabsMidExperienceToggle() or p4.enabled then
			return Dictionary.join(t16, {
				channelTabsConfigurationEnabled = p4.enabled
			})
		end

		local v78 = pruneNonSpecialTabs(t16.allChannelTabs)
		local selectedTabName = t16.selectedTabName

		if selectedTabName == nil or v78[selectedTabName] == nil then
			selectedTabName = if not v78.RBXGeneral then if not v78.RBXGlobal then nil else "RBXGlobal" else "RBXGeneral"
		end

		if selectedTabName and v78[selectedTabName] then
			v78 = Dictionary.join(v78, {
				[selectedTabName] = Dictionary.join(v78[selectedTabName], {
					HasUnreadMessages = false
				})
			})
		end

		return {
			channelTabsConfigurationEnabled = false,
			allChannelTabs = v78,
			selectedTabName = selectedTabName
		}
	end,
	[LocalTextChannelParticipantAdded.name] = function(t17: {[any]: any}, p5) -- line: 282
		-- upvalues: v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy), FFlagExpChatChannelTabRefactor (copy), insertTabAndReorder (copy), Dictionary (copy)
		local textChannelName = p5.textChannel.Name

		v7:trace("LocalTextChannelParticipantAdded dispatched: {}", textChannelName)

		if t17.allChannelTabs[textChannelName] ~= nil or textChannelName == "RBXSystem" then
			return t17
		end

		if GetFFlagTextChatEnableUniverseChatTabs() and not t17.channelTabsConfigurationEnabled and textChannelName ~= "RBXGeneral" then
			return t17
		end

		local n1

		if textChannelName == "RBXGeneral" then
			n1 = 1
		elseif GetFFlagTextChatEnableUniverseChatTabs() and textChannelName == "RBXGlobal" then
			n1 = not t17.allChannelTabs.RBXGeneral and 1 or 2
		else
			local allChannelTabs = t17.allChannelTabs
			local v85 = allChannelTabs.RBXGeneral ~= nil
			local v86 = GetFFlagTextChatEnableUniverseChatTabs() and allChannelTabs.RBXGlobal ~= nil

			n1 = (not v85 and 0 or 1) + (not v86 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then allChannelTabs.FriendsChat ~= nil else false) and 0 or 1) + 1
		end

		local t18 = {
			HasUnreadMessages = false,
			Name = textChannelName,
			TabIndex = n1
		}

		if FFlagExpChatChannelTabRefactor then
			t18.Type = "TextChat"
		end

		local v88 = insertTabAndReorder(t17.allChannelTabs, t18)

		if GetFFlagTextChatEnableUniverseChatTabs() then
			local selectedTabName = t17.selectedTabName

			if selectedTabName == "RBXGlobal" and textChannelName == "RBXGeneral" then
				selectedTabName = "RBXGeneral"
			elseif FFlagExpChatEnableFriendsTab and selectedTabName == "FriendsChat" and (textChannelName == "RBXGeneral" or textChannelName == "RBXGlobal") then
				selectedTabName = textChannelName
			end

			return Dictionary.join(t17, {
				allChannelTabs = v88,
				selectedTabName = selectedTabName
			})
		end

		if FFlagExpChatEnableFriendsTab and textChannelName == "RBXGeneral" and t17.selectedTabName == "FriendsChat" then
			return Dictionary.join(t17, {
				selectedTabName = "RBXGeneral",
				allChannelTabs = v88
			})
		end

		return Dictionary.join(t17, {
			allChannelTabs = v88
		})
	end,
	[LocalTextChannelParticipantRemoved.name] = function(t19: {[any]: any}, p6) -- line: 351
		-- upvalues: v7 (copy), onChannelRemoved (copy)
		v7:trace("LocalTextChannelParticipantRemoved dispatched: {}", p6.textChannel.Name)

		return (onChannelRemoved(t19, p6.textChannel))
	end,
	[TextChannelRemoved.name] = function(t20: {[any]: any}, p7) -- line: 359
		-- upvalues: v7 (copy), onChannelRemoved (copy)
		v7:trace("TextChannelRemoved dispatched: {}", p7.textChannel.Name)

		return (onChannelRemoved(t20, p7.textChannel))
	end,
	[TargetTextChannelPropertyChanged.name] = function(t21: {[any]: any}, p8) -- line: 364
		-- upvalues: v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatEnableFriendsTab (copy), Dictionary (copy), insertTabAndReorder (copy), removeTabAndReorder (copy)
		v7:trace("TargetTextChannelPropertyChanged dispatched")

		if p8.textChannel and t21.allChannelTabs[p8.textChannel.Name] then
			local v96 = t21.allChannelTabs[p8.textChannel.Name]
			local TabIndex = v96.TabIndex

			if p8.shouldReorderTabs then
				if v96.Name == "RBXGeneral" then
					TabIndex = 1
				elseif GetFFlagTextChatEnableUniverseChatTabs() and v96.Name == "RBXGlobal" then
					TabIndex = not t21.allChannelTabs.RBXGeneral and 1 or 2
				else
					local allChannelTabs = t21.allChannelTabs
					local v99 = allChannelTabs.RBXGeneral ~= nil
					local v100 = GetFFlagTextChatEnableUniverseChatTabs() and allChannelTabs.RBXGlobal ~= nil

					TabIndex = (not v99 and 0 or 1) + (not v100 and 0 or 1) + (not (if FFlagExpChatEnableFriendsTab then allChannelTabs.FriendsChat ~= nil else false) and 0 or 1) + 1
				end
			end

			local v101 = Dictionary.join(v96, {
				HasUnreadMessages = false,
				TabIndex = TabIndex
			})

			return Dictionary.join(t21, {
				allChannelTabs = insertTabAndReorder(removeTabAndReorder(t21.allChannelTabs, v96), v101),
				selectedTabName = v96.Name
			})
		end

		if GetFFlagTextChatEnableUniverseChatTabs() and not t21.channelTabsConfigurationEnabled then
			return t21
		end

		return Dictionary.join(t21, {
			selectedTabName = if not p8.textChannel then nil else p8.textChannel.Name
		})
	end,
	[IncomingMessageReceived.name] = handleIncomingMessageReceived,
	[MarkChannelUnreadForIncomingMessage.name] = if not FFlagExpChatUseMessagesStore or not FFlagExpChatUnreadTabIndicatorV2Window then nil else handleIncomingMessageReceived,
	[UniverseChatSystemMessageAdded.name] = handleUniverseChatSystemMessageAdded,
	[MarkChannelUnreadForSystemMessage.name] = if not FFlagExpChatUseMessagesStore or not FFlagExpChatUnreadTabIndicatorV2Window then nil else handleUniverseChatSystemMessageAdded,
	[UniverseChatChannelAdded.name] = function(t22: {[any]: any}, p9) -- line: 422
		-- upvalues: v7 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatChannelTabRefactor (copy), insertTabAndReorder (copy), FFlagExpChatEnableFriendsTab (copy), Dictionary (copy)
		v7:trace("UniverseChatChannelAdded dispatched: {}", p9.channelName)

		if t22.allChannelTabs[p9.channelName] ~= nil then
			return t22
		end

		local tabIndex = p9.tabIndex

		if GetFFlagTextChatEnableUniverseChatTabs() and p9.channelName == "RBXGlobal" then
			tabIndex = not t22.allChannelTabs.RBXGeneral and 1 or 2
		end

		local t23 = {
			HasUnreadMessages = false,
			Name = p9.channelName,
			TabIndex = tabIndex
		}

		if FFlagExpChatChannelTabRefactor then
			t23.Type = "UniverseChat"
		end

		local v106 = insertTabAndReorder(t22.allChannelTabs, t23)
		local selectedTabName

		if GetFFlagTextChatEnableUniverseChatTabs() then
			selectedTabName = t22.selectedTabName

			if selectedTabName == nil then
				selectedTabName = if not v106.RBXGeneral then p9.channelName else "RBXGeneral"
			elseif FFlagExpChatEnableFriendsTab and selectedTabName == "FriendsChat" then
				selectedTabName = p9.channelName
			end
		else
			selectedTabName = t22.selectedTabName or p9.channelName
		end

		return Dictionary.join(t22, {
			allChannelTabs = v106,
			selectedTabName = selectedTabName
		})
	end,
	[FriendsChatChannelAdded.name] = function(t24: {[any]: any}, p10) -- line: 463
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), v7 (copy), insertTabAndReorder (copy), Dictionary (copy)
		if not FFlagExpChatEnableFriendsTab then
			return t24
		end

		v7:trace("FriendsChatChannelAdded dispatched: {}", p10.channelName)

		if t24.allChannelTabs[p10.channelName] ~= nil then
			return t24
		end

		local t25 = {
			HasUnreadMessages = false,
			Type = "FriendsChat",
			Name = p10.channelName,
			TabIndex = p10.tabIndex
		}
		local v111 = insertTabAndReorder(t24.allChannelTabs, t25)
		local selectedTabName = t24.selectedTabName

		if selectedTabName == nil then
			selectedTabName = if not v111.RBXGeneral then p10.channelName else "RBXGeneral"
		end

		return Dictionary.join(t24, {
			allChannelTabs = v111,
			selectedTabName = selectedTabName
		})
	end,
	[FriendsChatChannelSelected.name] = function(t26: {[any]: any}, p11) -- line: 492
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), v7 (copy), Dictionary (copy)
		if not FFlagExpChatEnableFriendsTab then
			return t26
		end

		v7:trace("FriendsChatChannelSelected dispatched: {}", p11.channelName)

		local v115 = t26.allChannelTabs[p11.channelName]

		if v115 == nil then
			return Dictionary.join(t26, {
				selectedTabName = p11.channelName
			})
		end

		return Dictionary.join(t26, {
			allChannelTabs = Dictionary.join(t26.allChannelTabs, {
				[p11.channelName] = Dictionary.join(v115, {
					HasUnreadMessages = false
				})
			}),
			selectedTabName = p11.channelName
		})
	end,
	[SetChannelUnreadStatus.name] = function(t27: {[any]: any}, p12) -- line: 511
		-- upvalues: Dictionary (copy)
		local v118 = t27.allChannelTabs[p12.channelName]

		if v118 == nil then
			return t27
		end

		return Dictionary.join(t27, {
			allChannelTabs = Dictionary.join(t27.allChannelTabs, {
				[p12.channelName] = Dictionary.join(v118, {
					HasUnreadMessages = p12.hasUnreadMessages
				})
			})
		})
	end,
	[UniverseChatChannelSelected.name] = function(t28: {[any]: any}, p13) -- line: 526
		-- upvalues: v7 (copy), Dictionary (copy)
		v7:trace("UniverseChatChannelSelected dispatched: {}", p13.channelName)

		local v121 = t28.allChannelTabs[p13.channelName]

		if v121 == nil then
			return Dictionary.join(t28, {
				selectedTabName = p13.channelName
			})
		end

		return Dictionary.join(t28, {
			allChannelTabs = Dictionary.join(t28.allChannelTabs, {
				[p13.channelName] = Dictionary.join(v121, {
					HasUnreadMessages = false
				})
			}),
			selectedTabName = p13.channelName
		})
	end
})
