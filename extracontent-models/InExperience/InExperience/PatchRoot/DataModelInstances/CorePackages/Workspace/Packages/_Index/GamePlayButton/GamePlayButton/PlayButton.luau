local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local IXPService = game:GetService("IXPService")
local tutils = require(Parent.tutils)
local React = require(Parent.React)
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
local PlayButtonStates = require(script.Parent.PlayButtonStates)
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagLuaAppSupportUnifiedUIBloxPlayButton = require(Parent.SharedFlags).FFlagLuaAppSupportUnifiedUIBloxPlayButton
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require(Parent.SharedFlags).FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local v33 = game:DefineFastFlag("LuaAppJoinTextPlayableButton", false) or FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local v34 = game:DefineFastFlag("LuaAppIconPlayButton", false) or FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local v35 = FFlagLuaAppSupportUnifiedUIBloxPlayButton and (game:DefineFastFlag("LuaAppPlayButtonLoadingSkeleton3", false) or FFlagLuaAppUnifyPlayButtonAllSurfacesIxp)
local v36 = game:DefineFastFlag("LuaAppFixPlayButtonDefaultLaunchSource", false)
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
local v47 = game:DefineFastFlag("LuaAppUseTokenHeightForPlayButton", false)
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce
local FFlagLuaAppLaunchWhenLoadingEdp = require(Parent.SharedFlags).FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppLaunchWhenLoadingForce = require(Parent.SharedFlags).FFlagLuaAppLaunchWhenLoadingForce
local usePlayOnReleaseAfterUnmount = require(script.Parent.usePlayOnReleaseAfterUnmount)
local v53 = if not v34 then nil else "play-xlarge"
local v54 = Images["icons/common/play"]
local v55 = Images["icons/actions/truncationCollapse"]
local v56 = Images["icons/actions/truncationExpand"]

local function v57() -- line: 85
end

local t1 = {
	[InputSize.XSmall] = "Size_600",
	[InputSize.Small] = "Size_800",
	[InputSize.Medium] = "Size_1000",
	[InputSize.Large] = "Size_1200"
}

