local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local Foundation = dependencies.Foundation
local LuauPolyfill = dependencies.LuauPolyfill
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local IconSize = Foundation.Enums.IconSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize
local Button = Foundation.Button
local Dialog = Foundation.Dialog
local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local OverlayProvider = Foundation.OverlayProvider
local Progress = Foundation.Progress
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ReactOtter = require(SquadsParent.ReactOtter)
local getRbxthumbWithTypeSizeAndOptions = require(SquadsParent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require(SquadsParent.UserLib).Utils.Constants
local CreateExperienceInvite = require(Squads.Thunks.CreateExperienceInvite)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local Enums = require(SquadsParent.SquadsCore.Enums)
local SquadExperienceInviteSource = Enums.SquadExperienceInviteSource
local SquadLuckyRecommendationPhase = Enums.SquadLuckyRecommendationPhase
local Hooks = require(SquadsParent.SquadsCore.Hooks)
local useLuckyRecommendation = Hooks.useLuckyRecommendation
local useLuckyRecommendationAnalytics = Hooks.useLuckyRecommendationAnalytics
local EventNames = require(SquadsParent.SquadsCore.EventNames)

local function SquadLobbyLuckyRecommendationModal(t1: {[any]: any}) -- line: 67
	-- upvalues: useTokens (copy), useDispatch (copy), React (copy), SquadExternalContractContext (copy), useLuckyRecommendation (copy), useLuckyRecommendationAnalytics (copy), useLocalization (copy), SquadLuckyRecommendationPhase (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), useSelector (copy), EventNames (copy), CreateExperienceInvite (copy), SquadExperienceInviteSource (copy), setTimeout (copy), clearTimeout (copy), ReactOtter (copy), FoundationText (copy), View (copy), FoundationImage (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy), OverlayProvider (copy), Dialog (copy), DialogSize (copy), Button (copy), ButtonVariant (copy), Icon (copy), IconSize (copy)
	local v40 = useTokens()
	local v41 = useDispatch()
	local Size_300 = v40.Size.Size_300
	local v43 = React.useContext(SquadExternalContractContext)
	local v44 = useLuckyRecommendation()
	local state = v44.state
	local actions = v44.actions
	local sessionId = t1.sessionId
	local v48 = useLuckyRecommendationAnalytics(sessionId)
	local v49 = useLocalization({
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
	local v51 = phase == SquadLuckyRecommendationPhase.Rolling
	local v52 = phase == SquadLuckyRecommendationPhase.Revealed
	local v53 = v52 or phase == SquadLuckyRecommendationPhase.Errored
	local v54 = if state.phase ~= SquadLuckyRecommendationPhase.Revealed then nil else state.recommendation
	local v55 = v54 and v54.universeId
	local v56 = v54 and v54.rootPlaceId
	local v57 = if v55 == nil then nil else getRbxthumbWithTypeSizeAndOptions(tostring(v55), Constants.RbxthumbTypes.GameIcon, 150, false)
	local v58 = React.useCallback(function(p1) -- line: 107
		return p1.Squad and (p1.Squad.Squad and (p1.Squad.Squad.currentSquad and p1.Squad.Squad.currentSquad.squadId))
	end, {})
	local v59 = useSelector(v58)
	local v60 = React.useCallback(function(p2) -- line: 115
		return p2.Squad and (p2.Squad.Squad and p2.Squad.Squad.currentExperienceInvite)
	end, {})
	local v61 = useSelector(v60)
	local v62 = React.useCallback(function() -- line: 120
		-- upvalues: v48 (copy), EventNames (copy), phase (copy), t1 (copy)
		v48.fire(EventNames.LuckyRecommendationDismissed, {
			phaseAtDismiss = phase
		})
		t1.onClose()
	end, {
		v48,
		phase,
		t1.onClose
	})
	local v63 = React.useCallback(function() -- line: 127
		-- upvalues: v48 (copy), EventNames (copy), phase (copy), actions (copy), v59 (copy)
		v48.fire(EventNames.LuckyRecommendationRerolled, {
			phaseAtReroll = phase
		})
		actions.startRoll(v59, false)
	end, {
		actions.startRoll,
		v59,
		v48,
		phase
	})
	local v64 = React.useCallback(function() -- line: 134
		-- upvalues: v48 (copy), EventNames (copy), v56 (copy), v41 (copy), CreateExperienceInvite (copy), v43 (copy), SquadExperienceInviteSource (copy)
		local v72 = v48.getContext()

		v48.fire(EventNames.LuckyRecommendationJoinTapped, {
			rootPlaceId = v56
		})

		if v56 == nil then
			return
		end

		v41(CreateExperienceInvite(tostring(v56), v43, SquadExperienceInviteSource.LuckyRecommendation)):andThen(function(s1: string) -- line: 144
			-- upvalues: v48 (copy), EventNames (copy), v72 (copy), v56 (copy)
			if s1 then
				v48.fire(EventNames.LuckyRecommendationExperienceInviteCreated, {
					pickRequestId = v72.pickRequestId,
					revealType = v72.revealType,
					rootPlaceId = v56,
					experienceInviteId = s1
				})
			end
		end)
	end, {
		v41,
		v56,
		v43,
		v48
	})

	React.useLayoutEffect(function() -- line: 156
		-- upvalues: actions (copy), v59 (copy)
		actions.startRoll(v59, true)
	end, {
		actions.startRoll,
		v59
	})
	React.useEffect(function() -- line: 160
		-- upvalues: phase (copy), SquadLuckyRecommendationPhase (copy), setTimeout (copy), actions (copy), clearTimeout (copy)
		if phase ~= SquadLuckyRecommendationPhase.Rolling then
			return
		end

		local v73 = setTimeout(actions.endRoll, 1000)

		return function() -- line: 165
			-- upvalues: clearTimeout (copy), v73 (copy)
			clearTimeout(v73)
		end
	end, {
		phase,
		actions.endRoll
	})
	React.useEffect(function() -- line: 170
		-- upvalues: actions (copy)
		return function() -- line: 171
			-- upvalues: actions (copy)
			actions.cancelFetch()
		end
	end, { actions.cancelFetch })
	React.useEffect(function() -- line: 176
		-- upvalues: phase (copy), SquadLuckyRecommendationPhase (copy), v48 (copy), EventNames (copy), v55 (copy), state (copy)
		if phase == SquadLuckyRecommendationPhase.Revealed then
			v48.fire(EventNames.LuckyRecommendationRevealShown, {
				universeId = v55
			})

			return
		end

		if phase == SquadLuckyRecommendationPhase.Errored then
			v48.fire(EventNames.LuckyRecommendationErrorShown, {
				errorType = state.error
			})
		end
	end, {
		phase,
		v48,
		state,
		v55
	})

	local v65, v66 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 190
		-- upvalues: v51 (copy), v66 (copy), ReactOtter (copy), v53 (copy)
		if v51 then
			v66(ReactOtter.ease(100, {
				duration = 1,
				startingValue = 0,
				easingStyle = Enum.EasingStyle.Quad
			}))

			return
		end

		if v53 then
			v66(ReactOtter.ease(100, {
				duration = 0
			}))
		end
	end, {
		v51,
		v53,
		v66
	})

	local v67 = if not v52 then if v53 then {
		title = v49.errorTitle,
		actionText = v49.retryText,
		onAction = v63
	} else {
		title = v49.rollingTitle,
		subtitle = v49.rollingSubtitle,
		actionText = v49.cancelText,
		onAction = v62
	} else {
		title = v49.revealedTitle,
		subtitle = v49.revealedSubtitle,
		actionText = v49.joinText,
		onAction = v64,
		isActionDisabled = v61 ~= nil
	}
	local t2 = {
		Title = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
			LayoutOrder = 1,
			Text = v67.title
		})
	}

	if v67.subtitle ~= nil then
		t2.Subtitle = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 2,
			Text = v67.subtitle
		})
	end

	local t3 = {
		Header = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, t2)
	}

	if v54 then
		t3.GameResult = React.createElement(View, {
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-200",
			LayoutOrder = 2
		}, {
			Thumbnail = if not v57 then nil else React.createElement(FoundationImage, {
				tag = "radius-small",
				LayoutOrder = 1,
				Image = v57,
				Size = UDim2.fromOffset(v40.Size.Size_1000, v40.Size.Size_1000)
			}),
			GameInfo = React.createElement(View, {
				tag = "col align-y-center fill",
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v40.Size.Size_1000)
			}, {
				GameName = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
					LayoutOrder = 1,
					Text = v54.universeName
				})
			})
		})
	end

	if not v53 then
		t3.ProgressBar = React.createElement(View, {
			tag = "row align-y-center size-full-0",
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v40.Size.Size_500)
		}, {
			Bar = React.createElement(Progress, {
				shape = ProgressShape.Bar,
				size = ProgressSize.Medium,
				value = v65,
				width = UDim.new(1, 0)
			})
		})
	end

	return (React.createElement(OverlayProvider, {
		DisplayOrder = 11
	}, {
		Dialog = React.createElement(Dialog.Root, {
			onClose = v62,
			size = DialogSize.Small,
			hasBackdrop = t1.hasBackdrop == nil or t1.hasBackdrop,
			disablePortal = t1.disablePortal ~= nil and t1.disablePortal
		}, {
			Content = React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Main = React.createElement(View, {
					tag = "col size-full-0 auto-y",
					padding = {
						top = UDim.new(0, Size_300 + v40.Size.Size_200)
					}
				}, {
					Body = React.createElement(View, {
						tag = "col gap-large size-full-0 auto-y padding-bottom-large",
						LayoutOrder = 1
					}, t3),
					ActionButton = React.createElement(Button, {
						LayoutOrder = 2,
						onActivated = v67.onAction,
						text = v67.actionText,
						variant = ButtonVariant.Standard,
						width = UDim.new(1, 0),
						isDisabled = v67.isActionDisabled
					})
				}),
				ResetButton = if not v52 then nil else React.createElement(View, {
					tag = "row align-x-center align-y-center auto-xy padding-small radius-circle clip bg-over-media-100",
					ZIndex = 2,
					onActivated = v63,
					Size = UDim2.fromOffset(v40.Size.Size_1000, v40.Size.Size_1000),
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -v40.Size.Size_1000, 0, Size_300)
				}, {
					Icon = React.createElement(Icon, {
						name = "arrow-spin-clockwise",
						size = IconSize.Small,
						style = v40.Color.Content.Emphasis
					})
				})
			})
		})
	}))
end

return SquadLobbyLuckyRecommendationModal
