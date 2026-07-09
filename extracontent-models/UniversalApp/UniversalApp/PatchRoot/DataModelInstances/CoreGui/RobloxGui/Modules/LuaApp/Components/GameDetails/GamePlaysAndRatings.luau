local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local abbreviateCount = require(CorePackages.Workspace.Packages.Localization).abbreviateCount
local PrimaryStatWidget = require(Modules.LuaApp.Components.PrimaryStatWidget)
local GameRatings = require(Modules.LuaApp.Components.GameDetails.GameRatings)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local GamePlayerFeedbackPrompt = require(CorePackages.Workspace.Packages.PlayerFeedback).GamePlayerFeedbackPrompt
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local GameVotesRodux = require(CorePackages.Workspace.Packages.GameVotesRodux)
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local GetGamePlayerFeedbackMetadata = require(CorePackages.Workspace.Packages.PlayerFeedback).Thunks.GetGamePlayerFeedbackMetadata
local VoteStatus = GameVotesRodux.Enums.VoteStatus
local GetFFlagEdpPlayerFeedbackEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEdpPlayerFeedbackEnabled
local GetFFlagEdpPlayerFeedbackLogIXPExposure = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEdpPlayerFeedbackLogIXPExposure
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local IXPService = game:GetService("IXPService")
local v30 = Roact.PureComponent:extend("GamePlaysAndRatings")

if GetFFlagEdpPlayerFeedbackEnabled() then
	function v30.init(p1) -- line: 46
		-- upvalues: Logging (copy), GetFFlagEdpPlayerFeedbackLogIXPExposure (copy), IXPService (copy), AppUserLayers (copy), VoteStatus (copy)
		p1.state = {
			isFeedbackPromptOpen = false
		}

		function p1.openInlineFeedbackPrompt() -- line: 50
			-- upvalues: p1 (copy)
			p1:setState({
				isFeedbackPromptOpen = true
			})
		end
		function p1.closeInlineFeedbackPrompt() -- line: 55
			-- upvalues: p1 (copy)
			p1:setState({
				isFeedbackPromptOpen = false
			})
		end
		function p1.onClickFeedbackPromptButton() -- line: 60
			-- upvalues: p1 (copy), Logging (copy)
			if not p1.state.playerFeedbackMetadata then
				Logging.warn("Player feedback metadata is not available from feedback prompt")

				return
			end

			p1.props.openFeedbackForm(p1.props.universeId, p1.state.playerFeedbackMetadata, p1.closeInlineFeedbackPrompt)
		end
		function p1.onVoteSuccess(s1: string) -- line: 71
			-- upvalues: GetFFlagEdpPlayerFeedbackLogIXPExposure (copy), IXPService (copy), AppUserLayers (copy), p1 (copy), VoteStatus (copy), Logging (copy)
			if GetFFlagEdpPlayerFeedbackLogIXPExposure() then
				IXPService:LogUserLayerExposure(AppUserLayers.EDPPlayerFeedbackExposureLayer)
			end

			if not p1.props.enablePlayerFeedback then
				return
			end

			local universeId = p1.props.universeId
			local networking = p1.props.networking
			local rootPlaceId = p1.props.rootPlaceId

			if s1 == VoteStatus.NotVoted then
				p1.closeInlineFeedbackPrompt()

				return
			end

			p1.props.getGamePlayerFeedbackMetadata(networking, universeId, rootPlaceId, s1):andThen(function(p2) -- line: 90
				-- upvalues: p1 (copy), universeId (copy)
				if p2 and p2.canSubmitReview then
					if p1.props.showInlineFeedbackPrompt then
						p1:setState({
							playerFeedbackMetadata = p2
						})
						p1.openInlineFeedbackPrompt()

						return
					end

					p1.props.openFeedbackForm(universeId, p2)
				end
			end, function() -- line: 101
				-- upvalues: Logging (copy)
				Logging.warn("Failed to get player feedback metadata")
			end)
		end
	end
end

function v30.getLayoutInfo(p3, p4, p5, p6, p7, p8) -- line: 109
	-- upvalues: PrimaryStatWidget (copy)
	local appTheme = p3.props.appTheme
	local containerWidth = p3.props.containerWidth
	local v42, v43

	if p8 then
		v42 = PrimaryStatWidget.GetMinimumWidthRethemed(p4, p5, p8)
		v43 = PrimaryStatWidget.GetMinimumWidthRethemed(p6, p7, p8)
	else
		v42 = PrimaryStatWidget.GetMinimumWidth(p4, p5, appTheme.GameDetails.Text.BoldFont)
		v43 = PrimaryStatWidget.GetMinimumWidth(p6, p7, appTheme.GameDetails.Text.BoldFont)
	end

	if math.max(v42, v43) * 2 > containerWidth / 2 then
		return {
			isOneRow = false,
			subSectionWidth = containerWidth,
			widgetWidth = containerWidth / 2
		}
	end

	return {
		isOneRow = true,
		subSectionWidth = containerWidth / 2,
		widgetWidth = containerWidth / 4
	}
