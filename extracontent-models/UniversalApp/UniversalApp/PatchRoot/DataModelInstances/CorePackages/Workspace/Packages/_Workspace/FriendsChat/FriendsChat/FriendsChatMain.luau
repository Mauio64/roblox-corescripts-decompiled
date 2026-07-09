local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local Foundation = require(Parent.Foundation)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local Localization = require(Parent.RobloxAppLocales).Localization
local useChatWindowSettings = require(Parent.ExpChatIntegration.useChatWindowSettings)
local ConversationList = require(script.Parent.ConversationList)
local FriendsChatConversationWindow = require(script.Parent.ConversationWindow.FriendsChatConversationWindow)
local GetFriendsChatNavigationStore = require(script.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Stores.GetFriendsChatRealtimeStore)

local function FriendsChatMain(t1: {[any]: any}) -- line: 38
	-- upvalues: useChatWindowSettings (copy), React (copy), GetFriendsChatNavigationStore (copy), GetFriendsChatRealtimeStore (copy), SignalsReact (copy), Players (copy), Localization (copy), LocalizationService (copy), ConversationList (copy), FriendsChatConversationWindow (copy), LocalizationProvider (copy), Foundation (copy)
	local v16 = useChatWindowSettings()
	local v17 = React.useMemo(function() -- line: 40
		-- upvalues: v16 (copy)
		return {
			BackgroundColor3 = v16.ChatWindowBackgroundColor3,
			BackgroundTransparency = v16.ChatWindowBackgroundTransparency
		}
	end, { v16 })
	local v18 = GetFriendsChatNavigationStore(false)
	local v19 = GetFriendsChatRealtimeStore(false)

	React.useEffect(function() -- line: 55
		-- upvalues: v19 (copy)
		v19.markFriendsTabEntered()
	end, { v19 })

	local v20 = SignalsReact.useSignalState(v18.getSelectedConversationId)
	local v21 = t1.chatWindowSettings or v17
	local v22 = t1.parentLayoutOrder or 1
	local LocalPlayer = Players.LocalPlayer
	local v24 = if not LocalPlayer then nil else tostring(LocalPlayer.UserId)
	local v25 = React.useMemo(function() -- line: 64
		-- upvalues: Localization (copy), LocalizationService (copy)
		return Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function() -- line: 68
		-- upvalues: v19 (copy), v20 (copy)
		v19.setActiveConversationId(v20)

		return function() -- line: 70
			-- upvalues: v19 (copy)
			v19.setActiveConversationId(nil)
		end
	end, {
		v19,
		v20
	})

	local v26 = React.useCallback(function(s1: string) -- line: 75
		-- upvalues: v18 (copy)
		v18.setSelectedConversationId(s1)
	end, { v18 })
	local v27 = React.useCallback(function() -- line: 79
		-- upvalues: v18 (copy)
		v18.setSelectedConversationId(nil)
	end, { v18 })
	local v28 = React.useCallback(function(s2: string) -- line: 83
		-- upvalues: v18 (copy)
		v18.setSelectedConversationId(s2)
	end, { v18 })
	local v29 = if v20 ~= nil then React.createElement(FriendsChatConversationWindow, {
		conversationId = v20,
		parentLayoutOrder = v22,
		chatWindowSettings = v21,
		transparencyValue = t1.transparencyValue,
		textTransparency = t1.textTransparency,
		isSpatialUIEnabled = t1.isSpatialUIEnabled,
		isChannelBarVisible = t1.isChannelBarVisible,
		onHovered = t1.onHovered,
		onUnhovered = t1.onUnhovered,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
		onBack = v27,
		onFriendPlaceholderConversationCreated = v28
	}) else React.createElement(ConversationList, {
		LayoutOrder = v22,
		size = UDim2.fromScale(1, 1),
		chatWindowSettings = v21,
		transparencyValue = t1.transparencyValue,
		textTransparency = t1.textTransparency,
		onHovered = t1.onHovered,
		onUnhovered = t1.onUnhovered,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
		onConversationActivated = v26,
		localUserId = v24
	})

	return React.createElement(LocalizationProvider, {
		localization = v25
	}, {
		Content = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			Content = v29
		})
	})
end

return FriendsChatMain
