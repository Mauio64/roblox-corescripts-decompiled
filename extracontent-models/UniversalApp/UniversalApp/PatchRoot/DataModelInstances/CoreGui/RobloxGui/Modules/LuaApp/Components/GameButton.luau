local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local FeatureContext = require(Modules.LuaApp.Enum.FeatureContext)
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local User = require(Modules.LuaApp.Models.User)
local PlayabilityStatusEnum = require(CorePackages.Workspace.Packages.DiscoveryTypes).PlayabilityStatusEnum
local ConvertUniverseIdToString = require(CorePackages.Workspace.Packages.SharedFlags).ConvertUniverseIdToString
local joinGame = require(Modules.LuaApp.Util.joinGame)
local Constants = require(Modules.LuaApp.Constants)
local FitImageTextButton = require(Modules.LuaApp.Components.FitImageTextButton)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local FFlagPeopleListContextualMenuFixFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPeopleListContextualMenuFixFocusNavigation
local FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = require(CorePackages.Workspace.Packages.SharedFlags).FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
local FFlagEnablePartyNudgeV1_DEV = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePartyNudgeV1_DEV
local GREEN_PRIMARY = Constants.Color.GREEN_PRIMARY
local WHITE = Constants.Color.WHITE
local VIEW_GAME_DETAILS_FROM_BUTTON = Constants.AnalyticsKeyword.VIEW_GAME_DETAILS_FROM_BUTTON
local SmallRobuxIcon = Constants.SmallRobuxIcon

local function v30(n1: number, s1: string?, n2: number?) -- line: 52
	assert(type(n1) == "number", "formatInteger expects a number; was given type: " .. type(n1))

	local v37 = s1 or ","
	local v38 = n2 or 3

	assert(v37, "cannot be nil")
	assert(v38, "cannot be nil")

	local v39 = string.format("%.0f", (math.abs(n1)))
	local v40 = #v39 % v38

	if v40 == 0 then
		v40 = v38
	end

	local v41 = "(" .. string.rep("%d", v38) .. ")"
	local v42 = v37 .. "%1"
	local v43 = v39:sub(1, v40) .. v39:sub(v40 + 1):gsub(v41, v42)

	if n1 < 0 then
		v43 = "-" .. v43
	end

	return v43
end

local t1 = {
	[FeatureContext.PeopleList] = {
		ViewDetailsEnabled = true,
		JoinGameEnabled = true,
		BuyToPlayButtonEnabled = true
	},
	[FeatureContext.PlacesList] = {
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
local v32 = Roact.PureComponent:extend("GameButton")

v32.defaultProps = {
	showLoadingIndicatorWhenDataNotReady = false
}

function v32.init(p1) -- line: 101
	-- upvalues: FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), FeatureContext (copy), VIEW_GAME_DETAILS_FROM_BUTTON (copy), Constants (copy), joinGame (copy)
	function p1.openGameDetailsFromButton() -- line: 102
		-- upvalues: p1 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), FeatureContext (copy), VIEW_GAME_DETAILS_FROM_BUTTON (copy)
		local universePlaceInfo = p1.props.universePlaceInfo

		if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel and not universePlaceInfo then
			return
		end

		local analytics = p1.props.analytics
		local friend = p1.props.friend
		local index = p1.props.index
		local absolutePosition = p1.props.absolutePosition
		local callbackOnOpenGameDetails = p1.props.callbackOnOpenGameDetails
		local featureContext = p1.props.featureContext
		local v71 = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.universeRootPlaceId else universePlaceInfo.universeRootPlaceId or -1
		local placeId = universePlaceInfo.placeId
		local universeId = universePlaceInfo.universeId

		if placeId then
			if featureContext == FeatureContext.PeopleList then
				analytics.reportViewProfileFromPeopleList(friend.id, index, absolutePosition, v71, VIEW_GAME_DETAILS_FROM_BUTTON)
				analytics.reportOpenGameDetailFromPeopleList(friend.id, index, absolutePosition, v71, universeId, "gameButton", "GameDetailFromGameButton")
			end

			if callbackOnOpenGameDetails then
				callbackOnOpenGameDetails()
			end

			p1.props.openGameDetails(universeId)
		end
	end
	function p1.joinGameByUser() -- line: 152
		-- upvalues: p1 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), FeatureContext (copy), Constants (copy), joinGame (copy)
		local universePlaceInfo = p1.props.universePlaceInfo

		if not universePlaceInfo then
			return
		end

		local analytics = p1.props.analytics
		local friend = p1.props.friend
		local index = p1.props.index
		local callbackOnJoinGame = p1.props.callbackOnJoinGame
		local featureContext = p1.props.featureContext
		local absolutePosition = p1.props.absolutePosition
		local inGameFriendCount = p1.props.inGameFriendCount
		local source = p1.props.source
		local placeId = universePlaceInfo.placeId
		local v84 = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then universePlaceInfo.universeRootPlaceId else universePlaceInfo.universeRootPlaceId or -1

		if callbackOnJoinGame then
			callbackOnJoinGame()
		end

		local v85 = nil
		local PeopleListInHomePage = nil

		if featureContext == FeatureContext.PeopleList then
			PeopleListInHomePage = Constants.AnalyticsContext.PeopleListInHomePage

			function v85(p2) -- line: 180
				-- upvalues: analytics (copy), friend (copy), index (copy), absolutePosition (copy), placeId (copy), v84 (copy), inGameFriendCount (copy), source (copy)
				analytics.reportPeopleListJoinGame(friend.id, index, absolutePosition, placeId, v84, friend.gameInstanceId, inGameFriendCount, p2, source)
			end
		elseif featureContext == FeatureContext.PlacesList then
			PeopleListInHomePage = Constants.AnalyticsContext.GamePlayIntentInPlacesList

			function v85(p3) -- line: 195
				-- upvalues: analytics (copy), friend (copy), placeId (copy), v84 (copy)
				analytics.reportJoinGameInPlacesList(friend.id, placeId, v84, friend.gameInstanceId, p3)
			end
		end

		joinGame:ByUserAndPlaceId(friend, placeId, PeopleListInHomePage, v85)
	end