local function PlayButton(t2: {[any]: any}) -- line: 180
	-- upvalues: React (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), GamesProductInfoReducer (copy), tutils (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), usePlayButtonState (copy), FFlagLuaAppLaunchWhenLoadingForce (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), useOnPlayButtonCallback (copy), v36 (copy), FFlagLuaAppUnifiedPlayButtonSquadMenuDirection (copy), MenuDirection (copy), useOnPlaySquadButtonCallback (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy), PlayButtonStates (copy), usePlayOnReleaseAfterUnmount (copy), FFlagSduiExperienceDetailsSupport (copy), useLocalization (copy), FFlagLuaAppUpdatePlayButtonText (copy), FFlagUpdateActionNeededPlayButtonUi (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), useUserExperiment (copy), AppUserLayers (copy), FFlagLuaAppLogExposurePlayButtonUX (copy), IXPService (copy), FFlagLuaAppSupportUnifiedUIBloxPlayButton (copy), useTokens (copy), InputSize (copy), v47 (copy), t1 (copy), v35 (copy), Skeleton (copy), EnumsRadius (copy), ButtonVariant (copy), FFlagLuaAppIconTextPlayButton (copy), FFlagLuaAppTextOnlyPlayButton (copy), v33 (copy), v53 (copy), v34 (copy), GetFFlagIsSquadEnabled (copy), v54 (copy), ComboButton (copy), v56 (copy), v55 (copy), ButtonType (copy), Images (copy), Button (copy), v57 (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy), IconButton (copy), Button2 (copy)
	local v61 = React.useRef(false)

	React.useEffect(function() -- line: 182
		-- upvalues: v61 (copy)
		v61.current = true

		return function() -- line: 184
			-- upvalues: v61 (copy)
			v61.current = false
		end
	end, {})

	local v62 = useRoactService(RoactNetworking)
	local v63 = useSelector(function(p1) -- line: 190
		-- upvalues: t2 (copy), GamesProductInfoReducer (copy)
		if t2.universeId then
			return p1[GamesProductInfoReducer.key][t2.universeId]
		end

		return nil
	end, tutils.shallowEqual)
	local v64 = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else t2.eventContext or "PlayButton"
	local playButtonState = usePlayButtonState(v62, t2.universeId, t2.fetchDelayInSeconds, t2.isPlayableWhenLoading, not not FFlagLuaAppPlayButtonLoadingDurationTelemetry or nil, (if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else v64)).playButtonState
	local v66 = FFlagLuaAppLaunchWhenLoadingForce or FFlagLuaAppLaunchWhenLoadingEdp and t2.launchWhenLoading == true
	local v67 = useOnPlayButtonCallback(t2.universeId, t2.referralSource, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then t2.eventContext or "PlayButton" else v64, nil, t2.launchSource or (not v36 and "LuaGameCard" or "UnknownLaunchSource"), t2.experienceJoinData, t2.placeId, if not FFlagLuaAppLaunchWhenLoadingEdp and not FFlagLuaAppLaunchWhenLoadingForce then nil else t2.launchWhenLoading)
	local v68 = if not FFlagLuaAppUnifiedPlayButtonSquadMenuDirection or t2.squadButtonMenuDirection == nil then MenuDirection.Up else t2.squadButtonMenuDirection
	local v69 = useOnPlaySquadButtonCallback(v68, playButtonState, t2.referralSource, t2.universeId)
	local v70 = FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce or FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp and t2.launchOnReleaseAfterUnmount == true
	local v71 = React.useCallback(function() -- line: 237
		-- upvalues: v70 (copy), v61 (copy), t2 (copy), playButtonState (copy), PlayButtonStates (copy), v67 (copy)
		if not v70 and not v61.current then
			return
		end

		if t2.onActivated then
			t2.onActivated()
		end

		if t2.onPurchaseRequiredCallback and (playButtonState == PlayButtonStates.PaidAccess or playButtonState == PlayButtonStates.FiatPaidAccess) then
			t2.onPurchaseRequiredCallback()

			return
		end

		v67(playButtonState, t2.reportExperienceLaunched)
	end, {
		v67,
		playButtonState,
		t2.onPurchaseRequiredCallback,
		t2.reportExperienceLaunched,
		t2.onActivated,
		if not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce and not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp then nil else v70
	})
	local v72 = if not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp and not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountForce then nil else usePlayOnReleaseAfterUnmount(v71)
	local v73 = if not v70 or not v72 then nil else v72.playButtonRef
	local v74 = if not v70 or not v72 then nil else v72.loadingCaptureRef
	local v75 = if not v70 then v71 else v72.onActivated
	local v76 = React.useCallback(function(p2) -- line: 286
		-- upvalues: v61 (copy), t2 (copy), v69 (copy)
		if not v61.current then
			return
		end

		if t2.onActivated then
			t2.onActivated()
		end

		v69(p2)
	end, {
		v69,
		t2.onActivated
	})

	if FFlagSduiExperienceDetailsSupport then
		React.useEffect(function() -- line: 297
			-- upvalues: t2 (copy), v75 (copy)
			local onRegisterActivation = t2.onRegisterActivation

			if onRegisterActivation == nil then
				return
			end

			return onRegisterActivation(v75)
		end, {
			t2.onRegisterActivation,
			v75
		})
	end

	local v77 = useLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty",
		play = if not FFlagLuaAppUpdatePlayButtonText then nil else "Feature.ExperienceDetails.PlayButtonText.Play",
		unlock = if not FFlagUpdateActionNeededPlayButtonUi then nil else "Feature.ExperienceDetails.PlayButtonText.Unlock"
	})
	local v78 = nil
	local v79 = nil
	local v80 = nil

	if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v78, v79, v80 = useUserExperiment({ AppUserLayers.PlayButtonUXExposureLayer }, function(p3) -- line: 319
			-- upvalues: AppUserLayers (copy)
			local v113 = p3[AppUserLayers.PlayButtonUXExposureLayer] or {}

			return v113.HasJoinTextButton, v113.HasIconPlayButton, v113.HasPlayButtonLoadingSkeleton
		end, true)
	end

	if FFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function() -- line: 328
			-- upvalues: IXPService (copy), AppUserLayers (copy)
			IXPService:LogUserLayerExposure(AppUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local v81 = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then nil else useTokens()
	local v82 = false
	local v83 = false
	local v84 = false
	local v85 = t2.buttonSize or InputSize.Medium
	local v86 = nil

	if v47 then
		local v87 = t1[v85] or "Size_1000"

		v86 = (not v81 or not v81.Size[v87]) and 40 or v81.Size[v87]
	end

	local v88 = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton or not t2.width then t2.fillBehavior else "Fill"
	local Emphasis = nil
	local v90 = nil
	local v91 = nil
	local v92 = nil
	local v93 = nil

	if playButtonState == PlayButtonStates.Loading then
		if t2.hideIfLoading then
			return nil
		end

		if v35 and ((not FFlagLuaAppSupportUnifiedUIBloxPlayButton or not t2.useUIBloxButton) and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or v80)) then
			local v94

			if v47 then
				v94 = v86
			else
				local v95 = t1[v85] or "Size_1000"

				v94 = v81 and v81.Size[v95]
			end

			v93 = if v88 ~= "Fill" then UDim.new(0, v94) else UDim.new(1, 0)

			local uDim2 = UDim2.new(v93, UDim.new(0, v94))
			local v97 = FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or (v66 or v70)
			local v98 = React.createElement(Skeleton, {
				ZIndex = 2,
				Size = if not v97 then uDim2 else UDim2.fromScale(1, 1),
				radius = EnumsRadius.Medium
			})

			v92 = if not v97 then v98 else React.createElement("TextButton", {
				Size = uDim2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				ref = v74,
				[React.Event.Activated] = v75
			}, {
				Skeleton = v98
			})
			v84 = true
		end

		Emphasis = ButtonVariant.Emphasis
	elseif playButtonState == PlayButtonStates.Playable then
		Emphasis = ButtonVariant.Emphasis

		if FFlagLuaAppIconTextPlayButton or (FFlagLuaAppTextOnlyPlayButton or v33 and (not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or v78)) then
			v91 = t2.playableText or if not FFlagLuaAppUpdatePlayButtonText then v77.join else v77.play

			if FFlagLuaAppIconTextPlayButton and not t2.hidePlayableIcon then
				v90 = v53
			end
		else
			if not v34 and not t2.hidePlayableIcon then
				v90 = "icons/common/play"
			end

			v91 = t2.playableText

			if v34 and not t2.hidePlayableIcon then
				v90 = if not v91 or v91 == "" then v53 else "icons/common/play"
			end
		end
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.PlayableWithParty then
		v90 = v54
		v91 = if not t2.hideOptionalText then v77.joinWithParty else nil
		v82 = true
	elseif GetFFlagIsSquadEnabled() and playButtonState == PlayButtonStates.WaitingForParty then
		v90 = v54
		v91 = if not t2.hideOptionalText then v77.waitingForParty else nil
		v84 = true
		v83 = true
		v82 = true
	elseif playButtonState == PlayButtonStates.PaidAccess then
		v91 = tostring(v63 and v63.price or 0)
		Emphasis = ButtonVariant.Emphasis
		v90 = "icons/common/robux"
	elseif playButtonState == PlayButtonStates.FiatPaidAccess then
		Emphasis = ButtonVariant.Emphasis

		local v99 = v63 and v63.localizedFiatPrice or ""

		v91 = t2.fiatText or v99
	elseif playButtonState == PlayButtonStates.ActionNeeded then
		if FFlagUpdateActionNeededPlayButtonUi then
			Emphasis = ButtonVariant.Emphasis
			v91 = v77.unlock
		else
			Emphasis = ButtonVariant.SubEmphasis
			v90 = "icons/status/private"
			v91 = if not t2.hideOptionalText then v77.join else nil
		end
	elseif playButtonState == PlayButtonStates.UnplayableOther then
		if t2.hideIfUnplayable then
			return nil
		end

		Emphasis = ButtonVariant.Subtle
		v90 = "icons/status/unavailable"
		v91 = if not t2.hideOptionalText then v77.unavailable else nil
		v84 = true
	else
		error("invalid play button state!")
	end

	local v101

	if v82 then
		if not v47 and FFlagLuaAppSupportUnifiedUIBloxPlayButton then
			local v100 = t1[v85] or "Size_1000"

			v86 = (not v81 or not v81.Size[v100]) and 40 or v81.Size[v100]
		end

		v101 = React.createElement(ComboButton, {
			layoutOrder = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.LayoutOrder else nil,
			position = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.Position else nil,
			size = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then UDim2.new(t2.width or UDim.new(1, 0), t2.squadButtonHeight or UDim.new(1, 0)) else UDim2.new(1, 0, 0, v86),
			button = {
				icon = v90,
				text = v91,
				isDisabled = v84,
				onActivated = v84 and function() -- line: 493
				end or v75
			},
			overflow = {
				icon = if not FFlagLuaAppUnifiedPlayButtonSquadMenuDirection or v68 ~= MenuDirection.Down then v55 else v56,
				isDisabled = v83,
				onActivated = v83 and function() -- line: 501
				end or v76
			},
			testId = t2.testId
		})
	elseif FFlagLuaAppSupportUnifiedUIBloxPlayButton and t2.useUIBloxButton then
		if not v47 then
			local v102 = t1[v85] or "Size_1000"

			v86 = (not v81 or not v81.Size[v102]) and 40 or v81.Size[v102]
		end

		local v103 = v88 == "Fit"
		local v104 = if not v103 then UDim2.new(1, 0, 0, v86) else UDim2.new(0, 0, 0, v86)
		local v105 = playButtonState == PlayButtonStates.Loading
		local v106 = if Emphasis ~= ButtonVariant.SubEmphasis then if Emphasis ~= ButtonVariant.Subtle then ButtonType.PrimaryContextual else ButtonType.Secondary else ButtonType.PrimarySystem
		local v107 = if v90 ~= v53 then v90 else v54

		if type(v107) == "string" then
			v107 = Images[v107]
		end

		v101 = React.createElement(Button, {
			size = v104,
			fitContent = v103,
			buttonType = v106,
			icon = v107,
			text = v91,
			isLoading = v105,
			isDisabled = v84 or v105,
			userInteractionEnabled = not (v84 or v105),
			onActivated = if v84 or v105 then v57 else v75,
			ref = v73,
			[React.Tag] = if not t2.testId then nil else `data-testid={ t2.testId }`,
			DO_NOT_USE_useUIBloxButton = GetFFlagUIBloxUseFoundationButton() and true or (not not FFlagLuaAppPlayButtonOptOutFoundationButton or nil)
		})

		if (FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or v66 or v70) and v105 then
			v92 = React.createElement("TextButton", {
				Size = v104,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				ref = v74,
				[React.Event.Activated] = v75
			})
		end
	else
		local v108 = if not v34 then nil else (v91 == nil or v91 == "") and v90 ~= nil

		v101 = if not v34 or (FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and not v79 or not v108) then React.createElement(Button2, {
			LayoutOrder = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.LayoutOrder else nil,
			Position = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.Position else nil,
			icon = v90,
			text = v91,
			variant = Emphasis,
			size = v85,
			width = if not v35 or playButtonState ~= PlayButtonStates.Loading then if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.width else nil else v93,
			fillBehavior = v88,
			isDisabled = v84,
			onActivated = if v84 then v57 else v75,
			ref = v73,
			testId = t2.testId
		}) else React.createElement(IconButton, {
			LayoutOrder = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.LayoutOrder else nil,
			Position = if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.Position else nil,
			icon = v90,
			variant = Emphasis,
			size = v85,
			width = if not v35 or playButtonState ~= PlayButtonStates.Loading then if not FFlagLuaAppSupportUnifiedUIBloxPlayButton then t2.width else nil else v93,
			fillBehavior = v88,
			isDisabled = v84,
			onActivated = if v84 then v57 else v75,
			ref = v73,
			testId = t2.testId
		})
	end

	if FFlagLuaAppSupportUnifiedUIBloxPlayButton then
		return React.createElement("Frame", {
			LayoutOrder = t2.LayoutOrder,
			Position = t2.Position,
			Size = if not v47 then if not t2.width then if v88 ~= "Fill" then nil else UDim2.new(1, 0, 1, 0) else UDim2.new(t2.width, UDim.new(0, 0)) else UDim2.new(if not t2.width then if v88 ~= "Fill" then UDim.new(0, 0) else UDim.new(1, 0) else t2.width, UDim.new(0, v86)),
			AutomaticSize = if not v47 then if v88 ~= "Fill" then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y else if v88 ~= "Fill" then Enum.AutomaticSize.X else nil,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[React.Tag] = if not FFlagSduiExperienceDetailsSupport then nil else t2.tag
		}, {
			LoadingSkeleton = if playButtonState ~= PlayButtonStates.Loading then nil else v92,
			PlayButton = v101
		})
	end

	return v101
end

return React.memo(PlayButton)
