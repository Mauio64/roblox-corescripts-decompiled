local module = require("@luauforge/deferred/gHN")
local apiFetchGameDetails = require("@luauforge/bundled/dBl").GameDetails.ApiFetchGameDetails
local module2 = require("@luauforge/bundled/dSY")
local apiFetchPlaceInfos = require("@luauforge/bundled/dFa").Thunks.ApiFetchPlaceInfos
local module3 = require("@luauforge/deferred/gHS")

local module4 = require("@luauforge/deferred/gHT")

local module5 = require("@luauforge/deferred/gHU")

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