end
function v32.render(p4) -- line: 209
	-- upvalues: Roact (copy), LoadingBarWithTheme (copy), FFlagPeopleListContextualMenuFixFocusNavigation (copy), t1 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), PlayabilityStatusEnum (copy), GREEN_PRIMARY (copy), WHITE (copy), Constants (copy), FFlagEnablePartyNudgeV1_DEV (copy), SmallRobuxIcon (copy), v30 (copy), FitImageTextButton (copy), withStyle (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local universePlaceInfo = p4.props.universePlaceInfo

	if not universePlaceInfo and p4.props.showLoadingIndicatorWhenDataNotReady then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 104, 0, 32)
		}, {
			LoadingBar = Roact.createElement(LoadingBarWithTheme)
		})
	end

	local localization = p4.props.localization
	local layoutOrder = p4.props.layoutOrder
	local maxWidth = p4.props.maxWidth
	local featureContext = p4.props.featureContext
	local v51 = if not FFlagPeopleListContextualMenuFixFocusNavigation then nil else p4.props.selectionOrder
	local v52 = t1[featureContext] or t1.Default
	local u53 = false
	local u54 = false
	local price = nil

	if universePlaceInfo then
		u53 = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then v52.JoinGameEnabled and universePlaceInfo.isPlayable else v52.JoinGameEnabled and (universePlaceInfo.isPlayable == nil or universePlaceInfo.isPlayable)
		u54 = v52.BuyToPlayButtonEnabled and universePlaceInfo.reasonProhibited == PlayabilityStatusEnum.PurchaseRequired
		price = universePlaceInfo.price
	end

	local ViewDetailsEnabled = v52.ViewDetailsEnabled

	local function v57(p5, p6) -- line: 245
		-- upvalues: GREEN_PRIMARY (copy), WHITE (copy), Constants (copy), u53 (ref), FFlagEnablePartyNudgeV1_DEV (copy), p4 (copy), u54 (ref), SmallRobuxIcon (copy), ViewDetailsEnabled (copy), v30 (copy), price (ref), Roact (copy), FitImageTextButton (copy), layoutOrder (copy), maxWidth (copy), FFlagPeopleListContextualMenuFixFocusNavigation (copy), v51 (copy)
		local v89 = GREEN_PRIMARY
		local n3 = 0
		local v91 = WHITE
		local n4 = 0
		local WHITE2 = Constants.Color.WHITE
		local n5 = 0
		local GRAY1 = Constants.Color.GRAY1
		local n6 = 0
		local Header2Font = nil

		if p5 then
			local Theme = p5.Theme
			local p5Font = p5.Font

			v89 = Theme.ContextualPrimaryDefault.Color
			n3 = Theme.ContextualPrimaryDefault.Transparency
			v91 = Theme.ContextualPrimaryContent.Color
			n4 = Theme.ContextualPrimaryContent.Transparency
			WHITE2 = Theme.SystemPrimaryDefault.Color
			n5 = Theme.SystemPrimaryDefault.Transparency
			GRAY1 = Theme.SystemPrimaryContent.Color
			n6 = Theme.SystemPrimaryContent.Transparency
			Header2Font = p5Font.Header2.Font
		end

		local v100 = nil
		local v101 = nil
		local joinGameByUser

		if u53 then
			v100 = if not (FFlagEnablePartyNudgeV1_DEV and (p4.props.currentSquad and (p4.props.currentSquad.squadId and p4.props.currentSquad.squadId ~= ""))) then p6.joinText else p6.joinWithPartyText
			joinGameByUser = p4.joinGameByUser
		elseif u54 then
			joinGameByUser = p4.openGameDetailsFromButton
			v101 = SmallRobuxIcon
		else
			if not ViewDetailsEnabled then
				return nil
			end

			v100 = p6.viewDetailsText
			joinGameByUser = p4.openGameDetailsFromButton
			v89 = WHITE2
			n3 = n5
			v91 = GRAY1
			n4 = n6
		end

		local v103 = u54 and v30(price) or v100

		return Roact.createElement(FitImageTextButton, {
			backgroundImage = "rbxasset://textures/ui/LuaChat/9-slice/input-default.png",
			minWidth = 90,
			backgroundColor = v89,
			backgroundTransparency = n3,
			layoutOrder = layoutOrder,
			leftIconEnabled = v101 ~= nil,
			leftIcon = v101,
			maxWidth = maxWidth,
			textFont = Header2Font,
			text = v103,
			textColor = v91,
			textTransparency = n4,
			onActivated = joinGameByUser,
			selectionOrder = if not FFlagPeopleListContextualMenuFixFocusNavigation then nil else v51
		})
	end
	local function v58(p7) -- line: 319
		-- upvalues: withStyle (copy), v57 (copy)
		return withStyle(function(p8) -- line: 320
			-- upvalues: v57 (copy), p7 (copy)
			return v57(p8, p7)
		end)
	end

	if GetFFlagLuaAppUseWithLocalization() then
		return withLocalization({
			joinText = "Feature.Chat.Drawer.Join",
			joinWithPartyText = "Feature.Squads.Action.JoinWithParty",
			viewDetailsText = "Feature.Chat.Drawer.ViewDetails"
		})(v58)
	end

	return v58({
		joinText = localization:Format("Feature.Chat.Drawer.Join"),
		joinWithPartyText = localization:Format("Feature.Squads.Action.JoinWithParty"),
		viewDetailsText = localization:Format("Feature.Chat.Drawer.ViewDetails")
	})
