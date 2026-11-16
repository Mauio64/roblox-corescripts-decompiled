local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local react = dependencies.React
local foundation = dependencies.Foundation
local luauPolyfill = dependencies.LuauPolyfill
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization

local setTimeout = luauPolyfill.setTimeout
local clearTimeout = luauPolyfill.clearTimeout

local buttonVariant = foundation.Enums.ButtonVariant
local dialogSize = foundation.Enums.DialogSize
local iconSize = foundation.Enums.IconSize
local progressShape = foundation.Enums.ProgressShape
local progressSize = foundation.Enums.ProgressSize
local button = foundation.Button
local dialog = foundation.Dialog
local icon = foundation.Icon
local image = foundation.Image
local overlayProvider = foundation.OverlayProvider
local progress = foundation.Progress
local text = foundation.Text
local view = foundation.View
local useTokens = foundation.Hooks.useTokens

local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/ReactOtter")

local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UserLib").Utils.getRbxthumbWithTypeSizeAndOptions
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UserLib").Utils.Constants

local CreateExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Thunks/CreateExperienceInvite")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums")
local squadExperienceInviteSource = Enums.SquadExperienceInviteSource
local squadLuckyRecommendationPhase = Enums.SquadLuckyRecommendationPhase
local Hooks = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks")
local useLuckyRecommendation = Hooks.useLuckyRecommendation
local useLuckyRecommendationAnalytics = Hooks.useLuckyRecommendationAnalytics
local useIsExperienceInviteRetryBlocked = Hooks.useIsExperienceInviteRetryBlocked
local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite
local getSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Stores").GetSquadExperienceInviteStore
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SignalsReact").useSignalState
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local SQUAD_LOBBY_MODAL_DISPLAY_ORDER = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/Constants").SQUAD_LOBBY_MODAL_DISPLAY_ORDER

