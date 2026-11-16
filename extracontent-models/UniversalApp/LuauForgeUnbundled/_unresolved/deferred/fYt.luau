local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local none = module.None
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/edB")
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/Localization").abbreviateCount
local module4 = require("@luauforge/deferred/fYu")
local module5 = require("@luauforge/deferred/fYv")
local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local module6 = require("@luauforge/bundled/fNO")
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local gamePlayerFeedbackPrompt = require("@luauforge/deferred/fYx").GamePlayerFeedbackPrompt
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local module8 = require("@luauforge/bundled/dyO")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local getGamePlayerFeedbackMetadata = require("@luauforge/deferred/fYx").Thunks.GetGamePlayerFeedbackMetadata
local voteStatus = module8.Enums.VoteStatus

local getFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEdpPlayerFeedbackEnabled

local getFFlagEdpPlayerFeedbackLogIXPExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEdpPlayerFeedbackLogIXPExposure

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

local IXPService = game:GetService("IXPService")

local extended = module.PureComponent:extend("GamePlaysAndRatings")

function extended.didUpdate(p2)
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.update(p2.props.universeId)
	end
end

function extended.willUnmount(p2)
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.dispose()
	end
end

if getFFlagEdpPlayerFeedbackEnabled() then
	function extended:init()
		self.state = { isFeedbackPromptOpen = false }

		if fFlagMigrateGameInfoToStore then
			self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
				universeId = self.props.universeId,
				onChange = function(p2)
					self:setState({
						gameInfo = p2.gameInfo or none
					})
				end
			})
		end

		function self.openInlineFeedbackPrompt()
			self:setState({ isFeedbackPromptOpen = true })
		end
		function self.closeInlineFeedbackPrompt()
			self:setState({ isFeedbackPromptOpen = false })
		end
		function self.onClickFeedbackPromptButton()
			if self.state.playerFeedbackMetadata then
				self.props.openFeedbackForm(
					self.props.universeId,
					self.state.playerFeedbackMetadata,
					self.closeInlineFeedbackPrompt
				)
			else
				logging.warn("Player feedback metadata is not available from feedback prompt")
			end
		end
		function self.onVoteSuccess(p2)
			if getFFlagEdpPlayerFeedbackLogIXPExposure() then
				IXPService:LogUserLayerExposure(appUserLayers.EDPPlayerFeedbackExposureLayer)
			end

			if not self.props.enablePlayerFeedback then
				return
			end

			local universeId = self.props.universeId
			local networking = self.props.networking
			local rootPlaceId

			if fFlagMigrateGameInfoToStore then
				rootPlaceId = self.props.rootPlaceId
					or self.state.gameInfo and self.state.gameInfo.rootPlaceId
			else
				rootPlaceId = self.props.rootPlaceId
			end

			if p2 == voteStatus.NotVoted then
				self.closeInlineFeedbackPrompt()
			else
				self.props.getGamePlayerFeedbackMetadata(networking, universeId, rootPlaceId, p2):andThen(
					function(p3)
						if p3 and p3.canSubmitReview then
							if self.props.showInlineFeedbackPrompt then
								self:setState({ playerFeedbackMetadata = p3 })

								self.openInlineFeedbackPrompt()
							else
								self.props.openFeedbackForm(universeId, p3)
							end
						end
					end,
					function()
						logging.warn("Failed to get player feedback metadata")
					end
				)
			end
		end
	end
else
	function extended:init()
		if fFlagMigrateGameInfoToStore then
			self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
				universeId = self.props.universeId,
				onChange = function(p2)
					self:setState({
						gameInfo = p2.gameInfo or none
					})
				end
			})
		end
	end
end

function extended:getLayoutInfo(p3, p4, p5, p6, p7)
	local appTheme = self.props.appTheme
	local containerWidth = self.props.containerWidth
	local v5, v6

	if p7 then
		v5 = module4.GetMinimumWidthRethemed(p3, p4, p7)
		v6 = module4.GetMinimumWidthRethemed(p5, p6, p7)
	else
		v5 = module4.GetMinimumWidth(p3, p4, appTheme.GameDetails.Text.BoldFont)

		v6 = module4.GetMinimumWidth(p5, p6, appTheme.GameDetails.Text.BoldFont)
	end

	local v7 = math.max(v5, v6) * 2

	if containerWidth / 2 < v7 then
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

