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
local useLuckyRecommendation = require(SquadsParent.SquadsCore.Hooks).useLuckyRecommendation

local function SquadLobbyLuckyRecommendationModal(t1: {[any]: any}) -- line: 63
	-- upvalues: useTokens (copy), useDispatch (copy), React (copy), SquadExternalContractContext (copy), useLuckyRecommendation (copy), useLocalization (copy), SquadLuckyRecommendationPhase (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), useSelector (copy), CreateExperienceInvite (copy), SquadExperienceInviteSource (copy), setTimeout (copy), clearTimeout (copy), ReactOtter (copy), FoundationText (copy), View (copy), FoundationImage (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy), OverlayProvider (copy), Dialog (copy), DialogSize (copy), Button (copy), ButtonVariant (copy), Icon (copy), IconSize (copy)
	local v37 = useTokens()
	local v38 = useDispatch()
	local Size_300 = v37.Size.Size_300
	local v40 = React.useContext(SquadExternalContractContext)
	local v41 = useLuckyRecommendation()
	local state = v41.state
	local actions = v41.actions
	local v44 = useLocalization({
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
	local v46 = phase == SquadLuckyRecommendationPhase.Rolling
	local v47 = phase == SquadLuckyRecommendationPhase.Revealed
	local v48 = v47 or phase == SquadLuckyRecommendationPhase.Errored
	local v49 = if state.phase ~= SquadLuckyRecommendationPhase.Revealed then nil else state.recommendation
	local v50 = v49 and v49.universeId
	local v51 = v49 and v49.rootPlaceId
	local v52 = if v50 == nil then nil else getRbxthumbWithTypeSizeAndOptions(tostring(v50), Constants.RbxthumbTypes.GameIcon, 150, false)
	local v53 = React.useCallback(function(p1) -- line: 100
		return p1.Squad and (p1.Squad.Squad and (p1.Squad.Squad.currentSquad and p1.Squad.Squad.currentSquad.squadId))
	end, {})
	local v54 = useSelector(v53)
	local v55 = React.useCallback(function(p2) -- line: 108
		return p2.Squad and (p2.Squad.Squad and p2.Squad.Squad.currentExperienceInvite)
	end, {})
	local v56 = useSelector(v55)
	local v57 = React.useCallback(function() -- line: 113
		-- upvalues: actions (copy), v54 (copy)
		actions.startRoll(v54, false)
	end, {
		actions.startRoll,
		v54
	})
	local v58 = React.useCallback(function() -- line: 117
		-- upvalues: v51 (copy), v38 (copy), CreateExperienceInvite (copy), v40 (copy), SquadExperienceInviteSource (copy)
		if v51 == nil then
			return
		end

		v38(CreateExperienceInvite(tostring(v51), v40, SquadExperienceInviteSource.LuckyRecommendation))
	end, {
		v38,
		v51,
		v40
	})

	React.useLayoutEffect(function() -- line: 126
		-- upvalues: actions (copy), v54 (copy)
		actions.startRoll(v54, true)
	end, {
		actions.startRoll,
		v54
	})
	React.useEffect(function() -- line: 130
		-- upvalues: phase (copy), SquadLuckyRecommendationPhase (copy), setTimeout (copy), actions (copy), clearTimeout (copy)
		if phase ~= SquadLuckyRecommendationPhase.Rolling then
			return
		end

		local v66 = setTimeout(actions.endRoll, 1000)

		return function() -- line: 135
			-- upvalues: clearTimeout (copy), v66 (copy)
			clearTimeout(v66)
		end
	end, {
		phase,
		actions.endRoll
	})
	React.useEffect(function() -- line: 140
		-- upvalues: actions (copy)
		return function() -- line: 141
			-- upvalues: actions (copy)
			actions.cancelFetch()
		end
	end, { actions.cancelFetch })

	local v59, v60 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 148
		-- upvalues: v46 (copy), v60 (copy), ReactOtter (copy), v48 (copy)
		if v46 then
			v60(ReactOtter.ease(100, {
				duration = 1,
				startingValue = 0,
				easingStyle = Enum.EasingStyle.Quad
			}))

			return
		end

		if v48 then
			v60(ReactOtter.ease(100, {
				duration = 0
			}))
		end
	end, {
		v46,
		v48,
		v60
	})

	local v61 = if not v47 then if v48 then {
		title = v44.errorTitle,
		actionText = v44.retryText,
		onAction = v57
	} else {
		title = v44.rollingTitle,
		subtitle = v44.rollingSubtitle,
		actionText = v44.cancelText,
		onAction = t1.onClose
	} else {
		title = v44.revealedTitle,
		subtitle = v44.revealedSubtitle,
		actionText = v44.joinText,
		onAction = v58,
		isActionDisabled = v56 ~= nil
	}
	local t2 = {
		Title = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
			LayoutOrder = 1,
			Text = v61.title
		})
	}

	if v61.subtitle ~= nil then
		t2.Subtitle = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 2,
			Text = v61.subtitle
		})
	end

	local t3 = {
		Header = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, t2)
	}

	if v49 then
		t3.GameResult = React.createElement(View, {
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-200",
			LayoutOrder = 2
		}, {
			Thumbnail = if not v52 then nil else React.createElement(FoundationImage, {
				tag = "radius-small",
				LayoutOrder = 1,
				Image = v52,
				Size = UDim2.fromOffset(v37.Size.Size_1000, v37.Size.Size_1000)
			}),
			GameInfo = React.createElement(View, {
				tag = "col align-y-center fill",
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v37.Size.Size_1000)
			}, {
				GameName = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
					LayoutOrder = 1,
					Text = v49.universeName
				})
			})
		})
	end

	if not v48 then
		t3.ProgressBar = React.createElement(View, {
			tag = "row align-y-center size-full-0",
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v37.Size.Size_500)
		}, {
			Bar = React.createElement(Progress, {
				shape = ProgressShape.Bar,
				size = ProgressSize.Medium,
				value = v59,
				width = UDim.new(1, 0)
			})
		})
	end

	return (React.createElement(OverlayProvider, {
		DisplayOrder = 11
	}, {
		Dialog = React.createElement(Dialog.Root, {
			onClose = t1.onClose,
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
						top = UDim.new(0, Size_300 + v37.Size.Size_200)
					}
				}, {
					Body = React.createElement(View, {
						tag = "col gap-large size-full-0 auto-y padding-bottom-large",
						LayoutOrder = 1
					}, t3),
					ActionButton = React.createElement(Button, {
						LayoutOrder = 2,
						onActivated = v61.onAction,
						text = v61.actionText,
						variant = ButtonVariant.Standard,
						width = UDim.new(1, 0),
						isDisabled = v61.isActionDisabled
					})
				}),
				ResetButton = if not v47 then nil else React.createElement(View, {
					tag = "row align-x-center align-y-center auto-xy padding-small radius-circle clip bg-over-media-100",
					ZIndex = 2,
					onActivated = v57,
					Size = UDim2.fromOffset(v37.Size.Size_1000, v37.Size.Size_1000),
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -v37.Size.Size_1000, 0, Size_300)
				}, {
					Icon = React.createElement(Icon, {
						name = "arrow-spin-clockwise",
						size = IconSize.Small,
						style = v37.Color.Content.Emphasis
					})
				})
			})
		})
	}))
end

return SquadLobbyLuckyRecommendationModal
