local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local getSduiTelemetryHandlerNameRegistry = require(Parent.SduiCoreSystem).getSduiTelemetryHandlerNameRegistry
local SharedFlags = require(Parent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagLuaAppSduiOpenSearchResultsWithQueryAction = SharedFlags.FFlagLuaAppSduiOpenSearchResultsWithQueryAction

local function registerDiscoveryActionTelemetryHandlers() -- line: 11
	-- upvalues: getSduiTelemetryHandlerNameRegistry (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagLuaAppSduiOpenSearchResultsWithQueryAction (copy)
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		LeavingRoblox = {
			lazyHandler = function() -- line: 14
				return require(script.Parent.SduiLeavingRobloxTelemetryHandler)
			end
		},
		SocialLinkClick = {
			lazyHandler = function() -- line: 19
				return require(script.Parent.SduiOpenSocialLinkProfileTelemetryHandler)
			end
		},
		EventJoined = {
			lazyHandler = function() -- line: 24
				return require(script.Parent.SduiEventJoinedTelemetryHandler)
			end
		},
		ShareEventIconClicked = {
			lazyHandler = function() -- line: 29
				return require(script.Parent.SduiShareEventTelemetryHandler)
			end
		},
		RequestRefundClick = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 35
				return require(script.Parent.SduiRequestRefundClickTelemetryHandler)
			end
		},
		EdpStoreItemClick = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 42
				return require(script.Parent.SduiEdpStoreItemClickTelemetryHandler)
			end
		},
		ExperienceDetailsJoinFriends = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 49
				return require(script.Parent.SduiExperienceDetailsJoinFriendsTelemetryHandler)
			end
		},
		ExperienceDetailsCreatePrivateServer = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 56
				return require(script.Parent.SduiExperienceDetailsCreatePrivateServerTelemetryHandler)
			end
		},
		EdpStorePurchaseAttempt = {
			lazyHandler = function() -- line: 62
				return require(script.Parent.SduiEdpStorePurchaseAttemptTelemetryHandler)
			end
		},
		GameDetailsSubpage = if not FFlagSduiExperienceDetailsSupport then nil else {
			lazyHandler = function() -- line: 68
				return require(script.Parent.SduiGameDetailsSubpageTelemetryHandler)
			end
		},
		OpenSearchResultsWithQueryEdp = if not FFlagLuaAppSduiOpenSearchResultsWithQueryAction then nil else {
			lazyHandler = function() -- line: 75
				return require(script.Parent.SduiOpenSearchResultsWithQueryEdpTelemetryHandler)
			end
		}
	})
end

return registerDiscoveryActionTelemetryHandlers
