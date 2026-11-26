local getSduiTelemetryHandlerNameRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").getSduiTelemetryHandlerNameRegistry

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete
local fFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback

local function registerDiscoveryActionTelemetryHandlers()
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		LeavingRoblox = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiLeavingRobloxTelemetryHandler")
			end
		},
		SocialLinkClick = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiOpenSocialLinkProfileTelemetryHandler")
			end
		},
		EventJoined = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiEventJoinedTelemetryHandler")
			end
		},
		ShareEventIconClicked = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiShareEventTelemetryHandler")
			end
		},
		RequestRefundClick = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiRequestRefundClickTelemetryHandler")
			end
		},
		EdpStoreItemClick = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiEdpStoreItemClickTelemetryHandler")
			end
		},
		ExperienceDetailsJoinFriends = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiExperienceDetailsJoinFriendsTelemetryHandler")
			end
		},
		ExperienceDetailsCreatePrivateServer = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiExperienceDetailsCreatePrivateServerTelemetryHandler")
			end
		},
		EdpStorePurchaseAttempt = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiEdpStorePurchaseAttemptTelemetryHandler")
			end
		},
		GameDetailsSubpage = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiGameDetailsSubpageTelemetryHandler")
			end
		},
		GameTileOverflowMenu = fFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiGameTileOverflowMenuTelemetryHandler")
			end
		} or nil,
		OpenSearchResultsWithQueryEdp = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiOpenSearchResultsWithQueryEdpTelemetryHandler")
			end
		},
		QuerySuggestionClicked = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiQuerySuggestionClickedTelemetryHandler")
			end
		},
		SearchSuggestionClicked = fFlagLuaAppSduiSearchAutocomplete and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiSearchSuggestionClickedTelemetryHandler")
			end
		} or nil
	})
end

return registerDiscoveryActionTelemetryHandlers