local function SquadLobbyLuckyRecommendationModal(props)
	local v5 = useTokens()
	local v6 = useDispatch()

	local size_300 = v5.Size.Size_300
	local v7 = react.useContext(squadExternalContractContext)
	local v8 = useLuckyRecommendation()
	local state = v8.state
	local actions = v8.actions

	local v9 = useLuckyRecommendationAnalytics(props.sessionId)

	local v10 = useLocalization({
		rollingTitle = "Feature.Squads.Label.LuckyRecommendationRolling",
		rollingSubtitle = "Feature.Squads.Description.LuckyRecommendationRolling",
		revealedTitle = "Feature.Squads.Label.LuckyRecommendationRevealed",
		revealedSubtitle = "Feature.Squads.Description.LuckyRecommendationRevealed",
		errorTitle = "CommonUI.Messages.Response.SomethingWentWrong",
		joinText = "Feature.Squads.Action.JoinWithParty",
		cancelText = "CommonUI.Controls.Action.Cancel",
		retryText = "Feature.Squads.Action.Retry"
	})

	local phase = state.phase
	local v11 = phase == squadLuckyRecommendationPhase.Rolling
	local v12 = phase == squadLuckyRecommendationPhase.Revealed
	local v13 = v12 or phase == squadLuckyRecommendationPhase.Errored
	local recommendation

	if state.phase == squadLuckyRecommendationPhase.Revealed then
		recommendation = state.recommendation
	end

	local universeId = recommendation and recommendation.universeId
	local rootPlaceId = recommendation and recommendation.rootPlaceId
	local v14

	if universeId ~= nil then
		v14 = getRbxthumbWithTypeSizeAndOptions(
			tostring(universeId),
			constants.RbxthumbTypes.GameIcon,
			150,
			false
		)
	end

	local v16 = useSelector((react.useCallback(function(p2)
		return p2.Squad
			and p2.Squad.Squad
			and p2.Squad.Squad.currentSquad
			and p2.Squad.Squad.currentSquad.squadId
	end, {})))

	local v17 = react.useCallback(function(p2)
		return p2.Squad and p2.Squad.Squad and p2.Squad.Squad.currentExperienceInvite
	end, {})
	local v18

	if fFlagUseSignalsForSquadExperienceInvite then
		v18 = useSignalState(getSquadExperienceInviteStore(false).getHasCurrentExperienceInvite)
	else
		v18 = useSelector(v17) ~= nil
	end

	local v19 = useIsExperienceInviteRetryBlocked(v16)

	local v20 = react.useCallback(function()
		v9.fire(EventNames.LuckyRecommendationDismissed, { phaseAtDismiss = phase })

		props.onClose()
	end, { v9, phase, props.onClose })

	local v21 = react.useCallback(function()
		v9.fire(EventNames.LuckyRecommendationRerolled, { phaseAtReroll = phase })

		actions.startRoll(v16, false)
	end, { actions.startRoll, v16, v9, phase })

	local v22 = react.useCallback(function()
		local context = v9.getContext()
		v9.fire(EventNames.LuckyRecommendationJoinTapped, { rootPlaceId = rootPlaceId })

		if rootPlaceId == nil then
			return
		end

		v6(CreateExperienceInvite(tostring(rootPlaceId), v7, squadExperienceInviteSource.LuckyRecommendation)):andThen(function(p2)
			if p2 then
				v9.fire(EventNames.LuckyRecommendationExperienceInviteCreated, {
					pickRequestId = context.pickRequestId,
					revealType = context.revealType,
					rootPlaceId = rootPlaceId,
					experienceInviteId = p2
				})
			end
		end)
	end, { v6, rootPlaceId, v7, v9 })

	react.useLayoutEffect(function()
		actions.startRoll(v16, true)
	end, { actions.startRoll, v16 })

	react.useEffect(function()
		if phase ~= squadLuckyRecommendationPhase.Rolling then
			return
		end

		local v23 = setTimeout(actions.endRoll, 1000)
		return function()
			clearTimeout(v23)
		end
	end, { phase, actions.endRoll })

	react.useEffect(function()
		return function()
			actions.cancelFetch()
		end
	end, { actions.cancelFetch })

	react.useEffect(function()
		if phase == squadLuckyRecommendationPhase.Revealed then
			v9.fire(EventNames.LuckyRecommendationRevealShown, { universeId = universeId })
		elseif phase == squadLuckyRecommendationPhase.Errored then
			v9.fire(EventNames.LuckyRecommendationErrorShown, { errorType = state.error })
		end
	end, { phase, v9, state, universeId })

	local v23, v24 = ReactOtter.useAnimatedBinding(0)

	react.useEffect(function()
		if v11 then
			v24(ReactOtter.ease(100, {
				duration = 1,
				easingStyle = Enum.EasingStyle.Quad,
				startingValue = 0
			}))
		elseif v13 then
			v24(ReactOtter.ease(100, { duration = 0 }))
		end
	end, { v11, v13, v24 })
	local v25

	if v12 then
		v25 = {
			title = v10.revealedTitle,
			subtitle = v10.revealedSubtitle,
			actionText = v10.joinText,
			onAction = v22,
			isActionDisabled = v18 or v19
		}
	elseif v13 then
		v25 = { title = v10.errorTitle, actionText = v10.retryText, onAction = v21 }
	else
		v25 = {
			title = v10.rollingTitle,
			subtitle = v10.rollingSubtitle,
			actionText = v10.cancelText,
			onAction = v20
		}
	end

	local v26 = {}

	v26.Title = react.createElement(text, {
		tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
		LayoutOrder = 1,
		Text = v25.title,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--title" or nil
	})

	if v25.subtitle ~= nil then
		v26.Subtitle = react.createElement(text, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 2,
			Text = v25.subtitle,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--subtitle" or nil
		})
	end

	local children = {}

	children.Header = react.createElement(
		view,
		{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 1 },
		v26
	)

	if recommendation then
		local createElement = react.createElement

		local v30 = if v14 then react.createElement(image, {
			tag = "radius-small",
			LayoutOrder = 1,
			Image = v14,
			Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_1000),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--game-thumbnail" or nil
		}) else nil
		children.GameResult = createElement(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-200",
				LayoutOrder = 2
			},
			{
				Thumbnail = v30,
				GameInfo = react.createElement(
					view,
					{
						tag = "col align-y-center fill",
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, v5.Size.Size_1000)
					},
					{
						GameName = react.createElement(text, {
							tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
							LayoutOrder = 1,
							Text = recommendation.universeName,
							testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--game-name" or nil
						})
					}
				)
			}
		)
	end

	if not v13 then
		children.ProgressBar = react.createElement(
			view,
			{
				tag = "row align-y-center size-full-0",
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v5.Size.Size_500)
			},
			{
				Bar = react.createElement(progress, {
					shape = progressShape.Bar,
					size = progressSize.Medium,
					value = v23,
					width = UDim.new(1, 0),
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--progress" or nil
				})
			}
		)
	end

	local createElement = react.createElement

	local createElement2 = react.createElement
	local root = dialog.Root
	local v30 = {
		onClose = v20,
		size = dialogSize.Small,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		disablePortal = props.disablePortal ~= nil and props.disablePortal,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog" or nil
	}

	local createElement3 = react.createElement

	local v35 = {
		Main = react.createElement(view, {
			tag = "col size-full-0 auto-y",
			padding = {
				top = UDim.new(0, size_300 + v5.Size.Size_200)
			}
		}, {
			Body = react.createElement(
				view,
				{
					tag = "col gap-large size-full-0 auto-y padding-bottom-large",
					LayoutOrder = 1
				},
				children
			),
			ActionButton = react.createElement(button, {
				LayoutOrder = 2,
				onActivated = v25.onAction,
				text = v25.actionText,
				variant = buttonVariant.Standard,
				width = UDim.new(1, 0),
				isDisabled = v25.isActionDisabled,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--action-button" or nil
			})
		}),
		ResetButton = 0
	}

	local v36 = if v12 then react.createElement(view, {
		tag = "row align-x-center align-y-center auto-xy padding-small radius-circle clip bg-over-media-100",
		onActivated = v21,
		Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_1000),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -v5.Size.Size_1000, 0, size_300),
		ZIndex = 2,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--reroll-button" or nil
	}, {
		Icon = react.createElement(icon, {
			name = "arrow-spin-clockwise",
			size = iconSize.Small,
			style = v5.Color.Content.Emphasis
		})
	}) else nil
	v35.ResetButton = v36
	return createElement(overlayProvider, {
		DisplayOrder = SQUAD_LOBBY_MODAL_DISPLAY_ORDER
	}, {
		Dialog = createElement2(root, v30, {
			Content = createElement3(view, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 1
			}, v35)
		})
	})
end

return SquadLobbyLuckyRecommendationModal
