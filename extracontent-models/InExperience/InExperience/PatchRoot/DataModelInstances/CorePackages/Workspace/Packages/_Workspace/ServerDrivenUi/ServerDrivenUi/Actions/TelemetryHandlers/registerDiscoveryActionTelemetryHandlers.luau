local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiTelemetryHandlerNameRegistry = SduiCoreSystem.getSduiTelemetryHandlerNameRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete
local FFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback

local function registerDiscoveryActionTelemetryHandlers()
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		LeavingRoblox = {
			lazyHandler = function()
				return require(script.Parent.SduiLeavingRobloxTelemetryHandler)
			end
		},
		SocialLinkClick = {
			lazyHandler = function()
				return require(script.Parent.SduiOpenSocialLinkProfileTelemetryHandler)
			end
		},
		EventJoined = {
			lazyHandler = function()
				return require(script.Parent.SduiEventJoinedTelemetryHandler)
			end
		},
		ShareEventIconClicked = {
			lazyHandler = function()
				return require(script.Parent.SduiShareEventTelemetryHandler)
			end
		},
		RequestRefundClick = {
			lazyHandler = function()
				return require(script.Parent.SduiRequestRefundClickTelemetryHandler)
			end
		},
		EdpStoreItemClick = {
			lazyHandler = function()
				return require(script.Parent.SduiEdpStoreItemClickTelemetryHandler)
			end
		},
		ExperienceDetailsJoinFriends = {
			lazyHandler = function()
				return require(script.Parent.SduiExperienceDetailsJoinFriendsTelemetryHandler)
			end
		},
		ExperienceDetailsCreatePrivateServer = {
			lazyHandler = function()
				return require(script.Parent.SduiExperienceDetailsCreatePrivateServerTelemetryHandler)
			end
		},
		EdpStorePurchaseAttempt = {
			lazyHandler = function()
				return require(script.Parent.SduiEdpStorePurchaseAttemptTelemetryHandler)
			end
		},
		GameDetailsSubpage = {
			lazyHandler = function()
				return require(script.Parent.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		GameTileOverflowMenu = FFlagLuaAppSduiGameTileFeedback and {
			lazyHandler = function()
				return require(script.Parent.SduiGameTileOverflowMenuTelemetryHandler)
			end
		} or nil,
		OpenSearchResultsWithQueryEdp = {
			lazyHandler = function()
				return require(script.Parent.SduiOpenSearchResultsWithQueryEdpTelemetryHandler)
			end
		},
		QuerySuggestionClicked = {
			lazyHandler = function()
				return require(script.Parent.SduiQuerySuggestionClickedTelemetryHandler)
			end
		},
		SearchSuggestionClicked = FFlagLuaAppSduiSearchAutocomplete and {
			lazyHandler = function()
				return require(script.Parent.SduiSearchSuggestionClickedTelemetryHandler)
			end
		} or nil
	})
end

return registerDiscoveryActionTelemetryHandlers
