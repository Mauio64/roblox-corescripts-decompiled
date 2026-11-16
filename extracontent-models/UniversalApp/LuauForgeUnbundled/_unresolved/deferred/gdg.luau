local module = require("@luauforge/deferred/gdh")
local apiFetchGameDetails = require("@luauforge/bundled/dyi").GameDetails.ApiFetchGameDetails
local module2 = require("@luauforge/bundled/dPI")
local apiFetchPlaceInfos = require("@luauforge/bundled/dBV").Thunks.ApiFetchPlaceInfos
local module3 = require("@luauforge/deferred/gdm")

local module4 = require("@luauforge/deferred/gdn")

local module5 = require("@luauforge/deferred/gdo")

return function(callback)
	local function fn(p2)
		return callback(module5(p2, 30))
	end

	return {
		sendGameLinkToConversation = function(p2, p3, p4, value, value2)
			return callback(module(p2, p3, p4 or false, value or 0, value2 or 0))
		end,
		fetchGameData = function(p2, p3)
			module2.Game.getGameIconStore(false).getAndFetchGameIcons({ p3 })
			callback(apiFetchGameDetails.Fetch(p2, { p3 }))
		end,
		fetchConversations = fn,
		setAppLoaded = function()
			return callback(module3(true))
		end,
		fetchPlaceInfos = function(p2, p3)
			return callback(apiFetchPlaceInfos(p2, { p3 }))
		end,
		conversationListScrollTouchedBottom = function()
			return callback(module4(fn, 30))
		end
	}
end