function extended:render()
	return withStyle(function(p2)
		local showGlobalCounters = self.props.showGlobalCounters
		local showLikesFavoritesCount = self.props.showLikesFavoritesCount
		local containerWidth = self.props.containerWidth
		local rowPadding = self.props.rowPadding
		local playing

		if fFlagMigrateGameInfoToStore then
			local gameInfo = self.state.gameInfo
			playing = self.props.playing or gameInfo and gameInfo.playerCount or 0
		else
			playing = self.props.playing
		end

		local visits = self.props.visits
		local universeId = self.props.universeId
		local layoutOrder = self.props.LayoutOrder
		local localization = self.props.localization
		local hideVisits = self.props.hideVisits

		local v5 = abbreviateCount(playing, localization:GetLocale())
		local v6 = string.upper(localization:Format("Feature.GameDetails.Label.Playing"))
		local v7 = abbreviateCount(visits, localization:GetLocale())
		local v8 = string.upper(localization:Format("Feature.GameDetails.Label.Visits"))

		local layoutInfo = self:getLayoutInfo(v5, v6, v7, v8, p2)
		local isOneRow = layoutInfo.isOneRow
		local subSectionWidth = layoutInfo.subSectionWidth
		local widgetWidth = layoutInfo.widgetWidth

		local createElement = module.createElement
		local v10 = {
			Size = UDim2.new(0, containerWidth, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = getFFlagEdpPlayerFeedbackEnabled() and 1 or layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v11 = {
			ListLayout = module.createElement("UIListLayout", {
				FillDirection = isOneRow and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, isOneRow and 0 or rowPadding)
			}),
			Ratings = 0,
			PlaysAndVisitsSection = 0
		}

		local createElement2 = module.createElement

		local v14 = if getFFlagEdpPlayerFeedbackEnabled() then self.onVoteSuccess else nil

		local v15 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
		v11.Ratings = createElement2(module5, {
			LayoutOrder = isOneRow and 1 or 2,
			universeId = universeId,
			width = subSectionWidth,
			showGlobalCounters = showGlobalCounters,
			showLikesFavoritesCount = showLikesFavoritesCount,
			onVoteSuccess = v14,
			shouldHydrateLegacyIxp = v15
		})

		v11.PlaysAndVisitsSection = not hideVisits
			and showGlobalCounters
			and module.createElement("Frame", {
				Size = UDim2.new(0, subSectionWidth, 0, 0),
				BackgroundTransparency = 1,
				LayoutOrder = isOneRow and 2 or 1,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ListLayout = module.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				PlaySection = module.createElement(module4, {
					icon = "LuaApp/icons/GameDetails/playing_large",
					number = v5,
					label = v6,
					width = widgetWidth,
					LayoutOrder = 1
				}),
				VisitsSection = module.createElement(module4, {
					icon = "LuaApp/icons/GameDetails/sessions_large",
					number = v7,
					label = v8,
					width = widgetWidth,
					LayoutOrder = 2
				})
			})
		local element = createElement("Frame", v10, v11)

		if not getFFlagEdpPlayerFeedbackEnabled() then
			return element
		end

		local createElement3 = module.createElement
		local v17 = {
			Size = UDim2.new(0, containerWidth, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v18 = {
			ListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, rowPadding)
			}),
			GamePlayerAndRatingsFrame = element,
			PlayerFeedbackPrompt = 0
		}
		local v19

		if self.state.isFeedbackPromptOpen then
			local createElement4 = module.createElement

			local v22 = if fFlagMigrateGameInfoToStore then self.props.rootPlaceId or self.state.gameInfo and self.state.gameInfo.rootPlaceId else self.props.rootPlaceId
			v19 = createElement4(gamePlayerFeedbackPrompt, {
				placeId = v22,
				width = containerWidth,
				backgroundColor3 = p2.Tokens.Color.Shift.Shift_400.Color3,
				backgroundTransparency = p2.Tokens.Color.Shift.Shift_400.Transparency,
				LayoutOrder = 2,
				onDimiss = self.closeInlineFeedbackPrompt,
				onButtonClick = self.onClickFeedbackPromptButton
			})
		end

		v18.PlayerFeedbackPrompt = v19
		return createElement3("Frame", v17, v18)
	end)
end

local v5 = module6(extended)

local v6 = useSheetNavigation.connect(function(data, p2)
	local v7

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp
	then
		v7 = data.GameDetailsV2[p2.universeId]
	else
		v7 = data.GameDetails[p2.universeId]
	end

	if fFlagMigrateGameInfoToStore then
		local v8 = {
			playing = v7 and v7.playing,
			visits = v7 and v7.visits or 0,
			rootPlaceId = 0
		}
		local v9 = if getFFlagEdpPlayerFeedbackEnabled() then v7 and v7.rootPlaceId else nil
		v8.rootPlaceId = v9
		return v8
	else
		local v8 = data.Personalization[gameInfosReducer.key][p2.universeId]
		local playing = v7 and v7.playing or v8 and v8.playerCount or 0
		local visits = v7 and v7.visits or 0

		local v9 = if getFFlagEdpPlayerFeedbackEnabled() then v7 and v7.rootPlaceId or v8 and v8.placeId or nil else nil

		return { playing = playing, visits = visits, rootPlaceId = v9 }
	end
end, function(callback)
	return {
		openFeedbackForm = getFFlagEdpPlayerFeedbackEnabled() and function(p2, p3, onSubmitted)
			return callback(setCentralOverlay(centralOverlayType.GamePlayerFeedbackForm, {
				universeId = p2,
				playerFeedbackMetadata = p3,
				onSubmitted = onSubmitted
			}))
		end or nil,
		getGamePlayerFeedbackMetadata = getFFlagEdpPlayerFeedbackEnabled() and function(p2, p3, p4, p5)
			return callback(getGamePlayerFeedbackMetadata.Get(p2, p3, p4, p5))
		end or nil
	}
end)(v5)

if getFFlagEdpPlayerFeedbackEnabled() then
	v6 = RoactAppExperiment.connectUserLayer(
		{ appUserLayers.EDPPlayerFeedbackExposureLayer },
		function(p2, p3)
			local v7 = p2[appUserLayers.EDPPlayerFeedbackExposureLayer] or {}
			return {
				enablePlayerFeedback = v7.ShowFeedbackForm,
				showInlineFeedbackPrompt = v7.ShowInlinePrompt
			}
		end,
		false
	)(v6)
end

local connect = roactServices.connect

if not getFFlagEdpPlayerFeedbackEnabled() then
	roactNetworking = nil
end

return (connect({ localization = module3, networking = roactNetworking })(v6))