end

local v33 = RoactRodux.connect(function(p9, p10) -- line: 341
	-- upvalues: ConvertUniverseIdToString (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Cryo (copy), User (copy), FFlagEnablePartyNudgeV1_DEV (copy)
	local v61 = ConvertUniverseIdToString(p10.universeId)
	local t2 = nil

	if FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then
		t2 = {
			universeId = v61,
			universeRootPlaceId = p10.universeRootPlaceId,
			placeId = p10.placeId
		}
	end

	return {
		universePlaceInfo = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then p9.UniversePlaceInfos[v61] else Cryo.Dictionary.union(p9.UniversePlaceInfos[v61] or {}, t2),
		inGameFriendCount = p9.FriendPresenceCounts[User.PresenceType.IN_GAME],
		currentSquad = if not FFlagEnablePartyNudgeV1_DEV then nil else p9.Squad and (p9.Squad.Squad and p9.Squad.Squad.currentSquad)
	}
end, function(p11) -- line: 362
	-- upvalues: OpenGameDetails (copy)
	return {
		openGameDetails = function(p12) -- line: 364
			-- upvalues: p11 (copy), OpenGameDetails (copy)
			p11(OpenGameDetails(p12))
		end
	}
end)(v32)

return (RoactServices.connect({
	analytics = RoactAnalyticsCommonGameEvents,
	guiService = AppGuiService,
	localization = RoactLocalization
})(v33))
