local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local GuildedLogoWhiteAsset = require(CorePackages.Workspace.Packages.CommunityLinks).Constants.GuildedLogoWhiteAsset
local ProfileTypes = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums).ProfileTypes
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local navigateToBadgesSeeAll = require(CorePackages.Workspace.Packages.Badges).navigateToBadgesSeeAll
local navigateToDevStoreSeeAll = require(CorePackages.Workspace.Packages.DevStore).navigateToDevStoreSeeAll
local GameDetailsSubpage = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.GameDetailsSubpage
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local LocalizedTextLabel = require(Modules.LuaApp.Components.LocalizedTextLabel)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local OpenCentralOverlayForExperienceGuidelines = require(Modules.LuaApp.Thunks.OpenCentralOverlayForExperienceGuidelines)
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local OpenCloseOnlyInteractiveAlert = require(CorePackages.Workspace.Packages.DiscoveryRouting).OpenCloseOnlyInteractiveAlert
local GetFFlagUseVoiceExitBetaLanguage = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseVoiceExitBetaLanguage
local FStringLuaAppGenreTooltipStage = require(Modules.Personalization.Flags.FStringLuaAppGenreTooltipStage)
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents
local v39 = game:DefineFastFlag("LuaAppRemoveDeadGameInfoRowTooltipBranch", false)
local FFlagLuaAppBadgesSeeAllEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppBadgesSeeAllEnabled
local FStringLuaAppBadgesSeeAllIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaAppBadgesSeeAllIxpLayer
local FFlagLuaAppBadgesSeeAllLogExposure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppBadgesSeeAllLogExposure
local FFlagLuaAppDevStoreSeeAllSduiEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDevStoreSeeAllSduiEnabled
local FFlagLuaAppDevStoreSeeAllSduiLogExposure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDevStoreSeeAllSduiLogExposure
local FStringLuaAppDevStoreSeeAllSduiIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaAppDevStoreSeeAllSduiIxpLayer
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback
local v48 = Images["icons/actions/cycleRight"]
local v49 = Roact.PureComponent:extend("GameInfoRow")

v49.defaultProps = {
	leftPadding = 0,
	rightPadding = 0
}

