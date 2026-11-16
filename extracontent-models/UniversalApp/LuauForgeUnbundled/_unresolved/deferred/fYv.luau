local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/Localization").abbreviateCount
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local module = require("@luauforge/bundled/dyO")
local reasonForNotVoteable = module.Enums.ReasonForNotVoteable
local voteStatus = module.Enums.VoteStatus
local fetchGameVotes = module.GameVotes.FetchGameVotes
local fetchUserGameVotes = module.UserGameVotes.FetchUserGameVotes
local patchUserVotes = module.UserGameVotes.PatchUserVotes
local toastType = require("@luauforge/bundled/dwC").Enums.ToastType
local setCurrentToastMessage = require("@luauforge/bundled/dwC").Actions.SetCurrentToastMessage
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local vote = require("@luauforge/bundled/dpZ").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.Vote

local module3 = require("@luauforge/bundled/edB")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local module4 = require("@luauforge/deferred/fYw")
local module5 = require("@luauforge/bundled/edi")
local module6 = require("@luauforge/deferred/fYu")
local module7 = require("@luauforge/deferred/fWL")

local getFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEdpPlayerFeedbackEnabled

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

local rect = Rect.new(9, 9, 9, 9)

local extended = Roact.PureComponent:extend("GameRatings")

function extended:init()
	self.isMounted = false

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
			universeId = self.props.universeId,
			onChange = function(p2)
				self:setState({
					gameInfo = p2.gameInfo or none
				})
			end
		})
	end

	function self.onVoteButtonActivated(p2)
		local universeId = self.props.universeId
		local networking = self.props.networking
		local rootPlaceId

		if fFlagMigrateGameInfoToStore then
			rootPlaceId = self.props.rootPlaceId or self.state.gameInfo and self.state.gameInfo.rootPlaceId
		else
			rootPlaceId = self.props.rootPlaceId
		end

		if not (self.isMounted and rootPlaceId) then
			return
		end

		if self.props.dataLoadSucceed then
			local userGameVotes = self.props.userGameVotes
			local reasonForNotVoteable2 = userGameVotes.reasonForNotVoteable

			if userGameVotes.canVote then
				local eventIngest = self.props.eventIngest
				local userVote = userGameVotes.userVote

				if userVote == p2 then
					p2 = voteStatus.NotVoted
				end

				if getFFlagEdpPlayerFeedbackEnabled() then
					self.props.patchUserVotes(networking, universeId, p2, userVote):andThen(function(p3)
						if p3 ~= nil then
							self.props.onVoteSuccess(p2)
						end
					end)
				else
					self.props.patchUserVotes(networking, universeId, p2, userVote)
				end

				vote(eventIngest, "GameRatings", rootPlaceId, p2, userVote)
			elseif reasonForNotVoteable2 == reasonForNotVoteable.PlayGame then
				self.props.setCurrentToastMessage({
					toastType = toastType.NetworkingError,
					toastMessage = "Feature.Toast.VoteError.PlayGame"
				})
			elseif reasonForNotVoteable2 == reasonForNotVoteable.FloodCheckThresholdMet then
				self.props.setCurrentToastMessage({
					toastType = toastType.NetworkingError,
					toastMessage = "Feature.Toast.VoteError.FloodCheckThresholdMet"
				})
			elseif reasonForNotVoteable2 == reasonForNotVoteable.AssetNotVoteable then
				self.props.setCurrentToastMessage({
					toastType = toastType.NetworkingError,
					toastMessage = "Feature.Toast.VoteError.AssetNotVoteable"
				})
			else
				self.props.setCurrentToastMessage({
					toastType = toastType.NetworkingError,
					toastMessage = "Feature.Toast.VoteError.Default"
				})
			end
		elseif self.props.gameVotesFetchingStatus == retrievalStatus.Failed then
			self.props.dispatchFetchGameVotes(networking, universeId)
		else
			local eventIngest = self.props.eventIngest

			if getFFlagEdpPlayerFeedbackEnabled() then
				self.props.patchUserVotes(networking, universeId, p2, voteStatus.NotVoted):andThen(function(p3)
					if p3 ~= nil then
						self.props.onVoteSuccess(p2)
					end
				end)
			else
				self.props.patchUserVotes(networking, universeId, p2, voteStatus.NotVoted)
			end

			vote(eventIngest, "GameRatings", rootPlaceId, p2, voteStatus.NotVoted)
		end
	end

	function self.onVoteUpActivated()
		self.onVoteButtonActivated(voteStatus.VotedUp)
	end

	function self.onVoteDownActivated()
		self.onVoteButtonActivated(voteStatus.VotedDown)
	end
end

