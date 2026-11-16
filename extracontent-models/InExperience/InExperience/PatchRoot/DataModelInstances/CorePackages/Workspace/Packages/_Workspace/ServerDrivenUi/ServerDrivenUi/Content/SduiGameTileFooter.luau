local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local abbreviateCount = Localization.abbreviateCount
require(parent.Foundation)
local FoundationImages = require(parent.FoundationImages)
local Images = FoundationImages.Images

require(parent.SduiCoreSystem)
local SduiGameTileActiveFriendsFooter = require(ServerDrivenUi.Content.SduiGameTileActiveFriendsFooter)
local SduiTileFooter = require(ServerDrivenUi.Content.SduiTileFooter)
local SduiInGameFriendsData = require(ServerDrivenUi.DataStore.SduiInGameFriendsData)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixInlineSignalsReactPattern = SharedFlags.FFlagLuaAppFixInlineSignalsReactPattern
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileMetadataFontStyle = SharedFlags2.FFlagLuaAppSduiGameTileMetadataFontStyle

local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiGameTileUseFooterComponentAsDefault = SharedFlags3.FFlagSduiGameTileUseFooterComponentAsDefault

local function SduiGameTileFooter(props)
	local getInGameFriendsByGame = SduiInGameFriendsData.getInGameFriendsByGame
	local v

	if FFlagLuaAppFixInlineSignalsReactPattern then
		local v2 = React.useCallback(function(p): boolean
			local v2 = getInGameFriendsByGame(p)[props.universeId]

			if v2 then
				for _ in v2 do
					return true
				end
			end

			return false
		end, { getInGameFriendsByGame, props.universeId })
		v = SignalsReact.useSignalState(v2)
	else
		v = SignalsReact.useSignalState(function(p): boolean
			local v2 = getInGameFriendsByGame(p)[props.universeId]

			if v2 then
				for _ in v2 do
					return true
				end
			end

			return false
		end)
	end

	if (props.isSelected or props.isHovered) and props.ageRatingText and props.ageRatingText ~= "" then
		local createElement = React.createElement
		local v2 = {
			leftText = props.ageRatingText,
			analyticsContext = props.analyticsContext,
			fontStyle = 0,
			testId = "--sdui-game-tile-footer-age-rating"
		}
		local fontStyle

		if FFlagLuaAppSduiGameTileMetadataFontStyle then
			fontStyle = props.metadataFontStyle
		end

		v2.fontStyle = fontStyle
		return createElement(SduiTileFooter, v2)
	else
		if v then
			return React.createElement(SduiGameTileActiveFriendsFooter, {
				placeId = props.placeId,
				universeId = props.universeId,
				sduiContext = props.sduiContext,
				analyticsContext = props.analyticsContext,
				testId = "--sdui-game-tile-footer-active-friends",
				hideBorder = true
			})
		end

		if
			FFlagSduiGameTileUseFooterComponentAsDefault and props.useFooterComponentAsDefault
			or not props.ratingText
			or props.ratingText == ""
		then
			return props.footerComponent
		end

		local sduiContext = props.sduiContext
		local ratingText = props.ratingText
		local iconsstatusgamesrating_small

		if props.ratingText then
			iconsstatusgamesrating_small = Images["icons/status/games/rating_small"]
		end

		local rightText, iconsstatusgamespeopleplaying_small

		if props.playerCount ~= nil then
			rightText = props.playerCount == -1 and "--"
				or abbreviateCount(props.playerCount, sduiContext.dependencies.localization:GetLocale())
			iconsstatusgamespeopleplaying_small = Images["icons/status/games/people-playing_small"]
		end

		local createElement = React.createElement
		local v2 = {
			sduiContext = props.sduiContext,
			leftText = ratingText,
			leftIcon = iconsstatusgamesrating_small,
			rightText = rightText,
			rightIcon = iconsstatusgamespeopleplaying_small,
			fontStyle = 0,
			testId = "--sdui-game-tile-footer-rating"
		}
		local fontStyle

		if FFlagLuaAppSduiGameTileMetadataFontStyle then
			fontStyle = props.metadataFontStyle
		end

		v2.fontStyle = fontStyle
		return createElement(SduiTileFooter, v2)
	end
end

return React.memo(SduiGameTileFooter)
