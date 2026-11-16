local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local dependencies = require(Squads.dependencies)
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

local ReactOtter = require(parent.ReactOtter)

local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib2 = require(parent.UserLib)
local Constants = UserLib2.Utils.Constants

local CreateExperienceInvite = require(Squads.Thunks.CreateExperienceInvite)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadExperienceInviteSource = Enums.SquadExperienceInviteSource
local SquadLuckyRecommendationPhase = Enums.SquadLuckyRecommendationPhase
local Hooks = require(parent.SquadsCore.Hooks)
local useLuckyRecommendation = Hooks.useLuckyRecommendation
local useLuckyRecommendationAnalytics = Hooks.useLuckyRecommendationAnalytics
local useIsExperienceInviteRetryBlocked = Hooks.useIsExperienceInviteRetryBlocked
local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite
local Stores = require(parent.SquadsCore.Stores)
local GetSquadExperienceInviteStore = Stores.GetSquadExperienceInviteStore
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local EventNames = require(parent.SquadsCore.EventNames)

local Constants2 = require(Squads.Common.Constants)
local SQUAD_LOBBY_MODAL_DISPLAY_ORDER = Constants2.SQUAD_LOBBY_MODAL_DISPLAY_ORDER

local function SquadLobbyLuckyRecommendationModal(props)
	local v = useTokens()
	local v2 = useDispatch()

	local size_300 = v.Size.Size_300
	local v3 = react.useContext(SquadExternalContractContext)
	local v4 = useLuckyRecommendation()
	local state = v4.state
	local actions = v4.actions

	local v5 = useLuckyRecommendationAnalytics(props.sessionId)

	local v6 = useLocalization({
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
	local v7 = phase == SquadLuckyRecommendationPhase.Rolling
	local v8 = phase == SquadLuckyRecommendationPhase.Revealed
	local v9 = v8 or phase == SquadLuckyRecommendationPhase.Errored
	local recommendation

	if state.phase == SquadLuckyRecommendationPhase.Revealed then
		recommendation = state.recommendation
	end

	local universeId = recommendation and recommendation.universeId
	local rootPlaceId = recommendation and recommendation.rootPlaceId
	local image2

	if universeId ~= nil then
		image2 = getRbxthumbWithTypeSizeAndOptions(tostring(universeId), Constants.RbxthumbTypes.GameIcon, 150, false)
	end

	local v10 = useSelector((react.useCallback(function(p)
		return p.Squad and p.Squad.Squad and p.Squad.Squad.currentSquad and p.Squad.Squad.currentSquad.squadId
	end, {})))

	local v11 = react.useCallback(function(p)
		return p.Squad and p.Squad.Squad and p.Squad.Squad.currentExperienceInvite
	end, {})
	local v12

	if fFlagUseSignalsForSquadExperienceInvite then
		v12 = useSignalState(GetSquadExperienceInviteStore(false).getHasCurrentExperienceInvite)
	else
		v12 = useSelector(v11) ~= nil
	end

	local v13 = useIsExperienceInviteRetryBlocked(v10)

	local v14 = react.useCallback(function()
		v5.fire(EventNames.LuckyRecommendationDismissed, { phaseAtDismiss = phase })

		props.onClose()
	end, { v5, phase, props.onClose })

	local v15 = react.useCallback(function()
		v5.fire(EventNames.LuckyRecommendationRerolled, { phaseAtReroll = phase })

		actions.startRoll(v10, false)
	end, { actions.startRoll, v10, v5, phase })

	local onAction = react.useCallback(function()
		local context = v5.getContext()
		v5.fire(EventNames.LuckyRecommendationJoinTapped, { rootPlaceId = rootPlaceId })

		if rootPlaceId == nil then
			return
		end

		v2(CreateExperienceInvite(tostring(rootPlaceId), v3, SquadExperienceInviteSource.LuckyRecommendation)):andThen(function(experienceInviteId: string)
			if experienceInviteId then
				v5.fire(EventNames.LuckyRecommendationExperienceInviteCreated, {
					pickRequestId = context.pickRequestId,
					revealType = context.revealType,
					rootPlaceId = rootPlaceId,
					experienceInviteId = experienceInviteId
				})
			end
		end)
	end, { v2, rootPlaceId, v3, v5 })

	react.useLayoutEffect(function()
		actions.startRoll(v10, true)
	end, { actions.startRoll, v10 })

	react.useEffect(function()
		if phase ~= SquadLuckyRecommendationPhase.Rolling then
			return
		end

		local v16 = setTimeout(actions.endRoll, 1000)
		return function()
			clearTimeout(v16)
		end
	end, { phase, actions.endRoll })

	react.useEffect(function()
		return function()
			actions.cancelFetch()
		end
	end, { actions.cancelFetch })

	react.useEffect(function()
		if phase == SquadLuckyRecommendationPhase.Revealed then
			v5.fire(EventNames.LuckyRecommendationRevealShown, { universeId = universeId })
		elseif phase == SquadLuckyRecommendationPhase.Errored then
			v5.fire(EventNames.LuckyRecommendationErrorShown, { errorType = state.error })
		end
	end, { phase, v5, state, universeId })

	local v16, v17 = ReactOtter.useAnimatedBinding(0)

	react.useEffect(function()
		if v7 then
			v17(ReactOtter.ease(100, {
				duration = 1,
				easingStyle = Enum.EasingStyle.Quad,
				startingValue = 0
			}))
		elseif v9 then
			v17(ReactOtter.ease(100, { duration = 0 }))
		end
	end, { v7, v9, v17 })
	local v18

	if v8 then
		v18 = {
			title = v6.revealedTitle,
			subtitle = v6.revealedSubtitle,
			actionText = v6.joinText,
			onAction = onAction,
			isActionDisabled = v12 or v13
		}
	elseif v9 then
		v18 = { title = v6.errorTitle, actionText = v6.retryText, onAction = v15 }
	else
		v18 = {
			title = v6.rollingTitle,
			subtitle = v6.rollingSubtitle,
			actionText = v6.cancelText,
			onAction = v14
		}
	end

	local v19 = {}

	v19.Title = react.createElement(text, {
		tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
		LayoutOrder = 1,
		Text = v18.title,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--title" or nil
	})

	if v18.subtitle ~= nil then
		v19.Subtitle = react.createElement(text, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 2,
			Text = v18.subtitle,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--subtitle" or nil
		})
	end

	local children = {}

	children.Header = react.createElement(view, {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = 1
	}, v19)

	if recommendation then
		local createElement = react.createElement
		local thumbnail

		if image2 then
			thumbnail = react.createElement(image, {
				tag = "radius-small",
				LayoutOrder = 1,
				Image = image2,
				Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_1000),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--game-thumbnail" or nil
			})
		end

		children.GameResult = createElement(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-200",
				LayoutOrder = 2
			},
			{
				Thumbnail = thumbnail,
				GameInfo = react.createElement(
					view,
					{
						tag = "col align-y-center fill",
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, v.Size.Size_1000)
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

	if not v9 then
		children.ProgressBar = react.createElement(
			view,
			{
				tag = "row align-y-center size-full-0",
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v.Size.Size_500)
			},
			{
				Bar = react.createElement(progress, {
					shape = progressShape.Bar,
					size = progressSize.Medium,
					value = v16,
					width = UDim.new(1, 0),
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--progress" or nil
				})
			}
		)
	end

	local createElement = react.createElement

	local createElement2 = react.createElement
	local root = dialog.Root
	local v20 = {
		onClose = v14,
		size = dialogSize.Small,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		disablePortal = props.disablePortal ~= nil and props.disablePortal,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog" or nil
	}

	local createElement3 = react.createElement

	local v21 = {
		Main = react.createElement(view, {
			tag = "col size-full-0 auto-y",
			padding = {
				top = UDim.new(0, size_300 + v.Size.Size_200)
			}
		}, {
			Body = react.createElement(
				view,
				{ tag = "col gap-large size-full-0 auto-y padding-bottom-large", LayoutOrder = 1 },
				children
			),
			ActionButton = react.createElement(button, {
				LayoutOrder = 2,
				onActivated = v18.onAction,
				text = v18.actionText,
				variant = buttonVariant.Standard,
				width = UDim.new(1, 0),
				isDisabled = v18.isActionDisabled,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--action-button" or nil
			})
		}),
		ResetButton = 0
	}
	local resetButton

	if v8 then
		resetButton = react.createElement(view, {
			tag = "row align-x-center align-y-center auto-xy padding-small radius-circle clip bg-over-media-100",
			onActivated = v15,
			Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_1000),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -v.Size.Size_1000, 0, size_300),
			ZIndex = 2,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lucky-recommendation-dialog--reroll-button" or nil
		}, {
			Icon = react.createElement(icon, {
				name = "arrow-spin-clockwise",
				size = iconSize.Small,
				style = v.Color.Content.Emphasis
			})
		})
	end

	v21.ResetButton = resetButton
	return (createElement(overlayProvider, { DisplayOrder = SQUAD_LOBBY_MODAL_DISPLAY_ORDER }, {
		Dialog = createElement2(root, v20, {
			Content = createElement3(view, { tag = "size-full-0 auto-y", LayoutOrder = 1 }, v21)
		})
	}))
end

return SquadLobbyLuckyRecommendationModal
