local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local GameIconReducer = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.GameIconReducer
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local LoadableImage = UIBlox.App.Loading.LoadableImage
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local Text = require(CorePackages.Packages.Foundation).Text
local Follow = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.Follow
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SendGameFollow = require(Modules.LuaApp.Thunks.SendGameFollow)
local GameDetailNotificationsButton = require(Modules.LuaApp.Components.GameDetails.GameDetailNotificationsButton)
local useExperienceDetailsNavigation = require(script.Parent.Parent.ExperienceDetails.useExperienceDetailsNavigation)
local useEdpServerIxpVariables = require(script.Parent.Parent.ExperienceDetails.Hooks.useEdpServerIxpVariables)
local ExperienceDetailsExperimentation = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceDetailsExperimentation)
local GetNotificationsExperienceDetailsVariant = require(CorePackages.Workspace.Packages.SharedFlags).GetNotificationsExperienceDetailsVariant
local GetFFlagNotificationsForceEnableEDPDiscoverability = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagNotificationsForceEnableEDPDiscoverability
local FFlagEnableCreatorSubtitleNavigation = require(Modules.LuaApp.Flags.FFlagEnableCreatorSubtitleNavigation)
local FFlagCreatorSubtitleNavigationIXPEnabled = require(Modules.LuaApp.Flags.FFlagCreatorSubtitleNavigationIXPEnabled)
local FStringCreatorSubtitleNavigationExperimentLayer = require(Modules.LuaApp.Flags.FStringCreatorSubtitleNavigationExperimentLayer)
local v39 = Roact.PureComponent:extend("GameHeader")

function v39.init(p1) -- line: 66
	-- upvalues: GetFFlagNotificationsForceEnableEDPDiscoverability (copy), Follow (copy), FFlagCreatorSubtitleNavigationIXPEnabled (copy), IXPServiceWrapper (copy), FStringCreatorSubtitleNavigationExperimentLayer (copy), Roact (copy), FFlagEnableCreatorSubtitleNavigation (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), FFlagRenameDeprecatedUIBloxTokens (copy), VerifiedBadges (copy)
	function p1.toggleFollowExperience() -- line: 67
		-- upvalues: p1 (copy), GetFFlagNotificationsForceEnableEDPDiscoverability (copy), Follow (copy)
		local gameFollowings = p1.props.gameFollowings
		local universeId = p1.props.universeId
		local rootPlaceId = p1.props.rootPlaceId

		if gameFollowings == nil or (rootPlaceId == nil or universeId == nil) then
			return
		end

		local isFollowed = gameFollowings.isFollowed
		local v78 = p1.props.notificationsEnabled.count or 0
		local v79 = p1.props.notificationsEnabled.limit or 0
		local networking = p1.props.networking
		local eventIngest = p1.props.eventIngest
		local v82 = not not GetFFlagNotificationsForceEnableEDPDiscoverability() or p1.props.enableNotificationsDiscoverability

		p1.props.sendGameFollow(networking, universeId, not isFollowed, v82, v78, v79)
		Follow(eventIngest, "GameDetailsGameHeader", rootPlaceId, not isFollowed)
	end
	function p1.renderSubtitle(p2, p3, p4, p5) -- line: 97
		-- upvalues: FFlagCreatorSubtitleNavigationIXPEnabled (copy), IXPServiceWrapper (copy), FStringCreatorSubtitleNavigationExperimentLayer (copy), Roact (copy), FFlagEnableCreatorSubtitleNavigation (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), p1 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), VerifiedBadges (copy)
		local v87 = ((if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Global.FontSize_75 else p4.Tokens.FontSize.FontSize_350)) + p5
		local hasVerifiedBadge = p2.hasVerifiedBadge

		return Roact.createElement(VerifiedBadges.EmojiWrapper, {
			emoji = not hasVerifiedBadge and "" or VerifiedBadges.emoji.verified,
			layoutOrder = p3,
			maximumEmojiSize = v87
		}, {
			subtitleText = (function(p6) -- line: 98
				-- upvalues: FFlagCreatorSubtitleNavigationIXPEnabled (copy), IXPServiceWrapper (copy), FStringCreatorSubtitleNavigationExperimentLayer (copy), Roact (copy), FFlagEnableCreatorSubtitleNavigation (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), p1 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p4 (copy), p3 (copy), p2 (copy)
				if FFlagCreatorSubtitleNavigationIXPEnabled then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringCreatorSubtitleNavigationExperimentLayer)
				end

				return Roact.createElement(not FFlagEnableCreatorSubtitleNavigation and "TextLabel" or "TextButton", {
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = p6,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					BackgroundTransparency = 1,
					Font = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or not p1.props.showAgeMaturityInHeader then if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Typography.Body.Font else p4.Tokens.Typography.BodyLarge.Font else p1.props.foundationTokens.Typography.BodyMedium.Font,
					TextSize = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or not p1.props.showAgeMaturityInHeader then if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Global.FontSize_75 else p4.Tokens.FontSize.FontSize_350 else p1.props.foundationTokens.Typography.BodyMedium.FontSize,
					TextColor3 = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or not p1.props.showAgeMaturityInHeader then ((if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Color.Text.Muted else p4.Tokens.Color.Content.Muted)).Color3 else p1.props.foundationTokens.Color.Content.Default.Color3,
					TextTransparency = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or not p1.props.showAgeMaturityInHeader then ((if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Color.Text.Muted else p4.Tokens.Color.Content.Muted)).Transparency else p1.props.foundationTokens.Color.Content.Default.Transparency,
					LayoutOrder = p3,
					RichText = false,
					LineHeight = 1,
					[Roact.Event.Activated] = if not FFlagEnableCreatorSubtitleNavigation then nil else function() -- line: 156
						-- upvalues: p2 (copy), p1 (copy)
						if p2.type == "User" then
							p1.props.openUserProfilePage(p2.id, "GameDetailsGameHeader")

							return
						end

						if p2.type == "Group" then
							p1.props.openCommunityProfilePage(p2.id, "GameDetailsGameHeader")
						end
					end
				})
			end)(p2.name)
		})
	end
