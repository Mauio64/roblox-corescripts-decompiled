local CoreGui = game:GetService("CoreGui")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local React = require(AppChatParent.React)
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local ReactRoblox = require(AppChatParent.ReactRoblox)
local Rodux = require(AppChatParent.Rodux)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local AppChatReducer = require(AppChat.App.AppChatReducer)
local InExperienceAppChat = require(AppChat.App.InExperienceAppChat)
local InExperienceAppChatProviders = require(AppChat.App.InExperienceAppChatProviders)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local FFlagAppChatFriendsTabIxpEnabled = require(AppChat.Flags.FFlagAppChatFriendsTabIxpEnabled)
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local ChatModerationStatusHydrationMiddleware = require(AppChat.Middleware.ChatModerationStatusHydrationMiddleware)
local SignalsConversationMiddleware = require(AppChat.Middleware.SignalsConversationMiddleware)
local SignalsMessageIngestionMiddleware = require(AppChat.Middleware.SignalsMessageIngestionMiddleware)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)

return function(p1, p2, p3) -- line: 31
	-- upvalues: CoreGui (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), ChatPlacementContext (copy), ReactRoblox (copy), Rodux (copy), FFlagAppChatSignalsMessageStore (copy), SignalsMessageIngestionMiddleware (copy), FFlagAppChatConversationStore (copy), SignalsConversationMiddleware (copy), FFlagAppChatFriendsTabIxpEnabled (copy), FFlagExpChatEnableFriendsTab (copy), AppChat (copy), ChatModerationStatusHydrationMiddleware (copy), AppChatReducer (copy), ReactFocusNavigation (copy), React (copy), Provider (copy), InExperienceAppChatProviders (copy), InExperienceAppChat (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "AppChat"
	Folder.Parent = CoreGui

	if FFlagAppChatPerfTracking then
		AppChatPerfTracker.setSharedContext({
			placement = ChatPlacementContext.Enum.InExperienceDefault
		})
	end

	local v27 = ReactRoblox.createRoot(Folder)
	local t1 = { Rodux.thunkMiddleware }

	if FFlagAppChatSignalsMessageStore then
		table.insert(t1, SignalsMessageIngestionMiddleware)
	end

	if FFlagAppChatConversationStore then
		table.insert(t1, SignalsConversationMiddleware)
	end

	if FFlagAppChatFriendsTabIxpEnabled or FFlagExpChatEnableFriendsTab then
		table.insert(t1, require(AppChat.Middleware.SignalsFriendsChatSettingsMiddleware))
	end

	if FFlagExpChatEnableFriendsTab then
		table.insert(t1, ChatModerationStatusHydrationMiddleware)
	end

	local v29 = Rodux.Store.new(AppChatReducer, nil, t1)
	local v30 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	local function AppChatMainWithFocusRoot() -- line: 75
		-- upvalues: React (copy), ReactFocusNavigation (copy), v30 (copy), Provider (copy), InExperienceAppChatProviders (copy), v29 (copy), p3 (copy), p2 (copy), p1 (copy), InExperienceAppChat (copy)
		return React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
			value = v30
		}, {
			FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
				InExperienceAppChatProviders = React.createElement(InExperienceAppChatProviders, {
					store = v29,
					updateAppChatUnreadMessagesCount = p3,
					parentContainerContext = p2,
					apolloClient = p1
				}, {
					appChat = React.createElement(InExperienceAppChat)
				})
			})
		})
	end

	v27:render((AppChatMainWithFocusRoot()))

	return v27
end
