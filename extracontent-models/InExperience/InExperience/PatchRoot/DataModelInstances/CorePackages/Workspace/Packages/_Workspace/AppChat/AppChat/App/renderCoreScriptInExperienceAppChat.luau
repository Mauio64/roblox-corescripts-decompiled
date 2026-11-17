local CoreGui = game:GetService("CoreGui")

local AppChat = script:FindFirstAncestor("AppChat")

local parent = AppChat.Parent
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local ReactRoblox = require(parent.ReactRoblox)
local Rodux = require(parent.Rodux)

local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local AppChatReducer = require(AppChat.App.AppChatReducer)
local InExperienceAppChat = require(AppChat.App.InExperienceAppChat)
local InExperienceAppChatProviders = require(AppChat.App.InExperienceAppChatProviders)

local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForSquadExperienceInvite = SharedFlags.FFlagUseSignalsForSquadExperienceInvite
local ChatModerationStatusHydrationMiddleware = require(AppChat.Middleware.ChatModerationStatusHydrationMiddleware)
local SignalsConversationMiddleware = require(AppChat.Middleware.SignalsConversationMiddleware)
local SignalsMessageIngestionMiddleware = require(AppChat.Middleware.SignalsMessageIngestionMiddleware)
local SignalsUnreadMessageCountMiddleware = require(AppChat.Middleware.SignalsUnreadMessageCountMiddleware)
local FFlagAppChatSignalsActionHandlers = require(AppChat.Flags.FFlagAppChatSignalsActionHandlers)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)

return function(apolloClient, parentContainerContext, updateAppChatUnreadMessagesCount)
	local appChat = Instance.new("Folder")
	appChat.Name = "AppChat"
	appChat.Parent = CoreGui

	if FFlagAppChatPerfTracking then
		AppChatPerfTracker.setSharedContext({
			placement = ChatPlacementContext.Enum.InExperienceDefault
		})
	end

	local root = ReactRoblox.createRoot(appChat)
	local v = { Rodux.thunkMiddleware }

	if FFlagAppChatSignalsMessageStore then
		table.insert(v, SignalsMessageIngestionMiddleware)
	end

	if FFlagAppChatConversationStore then
		table.insert(v, SignalsConversationMiddleware)
	end

	table.insert(v, require(AppChat.Middleware.SignalsFriendsChatSettingsMiddleware))

	table.insert(v, ChatModerationStatusHydrationMiddleware)
	table.insert(v, SignalsUnreadMessageCountMiddleware)

	if FFlagUseSignalsForSquadExperienceInvite then
		local Middleware = require(parent.SquadsCore.Middleware)
		table.insert(v, Middleware.SignalsSquadMiddleware)
	end

	if FFlagAppChatSignalsActionHandlers then
		local SignalsMiddleware = require(parent.SignalsMiddleware)
		local v2 = SignalsMiddleware.ActionHandlers.create()
		local registerAppChatSignalsActionHandlers = require(AppChat.Handlers.registerAppChatSignalsActionHandlers)
		registerAppChatSignalsActionHandlers(v2)
		table.insert(v, SignalsMiddleware.createSignalsMiddleware(v2))
	end

	local store = Rodux.Store.new(AppChatReducer, nil, v)

	local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	local function AppChatMainWithFocusRoot()
		return React.createElement(
			ReactFocusNavigation.FocusNavigationContext.Provider,
			{ value = focusNavigationService },
			{
				FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
					InExperienceAppChatProviders = React.createElement(
						InExperienceAppChatProviders,
						{
							store = store,
							updateAppChatUnreadMessagesCount = updateAppChatUnreadMessagesCount,
							parentContainerContext = parentContainerContext,
							apolloClient = apolloClient
						},
						{
							appChat = React.createElement(InExperienceAppChat)
						}
					)
				})
			}
		)
	end

	root:render((AppChatMainWithFocusRoot()))

	return root
end
