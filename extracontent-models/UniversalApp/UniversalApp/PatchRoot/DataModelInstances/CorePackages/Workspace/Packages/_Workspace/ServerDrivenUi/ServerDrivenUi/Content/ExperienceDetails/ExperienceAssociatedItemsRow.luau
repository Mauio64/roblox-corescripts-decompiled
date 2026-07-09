local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Foundation = require(ServerDrivenUiParent.Foundation)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local RoactUtils = require(ServerDrivenUiParent.RoactUtils)
local Cryo = require(ServerDrivenUiParent.Cryo)
local Game = require(ServerDrivenUiParent.DataHydration).Game

require(ServerDrivenUiParent.SduiCoreSystem)

local PlayerFeedback = require(ServerDrivenUiParent.PlayerFeedback)
local CentralOverlay = require(ServerDrivenUiParent.CentralOverlay)
local RobloxAppEnums = require(ServerDrivenUiParent.RobloxAppEnums)
local SharedFlags = require(ServerDrivenUiParent.SharedFlags)
local useTokens = Foundation.Hooks.useTokens
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GamePlayerFeedbackPrompt = PlayerFeedback.GamePlayerFeedbackPrompt
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SduiAssociatedItemsRow = require(ServerDrivenUi.Content.SduiAssociatedItemsRow)
local GetFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled

local function ExperienceAssociatedItemsRow(t1: {[any]: any}) -- line: 35
	-- upvalues: useTokens (copy), useDispatch (copy), Game (copy), SignalsReact (copy), React (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), SetCentralOverlay (copy), CentralOverlayType (copy), SduiAssociatedItemsRow (copy), Cryo (copy), GamePlayerFeedbackPrompt (copy)
	local layoutOrder = t1.layoutOrder
	local v23 = useTokens()
	local v24 = useDispatch()
	local universeId = t1.universeId
	local v26 = Game.getGameInfoStore(false)
	local v27 = SignalsReact.useSignalState(v26.getAndFetchGameInfo(universeId).data)
	local v28 = v27 and v27.rootPlaceId
	local v29 = Game.getVotesStore(false)
	local v30 = SignalsReact.useSignalState(v29.getAndFetchUserVote(universeId).data)
	local v31 = React.useCallback(function(p1) -- line: 49
		-- upvalues: v28 (copy), Game (copy)
		if not v28 then
			return nil
		end

		return Game.getUserVoteFeedbackMetadataStore(p1).getUserVoteFeedbackMetadata(v28).data(p1)
	end, { v28 })
	local v32 = SignalsReact.useSignalState(v31)
	local v33 = GetFFlagEdpPlayerFeedbackEnabled() and (v32 and v32.canSubmitReview)
	local v34 = React.useCallback(function() -- line: 66
		-- upvalues: v28 (copy), Game (copy)
		if v28 then
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(v28)
		end
	end, { v28 })
	local v35 = React.useCallback(function() -- line: 74
		-- upvalues: v32 (copy), v30 (copy), v24 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), universeId (copy), v34 (copy)
		if v32 and (v32.canSubmitReview and v30) and (v30.userVote == true or v30.userVote == false) then
			local t2 = {
				[true] = "Upvote",
				[false] = "Downvote"
			}
			local v38 = nil

			for _, v40 in v32.categories do
				if v40.type == t2[v30.userVote] then
					v38 = v40

					break
				end
			end

			local t3 = {
				rootPlaceId = v32.rootPlaceId,
				canSubmitReview = v32.canSubmitReview,
				canSubmitComment = v32.canSubmitComment,
				categoryType = t2[v30.userVote],
				category = v38,
				comment = v32.comment,
				metadata = v32.metadata
			}

			v24(SetCentralOverlay(CentralOverlayType.GamePlayerFeedbackForm, {
				universeId = universeId,
				playerFeedbackMetadata = t3,
				onSubmitted = v34
			}))
		end
	end, {
		v32,
		universeId,
		v24,
		v30,
		v34
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder
	}, {
		MinHeightConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(0, v23.Size.Size_700)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v23.Padding.Small)
		}),
		ChipsRow = React.createElement(SduiAssociatedItemsRow, Cryo.Dictionary.join(t1, {
			universeId = nil,
			layoutOrder = 1
		})),
		FeedbackPrompt = if not v33 or not v28 then nil else React.createElement(GamePlayerFeedbackPrompt, {
			LayoutOrder = 2,
			placeId = v28,
			onButtonClick = v35,
			onDimiss = v34
		})
	})
end

return React.memo(ExperienceAssociatedItemsRow)