function v49.init(p1) -- line: 87
	-- upvalues: Roact (copy), GameDetailsSubpage (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), AppPage (copy), FFlagLuaAppDevStoreSeeAllSduiLogExposure (copy), IXPService (copy), FStringLuaAppDevStoreSeeAllSduiIxpLayer (copy), FFlagLuaAppDevStoreSeeAllSduiEnabled (copy), navigateToDevStoreSeeAll (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), FFlagLuaAppBadgesSeeAllLogExposure (copy), FStringLuaAppBadgesSeeAllIxpLayer (copy), FFlagLuaAppBadgesSeeAllEnabled (copy), navigateToBadgesSeeAll (copy), v39 (copy), FStringLuaAppGenreTooltipStage (copy), EnableCommunityProfilePageIXP (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy)
	p1.infoNameTextLabelRef = Roact.createRef()

	local v53, v54 = Roact.createBinding(0)

	p1.maxRightContentWidth = v53
	p1.setMaxRightContentWidth = v54
	p1.state = {
		buttonPressed = false
	}

	function p1.onAbsoluteSizeChange(p2) -- line: 95
		-- upvalues: p1 (copy)
		local AbsoluteSizeX = p2.AbsoluteSize.X

		p1.setMaxRightContentWidth((math.floor(AbsoluteSizeX - (p1.props.leftPadding + p1.props.rightPadding))))
	end
	function p1.onInputBegan(_, p4) -- line: 100
		-- upvalues: p1 (copy)
		if p4.UserInputState == Enum.UserInputState.Begin and ((p4.UserInputType == Enum.UserInputType.Touch or p4.UserInputType == Enum.UserInputType.MouseButton1) and not p1.state.buttonPressed) then
			p1:setState({
				buttonPressed = true
			})
		end
	end
	function p1.onInputEnded() -- line: 116
		-- upvalues: p1 (copy)
		if p1.state.buttonPressed then
			p1:setState({
				buttonPressed = false
			})
		end
	end
	function p1.onActivated() -- line: 124
		-- upvalues: p1 (copy), GameDetailsSubpage (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), AppPage (copy), FFlagLuaAppDevStoreSeeAllSduiLogExposure (copy), IXPService (copy), FStringLuaAppDevStoreSeeAllSduiIxpLayer (copy), FFlagLuaAppDevStoreSeeAllSduiEnabled (copy), navigateToDevStoreSeeAll (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), FFlagLuaAppBadgesSeeAllLogExposure (copy), FStringLuaAppBadgesSeeAllIxpLayer (copy), FFlagLuaAppBadgesSeeAllEnabled (copy), navigateToBadgesSeeAll (copy), v39 (copy), FStringLuaAppGenreTooltipStage (copy), EnableCommunityProfilePageIXP (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy)
		local linkPage = p1.props.linkPage
		local linkView = p1.props.linkView
		local linkUrl = p1.props.linkUrl

		if not linkPage and (not linkView and not linkUrl) then
			return
		end

		local eventIngest = p1.props.eventIngest
		local universeId = p1.props.universeId

		if linkUrl then
			p1.props.openLeaveRobloxAlert(function() -- line: 137
				-- upvalues: p1 (copy), linkUrl (copy)
				p1.props.linking:openURL(linkUrl)
				p1.props.closeAlert()

				local linkClickCallback = p1.props.linkClickCallback

				if linkClickCallback then
					linkClickCallback()
				end
			end)

			return
		end

		local placeId = p1.props.placeId
		local analyticsSubPage = p1.props.analyticsSubPage

		GameDetailsSubpage(eventIngest, "GameInfoRow", placeId, analyticsSubPage, if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else universeId)

		local currentText = p1.infoNameTextLabelRef.current.Text

		if linkView == AppPage.ExperienceGuidelinesExplained then
			p1.props.openExperienceGuidelinesExplained(universeId)

			return
		end

		if linkView == AppPage.PassesPage then
			if FFlagLuaAppDevStoreSeeAllSduiLogExposure then
				IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppDevStoreSeeAllSduiIxpLayer)
			end

			if FFlagLuaAppDevStoreSeeAllSduiEnabled then
				navigateToDevStoreSeeAll(p1.props.navigation, universeId)

				return
			end

			p1.props.navigateDown({
				name = AppPage.PassesPage,
				detail = universeId,
				extraProps = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else {
					viewWidth = p1.props.viewWidth
				}
			})

			return
		end

		if FFlagLuaAppBadgesSeeAllLogExposure and analyticsSubPage == "Badges" then
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppBadgesSeeAllIxpLayer)
		end

		if FFlagLuaAppBadgesSeeAllEnabled and linkView == AppPage.BadgesSeeAll then
			navigateToBadgesSeeAll(p1.props.navigation, universeId)

			return
		end

		if not v39 then
			if linkView == "UpdatedGenre" then
				local localization = p1.props.localization

				p1.props.openCloseOnlyInteractiveAlert(p1.props.infoData, localization:Format("Feature.GameDetails.Label.GenreInProgress"), p1.props.closeAlert)

				return
			end

			if linkView == "GenreUnderConstruction" then
				local localization = p1.props.localization
				local v91 = nil

				if FStringLuaAppGenreTooltipStage == "UnderConstruction" then
					v91 = localization:Format("Feature.GameDetails.Label.GenreUnderConstruction")
				elseif FStringLuaAppGenreTooltipStage == "InProgress" then
					v91 = localization:Format("Feature.GameDetails.Label.GenreInProgress")
				end

				if v91 then
					p1.props.openCloseOnlyInteractiveAlert(localization:Format("Feature.GameDetails.Label.Unavailable"), v91, p1.props.closeAlert)
				end

				return
			end
		end

		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and (analyticsSubPage == "Developer" or analyticsSubPage == "Group") then
			EnableCommunityProfilePageIXP.logExposure()
		end

		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and linkView == "CommunityProfilePlatform" and p1.props.linkViewData ~= nil then
			local linkViewData = p1.props.linkViewData

			p1.props.openCommunityProfilePage(linkViewData, `ExperienceDetailsPage:{ analyticsSubPage }`)

			return
		end

		if linkView == "UserProfilePlatform" and p1.props.linkViewData ~= nil then
			local linkViewData = p1.props.linkViewData

			p1.props.openUserProfilePage(linkViewData, `ExperienceDetailsPage:{ analyticsSubPage }`)

			return
		end

		p1.props.navigateDown({
			name = AppPage.GenericWebPage,
			detail = linkPage,
			extraProps = {
				title = currentText,
				transitionAnimation = TransitionAnimation.SlideInFromRight,
				onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else p1.props.onClose
			}
		})
	end
