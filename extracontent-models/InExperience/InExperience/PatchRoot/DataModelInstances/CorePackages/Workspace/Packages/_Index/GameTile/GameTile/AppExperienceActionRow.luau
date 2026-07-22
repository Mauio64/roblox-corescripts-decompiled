local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local IXPService = game:GetService("IXPService")
local Cryo = require(GameTileParent.Cryo)
local RoactServices = require(GameTileParent.RoactServices).RoactServices
local RoactServiceTags = require(GameTileParent.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local RoactNetworking = RoactServiceTags.RoactNetworking
local Roact = require(GameTileParent.Roact)
local React = require(GameTileParent.React)
local RoactRodux = require(GameTileParent.RoactRodux)
local t = require(GameTileParent.t)
local ButtonSize = require(GameTileParent.Foundation).Enums.ButtonSize
local UIBlox = require(GameTileParent.UIBlox)
local ExperienceActionRow = UIBlox.App.Tile.ExperienceActionRow
local Images = UIBlox.App.ImageSet.Images
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local MenuDirection = UIBlox.App.Menu.MenuDirection
local RobloxAppSessionization = require(GameTileParent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local withLocalization = require(GameTileParent.Localization).withLocalization
local GamePlayButton = require(GameTileParent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local PlayButtonStates = GamePlayButton.PlayButtonStates
local usePlayButtonState = GamePlayButton.usePlayButtonState
local useOnPlaySquadButtonCallback = GamePlayButton.useOnPlaySquadButtonCallback
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local useRoactService = require(GameTileParent.RobloxAppHooks).useRoactService
local GamesProductInfoReducer = require(GameTileParent.GameProductInfoRodux).GamesProductInfoReducer
local CentralOverlayType = require(GameTileParent.RobloxAppEnums).CentralOverlayType
local CloseCentralOverlay = require(GameTileParent.CentralOverlay).Thunks.CloseCentralOverlay
local AppUserLayers = require(GameTileParent.ExperimentLayers).AppUserLayers
local useUserExperiment = require(GameTileParent.RoactAppExperiment).useUserExperiment
local useAppPolicy = require(GameTileParent.UniversalAppPolicy).useAppPolicy
local GetFFlagIsSquadEnabled = require(GameTileParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagLuaAppEnablePlaySquadButton = require(GameTileParent.SharedFlags).FFlagLuaAppEnablePlaySquadButton
local FFlagLuaAppEnablePlayableStateWhenLoading = require(GameTileParent.SharedFlags).FFlagLuaAppEnablePlayableStateWhenLoading
local FFlagLuaAppSupportDisablePlayableWhenLoading = require(GameTileParent.SharedFlags).FFlagLuaAppSupportDisablePlayableWhenLoading
local FFlagLuaAppDisablePlayableWhenLoadingForce = require(GameTileParent.SharedFlags).FFlagLuaAppDisablePlayableWhenLoadingForce
local FFlagLuaAppPlayButtonLoadingPrimary = require(GameTileParent.SharedFlags).FFlagLuaAppPlayButtonLoadingPrimary
local FFlagLuaAppUnifyPlayButtonTile = require(GameTileParent.SharedFlags).FFlagLuaAppUnifyPlayButtonTile
local FFlagLuaAppUnifyPlayButtonTileIxp = require(GameTileParent.SharedFlags).FFlagLuaAppUnifyPlayButtonTileIxp
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require(GameTileParent.SharedFlags).FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local FFlagUpdateActionNeededPlayButtonUi = require(GameTileParent.SharedFlags).FFlagUpdateActionNeededPlayButtonUi
local GetFFlagUIBloxUseFoundationButton = require(GameTileParent.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagLuaAppPlayButtonOptOutFoundationButton = require(GameTileParent.SharedFlags).FFlagLuaAppPlayButtonOptOutFoundationButton
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(GameTileParent.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local FFlagLuaAppTextOnlyPlayButton = require(GameTileParent.SharedFlags).FFlagLuaAppTextOnlyPlayButton
local FFlagLuaAppIconTextPlayButton = require(GameTileParent.SharedFlags).FFlagLuaAppIconTextPlayButton
local FFlagLuaAppUpdatePlayButtonText = require(GameTileParent.SharedFlags).FFlagLuaAppUpdatePlayButtonText
local FFlagLuaAppLogExposurePlayButtonUX = require(GameTileParent.SharedFlags).FFlagLuaAppLogExposurePlayButtonUX
local FFlagLuaAppDemoModePlayButton = require(GameTileParent.SharedFlags).FFlagLuaAppDemoModePlayButton
local FFlagLuaAppDemoModePlayButtonTelemetry = require(GameTileParent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry
local v55 = game:DefineFastFlag("LuaAppFixAppExperienceActionRowLoadingState", false)
local GameTileExperimentation = require(GameTile.GameTileExperimentation)
local v57 = if not FFlagLuaAppUnifyPlayButtonTile then nil else 40
local v58 = Roact.PureComponent:extend("AppExperienceActionRow")

v58.validateProps = t.strictInterface({
	universeId = t.string,
	launchExperienceEventContext = t.optional(t.string),
	referralSource = t.optional(t.string),
	launchSource = t.string,
	reportExperienceLaunched = t.optional(t.callback),
	entry = t.table,
	openGameDetails = t.callback,
	horizontalPadding = t.optional(t.number),
	verticalPadding = t.optional(t.number),
	height = t.optional(t.number),
	fetchDelayInSeconds = t.optional(t.number),
	index = t.optional(t.number),
	showButtonText = t.optional(t.boolean),
	width = if not FFlagLuaAppUnifyPlayButtonTile then nil else t.optional(t.UDim),
	placeIdOverride = t.optional(t.string),
	launchDataOverride = t.optional(t.string),
	price = t.optional(t.number),
	centralOverlayType = t.optional(t.string),
	closeCentralOverlay = t.optional(t.callback),
	playButtonState = t.string,
	playabilityStatus = t.optional(t.table),
	onPlayButtonActivated = t.callback,
	onPlaySquadButtonActivated = t.optional(t.callback),
	sessionService = t.optional(t.union(t.Instance, t.table)),
	isUnifiedGameTileEnabled = t.optional(t.boolean),
	hasUnifiedPlayButtonIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else t.optional(t.boolean),
	unifyToUIBloxIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else t.optional(t.boolean)
})

local function modifyPlayButtonState(p1) -- line: 118
	-- upvalues: PlayButtonStates (copy)
	if p1 == PlayButtonStates.Loading then
		return PlayButtonStates.Playable
	end

	return p1
end

function v58.init(p2) -- line: 127
	-- upvalues: SetGamePlaySession (copy), SessionType (copy), FFlagLuaAppUnifyPlayButtonTile (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
	function p2.onPlayPressed() -- line: 128
		-- upvalues: p2 (copy), SetGamePlaySession (copy), SessionType (copy)
		if p2:requiresPurchase() or p2:requiresFiatPurchase() then
			p2.props.openGameDetails()

			return
		end

		if p2:isButtonEnabled() then
			SetGamePlaySession(p2.props.sessionService, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)

			local v97 = if not p2.props.reportExperienceLaunched then nil else p2.reportExperienceLaunched

			p2.props.onPlayButtonActivated(p2.props.playButtonState, v97)
		end
	end
	function p2.reportExperienceLaunched(s1: string?) -- line: 142
		-- upvalues: FFlagLuaAppUnifyPlayButtonTile (copy), SetGamePlaySession (copy), p2 (copy), SessionType (copy), FFlagLuaAppDemoModePlayButtonTelemetry (copy)
		if FFlagLuaAppUnifyPlayButtonTile then
			SetGamePlaySession(p2.props.sessionService, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		p2.props.reportExperienceLaunched(p2.props.entry, p2.props.referralSource, p2.props.launchSource, p2.props.launchExperienceEventContext, p2.props.index, if not FFlagLuaAppDemoModePlayButtonTelemetry then nil else s1)
	end
end
function v58.willUnmount(p3) -- line: 158
	-- upvalues: FFlagLuaAppEnablePlaySquadButton (copy), CentralOverlayType (copy)
	if FFlagLuaAppEnablePlaySquadButton and p3.props.centralOverlayType == CentralOverlayType.GameDetailsSquad then
		p3.props.closeCentralOverlay()
	end
end
function v58.render(p4) -- line: 165
	-- upvalues: FFlagLuaAppUnifyPlayButtonTile (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), FFlagLuaAppUnifyPlayButtonTileIxp (copy), GameTileExperimentation (copy), withLocalization (copy), Roact (copy), PlayButton (copy), ButtonSize (copy), FFlagLuaAppDemoModePlayButton (copy), v57 (copy), FFlagUpdateActionNeededPlayButtonUi (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppIconTextPlayButton (copy), FFlagLuaAppUpdatePlayButtonText (copy), ExperienceActionRow (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), PlayButtonStates (copy), FFlagLuaAppEnablePlaySquadButton (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy)
	if FFlagLuaAppUnifyPlayButtonTile then
		local isUnifiedGameTileEnabled = p4.props.isUnifiedGameTileEnabled
		local v67 = FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and p4.props.hasUnifiedPlayButtonIxp or FFlagLuaAppUnifyPlayButtonTileIxp and GameTileExperimentation.getIsPlayButtonMigrationEnabled()

		if isUnifiedGameTileEnabled and (not FFlagLuaAppUnifyPlayButtonTileIxp and not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp or v67) then
			local v68 = p4.props.horizontalPadding or 0
			local v69 = p4.props.verticalPadding or 0

			return withLocalization({
				buyText = "Feature.ExperienceDetails.PlayButtonText.Buy"
			})(function(p5) -- line: 185
				-- upvalues: Roact (copy), PlayButton (copy), p4 (copy), ButtonSize (copy), FFlagLuaAppDemoModePlayButton (copy), v68 (copy), v69 (copy), v57 (copy)
				return Roact.createElement(PlayButton, {
					isPlayableWhenLoading = true,
					universeId = p4.props.universeId,
					placeId = p4.props.placeIdOverride,
					referralSource = p4.props.referralSource,
					eventContext = p4.props.launchExperienceEventContext,
					launchSource = p4.props.launchSource,
					experienceJoinData = if not p4.props.launchDataOverride then nil else {
						launchData = p4.props.launchDataOverride
					},
					reportExperienceLaunched = p4.reportExperienceLaunched,
					fiatText = p5.buyText,
					hideOptionalText = not p4.props.showButtonText,
					buttonSize = ButtonSize.Medium,
					useUIBloxButton = p4.props.unifyToUIBloxIxp,
					onPurchaseRequiredCallback = p4.props.openGameDetails,
					preferSecondaryPlayButton = not not FFlagLuaAppDemoModePlayButton or nil,
					fillBehavior = if p4.props.width then nil else "Fill",
					width = p4.props.width,
					Position = UDim2.new(0, v68, 1, -v69 - v57)
				})
			end)
		end
	end

	return withLocalization({
		actionNeededText = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		unavailableText = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		buyText = "Feature.ExperienceDetails.PlayButtonText.Buy",
		unlockText = if not FFlagUpdateActionNeededPlayButtonUi then nil else "Feature.ExperienceDetails.PlayButtonText.Unlock",
		playDemoText = if not FFlagLuaAppDemoModePlayButton then nil else "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playText = if not FFlagLuaAppTextOnlyPlayButton and not FFlagLuaAppIconTextPlayButton then nil else not FFlagLuaAppUpdatePlayButtonText and "Feature.ExperienceDetails.PlayButtonText.ActionNeeded" or "Feature.ExperienceDetails.PlayButtonText.Play"
	})(function(p6) -- line: 227
		-- upvalues: Roact (copy), ExperienceActionRow (copy), p4 (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), PlayButtonStates (copy), FFlagLuaAppEnablePlaySquadButton (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy)
		return Roact.createElement(ExperienceActionRow, {
			isActionable = p4:isButtonEnabled(),
			buttonLoading = if not FFlagLuaAppSupportDisablePlayableWhenLoading then nil else p4.props.playButtonState == PlayButtonStates.Loading,
			text = p4:getButtonText(p6),
			icon = p4:getButtonIcon(),
			buttonType = p4:getButtonType(),
			onPlayPressed = p4.onPlayPressed,
			onOverflowPressed = if not FFlagLuaAppEnablePlaySquadButton or not p4:isOverflowButtonVisible() then nil else p4.props.onPlaySquadButtonActivated,
			horizontalPadding = p4.props.horizontalPadding,
			verticalPadding = p4.props.verticalPadding,
			height = p4.props.height,
			DO_NOT_USE_useUIBloxButton = GetFFlagUIBloxUseFoundationButton() and true or (not not FFlagLuaAppPlayButtonOptOutFoundationButton or nil)
		})
	end)
end
function v58.isOverflowButtonVisible(p7) -- line: 251
	-- upvalues: FFlagLuaAppEnablePlaySquadButton (copy), PlayButtonStates (copy)
	return FFlagLuaAppEnablePlaySquadButton and (p7.props.playButtonState == PlayButtonStates.PlayableWithParty or p7.props.playButtonState == PlayButtonStates.WaitingForParty)
end
function v58.isButtonEnabled(p8) -- line: 261
	-- upvalues: FFlagLuaAppEnablePlayableStateWhenLoading (copy), GetFFlagIsSquadEnabled (copy), PlayButtonStates (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), FFlagLuaAppDemoModePlayButton (copy)
	if FFlagLuaAppEnablePlayableStateWhenLoading and (p8.props.playabilityStatus == nil and GetFFlagIsSquadEnabled() and p8.props.playButtonState == PlayButtonStates.WaitingForParty) then
		return false
	end

	return p8.props.playabilityStatus == nil or (p8.props.playButtonState == PlayButtonStates.Playable or (not FFlagLuaAppSupportDisablePlayableWhenLoading and p8.props.playButtonState == PlayButtonStates.Loading or (GetFFlagIsSquadEnabled() and p8.props.playButtonState == PlayButtonStates.PlayableWithParty or (p8:isActionNeeded() or (p8:requiresPurchase() or (p8:requiresFiatPurchase() or FFlagLuaAppDemoModePlayButton and p8.props.playButtonState == PlayButtonStates.DemoMode))))))
end
function v58.requiresFiatPurchase(p9) -- line: 287
	-- upvalues: PlayButtonStates (copy)
	return p9.props.playButtonState == PlayButtonStates.FiatPaidAccess
end
function v58.requiresPurchase(p10) -- line: 291
	-- upvalues: PlayButtonStates (copy)
	return p10.props.playButtonState == PlayButtonStates.PaidAccess
end
function v58.isActionNeeded(p11) -- line: 295
	-- upvalues: PlayButtonStates (copy)
	return p11.props.playButtonState == PlayButtonStates.ActionNeeded
end
function v58.getButtonText(p12, p13) -- line: 299
	-- upvalues: FFlagUpdateActionNeededPlayButtonUi (copy), FFlagLuaAppEnablePlaySquadButton (copy), PlayButtonStates (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppIconTextPlayButton (copy)
	if p12.props.showButtonText then
		if not FFlagUpdateActionNeededPlayButtonUi and p12:isActionNeeded() then
			return p13.actionNeededText
		end

		if not p12:isButtonEnabled() then
			if FFlagLuaAppEnablePlaySquadButton and p12.props.playButtonState == PlayButtonStates.WaitingForParty then
				return nil
			end

			return p13.unavailableText
		end
	end

	if FFlagUpdateActionNeededPlayButtonUi and p12:isActionNeeded() then
		return p13.unlockText
	end

	if p12:requiresPurchase() then
		return (tostring(p12.props.price or "--"))
	end

	if p12:requiresFiatPurchase() then
		return p13.buyText
	end

	if FFlagLuaAppDemoModePlayButton and p12.props.playButtonState == PlayButtonStates.DemoMode then
		return p13.playDemoText
	end

	if (FFlagLuaAppTextOnlyPlayButton or FFlagLuaAppIconTextPlayButton) and p12.props.playButtonState == PlayButtonStates.Playable then
		return p13.playText
	end

	return nil
end
function v58.getButtonType(p14) -- line: 334
	-- upvalues: FFlagLuaAppSupportDisablePlayableWhenLoading (copy), v55 (copy), FFlagLuaAppPlayButtonLoadingPrimary (copy), PlayButtonStates (copy), ButtonType (copy), FFlagUpdateActionNeededPlayButtonUi (copy), FFlagLuaAppDemoModePlayButton (copy)
	if FFlagLuaAppSupportDisablePlayableWhenLoading and ((v55 or not FFlagLuaAppPlayButtonLoadingPrimary) and p14.props.playButtonState == PlayButtonStates.Loading) then
		if v55 then
			if FFlagLuaAppPlayButtonLoadingPrimary then
				return ButtonType.PrimaryContextual
			end

			return ButtonType.Secondary
		end

		return ButtonType.Secondary
	end

	if not FFlagUpdateActionNeededPlayButtonUi and p14:isActionNeeded() then
		return ButtonType.PrimarySystem
	end

	if FFlagLuaAppDemoModePlayButton and p14.props.playButtonState == PlayButtonStates.DemoMode then
		return ButtonType.PrimarySystem
	end

	if not p14:isButtonEnabled() then
		return ButtonType.Secondary
	end

	return ButtonType.PrimaryContextual
end
function v58.getButtonIcon(p15) -- line: 356
	-- upvalues: FFlagLuaAppSupportDisablePlayableWhenLoading (copy), PlayButtonStates (copy), FFlagUpdateActionNeededPlayButtonUi (copy), Images (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagLuaAppTextOnlyPlayButton (copy), FFlagLuaAppEnablePlaySquadButton (copy)
	if FFlagLuaAppSupportDisablePlayableWhenLoading and p15.props.playButtonState == PlayButtonStates.Loading then
		return nil
	end

	if not FFlagUpdateActionNeededPlayButtonUi and p15:isActionNeeded() then
		return Images["icons/status/private"]
	end

	if p15:requiresPurchase() then
		return Images["icons/common/robux"]
	end

	if p15:requiresFiatPurchase() or FFlagLuaAppDemoModePlayButton and p15.props.playButtonState == PlayButtonStates.DemoMode or FFlagUpdateActionNeededPlayButtonUi and p15:isActionNeeded() then
		return nil
	end

	if FFlagLuaAppTextOnlyPlayButton and p15.props.playButtonState == PlayButtonStates.Playable then
		return nil
	end

	if not p15:isButtonEnabled() then
		if FFlagLuaAppEnablePlaySquadButton and p15.props.playButtonState == PlayButtonStates.WaitingForParty then
			return Images["icons/common/play"]
		end

		return Images["icons/status/unavailable"]
	end

	return Images["icons/common/play"]
end

local v60 = v58
local v61 = RoactRodux.connect(function(p16, p17) -- line: 468
	-- upvalues: GamesProductInfoReducer (copy), FFlagLuaAppEnablePlaySquadButton (copy)
	local universeId = p17.universeId
	local v95 = if not p16[GamesProductInfoReducer.key] then nil else p16[GamesProductInfoReducer.key][universeId]

	return {
		price = if v95 == nil then nil else v95.price,
		centralOverlayType = if not FFlagLuaAppEnablePlaySquadButton then nil else p16.CentralOverlay.OverlayType
	}
end, function(p18) -- line: 477
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeCentralOverlay = function() -- line: 479
			-- upvalues: p18 (copy), CloseCentralOverlay (copy)
			return p18(CloseCentralOverlay())
		end
	}
end)(function(p19) -- line: 383
	-- upvalues: useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), FFlagLuaAppEnablePlayableStateWhenLoading (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy), useOnPlayButtonCallback (copy), FFlagLuaAppEnablePlaySquadButton (copy), useOnPlaySquadButtonCallback (copy), MenuDirection (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), useUserExperiment (copy), AppUserLayers (copy), FFlagLuaAppLogExposurePlayButtonUX (copy), React (copy), IXPService (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), useAppPolicy (copy), FFlagLuaAppDisablePlayableWhenLoadingForce (copy), PlayButtonStates (copy), FFlagLuaAppDemoModePlayButton (copy), Cryo (copy), Roact (copy), v60 (copy)
	local v80 = useRoactService(RoactNetworking)
	local v81 = usePlayButtonState(v80, p19.universeId, p19.fetchDelayInSeconds, not not FFlagLuaAppEnablePlayableStateWhenLoading or nil, not not FFlagLuaAppPlayButtonLoadingDurationTelemetry or nil, if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else p19.launchExperienceEventContext)
	local t1 = nil

	if p19.launchDataOverride then
		t1 = {
			launchData = p19.launchDataOverride
		}
	end

	local v83 = useOnPlayButtonCallback(p19.universeId, p19.referralSource, p19.launchExperienceEventContext or "PlayButton", nil, p19.launchSource or "UnknownLaunchSource", t1, p19.placeIdOverride)
	local v84 = if not FFlagLuaAppEnablePlaySquadButton then nil else useOnPlaySquadButtonCallback(MenuDirection.Up, v81.playButtonState, p19.referralSource, p19.universeId)
	local v85 = nil
	local v86 = nil

	if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v85, v86 = useUserExperiment({ AppUserLayers.PlayButtonUXExposureLayer }, function(p20) -- line: 423
			-- upvalues: AppUserLayers (copy)
			local v102 = p20[AppUserLayers.PlayButtonUXExposureLayer] or {}

			return v102.HasUnifiedPlayButton, v102.UnifyToUIBlox
		end, true)
	end

	if FFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function() -- line: 432
			-- upvalues: IXPService (copy), AppUserLayers (copy)
			IXPService:LogUserLayerExposure(AppUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	local v87 = nil

	if FFlagLuaAppSupportDisablePlayableWhenLoading then
		local v88 = useAppPolicy(function(p21) -- line: 439
			return p21.getDisablePlayableWhenLoading()
		end)

		v87 = FFlagLuaAppDisablePlayableWhenLoadingForce or v88
	end

	local playButtonState

	if FFlagLuaAppEnablePlayableStateWhenLoading or FFlagLuaAppSupportDisablePlayableWhenLoading and v87 then
		playButtonState = v81.playButtonState
	else
		local playButtonState2 = v81.playButtonState

		playButtonState = if playButtonState2 ~= PlayButtonStates.Loading then playButtonState2 else PlayButtonStates.Playable
	end

	if FFlagLuaAppDemoModePlayButton and v81.secondaryPlayButtonState ~= nil then
		playButtonState = v81.secondaryPlayButtonState
	end

	local v91 = Cryo.Dictionary.join(p19, {
		playabilityStatus = v81.playabilityStatus,
		onPlayButtonActivated = v83,
		onPlaySquadButtonActivated = v84,
		playButtonState = playButtonState,
		hasUnifiedPlayButtonIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else v85,
		unifyToUIBloxIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else v86
	})

	return Roact.createElement(v60, v91)
end)

return (RoactServices.connect({
	sessionService = AppSessionService
})(v61))