end
function v39.render(p7) -- line: 183
	-- upvalues: GetFFlagNotificationsForceEnableEDPDiscoverability (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), withLocalization (copy), withTextSizeOffset (copy), withStyle (copy), Roact (copy), LoadableImage (copy), Text (copy), FFlagRenameDeprecatedUIBloxTokens (copy), GameDetailNotificationsButton (copy)
	local v46 = not not GetFFlagNotificationsForceEnableEDPDiscoverability() or p7.props.enableNotificationsDiscoverability
	local gameDetail = p7.props.gameDetail
	local gameInfo = p7.props.gameInfo
	local v49 = gameDetail and gameDetail.creator
	local u50 = if not v46 then nil else p7.props.rootPlaceId
	local propsLayoutOrder = p7.props.LayoutOrder
	local showSubtitle = p7.props.showSubtitle
	local v53 = gameDetail and gameDetail.name or (gameInfo and gameInfo.name or nil)
	local v54 = not p7.props.showNotificationButton and -68 or -116
	local u55 = nil

	if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (p7.props.showAgeMaturityInHeader and p7.props.ageRecommendations) then
		local summary = p7.props.ageRecommendations.summary
		local v57 = summary and summary.ageRecommendation or nil

		if v57 then
			u55 = v57.displayNameWithHeaderShort or v57.displayName
		end
	end

	return withLocalization({
		containsStrongLanguageText = "Feature.GameDetails.Label.ContainsStrongLanguagePillWarning"
	})(function(_) -- line: 223
		-- upvalues: withTextSizeOffset (copy), withStyle (copy), Roact (copy), propsLayoutOrder (copy), LoadableImage (copy), p7 (copy), v54 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), Text (copy), v53 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), showSubtitle (copy), v49 (copy), u55 (ref), v46 (copy), GameDetailNotificationsButton (copy), u50 (ref)
		return withTextSizeOffset(function(p9) -- line: 224
			-- upvalues: withStyle (copy), Roact (copy), propsLayoutOrder (copy), LoadableImage (copy), p7 (copy), v54 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), Text (copy), v53 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), showSubtitle (copy), v49 (copy), u55 (ref), v46 (copy), GameDetailNotificationsButton (copy), u50 (ref)
			return withStyle(function(p10) -- line: 225
				-- upvalues: Roact (copy), propsLayoutOrder (copy), LoadableImage (copy), p7 (copy), v54 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), Text (copy), v53 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), showSubtitle (copy), v49 (copy), p9 (copy), u55 (ref), v46 (copy), GameDetailNotificationsButton (copy), u50 (ref)
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = propsLayoutOrder,
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					ListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12),
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					GameIcon = Roact.createElement(LoadableImage, {
						LayoutOrder = 1,
						Size = UDim2.fromOffset(56, 56),
						Image = p7.props.gameIcon and p7.props.gameIcon.url,
						cornerRadius = UDim.new(0, 8)
					}),
					HeaderText = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(1, v54, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						TextListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 4)
						}),
						Title = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or not p7.props.showAgeMaturityInHeader then Roact.createElement("TextLabel", {
							TextWrapped = true,
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Position = UDim2.new(0, 0, 0, 0),
							Text = v53,
							TextXAlignment = Enum.TextXAlignment.Left,
							Font = if not FFlagRenameDeprecatedUIBloxTokens then p10.Tokens.Semantic.Typography.Header.Font else p10.Tokens.Typography.HeadingSmall.Font,
							TextSize = if not FFlagRenameDeprecatedUIBloxTokens then p10.Tokens.Semantic.Typography.Header.FontSize else p10.Tokens.Typography.HeadingSmall.FontSize,
							TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p10.Tokens.Semantic.Color.Text.Emphasis else p10.Tokens.Color.Content.Emphasis)).Color3,
							TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p10.Tokens.Semantic.Color.Text.Emphasis else p10.Tokens.Color.Content.Emphasis)).Transparency
						}) else Roact.createElement(Text, {
							TextWrapped = true,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Position = UDim2.new(0, 0, 0, 0),
							Text = v53,
							TextXAlignment = Enum.TextXAlignment.Left,
							fontStyle = p7.props.foundationTokens.Typography.HeadingSmall,
							textStyle = p7.props.foundationTokens.Color.Content.Emphasis
						}),
						Subtitle = showSubtitle and (v49 and p7.renderSubtitle(v49, 2, p10, p9, if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) then nil else p7.props.foundationTokens)),
						AgeMaturity = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not p7.props.showAgeMaturityInHeader or not u55) then nil else Roact.createElement(Text, {
							TextWrapped = true,
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.XY,
							TextXAlignment = Enum.TextXAlignment.Left,
							textStyle = p7.props.foundationTokens.Color.Content.Default,
							fontStyle = p7.props.foundationTokens.Typography.BodyMedium,
							Text = u55
						})
					}),
					NotificationsFrame = if not p7.props.showNotificationButton or not v46 then nil else Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 3,
						Size = UDim2.fromScale(0, 1),
						Position = UDim2.new(1, -36, 0, 0)
					}, {
						GameDetailNotificationsButton = Roact.createElement(GameDetailNotificationsButton, {
							universeId = p7.props.universeId,
							gameFollowings = p7.props.gameFollowings,
							rootPlaceId = u50,
							toggleFollowExperience = p7.toggleFollowExperience
						})
					})
				})
			end)
		end)
	end)