end
function v30.render(p9) -- line: 149
	-- upvalues: withStyle (copy), abbreviateCount (copy), Roact (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), GameRatings (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), PrimaryStatWidget (copy), GamePlayerFeedbackPrompt (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	return withStyle(function(p10) -- line: 150
		-- upvalues: p9 (copy), abbreviateCount (copy), Roact (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), GameRatings (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), PrimaryStatWidget (copy), GamePlayerFeedbackPrompt (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
		local showGlobalCounters = p9.props.showGlobalCounters
		local showLikesFavoritesCount = p9.props.showLikesFavoritesCount
		local containerWidth = p9.props.containerWidth
		local rowPadding = p9.props.rowPadding
		local playing = p9.props.playing
		local visits = p9.props.visits
		local universeId = p9.props.universeId
		local propsLayoutOrder = p9.props.LayoutOrder
		local localization = p9.props.localization
		local hideVisits = p9.props.hideVisits
		local v71 = abbreviateCount(playing, localization:GetLocale())
		local v72 = string.upper(localization:Format("Feature.GameDetails.Label.Playing"))
		local v73 = abbreviateCount(visits, localization:GetLocale())
		local v74 = string.upper(localization:Format("Feature.GameDetails.Label.Visits"))
		local v75 = p9:getLayoutInfo(v71, v72, v73, v74, p10)
		local isOneRow = v75.isOneRow
		local subSectionWidth = v75.subSectionWidth
		local widgetWidth = v75.widgetWidth
		local v79 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, containerWidth, 0, 0),
			LayoutOrder = if not GetFFlagEdpPlayerFeedbackEnabled() then propsLayoutOrder else 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = isOneRow and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, if not isOneRow then rowPadding else 0)
			}),
			Ratings = Roact.createElement(GameRatings, {
				LayoutOrder = not isOneRow and 2 or 1,
				universeId = universeId,
				width = subSectionWidth,
				showGlobalCounters = showGlobalCounters,
				showLikesFavoritesCount = showLikesFavoritesCount,
				onVoteSuccess = if not GetFFlagEdpPlayerFeedbackEnabled() then nil else p9.onVoteSuccess,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p9.props.shouldHydrateLegacyIxp
			}),
			PlaysAndVisitsSection = not hideVisits and (showGlobalCounters and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, subSectionWidth, 0, 0),
				LayoutOrder = not isOneRow and 1 or 2,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				PlaySection = Roact.createElement(PrimaryStatWidget, {
					icon = "LuaApp/icons/GameDetails/playing_large",
					LayoutOrder = 1,
					number = v71,
					label = v72,
					width = widgetWidth
				}),
				VisitsSection = Roact.createElement(PrimaryStatWidget, {
					icon = "LuaApp/icons/GameDetails/sessions_large",
					LayoutOrder = 2,
					number = v73,
					label = v74,
					width = widgetWidth
				})
			}))
		})

		if GetFFlagEdpPlayerFeedbackEnabled() then
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, containerWidth, 0, 0),
				LayoutOrder = propsLayoutOrder,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, rowPadding)
				}),
				GamePlayerAndRatingsFrame = v79,
				PlayerFeedbackPrompt = if not p9.state.isFeedbackPromptOpen then nil else Roact.createElement(GamePlayerFeedbackPrompt, {
					LayoutOrder = 2,
					placeId = p9.props.rootPlaceId,
					width = containerWidth,
					backgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p10.Tokens.Semantic.Color.Ui.Emphasis else p10.Tokens.Color.Shift.Shift_400)).Color3,
					backgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p10.Tokens.Semantic.Color.Ui.Emphasis else p10.Tokens.Color.Shift.Shift_400)).Transparency,
					onDimiss = p9.closeInlineFeedbackPrompt,
					onButtonClick = p9.onClickFeedbackPromptButton
				})
			})
		end

		return v79
	end)
end

local v31 = withTheme_DEPRECATED(v30)
local v32 = RoactRodux.connect(function(p11, p12) -- line: 262
	-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameInfosReducer (copy), GetFFlagEdpPlayerFeedbackEnabled (copy)
	local v47 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p12.shouldHydrateLegacyIxp) then p11.GameDetails[p12.universeId] else p11.GameDetailsV2[p12.universeId]
	local v48 = p11.Personalization[GameInfosReducer.key][p12.universeId]
	local v49 = v47 and v47.playing or (v48 and v48.playerCount or 0)
	local v50 = v47 and v47.visits or 0
	local v51 = nil

	if GetFFlagEdpPlayerFeedbackEnabled() then
		v51 = v47 and v47.rootPlaceId or (v48 and v48.placeId or nil)
	end

	return {
		playing = v49,
		visits = v50,
		rootPlaceId = v51
	}
end, function(p13) -- line: 286
	-- upvalues: GetFFlagEdpPlayerFeedbackEnabled (copy), SetCentralOverlay (copy), CentralOverlayType (copy), GetGamePlayerFeedbackMetadata (copy)
	return {
		openFeedbackForm = if not GetFFlagEdpPlayerFeedbackEnabled() then nil else function(p14, p15, p16) -- line: 289
			-- upvalues: p13 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
			return p13(SetCentralOverlay(CentralOverlayType.GamePlayerFeedbackForm, {
				universeId = p14,
				playerFeedbackMetadata = p15,
				onSubmitted = p16
			}))
		end,
		getGamePlayerFeedbackMetadata = if not GetFFlagEdpPlayerFeedbackEnabled() then nil else function(p17, p18, p19, p20) -- line: 298
			-- upvalues: p13 (copy), GetGamePlayerFeedbackMetadata (copy)
			return p13(GetGamePlayerFeedbackMetadata.Get(p17, p18, p19, p20))
		end
	}
end)(v31)

if GetFFlagEdpPlayerFeedbackEnabled() then
	v32 = RoactAppExperiment.connectUserLayer({ AppUserLayers.EDPPlayerFeedbackExposureLayer }, function(p21, _) -- line: 308
		-- upvalues: AppUserLayers (copy)
		local v55 = p21[AppUserLayers.EDPPlayerFeedbackExposureLayer] or {}

		return {
			enablePlayerFeedback = v55.ShowFeedbackForm,
			showInlineFeedbackPrompt = v55.ShowInlinePrompt
		}
	end, false)(v32)
end

return (RoactServices.connect({
	localization = RoactLocalization,
	networking = if not GetFFlagEdpPlayerFeedbackEnabled() then nil else RoactNetworking
})(v32))