end
function v49.render(p5) -- line: 256
	-- upvalues: GetFFlagUseVoiceExitBetaLanguage (copy), GuildedLogoWhiteAsset (copy), Roact (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ImageSetLabel (copy), VerifiedBadges (copy), v48 (copy), LocalizedTextLabel (copy)
	local Cells = p5.props.appTheme.GameDetails.GameInfoList.Cells
	local propsSize = p5.props.Size
	local propsPosition = p5.props.Position
	local propsLayoutOrder = p5.props.LayoutOrder
	local buttonPressed = p5.state.buttonPressed
	local infoName = p5.props.infoName
	local v62 = p5.props.infoData or ""
	local infoIcon = p5.props.infoIcon
	local v64 = false

	if GetFFlagUseVoiceExitBetaLanguage() then
		v64 = p5.props.infoIcon ~= nil
	elseif infoIcon == GuildedLogoWhiteAsset then
		v64 = true
	end

	local v65 = p5.props.linkPage ~= nil or (p5.props.linkView or p5.props.linkUrl)
	local leftPadding = p5.props.leftPadding
	local rightPadding = p5.props.rightPadding
	local topPadding = p5.props.topPadding
	local bottomPadding = p5.props.bottomPadding

	if not v65 then
		buttonPressed = false
	end

	local function getInfoDataTextLabel(_, p7) -- line: 284
		-- upvalues: Roact (copy), v62 (copy), React (copy), p5 (copy)
		return Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 0, 0, 0),
			TextTruncate = Enum.TextTruncate.SplitWord,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = p7.Font.Header2.Font,
			TextSize = p7.Font.BaseSize * p7.Font.Header2.RelativeSize,
			TextColor3 = p7.Theme.TextEmphasis.Color,
			TextTransparency = p7.Theme.TextEmphasis.Transparency,
			Text = v62,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = false,
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 1,
			[React.Tag] = if not p5.props.testId then nil else `data-testid={ p5.props.testId }`
		})
	end

	local style = p5.props.style

	return Roact.createElement("ImageButton", {
		Size = propsSize,
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = propsPosition,
		AutoButtonColor = false,
		LayoutOrder = propsLayoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = buttonPressed and Cells.Background.Transparency.Pressed or Cells.Background.Transparency.Default,
		BackgroundColor3 = Cells.Background.Color,
		[Roact.Event.InputBegan] = p5.onInputBegan,
		[Roact.Event.InputEnded] = p5.onInputEnded,
		[Roact.Event.Activated] = p5.onActivated,
		[Roact.Change.AbsoluteSize] = p5.onAbsoluteSizeChange
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Wraps = true,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then style.Tokens.Global.Size_100 else style.Tokens.Size.Size_200)
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding),
			PaddingTop = UDim.new(0, topPadding),
			PaddingBottom = UDim.new(0, bottomPadding)
		}),
		RightContent = Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 11),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				HorizontalFlex = Enum.UIFlexAlignment.Fill
			}),
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = p5.maxRightContentWidth:map(function(p8) -- line: 352
					return Vector2.new(p8, 1e999)
				end)
			}),
			InfoIcon = v64 and Roact.createElement(ImageSetLabel, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, 20, 0, 20),
				Image = p5.props.infoIcon,
				ImageColor3 = style.Theme.IconEmphasis.Color,
				ImageTransparency = style.Theme.IconEmphasis.Transparency
			}),
			InfoDataTextLabelVerifiedBadge = p5.props.useVerifiedBadgeEmojiWrapper and Roact.createElement(VerifiedBadges.EmojiWrapper, {
				layoutOrder = 1,
				emoji = not p5.props.useVerifiedBadgeEmojiWrapper and "" or VerifiedBadges.emoji.verified,
				size = UDim2.new(0, 0, 0, 0),
				anchorPoint = Vector2.new(1, 0),
				automaticSize = Enum.AutomaticSize.XY,
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				verticalAlignment = Enum.VerticalAlignment.Center
			}, {
				InfoDataTextLabel = getInfoDataTextLabel(true, style)
			}),
			InfoDataTextLabel = if p5.props.useVerifiedBadgeEmojiWrapper or v62 == "" then nil else getInfoDataTextLabel(false, style),
			LinkArrow = v65 and Roact.createElement(ImageSetLabel, {
				Size = UDim2.new(0, 14, 0, 14),
				Image = v48,
				ImageColor3 = style.Theme.IconEmphasis.Color,
				ImageTransparency = style.Theme.IconEmphasis.Transparency,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				[React.Tag] = if not p5.props.testId then nil else `data-testid={ p5.props.testId }`
			})
		}),
		InfoNameTextLabel = Roact.createElement(if not p5.props.disableInfoNameLocalization then LocalizedTextLabel else "TextLabel", {
			Size = UDim2.new(v62 == "" and 1 or 0, v62 == "" and -25 or 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = style.Font.Body.Font,
			TextSize = style.Font.BaseSize * style.Font.Body.RelativeSize,
			TextColor3 = style.Theme.TextDefault.Color,
			TextTransparency = style.Theme.TextDefault.Transparency,
			Text = infoName,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true,
			[Roact.Ref] = p5.infoNameTextLabelRef,
			LayoutOrder = 1
		})
	})
