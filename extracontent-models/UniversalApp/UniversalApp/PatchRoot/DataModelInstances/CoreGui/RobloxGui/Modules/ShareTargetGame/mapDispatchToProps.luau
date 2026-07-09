local CorePackages = game:GetService("CorePackages")
local SendGameLinkMessage = require(script.Parent.Thunks.SendGameLinkMessage)
local ApiFetchGameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.ApiFetchGameDetails
local ApiFetchGameIcons = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.ApiFetchGameIcons
local ApiFetchPlaceInfos = require(CorePackages.Workspace.Packages.PlaceInfoRodux).Thunks.ApiFetchPlaceInfos
local SetAppLoaded = require(CorePackages.Workspace.Packages.AppChat.SetAppLoaded)
local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local requestOlderConversations = require(ShareTargetGame.ChatConversations.Thunks.requestOlderConversations)
local DEPRECATED_getLocalUserConversations = require(CorePackages.Workspace.Packages.AppChat.DEPRECATED_getLocalUserConversations)

return function(p1) -- line: 19
	-- upvalues: DEPRECATED_getLocalUserConversations (copy), SendGameLinkMessage (copy), ApiFetchGameIcons (copy), ApiFetchGameDetails (copy), SetAppLoaded (copy), ApiFetchPlaceInfos (copy), requestOlderConversations (copy)
	local function v11(p2) -- line: 20
		-- upvalues: p1 (copy), DEPRECATED_getLocalUserConversations (copy)
		return p1(DEPRECATED_getLocalUserConversations(p2, 30))
	end

	return {
		sendGameLinkToConversation = function(p3, p4, b1: boolean?, n1: number?, n2: number?) -- line: 25
			-- upvalues: p1 (copy), SendGameLinkMessage (copy)
			return p1(SendGameLinkMessage(p3, p4, b1 or false, n1 or 0, n2 or 0))
		end,
		fetchGameData = function(p5, p6) -- line: 37
			-- upvalues: p1 (copy), ApiFetchGameIcons (copy), ApiFetchGameDetails (copy)
			p1(ApiFetchGameIcons(p5, { p6 }))
			p1(ApiFetchGameDetails.Fetch(p5, { p6 }))
		end,
		fetchConversations = v11,
		setAppLoaded = function() -- line: 44
			-- upvalues: p1 (copy), SetAppLoaded (copy)
			return p1(SetAppLoaded(true))
		end,
		fetchPlaceInfos = function(p7, p8) -- line: 48
			-- upvalues: p1 (copy), ApiFetchPlaceInfos (copy)
			return p1(ApiFetchPlaceInfos(p7, { p8 }))
		end,
		conversationListScrollTouchedBottom = function() -- line: 52
			-- upvalues: p1 (copy), requestOlderConversations (copy), v11 (copy)
			return p1(requestOlderConversations(v11, 30))
		end
	}
end
