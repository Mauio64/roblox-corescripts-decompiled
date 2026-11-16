local CoreGui = game:GetService("CoreGui")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactRoblox")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")

local provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local AppChatReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/AppChatReducer")
local InExperienceAppChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/InExperienceAppChat")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/InExperienceAppChatProviders")

local FFlagAppChatSignalsMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsMessageStore")
local FFlagAppChatConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationStore")
local FFlagAppChatFriendsTabIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFriendsTabIxpEnabled")
local FFlagAppChatUseDataHydrationForChatTimeouts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseDataHydrationForChatTimeouts")
local fFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagExpChatEnableFriendsTab
local fFlagUseSignalsForSquadExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagUseSignalsForSquadExperienceInvite
local ChatModerationStatusHydrationMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/ChatModerationStatusHydrationMiddleware")
local SignalsConversationMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsConversationMiddleware")
local SignalsMessageIngestionMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsMessageIngestionMiddleware")
local SignalsUnreadMessageCountMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsUnreadMessageCountMiddleware")
local FFlagAppChatSignalsActionHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsActionHandlers")

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")

return function(p2, p3, p4)
	local appChat = Instance.new("Folder")
	appChat.Name = "AppChat"
	appChat.Parent = CoreGui

	if FFlagAppChatPerfTracking then
		AppChatPerfTracker.setSharedContext({ placement = ChatPlacementContext.Enum.InExperienceDefault })
	end

	local root = ReactRoblox.createRoot(appChat)
	local v5 = { Rodux.thunkMiddleware }

	if FFlagAppChatSignalsMessageStore then
		table.insert(v5, SignalsMessageIngestionMiddleware)
	end

	if FFlagAppChatConversationStore then
		table.insert(v5, SignalsConversationMiddleware)
	end

	if FFlagAppChatFriendsTabIxpEnabled or fFlagExpChatEnableFriendsTab then
		table.insert(v5, require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsFriendsChatSettingsMiddleware"))
	end

	if fFlagExpChatEnableFriendsTab or FFlagAppChatUseDataHydrationForChatTimeouts then
		table.insert(v5, ChatModerationStatusHydrationMiddleware)
	end

	table.insert(v5, SignalsUnreadMessageCountMiddleware)

	if fFlagUseSignalsForSquadExperienceInvite then
		table.insert(v5, require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Middleware").SignalsSquadMiddleware)
	end

	if FFlagAppChatSignalsActionHandlers then
		local SignalsMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsMiddleware")
		local v6 = SignalsMiddleware.ActionHandlers.create()
		require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Handlers/registerAppChatSignalsActionHandlers")(v6)
		table.insert(v5, SignalsMiddleware.createSignalsMiddleware(v6))
	end

	local store = Rodux.Store.new(AppChatReducer, nil, v5)

	local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	local function AppChatMainWithFocusRoot()
		return React.createElement(
			ReactFocusNavigation.FocusNavigationContext.Provider,
			{ value = focusNavigationService },
			{
				FocusNavigationRegistryProvider = React.createElement(provider, nil, {
					InExperienceAppChatProviders = React.createElement(
						module8,
						{
							store = store,
							updateAppChatUnreadMessagesCount = p4,
							parentContainerContext = p3,
							apolloClient = p2
						},
						{ appChat = React.createElement(InExperienceAppChat) }
					)
				})
			}
		)
	end

	root:render((AppChatMainWithFocusRoot()))

	return root
end
