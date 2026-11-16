local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")

local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local PlayerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/PlayerFeedback")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")

local useTokens = Foundation.Hooks.useTokens
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local gamePlayerFeedbackPrompt = PlayerFeedback.GamePlayerFeedbackPrompt
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local SduiAssociatedItemsRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiAssociatedItemsRow")

local getFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled

local function ExperienceAssociatedItemsRow(p2)
	local layoutOrder = p2.layoutOrder
	local v5 = useTokens()
	local v6 = useDispatch()

	local universeId = p2.universeId

	local gameInfoStore = Game.getGameInfoStore(false)
	local v7 = SignalsReact.useSignalState(gameInfoStore.getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v7 and v7.rootPlaceId

	local votesStore = Game.getVotesStore(false)
	local v8 = SignalsReact.useSignalState(votesStore.getAndFetchUserVote(universeId).data)

	local v9 = React.useCallback(function(p3)
		if rootPlaceId then
			return Game.getUserVoteFeedbackMetadataStore(p3).getUserVoteFeedbackMetadata(rootPlaceId).data(p3)
		end

		return nil
	end, { rootPlaceId })
	local v10 = SignalsReact.useSignalState(v9)

	local canSubmitReview = getFFlagEdpPlayerFeedbackEnabled() and v10 and v10.canSubmitReview

	local v11 = React.useCallback(function()
		if rootPlaceId then
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)
		end
	end, { rootPlaceId })

	local v12 = React.useCallback(function()
		if v10 and v10.canSubmitReview and v8 and (v8.userVote == true or v8.userVote == false) then
			local v13 = { [true] = "Upvote", [false] = "Downvote" }
			local v14 = nil

			for k, category in v10.categories do
				if category.type == v13[v8.userVote] then
					v14 = category
					break
				end
			end

			local v16 = {
				rootPlaceId = v10.rootPlaceId,
				canSubmitReview = v10.canSubmitReview,
				canSubmitComment = v10.canSubmitComment,
				categoryType = v13[v8.userVote],
				category = v14,
				comment = v10.comment,
				metadata = v10.metadata
			}

			v6(setCentralOverlay(centralOverlayType.GamePlayerFeedbackForm, {
				universeId = universeId,
				playerFeedbackMetadata = v16,
				onSubmitted = v11
			}))
		end
	end, { v10, universeId, v6, v8, v11 })

	local createElement = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder
	}

	local v15 = {
		MinHeightConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(0, v5.Size.Size_700)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Padding.Small)
		}),
		ChipsRow = React.createElement(
			SduiAssociatedItemsRow,
			Cryo.Dictionary.join(p2, { universeId = nil, layoutOrder = 1 })
		),
		FeedbackPrompt = 0
	}

	local v16 = if canSubmitReview and rootPlaceId then React.createElement(gamePlayerFeedbackPrompt, {
		placeId = rootPlaceId,
		onButtonClick = v12,
		onDimiss = v11,
		LayoutOrder = 2
	}) else nil
	v15.FeedbackPrompt = v16
	return createElement("Frame", v14, v15)
end

return React.memo(ExperienceAssociatedItemsRow)
