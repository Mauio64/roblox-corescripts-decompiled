local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/edC")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local module3 = require("@luauforge/bundled/edB")
local roactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module4 = require("@luauforge/deferred/hLY")
local module5 = require("@luauforge/bundled/dHo")
local module6 = require("@luauforge/bundled/dxC")

local presenceType = require("@luauforge/bundled/dPI").Presence.PresenceEnums.PresenceType

local useGetOnlineFriends = require("@luauforge/deferred/hLV").useGetOnlineFriends

local module7 = require("@luauforge/deferred/hLS")

local playabilityStatusEnum = require("@luauforge/bundled/cyO").PlayabilityStatusEnum

local convertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/SharedFlags").ConvertUniverseIdToString
local module8 = require("@luauforge/bundled/eeB")

local module9 = require("@luauforge/bundled/dwA")
local module10 = require("@luauforge/deferred/gds")
local module11 = require("@luauforge/bundled/edh")

local module12 = require("@luauforge/bundled/edD")

local fFlagPeopleListContextualMenuFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPeopleListContextualMenuFixFocusNavigation
local fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
local fFlagEnablePartyNudgeV1_DEV = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePartyNudgeV1_DEV

local GREEN_PRIMARY = module9.Color.GREEN_PRIMARY
local white = module9.Color.WHITE

local VIEW_GAME_DETAILS_FROM_BUTTON = module9.AnalyticsKeyword.VIEW_GAME_DETAILS_FROM_BUTTON

local smallRobuxIcon = module9.SmallRobuxIcon

local function fn(price, value, count)
	assert(type(price) == "number", "formatInteger expects a number; was given type: " .. type(price))

	local v5 = value or ","
	local v6 = count or 3
	assert(v5, "cannot be nil")
	assert(v6, "cannot be nil")

	local v7 = string.format("%.0f", (math.abs(price)))
	local v8 = #v7 % v6

	if v8 == 0 then
		v8 = v6
	end

	local v9 = "(" .. string.rep("%d", v6) .. ")"
	local v10 = v5 .. "%1"
	local v11 = v7:sub(1, v8) .. v7:sub(v8 + 1):gsub(v9, v10)

	if price < 0 then
		v11 = "-" .. v11
	end

	return v11
end

local v5 = {
	[module4.PeopleList] = {
		ViewDetailsEnabled = true,
		JoinGameEnabled = true,
		BuyToPlayButtonEnabled = true
	},
	[module4.PlacesList] = {
		ViewDetailsEnabled = false,
		JoinGameEnabled = false,
		BuyToPlayButtonEnabled = true
	},
	Default = {
		ViewDetailsEnabled = true,
		JoinGameEnabled = true,
		BuyToPlayButtonEnabled = true
	}
}

local extended = Roact.PureComponent:extend("GameButton")

extended.defaultProps = { showLoadingIndicatorWhenDataNotReady = false }

