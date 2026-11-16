local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local Cryo = require(parent.Cryo)

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
require(parent.SduiCoreSystem)
local PlayerFeedback = require(parent.PlayerFeedback)
local CentralOverlay = require(parent.CentralOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SharedFlags = require(parent.SharedFlags)

local useTokens = Foundation.Hooks.useTokens
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GamePlayerFeedbackPrompt = PlayerFeedback.GamePlayerFeedbackPrompt
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SduiAssociatedItemsRow = require(ServerDrivenUi.Content.SduiAssociatedItemsRow)

local GetFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled

local function ExperienceAssociatedItemsRow(p)
	local layoutOrder = p.layoutOrder
	local v = useTokens()
	local v2 = useDispatch()

	local universeId = p.universeId

	local gameInfoStore = Game.getGameInfoStore(false)
	local v3 = SignalsReact.useSignalState(gameInfoStore.getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v3 and v3.rootPlaceId

	local votesStore = Game.getVotesStore(false)
	local v4 = SignalsReact.useSignalState(votesStore.getAndFetchUserVote(universeId).data)

	local v5 = React.useCallback(function(p2)
		if rootPlaceId then
			return Game.getUserVoteFeedbackMetadataStore(p2).getUserVoteFeedbackMetadata(rootPlaceId).data(p2)
		end

		return nil
	end, { rootPlaceId })
	local v6 = SignalsReact.useSignalState(v5)

	local canSubmitReview = GetFFlagEdpPlayerFeedbackEnabled() and v6 and v6.canSubmitReview

	local v7 = React.useCallback(function()
		if rootPlaceId then
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)
		end
	end, { rootPlaceId })

	local onButtonClick = React.useCallback(function()
		if v6 and v6.canSubmitReview and v4 and (v4.userVote == true or v4.userVote == false) then
			local v8 = { [true] = "Upvote", [false] = "Downvote" }
			local category2 = nil

			for _, category in v6.categories do
				if category.type == v8[v4.userVote] then
					category2 = category
					break
				end
			end

			local playerFeedbackMetadata = {
				rootPlaceId = v6.rootPlaceId,
				canSubmitReview = v6.canSubmitReview,
				canSubmitComment = v6.canSubmitComment,
				categoryType = v8[v4.userVote],
				category = category2,
				comment = v6.comment,
				metadata = v6.metadata
			}

			v2(SetCentralOverlay(CentralOverlayType.GamePlayerFeedbackForm, {
				universeId = universeId,
				playerFeedbackMetadata = playerFeedbackMetadata,
				onSubmitted = v7
			}))
		end
	end, { v6, universeId, v2, v4, v7 })

	local createElement = React.createElement
	local v8 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder
	}

	local v9 = {
		MinHeightConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(0, v.Size.Size_700)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Padding.Small)
		}),
		ChipsRow = React.createElement(
			SduiAssociatedItemsRow,
			Cryo.Dictionary.join(p, { universeId = nil, layoutOrder = 1 })
		),
		FeedbackPrompt = 0
	}
	local feedbackPrompt

	if canSubmitReview and rootPlaceId then
		feedbackPrompt = React.createElement(GamePlayerFeedbackPrompt, {
			placeId = rootPlaceId,
			onButtonClick = onButtonClick,
			onDimiss = v7,
			LayoutOrder = 2
		})
	end

	v9.FeedbackPrompt = feedbackPrompt
	return createElement("Frame", v8, v9)
end

return React.memo(ExperienceAssociatedItemsRow)