end

local v50 = withTheme_DEPRECATED(v49)
local v51 = RoactRodux.connect(nil, function(p9) -- line: 439
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy), OpenCentralOverlayForExperienceGuidelines (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), v39 (copy), OpenCloseOnlyInteractiveAlert (copy), CloseCentralOverlay (copy), EnableCommunityProfilePageIXP (copy), AppPage (copy), ProfileTypes (copy)
	return {
		navigateDown = function(p10) -- line: 441
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), p9 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v12.down(v12.fromLegacyPage(p10))
			end

			return p9(NavigateDown(p10))
		end,
		openExperienceGuidelinesExplained = function(p11) -- line: 448
			-- upvalues: p9 (copy), OpenCentralOverlayForExperienceGuidelines (copy)
			p9(OpenCentralOverlayForExperienceGuidelines(p11, false))
		end,
		openLeaveRobloxAlert = function(p12) -- line: 451
			-- upvalues: p9 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
			p9(OpenCentralOverlayForLeaveRobloxAlert(p12))
		end,
		openCloseOnlyInteractiveAlert = not v39 and function(p13, p14, p15) -- line: 456
			-- upvalues: p9 (copy), OpenCloseOnlyInteractiveAlert (copy)
			p9(OpenCloseOnlyInteractiveAlert(p13, p14, p15, nil, false))
		end or nil,
		closeAlert = not v39 and function() -- line: 461
			-- upvalues: p9 (copy), CloseCentralOverlay (copy)
			p9(CloseCentralOverlay())
		end or nil,
		openCommunityProfilePage = if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else function(s1: string, s2: string) -- line: 465
			-- upvalues: AppPage (copy), ProfileTypes (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), p9 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.ProfilePlatform,
				detail = s1,
				extraProps = {
					profileType = ProfileTypes.Community,
					source = s2
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v12.down(v12.fromLegacyPage(t1))

				return
			end

			p9(NavigateDown(t1))
		end,
		openUserProfilePage = function(s3: string, s4: string) -- line: 481
			-- upvalues: AppPage (copy), ProfileTypes (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), p9 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.ProfilePlatform,
				detail = s3,
				extraProps = {
					profileType = ProfileTypes.User,
					source = s4
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v12.down(v12.fromLegacyPage(t2))

				return
			end

			p9(NavigateDown(t2))
		end
	}
end)(function(p16) -- line: 422
	-- upvalues: useStyle (copy), FFlagLuaAppBadgesSeeAllEnabled (copy), FFlagLuaAppDevStoreSeeAllSduiEnabled (copy), useNavigation (copy), Cryo (copy), Roact (copy), v50 (copy)
	local v73 = useStyle()
	local v74 = if not FFlagLuaAppBadgesSeeAllEnabled and not FFlagLuaAppDevStoreSeeAllSduiEnabled then nil else useNavigation()
	local v75 = Cryo.Dictionary.join(p16, {
		style = v73,
		navigation = v74
	})

	return Roact.createElement(v50, v75)
end)

return RoactServices.connect({
	eventIngest = AppEventIngestService,
	linking = AppLinking,
	localization = RoactLocalization
})(v51)
