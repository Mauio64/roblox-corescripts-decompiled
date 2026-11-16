local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").abbreviateCount
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/FoundationImages").Images

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local SduiGameTileActiveFriendsFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiGameTileActiveFriendsFooter")
local SduiTileFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTileFooter")
local SduiInGameFriendsData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/SduiInGameFriendsData")

local fFlagLuaAppFixInlineSignalsReactPattern = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppFixInlineSignalsReactPattern
local fFlagLuaAppSduiGameTileMetadataFontStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileMetadataFontStyle

local fFlagSduiGameTileUseFooterComponentAsDefault = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileUseFooterComponentAsDefault

local function SduiGameTileFooter(props)
	local getInGameFriendsByGame = SduiInGameFriendsData.getInGameFriendsByGame
	local v5

	if fFlagLuaAppFixInlineSignalsReactPattern then
		local v6 = React.useCallback(function(p2): boolean
			local v7 = getInGameFriendsByGame(p2)[props.universeId]

			if v7 then
				for k in v7 do
					return true
				end
			end

			return false
		end, { getInGameFriendsByGame, props.universeId })
		v5 = SignalsReact.useSignalState(v6)
	else
		v5 = SignalsReact.useSignalState(function(p2): boolean
			local v6 = getInGameFriendsByGame(p2)[props.universeId]

			if v6 then
				for k in v6 do
					return true
				end
			end

			return false
		end)
	end

	if (props.isSelected or props.isHovered) and props.ageRatingText and props.ageRatingText ~= "" then
		local createElement = React.createElement
		local v7 = {
			leftText = props.ageRatingText,
			analyticsContext = props.analyticsContext,
			fontStyle = 0,
			testId = "--sdui-game-tile-footer-age-rating"
		}
		local v8 = if fFlagLuaAppSduiGameTileMetadataFontStyle then props.metadataFontStyle else nil
		v7.fontStyle = v8
		return createElement(SduiTileFooter, v7)
	else
		if v5 then
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
			fFlagSduiGameTileUseFooterComponentAsDefault and props.useFooterComponentAsDefault
			or not props.ratingText
			or props.ratingText == ""
		then
			return props.footerComponent
		end

		local sduiContext = props.sduiContext
		local ratingText = props.ratingText
		local iconsstatusgamesrating_small = if props.ratingText then images["icons/status/games/rating_small"] else nil
		local v6, iconsstatusgamespeopleplaying_small

		if props.playerCount ~= nil then
			v6 = props.playerCount == -1 and "--"
				or abbreviateCount(props.playerCount, sduiContext.dependencies.localization:GetLocale())
			iconsstatusgamespeopleplaying_small = images["icons/status/games/people-playing_small"]
		end

		local createElement = React.createElement
		local v8 = {
			sduiContext = props.sduiContext,
			leftText = ratingText,
			leftIcon = iconsstatusgamesrating_small,
			rightText = v6,
			rightIcon = iconsstatusgamespeopleplaying_small,
			fontStyle = 0,
			testId = "--sdui-game-tile-footer-rating"
		}

		local v9 = if fFlagLuaAppSduiGameTileMetadataFontStyle then props.metadataFontStyle else nil
		v8.fontStyle = v9
		return createElement(SduiTileFooter, v8)
	end
end

return React.memo(SduiGameTileFooter)