function extended.render(data)
	local position = data.props.Position
	local layoutOrder = data.props.LayoutOrder

	local width = data.props.width
	local gameVotes = data.props.gameVotes
	local userGameVotes = data.props.userGameVotes
	local gameVotesFetchingStatus = data.props.gameVotesFetchingStatus
	local isLoading = data.props.isLoading
	local dataLoadSucceed = data.props.dataLoadSucceed
	local showGlobalCounters = data.props.showGlobalCounters
	local showLikesFavoritesCount = data.props.showLikesFavoritesCount

	local localization = data.props.localization

	local upVotes = gameVotes and gameVotes.upVotes or 0
	local v5 = upVotes + (gameVotes and gameVotes.downVotes or 0)
	local v6 = gameVotesFetchingStatus == retrievalStatus.Done
		and abbreviateCount(v5, localization:GetLocale())
		or "--"
	local v7

	if showGlobalCounters and showLikesFavoritesCount then
		v7 = string.upper(localization:Format("Feature.GameDetails.Label.Votes", {
			votes = v6
		}))
	else
		v7 = string.upper(localization:Format("Feature.GameDetails.Label.Upvoted"))
	end

	local v8 = v5 > 0 and tostring((math.floor(upVotes / v5 * 100))) .. "%" or "--"

	local userVote = dataLoadSucceed and userGameVotes and userGameVotes.userVote

	return withStyle(function(p2)
		return Roact.createElement(module5, {
			Size = UDim2.new(0, width, 0, 70),
			Position = position,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "LuaApp/buttons/buttonFill",
			ImageColor3 = p2.Theme.UIEmphasis.Color,
			ImageTransparency = p2.Theme.UIEmphasis.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect
		}, {
			RatingsStat = Roact.createElement(module6, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				icon = "LuaApp/icons/GameDetails/rating_large",
				number = v8,
				label = v7,
				width = width - 88 - 30
			}),
			VoteUp = Roact.createElement(module4, {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				iconImage = userVote == voteStatus.VotedUp and "LuaApp/icons/GameDetails/voteUpOn" or "LuaApp/icons/GameDetails/voteUpOff",
				iconSize = UDim2.new(0, 36, 0, 36),
				isChecked = userVote == voteStatus.VotedUp,
				isLoading = isLoading,
				onActivated = data.onVoteUpActivated,
				withNewThemeProvider = true
			}),
			VoteDown = Roact.createElement(module4, {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -64, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				iconImage = userVote == voteStatus.VotedDown and "LuaApp/icons/GameDetails/voteDownOn" or "LuaApp/icons/GameDetails/voteDownOff",
				iconSize = UDim2.new(0, 36, 0, 36),
				isChecked = userVote == voteStatus.VotedDown,
				isLoading = isLoading,
				onActivated = data.onVoteDownActivated,
				withNewThemeProvider = true
			})
		})
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended.didUpdate(p2)
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.update(p2.props.universeId)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription.dispose()
	end
end

local v5 = RoactRodux.connect(function(data, p2)
	local patchingStatus = patchUserVotes.GetPatchingStatus(data, p2.universeId)
	local v6, v7

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp
	then
		v6 = module7.GetFetchingStatus(data, p2.universeId)
		v7 = module7.GetFetchingStatus(data, p2.universeId)
	else
		v6 = fetchGameVotes.GetFetchingStatus(data, p2.universeId)
		v7 = fetchUserGameVotes.GetFetchingStatus(data, p2.universeId)
	end

	local gameVote = data.GameVotes[p2.universeId]
	local userGameVote = data.UserGameVotes[p2.universeId]
	local v8 = nil

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp
	then
		if data.GameDetailsV2 and data.GameDetailsV2[p2.universeId] then
			v8 = data.GameDetailsV2 and data.GameDetailsV2[p2.universeId].rootPlaceId
		elseif not fFlagMigrateGameInfoToStore then
			local v9 = data.Personalization[gameInfosReducer.key][p2.universeId]

			if v9 then
				v8 = v9.placeId
			end
		end
	elseif data.GameDetails and data.GameDetails[p2.universeId] then
		v8 = data.GameDetails and data.GameDetails[p2.universeId].rootPlaceId
	elseif not fFlagMigrateGameInfoToStore then
		local v9 = data.Personalization[gameInfosReducer.key][p2.universeId]

		if v9 then
			v8 = v9.placeId
		end
	end

	return {
		gameVotes = gameVote,
		userGameVotes = userGameVote,
		rootPlaceId = v8,
		gameVotesFetchingStatus = v6,
		isLoading = v6 == retrievalStatus.Fetching or v7 == retrievalStatus.Fetching or patchingStatus == retrievalStatus.Fetching,
		dataLoadSucceed = gameVote and userGameVote
	}
end, function(callback)
	return {
		setCurrentToastMessage = function(p2)
			return callback(setCurrentToastMessage(p2))
		end,
		dispatchFetchGameVotes = function(p2, p3)
			return callback(fetchGameVotes.Fetch(p2, p3))
		end,
		patchUserVotes = function(p2, p3, p4, p5)
			return callback(patchUserVotes.Patch(p2, p3, p4, p5))
		end
	}
end)(extended)

return roactServices.connect({
	localization = module3,
	networking = roactNetworking,
	eventIngest = appEventIngestService
})(v5)