function extended:init()
	function self.openGameDetailsFromButton()
		local universePlaceInfo = self.props.universePlaceInfo

		if not (fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel or universePlaceInfo) then
			return
		end

		local analytics = self.props.analytics
		local friend = self.props.friend
		local index = self.props.index
		local absolutePosition = self.props.absolutePosition
		local callbackOnOpenGameDetails = self.props.callbackOnOpenGameDetails
		local featureContext = self.props.featureContext
		local universeRootPlaceId

		if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
			universeRootPlaceId = universePlaceInfo.universeRootPlaceId or -1
		else
			universeRootPlaceId = universePlaceInfo.universeRootPlaceId
		end

		local placeId = universePlaceInfo.placeId
		local universeId = universePlaceInfo.universeId

		if placeId then
			if featureContext == module4.PeopleList then
				analytics.reportViewProfileFromPeopleList(
					friend.id,
					index,
					absolutePosition,
					universeRootPlaceId,
					VIEW_GAME_DETAILS_FROM_BUTTON
				)

				analytics.reportOpenGameDetailFromPeopleList(
					friend.id,
					index,
					absolutePosition,
					universeRootPlaceId,
					universeId,
					"gameButton",
					"GameDetailFromGameButton"
				)
			end

			if callbackOnOpenGameDetails then
				callbackOnOpenGameDetails()
			end

			self.props.openGameDetails(universeId)
		end
	end

	function self.joinGameByUser()
		local universePlaceInfo = self.props.universePlaceInfo

		if not universePlaceInfo then
			return
		end

		local analytics = self.props.analytics
		local friend = self.props.friend
		local index = self.props.index
		local callbackOnJoinGame = self.props.callbackOnJoinGame
		local featureContext = self.props.featureContext
		local absolutePosition = self.props.absolutePosition
		local inGameFriendCount = self.props.inGameFriendCount
		local source = self.props.source

		local placeId = universePlaceInfo.placeId
		local universeRootPlaceId

		if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
			universeRootPlaceId = universePlaceInfo.universeRootPlaceId or -1
		else
			universeRootPlaceId = universePlaceInfo.universeRootPlaceId
		end

		if callbackOnJoinGame then
			callbackOnJoinGame()
		end

		local fn2
		local v6 = nil

		if featureContext == module4.PeopleList then
			v6 = module9.AnalyticsContext.PeopleListInHomePage
			fn2 = function(p3)
				analytics.reportPeopleListJoinGame(
					friend.id,
					index,
					absolutePosition,
					placeId,
					universeRootPlaceId,
					friend.gameInstanceId,
					inGameFriendCount,
					p3,
					source
				)
			end
		elseif featureContext == module4.PlacesList then
			v6 = module9.AnalyticsContext.GamePlayIntentInPlacesList
			fn2 = function(p3)
				analytics.reportJoinGameInPlacesList(
					friend.id,
					placeId,
					universeRootPlaceId,
					friend.gameInstanceId,
					p3
				)
			end
		end

		module8:ByUserAndPlaceId(friend, placeId, v6, fn2)
	end
end

