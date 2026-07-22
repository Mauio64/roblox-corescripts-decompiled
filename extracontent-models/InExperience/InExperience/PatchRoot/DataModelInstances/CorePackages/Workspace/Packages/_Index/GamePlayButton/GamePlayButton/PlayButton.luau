local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local IXPService = game:GetService("IXPService")
local tutils = require(Parent.tutils)
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UIBlox = require(Parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ComboButton = UIBlox.App.Button.ComboButton
local Images = UIBlox.App.ImageSet.Images
local MenuDirection = UIBlox.App.Menu.MenuDirection
local Foundation = require(Parent.Foundation)
local Button2 = Foundation.Button
local IconButton = Foundation.IconButton
local Skeleton = Foundation.Skeleton
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local GamesProductInfoReducer = require(Parent.GameProductInfoRodux).GamesProductInfoReducer
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local useOnPlayButtonCallback = require(script.Parent.useOnPlayButtonCallback)
local useOnPlaySquadButtonCallback = require(script.Parent.useOnPlaySquadButtonCallback)
local usePlayButtonState = require(script.Parent.usePlayButtonState)
local PlayButtonGroupView = require(script.Parent.PlayButtonGroupView)
local PlayButtonView = require(script.Parent.PlayButtonView)
local PlayButtonStates = require(script.Parent.PlayButtonStates)
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require(Parent.SharedFlags).FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local FFlagLuaAppJoinTextPlayableButton = require(Parent.SharedFlags).FFlagLuaAppJoinTextPlayableButton
local FFlagLuaAppIconPlayButton = require(Parent.SharedFlags).FFlagLuaAppIconPlayButton
local FFlagLuaAppPlayButtonLoadingSkeleton = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLoadingSkeleton
local v39 = game:DefineFastFlag("LuaAppFixPlayButtonDefaultLaunchSource", false)
local FFlagUpdateActionNeededPlayButtonUi = require(Parent.SharedFlags).FFlagUpdateActionNeededPlayButtonUi
local FFlagLuaAppUnifiedPlayButtonSquadMenuDirection = require(Parent.SharedFlags).FFlagLuaAppUnifiedPlayButtonSquadMenuDirection
local GetFFlagUIBloxUseFoundationButton = require(Parent.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagLuaAppPlayButtonOptOutFoundationButton = require(Parent.SharedFlags).FFlagLuaAppPlayButtonOptOutFoundationButton
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local FFlagLuaAppTextOnlyPlayButton = require(Parent.SharedFlags).FFlagLuaAppTextOnlyPlayButton
local FFlagLuaAppIconTextPlayButton = require(Parent.SharedFlags).FFlagLuaAppIconTextPlayButton
local FFlagLuaAppUpdatePlayButtonText = require(Parent.SharedFlags).FFlagLuaAppUpdatePlayButtonText
local FFlagLuaAppLogExposurePlayButtonUX = require(Parent.SharedFlags).FFlagLuaAppLogExposurePlayButtonUX
local FFlagLuaAppUseTokenHeightForPlayButton = require(Parent.SharedFlags).FFlagLuaAppUseTokenHeightForPlayButton
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce
local FFlagLuaAppLaunchWhenLoadingEdp = require(Parent.SharedFlags).FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppLaunchWhenLoadingForce = require(Parent.SharedFlags).FFlagLuaAppLaunchWhenLoadingForce
local FFlagLuaAppDemoModePlayButton = require(Parent.SharedFlags).FFlagLuaAppDemoModePlayButton
local FFlagLuaAppPlayButtonViewRefactor = require(Parent.SharedFlags).FFlagLuaAppPlayButtonViewRefactor
local usePlayOnReleaseAfterUnmount = require(script.Parent.usePlayOnReleaseAfterUnmount)
local v58 = if not FFlagLuaAppIconPlayButton then nil else "play-xlarge"
local v59 = Images["icons/common/play"]
local v60 = Images["icons/actions/truncationCollapse"]
local v61 = Images["icons/actions/truncationExpand"]

local function v62() -- line: 86
end

local v63 = if not FFlagLuaAppDemoModePlayButton then {
	[InputSize.XSmall] = "Size_600",
	[InputSize.Small] = "Size_800",
	[InputSize.Medium] = "Size_1000",
	[InputSize.Large] = "Size_1200"
} else require(script.Parent.ButtonHeightSizeKeyByInputSize)

local function PlayButton(t1: {[any]: any}) -- line: 185
	-- upvalues: React (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), GamesProductInfoReducer (copy), tutils (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), FFlagLuaAppDemoModePlayButton (copy), useBreakpointXOrSmaller (copy), Responsive (copy), usePlayButtonState (copy), PlayButtonStates (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), useOnPlayButtonCallback (copy), v39 (copy), FFlagLuaAppUnifiedPlayButtonSquadMenuDirection (copy), MenuDirection (copy), useOnPlaySquadButtonCallback (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy), usePlayOnReleaseAfterUnmount (copy), FFlagSduiExperienceDetailsSupport (copy), useLocalization (copy), FFlagLuaAppUpdatePlayButtonText (copy), FFlagUpdateActionNeededPlayButtonUi (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), useUserExperiment (copy), AppUserLayers (copy), FFlagLuaAppLogExposurePlayButtonUX (copy), IXPService (copy), useTokens (copy), FFlagLuaAppPlayButtonViewRefactor (copy), PlayButtonGroupView (copy), PlayButtonView (copy), InputSize (copy), FFlagLuaAppUseTokenHeightForPlayButton (copy), v63 (copy), FFlagLuaAppPlayButtonLoadingSkeleton (copy), Skeleton (copy), EnumsRadius (copy), ButtonVariant (copy), FFlagLuaAppIconTextPlayButton (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppJoinTextPlayableButton (copy), v58 (copy), FFlagLuaAppIconPlayButton (copy), GetFFlagIsSquadEnabled (copy), v59 (copy), ComboButton (copy), v61 (copy), v60 (copy), ButtonType (copy), Images (copy), Button (copy), v62 (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy), IconButton (copy), Button2 (copy)
	local v66 = React.useRef(false)

	React.useEffect(function() -- line: 187
		-- upvalues: v66 (copy)
		v66.current = true

		return function() -- line: 189
			-- upvalues: v66 (copy)
			v66.current = false
		end
	end, {})

	local v67 = useRoactService(RoactNetworking)
	local v68 = useSelector(function(p1) -- line: 195
		-- upvalues: t1 (copy), GamesProductInfoReducer (copy)
		if t1.universeId then
			return p1[GamesProductInfoReducer.key][t1.universeId]
		end

		return nil
	end, tutils.shallowEqual)
	local v69 = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else t1.eventContext or "PlayButton"
	local v70 = nil

	if FFlagLuaAppDemoModePlayButton then
		v70 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	end

	local v71 = usePlayButtonState(v67, t1.universeId, t1.fetchDelayInSeconds, t1.isPlayableWhenLoading, not not FFlagLuaAppPlayButtonLoadingDurationTelemetry or nil, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v69)
	local playButtonState = v71.playButtonState
	local u73 = if not FFlagLuaAppDemoModePlayButton then nil else v71.secondaryPlayButtonState

	if FFlagLuaAppDemoModePlayButton and u73 ~= nil then
		local v74 = playButtonState == PlayButtonStates.UnplayableOther
		local v75 = u73 == PlayButtonStates.UnplayableOther

		if t1.preferSecondaryPlayButton == true or v70 and v74 then
			playButtonState = u73
			u73 = nil
		elseif v70 and v75 then
			u73 = nil
		end
	end

	local v76 = FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp and t1.launchWhenLoading == true
	local v77 = useOnPlayButtonCallback(t1.universeId, t1.referralSource, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then t1.eventContext or "PlayButton" else v69, nil, t1.launchSource or (not v39 and "LuaGameCard" or "UnknownLaunchSource"), t1.experienceJoinData, t1.placeId, if not FFlagLuaAppLaunchWhenLoadingEdp and not FFlagLuaAppLaunchWhenLoadingForce then nil else t1.launchWhenLoading)
	local v78 = if not FFlagLuaAppUnifiedPlayButtonSquadMenuDirection or t1.squadButtonMenuDirection == nil then MenuDirection.Up else t1.squadButtonMenuDirection
	local v79 = useOnPlaySquadButtonCallback(v78, playButtonState, t1.referralSource, t1.universeId)
	local v80 = FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce or FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp and t1.launchOnReleaseAfterUnmount == true
	local v81 = nil
	local v83

	if FFlagLuaAppDemoModePlayButton then
		local v82 = React.useCallback(function(s1: string?) -- line: 266
			-- upvalues: v80 (copy), v66 (copy), t1 (copy), PlayButtonStates (copy), v77 (copy)
			if s1 == nil then
				return
			end

			if not v80 and not v66.current then
				return
			end

			if t1.onActivated then
				t1.onActivated()
			end

			if t1.onPurchaseRequiredCallback and (s1 == PlayButtonStates.PaidAccess or s1 == PlayButtonStates.FiatPaidAccess) then
				t1.onPurchaseRequiredCallback()

				return
			end

			v77(s1, t1.reportExperienceLaunched)
		end, {
			v77,
			t1.onPurchaseRequiredCallback,
			t1.reportExperienceLaunched,
			t1.onActivated,
			if not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce and not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp then nil else v80
		})

		v83 = React.useCallback(function() -- line: 303
			-- upvalues: v82 (copy), playButtonState (ref)
			v82(playButtonState)
		end, {
			v82,
			playButtonState
		})
		v81 = React.useCallback(function() -- line: 307
			-- upvalues: v82 (copy), u73 (ref)
			v82(u73)
		end, {
			v82,
			u73
		})
	else
		v83 = React.useCallback(function() -- line: 312
			-- upvalues: v80 (copy), v66 (copy), t1 (copy), playButtonState (ref), PlayButtonStates (copy), v77 (copy)
			if not v80 and not v66.current then
				return
			end

			if t1.onActivated then
				t1.onActivated()
			end

			if t1.onPurchaseRequiredCallback and (playButtonState == PlayButtonStates.PaidAccess or playButtonState == PlayButtonStates.FiatPaidAccess) then
				t1.onPurchaseRequiredCallback()

				return
			end

			v77(playButtonState, t1.reportExperienceLaunched)
		end, {
			v77,
			playButtonState,
			t1.onPurchaseRequiredCallback,
			t1.reportExperienceLaunched,
			t1.onActivated,
			if not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce and not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp then nil else v80
		})
	end

	local v84 = if not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp and not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce then nil else usePlayOnReleaseAfterUnmount(v83)
	local v85 = if not v80 or not v84 then nil else v84.playButtonRef
	local v86 = if not v80 or not v84 then nil else v84.loadingCaptureRef
	local v87 = if not v80 then v83 else v84.onActivated
	local v88 = React.useCallback(function(p2) -- line: 362
		-- upvalues: v66 (copy), t1 (copy), v79 (copy)
		if not v66.current then
			return
		end

		if t1.onActivated then
			t1.onActivated()
		end

		v79(p2)
	end, {
		v79,
		t1.onActivated
	})

	if FFlagSduiExperienceDetailsSupport then
		React.useEffect(function() -- line: 373
			-- upvalues: t1 (copy), v87 (copy)
			local onRegisterActivation = t1.onRegisterActivation

			if onRegisterActivation == nil then
				return
			end

			return onRegisterActivation(v87)
		end, {
			t1.onRegisterActivation,
			v87
		})
	end

	local v89 = useLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty",
		play = if not FFlagLuaAppUpdatePlayButtonText then nil else "Feature.ExperienceDetails.PlayButtonText.Play",
		playDemo = if not FFlagLuaAppDemoModePlayButton then nil else "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		unlock = if not FFlagUpdateActionNeededPlayButtonUi then nil else "Feature.ExperienceDetails.PlayButtonText.Unlock"
	})
	local v90 = nil
	local v91 = nil
	local v92 = nil

	if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v90, v91, v92 = useUserExperiment({ AppUserLayers.PlayButtonUXExposureLayer }, function(p3) -- line: 396
			-- upvalues: AppUserLayers (copy)
			local v126 = p3[AppUserLayers.PlayButtonUXExposureLayer] or {}

			return v126.HasJoinTextButton, v126.HasIconPlayButton, v126.HasPlayButtonLoadingSkeleton
		end, true)
	end

	if FFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function() -- line: 405
			-- upvalues: IXPService (copy), AppUserLayers (copy)
			IXPService:LogUserLayerExposure(AppUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local v93 = useTokens()

	if FFlagLuaAppPlayButtonViewRefactor then
		return React.createElement(if not FFlagLuaAppDemoModePlayButton then PlayButtonView else PlayButtonGroupView, {
			playButtonState = playButtonState,
			secondaryPlayButtonState = if not FFlagLuaAppDemoModePlayButton then nil else u73,
			gameProductInfo = v68,
			localized = v89,
			tokens = v93,
			hasJoinTextPlayableButtonIxp = v90,
			hasIconPlayButtonIxp = v91,
			hasPlayButtonLoadingSkeletonIxp = v92,
			onPlayButtonActivated = v87,
			onSecondaryPlayButtonActivated = if not FFlagLuaAppDemoModePlayButton then nil else v81,
			onPlaySquadButtonActivated = v88,
			playButtonCaptureRef = v85,
			loadingCaptureRef = v86,
			shouldLaunchWhenLoading = v76,
			shouldLaunchOnReleaseAfterUnmount = v80,
			squadButtonMenuDirection = v78,
			playableText = t1.playableText,
			fiatText = t1.fiatText,
			hidePlayableIcon = t1.hidePlayableIcon,
			hideOptionalText = t1.hideOptionalText,
			buttonSize = t1.buttonSize,
			width = t1.width,
			expandWidthForSecondaryPlayButton = if not FFlagLuaAppDemoModePlayButton then nil else t1.expandWidthForSecondaryPlayButton,
			fillBehavior = t1.fillBehavior,
			useUIBloxButton = t1.useUIBloxButton,
			hideIfUnplayable = t1.hideIfUnplayable,
			hideIfLoading = t1.hideIfLoading,
			LayoutOrder = t1.LayoutOrder,
			Position = t1.Position,
			tag = t1.tag,
			testId = t1.testId
		})
	end

	local v94 = false
	local v95 = false
	local v96 = false
	local v97 = t1.buttonSize or InputSize.Medium
	local v98 = nil

	if FFlagLuaAppUseTokenHeightForPlayButton then
		local v99 = v63[v97] or "Size_1000"

		v98 = (not v93 or not v93.Size[v99]) and 40 or v93.Size[v99]
	end

	local v100 = if not t1.width then t1.fillBehavior else "Fill"
	local Emphasis = nil
	local v102 = nil
	local v103 = nil
	local v104 = nil
	local v105 = nil

	if playButtonState == PlayButtonStates.Loading then
		if t1.hideIfLoading then
			return nil
		end

		if FFlagLuaAppPlayButtonLoadingSkeleton and (not t1.useUIBloxButton and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or v92)) then
			local v106

			if FFlagLuaAppUseTokenHeightForPlayButton then
				v106 = v98
			else
				local v107 = v63[v97] or "Size_1000"

				v106 = v93 and v93.Size[v107]
			end

			v105 = if v100 ~= "Fill" then UDim.new(0, v106) else UDim.new(1, 0)

			local uDim2 = UDim2.new(v105, UDim.new(0, v106))
			local v109 = FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or (v76 or v80)
			local v110 = React.createElement(Skeleton, {
				ZIndex = 2,
				Size = if not v109 then uDim2 else UDim2.fromScale(1, 1),
				radius = EnumsRadius.Medium
			})

			v104 = if not v109 then v110 else React.createElement("TextButton", {
				Size = uDim2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				ref = v86,
				[React.Event.Activated] = v87
			}, {
				Skeleton = v110
			})
			v96 = true
		end

		Emphasis = ButtonVariant.Emphasis
	elseif playButtonState == PlayButtonStates.Playable then
		Emphasis = ButtonVariant.Emphasis

		if FFlagLuaAppIconTextPlayButton or (FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppJoinTextPlayableButton and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or v90)) then
			v103 = t1.playableText or if not FFlagLuaAppUpdatePlayButtonText then v89.join else v89.play

			if FFlagLuaAppIconTextPlayButton and not t1.hidePlayableIcon then
				v102 = v58
			end
		else
			if not FFlagLuaAppIconPlayButton and not t1.hidePlayableIcon then
				v102 = "icons/common/play"
			end

			v103 = t1.playableText

			if FFlagLuaAppIconPlayButton and not t1.hidePlayableIcon then
				v102 = if not v103 or v103 == "" then v58 else "icons/common/play"
			end
		end
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		v102 = v59
		v103 = if not t1.hideOptionalText then v89.joinWithParty else nil
		v94 = true
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		v102 = v59
		v103 = if not t1.hideOptionalText then v89.waitingForParty else nil
		v96 = true
		v95 = true
		v94 = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		v103 = tostring(v68 and v68.price or 0)
		Emphasis = ButtonVariant.Emphasis
		v102 = "icons/common/robux"
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		Emphasis = ButtonVariant.Emphasis

		local v111 = v68 and v68.localizedFiatPrice or ""

		v103 = t1.fiatText or v111
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		if FFlagUpdateActionNeededPlayButtonUi then
			Emphasis = ButtonVariant.Emphasis
			v103 = v89.unlock
		else
			Emphasis = ButtonVariant.SubEmphasis
			v102 = "icons/status/private"
			v103 = if not t1.hideOptionalText then v89.join else nil
		end
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		if t1.hideIfUnplayable then
			return nil
		end

		Emphasis = ButtonVariant.Subtle
		v102 = "icons/status/unavailable"
		v103 = if not t1.hideOptionalText then v89.unavailable else nil
		v96 = true
	else
		error("invalid play button state!")
	end

	local v113

	if v94 then
		if not FFlagLuaAppUseTokenHeightForPlayButton then
			local v112 = v63[v97] or "Size_1000"

			v98 = (not v93 or not v93.Size[v112]) and 40 or v93.Size[v112]
		end

		v113 = React.createElement(ComboButton, {
			size = UDim2.new(1, 0, 0, v98),
			button = {
				icon = v102,
				text = v103,
				isDisabled = v96,
				onActivated = v96 and function() -- line: 605
				end or v87
			},
			overflow = {
				icon = if not FFlagLuaAppUnifiedPlayButtonSquadMenuDirection or v78 ~= MenuDirection.Down then v60 else v61,
				isDisabled = v95,
				onActivated = v95 and function() -- line: 613
				end or v88
			},
			testId = t1.testId
		})
	elseif t1.useUIBloxButton then
		if not FFlagLuaAppUseTokenHeightForPlayButton then
			local v114 = v63[v97] or "Size_1000"

			v98 = (not v93 or not v93.Size[v114]) and 40 or v93.Size[v114]
		end

		local v115 = v100 == "Fit"
		local v116 = if not v115 then UDim2.new(1, 0, 0, v98) else UDim2.new(0, 0, 0, v98)
		local v117 = playButtonState == PlayButtonStates.Loading
		local v118 = if Emphasis ~= ButtonVariant.SubEmphasis then if Emphasis ~= ButtonVariant.Subtle then ButtonType.PrimaryContextual else ButtonType.Secondary else ButtonType.PrimarySystem
		local v119 = if v102 ~= v58 then v102 else v59

		if type(v119) == "string" then
			v119 = Images[v119]
		end

		v113 = React.createElement(Button, {
			size = v116,
			fitContent = v115,
			buttonType = v118,
			icon = v119,
			text = v103,
			isLoading = v117,
			isDisabled = v96 or v117,
			userInteractionEnabled = not (v96 or v117),
			onActivated = if v96 or v117 then v62 else v87,
			ref = v85,
			[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`,
			DO_NOT_USE_useUIBloxButton = GetFFlagUIBloxUseFoundationButton() and true or (not not FFlagLuaAppPlayButtonOptOutFoundationButton or nil)
		})

		if (FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or v76 or v80) and v117 then
			v104 = React.createElement("TextButton", {
				Size = v116,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				ref = v86,
				[React.Event.Activated] = v87
			})
		end
	else
		local v120 = if not FFlagLuaAppIconPlayButton then nil else (v103 == nil or v103 == "") and v102 ~= nil

		v113 = if not FFlagLuaAppIconPlayButton or (FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and not v91 or not v120) then React.createElement(Button2, {
			icon = v102,
			text = v103,
			variant = Emphasis,
			size = v97,
			width = if not FFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then nil else v105,
			fillBehavior = v100,
			isDisabled = v96,
			onActivated = if v96 then v62 else v87,
			ref = v85,
			testId = t1.testId
		}) else React.createElement(IconButton, {
			icon = v102,
			variant = Emphasis,
			size = v97,
			width = if not FFlagLuaAppPlayButtonLoadingSkeleton or playButtonState ~= PlayButtonStates.Loading then nil else v105,
			fillBehavior = v100,
			isDisabled = v96,
			onActivated = if v96 then v62 else v87,
			ref = v85,
			testId = t1.testId
		})
	end

	return React.createElement("Frame", {
		LayoutOrder = t1.LayoutOrder,
		Position = t1.Position,
		Size = if not FFlagLuaAppUseTokenHeightForPlayButton then if not t1.width then if v100 ~= "Fill" then nil else UDim2.new(1, 0, 1, 0) else UDim2.new(t1.width, UDim.new(0, 0)) else UDim2.new(if not t1.width then if v100 ~= "Fill" then UDim.new(0, 0) else UDim.new(1, 0) else t1.width, UDim.new(0, v98)),
		AutomaticSize = if not FFlagLuaAppUseTokenHeightForPlayButton then if v100 ~= "Fill" then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y else if v100 ~= "Fill" then Enum.AutomaticSize.X else nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Tag] = if not FFlagSduiExperienceDetailsSupport then nil else t1.tag
	}, {
		LoadingSkeleton = if playButtonState ~= PlayButtonStates.Loading then nil else v104,
		PlayButton = v113
	})
end

return React.memo(PlayButton)
