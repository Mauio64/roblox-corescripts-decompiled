local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/Localization").abbreviateCount
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local module = require("@luauforge/bundled/dBR")
local reasonForNotVoteable = module.Enums.ReasonForNotVoteable
local voteStatus = module.Enums.VoteStatus
local fetchGameVotes = module.GameVotes.FetchGameVotes
local patchUserVotes = module.UserGameVotes.PatchUserVotes
local toastType = require("@luauforge/bundled/dzF").Enums.ToastType
local setCurrentToastMessage = require("@luauforge/bundled/dzF").Actions.SetCurrentToastMessage
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local vote = require("@luauforge/bundled/dtb").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.Vote

local module3 = require("@luauforge/bundled/egY")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local module4 = require("@luauforge/deferred/gDs")
local module5 = require("@luauforge/bundled/egF")
local module6 = require("@luauforge/deferred/gDq")
local module7 = require("@luauforge/deferred/gBI")

local getFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEdpPlayerFeedbackEnabled

local rect = Rect.new(9, 9, 9, 9)

local extended = Roact.PureComponent:extend("GameRatings")

function extended:init()
	self.isMounted = false
	self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
		universeId = self.props.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none
			})
		end
	})

	function self.onVoteButtonActivated(p2)
		local universeId = self.props.universeId
		local networking = self.props.networking
		local rootPlaceId = self.props.rootPlaceId
			or self.state.gameInfo and self.state.gameInfo.rootPlaceId

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
				local patchUserVotes2 = self.props.patchUserVotes
				local v5 = p2
				patchUserVotes2(networking, universeId, v5, voteStatus.NotVoted):andThen(function(p3)
					if p3 ~= nil then
						self.props.onVoteSuccess(p2)
					end
				end)
			else
				local patchUserVotes2 = self.props.patchUserVotes
				local v5 = p2
				patchUserVotes2(networking, universeId, v5, voteStatus.NotVoted)
			end

			local v5 = p2
			vote(eventIngest, "GameRatings", rootPlaceId, v5, voteStatus.NotVoted)
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
	p2.gameInfoSubscription.update(p2.props.universeId)
end

function extended:willUnmount()
	self.isMounted = false
	self.gameInfoSubscription.dispose()
end

local v5 = RoactRodux.connect(function(data, p2)
	local patchingStatus = patchUserVotes.GetPatchingStatus(data, p2.universeId)

	local fetchingStatus = module7.GetFetchingStatus(data, p2.universeId)
	local fetchingStatus2 = module7.GetFetchingStatus(data, p2.universeId)

	local gameVote = data.GameVotes[p2.universeId]
	local userGameVote = data.UserGameVotes[p2.universeId]

	local v6 = if data.GameDetailsV2 and data.GameDetailsV2[p2.universeId] then data.GameDetailsV2 and data.GameDetailsV2[p2.universeId].rootPlaceId else nil

	return {
		gameVotes = gameVote,
		userGameVotes = userGameVote,
		rootPlaceId = v6,
		gameVotesFetchingStatus = fetchingStatus,
		isLoading = fetchingStatus == retrievalStatus.Fetching or fetchingStatus2 == retrievalStatus.Fetching or patchingStatus == retrievalStatus.Fetching,
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