function extended.render(props)
	local universePlaceInfo = props.props.universePlaceInfo

	if not universePlaceInfo and props.props.showLoadingIndicatorWhenDataNotReady then
		return Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(0, 104, 0, 32) },
			{ LoadingBar = Roact.createElement(module11) }
		)
	end

	local localization = props.props.localization
	local layoutOrder = props.props.layoutOrder
	local maxWidth = props.props.maxWidth
	local featureContext = props.props.featureContext
	local selectionOrder

	if fFlagPeopleListContextualMenuFixFocusNavigation then
		selectionOrder = props.props.selectionOrder
	else
		selectionOrder = nil
	end

	local v6 = v5[featureContext] or v5.Default
	local v7, v8, price

	if universePlaceInfo then
		if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
			v7 = v6.JoinGameEnabled
				and (universePlaceInfo.isPlayable == nil or universePlaceInfo.isPlayable)
		else
			v7 = v6.JoinGameEnabled and universePlaceInfo.isPlayable
		end

		v8 = v6.BuyToPlayButtonEnabled
			and universePlaceInfo.reasonProhibited == playabilityStatusEnum.PurchaseRequired
		price = universePlaceInfo.price
	else
		v7 = false
		v8 = false
		price = nil
	end

	local viewDetailsEnabled = v6.ViewDetailsEnabled

	local function fn2(p2, props2)
		local v9 = GREEN_PRIMARY

		local v10 = white

		local v11 = module9.Color.WHITE

		local v12 = module9.Color.GRAY1
		local v13, v14, v15, v16, font

		if p2 then
			local theme = p2.Theme
			local font2 = p2.Font
			v9 = theme.ContextualPrimaryDefault.Color
			v13 = theme.ContextualPrimaryDefault.Transparency
			v10 = theme.ContextualPrimaryContent.Color
			v14 = theme.ContextualPrimaryContent.Transparency
			v11 = theme.SystemPrimaryDefault.Color
			v15 = theme.SystemPrimaryDefault.Transparency
			v12 = theme.SystemPrimaryContent.Color
			v16 = theme.SystemPrimaryContent.Transparency
			font = font2.Header2.Font
		else
			v13 = 0
			v14 = 0
			v15 = 0
			v16 = 0
		end

		local v17 = nil

		local v18 = nil
		local v19

		if v7 then
			if
				fFlagEnablePartyNudgeV1_DEV
				and props.props.currentSquad
				and props.props.currentSquad.squadId
				and props.props.currentSquad.squadId ~= ""
			then
				v17 = props2.joinWithPartyText
			else
				v17 = props2.joinText
			end

			v19 = props.joinGameByUser
		elseif v8 then
			v19 = props.openGameDetailsFromButton
			v18 = smallRobuxIcon
		else
			if not viewDetailsEnabled then
				return nil
			end

			v17 = props2.viewDetailsText
			v19 = props.openGameDetailsFromButton
			v14 = v16
			v10 = v12
			v13 = v15
			v9 = v11
		end

		v17 = v8 and fn(price) or v17

		return Roact.createElement(module10, {
			backgroundColor = v9,
			backgroundTransparency = v13,
			backgroundImage = "rbxasset://textures/ui/LuaChat/9-slice/input-default.png",
			layoutOrder = layoutOrder,
			leftIconEnabled = v18 ~= nil,
			leftIcon = v18,
			maxWidth = maxWidth,
			minWidth = 90,
			textFont = font,
			text = v17,
			textColor = v10,
			textTransparency = v14,
			onActivated = v19,
			selectionOrder = if fFlagPeopleListContextualMenuFixFocusNavigation then selectionOrder else nil
		})
	end

	local function fn3(p2)
		return withStyle(function(p3)
			return fn2(p3, p2)
		end)
	end

	if module12() then
		return module({
			joinText = "Feature.Chat.Drawer.Join",
			joinWithPartyText = "Feature.Squads.Action.JoinWithParty",
			viewDetailsText = "Feature.Chat.Drawer.ViewDetails"
		})(fn3)
	end

	return fn3({
		joinText = localization:Format("Feature.Chat.Drawer.Join"),
		joinWithPartyText = localization:Format("Feature.Squads.Action.JoinWithParty"),
		viewDetailsText = localization:Format("Feature.Chat.Drawer.ViewDetails")
	})
end

local v6 = RoactRodux.connect(function(data, data2)
	local v7 = convertUniverseIdToString(data2.universeId)

	local v8 = fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
		and {
			universeId = v7,
			universeRootPlaceId = data2.universeRootPlaceId,
			placeId = data2.placeId
		}
		or nil

	local v10 = if fFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then Cryo.Dictionary.union(data.UniversePlaceInfos[v7] or {}, v8) else data.UniversePlaceInfos[v7]

	local v11 = if not module7 then data.FriendPresenceCounts[module6.PresenceType.IN_GAME] else nil

	local v12 = if fFlagEnablePartyNudgeV1_DEV then data.Squad and data.Squad.Squad and data.Squad.Squad.currentSquad else nil
	return { universePlaceInfo = v10, inGameFriendCount = v11, currentSquad = v12 }
end, function(callback)
	return {
		openGameDetails = function(p2)
			callback(module5(p2))
		end
	}
end)(extended)

local v7 = roactServices.connect({
	analytics = roactAnalyticsCommonGameEvents,
	guiService = appGuiService,
	localization = module3
})(v6)

local function GameButtonWrapper(p2)
	local v8 = useGetOnlineFriends()

	local v9 = React.useMemo(function()
		local filtered = Cryo.List.filter(v8 or {}, function(p3)
			local v11 = p3.presence

			if v11 then
				if p3.presence.userPresenceType == presenceType.InGame then
					v11 = p3.presence.universeId and p3.presence.universeId ~= ""
				else
					v11 = false
				end
			end

			return v11
		end)

		return filtered and #filtered or 0
	end, { v8 })

	return Roact.createElement(v7, Cryo.Dictionary.union(p2, { inGameFriendCount = v9 }))
end

return if module7 then React.memo(GameButtonWrapper) else v7