end

local v40 = RoactRodux.connect(function(p11, p12) -- line: 355
	-- upvalues: GameInfosReducer (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameIconReducer (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy)
	local v60 = p11.Personalization[GameInfosReducer.key][p12.universeId]
	local v61, v62

	if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p12.shouldHydrateLegacyIxp then
		v61 = p11.GameDetailsV2[p12.universeId]
		v62 = if p11[GameIconReducer.key][p12.universeId] ~= nil then p11[GameIconReducer.key][p12.universeId] else {
			url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", p12.universeId)
		}
	else
		v62 = p11[GameIconReducer.key][p12.universeId]
		v61 = p11.GameDetails[p12.universeId]
	end

	return {
		gameDetail = v61,
		gameInfo = v60,
		gameIcon = v62,
		gameFollowings = p11.GameFollowings[p12.universeId],
		rootPlaceId = v61 and v61.rootPlaceId or v60 and v60.placeId,
		notificationsEnabled = p11.ExperienceNotificationsEnabled or {},
		ageRecommendations = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or not p12.showAgeMaturityInHeader then nil else p11.AgeRecommendations[p12.universeId]
	}
end, function(p13) -- line: 394
	-- upvalues: SendGameFollow (copy)
	return {
		sendGameFollow = function(p14, p15, p16, p17, p18, p19) -- line: 396
			-- upvalues: p13 (copy), SendGameFollow (copy)
			return p13(SendGameFollow(p14, p15, p16, p17, p18, p19))
		end
	}
end)(v39)
local v41 = RoactServices.connect({
	networking = RoactNetworking,
	eventIngest = AppEventIngestService
})(v40)
local v42 = RoactAppPolicy.connect(function(p20, _) -- line: 423
	return {
		showSubtitle = p20.getGameDetailsSubtitle()
	}
end)(v41)

if not GetFFlagNotificationsForceEnableEDPDiscoverability() then
	v42 = RoactAppExperiment.connectUserLayer({ AppUserLayers.ExperienceDetailsPageLayer }, function(p22, _) -- line: 432
		-- upvalues: AppUserLayers (copy), GetNotificationsExperienceDetailsVariant (copy)
		return {
			enableNotificationsDiscoverability = ((p22[AppUserLayers.ExperienceDetailsPageLayer] or {})[GetNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName] or -1) == 2
		}
	end)(v42)
end

if FFlagEnableCreatorSubtitleNavigation or FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
	local v43 = v42

	function v42(p24) -- line: 448
		-- upvalues: FFlagEnableCreatorSubtitleNavigation (copy), useExperienceDetailsNavigation (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), useEdpServerIxpVariables (copy), useTokens (copy), ExperienceDetailsExperimentation (copy), Dash (copy), Roact (copy), v43 (copy)
		local v69 = nil

		if FFlagEnableCreatorSubtitleNavigation then
			v69 = useExperienceDetailsNavigation(if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p24.shouldHydrateLegacyIxp)
		end

		local v70 = nil
		local v71 = nil

		if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			v70 = useEdpServerIxpVariables()
			v71 = useTokens()
		end

		local t1 = {
			openCommunityProfilePage = if not FFlagEnableCreatorSubtitleNavigation then nil else v69.openCommunityProfilePage,
			openUserProfilePage = if not FFlagEnableCreatorSubtitleNavigation then nil else v69.openUserProfilePage,
			edpServerIxpVariables = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else v70,
			foundationTokens = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else v71,
			showAgeMaturityInHeader = not (not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui())) and (not not v70 and v70.showAgeMaturityInHeader == true) or nil
		}
		local v73 = Dash.join(p24, t1)

		return Roact.createElement(v43, v73)
	end
end

return v42
