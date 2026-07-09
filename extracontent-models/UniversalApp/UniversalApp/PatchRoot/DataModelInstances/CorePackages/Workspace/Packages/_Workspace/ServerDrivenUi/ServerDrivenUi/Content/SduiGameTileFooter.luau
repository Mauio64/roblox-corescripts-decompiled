local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local abbreviateCount = require(ServerDrivenUiParent.Localization).abbreviateCount
local Images = require(ServerDrivenUiParent.FoundationImages).Images

require(ServerDrivenUiParent.SduiCoreSystem)

local SduiGameTileActiveFriendsFooter = require(ServerDrivenUi.Content.SduiGameTileActiveFriendsFooter)
local SduiTileFooter = require(ServerDrivenUi.Content.SduiTileFooter)
local SduiInGameFriendsData = require(ServerDrivenUi.DataStore.SduiInGameFriendsData)
local FFlagLuaAppFixInlineSignalsReactPattern = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppFixInlineSignalsReactPattern

local function SduiGameTileFooter(t1: {[any]: any}) -- line: 34
	-- upvalues: SduiInGameFriendsData (copy), FFlagLuaAppFixInlineSignalsReactPattern (copy), React (copy), SignalsReact (copy), SduiTileFooter (copy), SduiGameTileActiveFriendsFooter (copy), Images (copy), abbreviateCount (copy)
	local getInGameFriendsByGame = SduiInGameFriendsData.getInGameFriendsByGame
	local v15

	if FFlagLuaAppFixInlineSignalsReactPattern then
		local v14 = React.useCallback(function(p1) -- line: 39
			-- upvalues: getInGameFriendsByGame (copy), t1 (copy)
			local v22 = getInGameFriendsByGame(p1)[t1.universeId]

			if v22 then
				for _ in v22 do
					return true
				end
			end

			return false
		end, {
			getInGameFriendsByGame,
			t1.universeId
		})

		v15 = SignalsReact.useSignalState(v14)
	else
		v15 = SignalsReact.useSignalState(function(p2) -- line: 51
			-- upvalues: getInGameFriendsByGame (copy), t1 (copy)
			local v25 = getInGameFriendsByGame(p2)[t1.universeId]

			if v25 then
				for _ in v25 do
					return true
				end
			end

			return false
		end)
	end

	if (t1.isSelected or t1.isHovered) and t1.ageRatingText and t1.ageRatingText ~= "" then
		return React.createElement(SduiTileFooter, {
			testId = "--sdui-game-tile-footer-age-rating",
			leftText = t1.ageRatingText,
			analyticsContext = t1.analyticsContext
		})
	end

	if v15 then
		return React.createElement(SduiGameTileActiveFriendsFooter, {
			testId = "--sdui-game-tile-footer-active-friends",
			hideBorder = true,
			placeId = t1.placeId,
			universeId = t1.universeId,
			sduiContext = t1.sduiContext,
			analyticsContext = t1.analyticsContext
		})
	end

	if t1.ratingText and t1.ratingText ~= "" then
		local sduiContext = t1.sduiContext
		local ratingText = t1.ratingText
		local v18 = if not t1.ratingText then nil else Images["icons/status/games/rating_small"]
		local v19 = nil
		local v20 = nil

		if t1.playerCount ~= nil then
			v20 = if t1.playerCount ~= -1 then abbreviateCount(t1.playerCount, sduiContext.dependencies.localization:GetLocale()) else "--"
			v19 = Images["icons/status/games/people-playing_small"]
		end

		return React.createElement(SduiTileFooter, {
			testId = "--sdui-game-tile-footer-rating",
			sduiContext = t1.sduiContext,
			leftText = ratingText,
			leftIcon = v18,
			rightText = v20,
			rightIcon = v19
		})
	end

	return t1.footerComponent
end

return React.memo(SduiGameTileFooter)
