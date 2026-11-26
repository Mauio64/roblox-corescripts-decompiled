local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Dash = require(CorePackages.Packages.Dash)
local Roact = require(CorePackages.Packages.Roact)
local none = Roact.None
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local loadableImage = UIBlox.App.Loading.LoadableImage
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text

local follow = require("@luauforge/bundled/dtb").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.Follow

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpNonSduiBuildAttribution = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpNonSduiBuildAttribution

local module3 = require("@luauforge/deferred/gDa")
local module4 = require("@luauforge/deferred/gDd")
local module5 = require("@luauforge/deferred/gCX")
local module6 = require("@luauforge/deferred/gDh")
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization

local module7 = require("@luauforge/deferred/gDi")
local module8 = require("@luauforge/deferred/gCa")

local module9 = require("@luauforge/deferred/gBX")

local getNotificationsExperienceDetailsVariant = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetNotificationsExperienceDetailsVariant

local getFFlagNotificationsForceEnableEDPDiscoverability = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagNotificationsForceEnableEDPDiscoverability
local module10 = require("@luauforge/deferred/gDm")
local module11 = require("@luauforge/deferred/gDn")

local module12 = require("@luauforge/deferred/gDo")

local extended = Roact.PureComponent:extend("GameHeader")

function extended:init()
	local v5

	if fFlagLuaAppEdpNonSduiBuildAttribution then
		v5 = localization.new(LocalizationService.RobloxLocaleId)
	else
		v5 = nil
	end

	local function iconWithFallback(p2)
		return p2
			or {
				url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", self.props.universeId)
			}
	end

	self.gameIconSubscription = GameHydrationReact.subscribeGameIcon({
		universeId = self.props.universeId,
		onChange = function(p2)
			self:setState({
				gameIcon = p2 or {
					url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", self.props.universeId)
				}
			})
		end
	})
	self.state = {
		gameIcon = self.gameIconSubscription.getCurrent() or {
			url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", self.props.universeId)
		}
	}
	self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
		universeId = self.props.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none
			})
		end
	})

	function self.toggleFollowExperience()
		local gameFollowings = self.props.gameFollowings
		local universeId = self.props.universeId
		local rootPlaceId = self.props.rootPlaceId
			or self.state.gameInfo and self.state.gameInfo.rootPlaceId

		if gameFollowings == nil or rootPlaceId == nil or universeId == nil then
			return
		end

		local isFollowed = gameFollowings.isFollowed
		local count = self.props.notificationsEnabled.count or 0
		local limit = self.props.notificationsEnabled.limit or 0

		local networking = self.props.networking
		local eventIngest = self.props.eventIngest

		local v6 = getFFlagNotificationsForceEnableEDPDiscoverability() and true
			or self.props.enableNotificationsDiscoverability
		self.props.sendGameFollow(networking, universeId, not isFollowed, v6, count, limit)

		follow(eventIngest, "GameDetailsGameHeader", rootPlaceId, not isFollowed)
	end

	function self.renderSubtitle(props, layoutOrder, p2, p3)
		local function fn(p4)
			if module11 then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(module12)
			end

			local createElement = Roact.createElement
			local v7 = {}
			v7.AutomaticSize = Enum.AutomaticSize.XY
			v7.Text = p4
			v7.TextXAlignment = Enum.TextXAlignment.Left
			v7.TextWrapped = true
			v7.BackgroundTransparency = 1
			local v9

			if
				(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui())
				and self.props.showAgeMaturityInHeader
			then
				v9 = self.props.foundationTokens.Typography.BodyMedium.Font
			else
				v9 = p2.Tokens.Typography.BodyLarge.Font
			end

			v7.FontFace = normalizeFontFace(v9)

			local v10 = if (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui()) and self.props.showAgeMaturityInHeader then self.props.foundationTokens.Typography.BodyMedium.FontSize else p2.Tokens.FontSize.FontSize_350
			v7.TextSize = v10

			local v11 = if (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui()) and self.props.showAgeMaturityInHeader then self.props.foundationTokens.Color.Content.Default.Color3 else p2.Tokens.Color.Content.Muted.Color3
			v7.TextColor3 = v11

			local v12 = if (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui()) and self.props.showAgeMaturityInHeader then self.props.foundationTokens.Color.Content.Default.Transparency else p2.Tokens.Color.Content.Muted.Transparency
			v7.TextTransparency = v12

			v7.LayoutOrder = layoutOrder
			v7.RichText = false
			v7.LineHeight = 1
			v7[Roact.Event.Activated] = module10 and function()
				if props.type == "User" then
					self.props.openUserProfilePage(props.id, "GameDetailsGameHeader")
				elseif props.type == "Group" then
					self.props.openCommunityProfilePage(props.id, "GameDetailsGameHeader")
				end
			end or nil
			return createElement(module10 and "TextButton" or "TextLabel", v7)
		end

		local v6 = p2.Tokens.FontSize.FontSize_350 + p3
		local hasVerifiedBadge = props.hasVerifiedBadge

		local element = Roact.createElement(VerifiedBadges.EmojiWrapper, {
			emoji = not hasVerifiedBadge and "" or VerifiedBadges.emoji.verified,
			layoutOrder = layoutOrder,
			maximumEmojiSize = v6
		}, { subtitleText = fn(props.name) })

		local gameDetail = self.props.gameDetail
		local v7 = if fFlagLuaAppEdpNonSduiBuildAttribution then module5(gameDetail) else nil

		if not fFlagLuaAppEdpNonSduiBuildAttribution or props.name == nil or not v7 then
			return element
		end

		local v8 = if hasVerifiedBadge then `{props.name}{module2.emoji.verified}` else props.name
		local v9 = module6(v5, true, v8)

		if v9 == nil then
			return element
		end

		return fn(v9)
	end
end

function extended.didUpdate(data)
	data.gameIconSubscription.update(data.props.universeId)
	data.gameInfoSubscription.update(data.props.universeId)
end

function extended.willUnmount(p2)
	p2.gameIconSubscription.dispose()
	p2.gameInfoSubscription.dispose()
end

function extended.render(data)
	local v5 = getFFlagNotificationsForceEnableEDPDiscoverability() and true
		or data.props.enableNotificationsDiscoverability
	local gameDetail = data.props.gameDetail
	local gameInfo = data.state.gameInfo
	local gameIcon = data.state.gameIcon
	local creator = gameDetail and gameDetail.creator

	local rootPlaceId = if v5 then data.props.rootPlaceId or gameInfo and gameInfo.rootPlaceId else nil

	local layoutOrder = data.props.LayoutOrder
	local showSubtitle = data.props.showSubtitle

	local name = gameDetail and gameDetail.name or gameInfo and gameInfo.name or nil

	local v6 = data.props.showNotificationButton and -116 or -68

	local displayNameWithHeaderShort = nil

	if
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui())
		and data.props.showAgeMaturityInHeader
		and data.props.ageRecommendations
	then
		local summary = data.props.ageRecommendations.summary
		local ageRecommendation = summary and summary.ageRecommendation or nil

		if ageRecommendation then
			displayNameWithHeaderShort = ageRecommendation.displayNameWithHeaderShort
				or ageRecommendation.displayName
		end
	end

	return withLocalization({
		containsStrongLanguageText = "Feature.GameDetails.Label.ContainsStrongLanguagePillWarning"
	})(function(p2)
		return withTextSizeOffset(function(p3)
			return withStyle(function(p4)
				local createElement = Roact.createElement
				local v8 = {
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder,
					AutomaticSize = Enum.AutomaticSize.Y
				}
				local v9 = {
					ListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12),
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					GameIcon = Roact.createElement(loadableImage, {
						LayoutOrder = 1,
						Size = UDim2.fromOffset(56, 56),
						Image = gameIcon and gameIcon.url,
						cornerRadius = UDim.new(0, 8)
					}),
					HeaderText = 0,
					NotificationsFrame = 0
				}

				local createElement2 = Roact.createElement
				local v11 = {
					Size = UDim2.new(1, v6, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 2
				}

				local v12 = {
					TextListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					Title = 0,
					Subtitle = 0,
					AgeMaturity = 0
				}
				local v13

				if
					(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui())
					and data.props.showAgeMaturityInHeader
				then
					v13 = Roact.createElement(text, {
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.new(0, 0, 0, 0),
						Text = name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						fontStyle = data.props.foundationTokens.Typography.HeadingSmall,
						textStyle = data.props.foundationTokens.Color.Content.Emphasis,
						LayoutOrder = 1
					})
				else
					v13 = Roact.createElement("TextLabel", {
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.new(0, 0, 0, 0),
						Text = name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						BackgroundTransparency = 1,
						FontFace = normalizeFontFace(p4.Tokens.Typography.HeadingSmall.Font),
						TextSize = p4.Tokens.Typography.HeadingSmall.FontSize,
						TextColor3 = p4.Tokens.Color.Content.Emphasis.Color3,
						TextTransparency = p4.Tokens.Color.Content.Emphasis.Transparency,
						LayoutOrder = 1
					})
				end

				v12.Title = v13

				local v14 = showSubtitle and creator

				if v14 then
					local renderSubtitle = data.renderSubtitle
					local v18

					if
						fFlagLuaAppEdpBackendV2SduiInterleaveDefault
						or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui()
					then
						v18 = data.props.foundationTokens
					end

					v14 = renderSubtitle(creator, 2, p4, p3, v18)
				end

				v12.Subtitle = v14

				local v15 = if (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui()) and data.props.showAgeMaturityInHeader and displayNameWithHeaderShort then Roact.createElement(text, {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					textStyle = data.props.foundationTokens.Color.Content.Default,
					fontStyle = data.props.foundationTokens.Typography.BodyMedium,
					Text = displayNameWithHeaderShort,
					LayoutOrder = 3
				}) else nil
				v12.AgeMaturity = v15
				v9.HeaderText = createElement2("Frame", v11, v12)

				local v16 = if data.props.showNotificationButton and v5 then Roact.createElement("Frame", {
					Size = UDim2.fromScale(0, 1),
					Position = UDim2.new(1, -36, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 3
				}, {
					GameDetailNotificationsButton = Roact.createElement(module4, {
						universeId = data.props.universeId,
						gameFollowings = data.props.gameFollowings,
						rootPlaceId = rootPlaceId,
						toggleFollowExperience = data.toggleFollowExperience
					})
				}) else nil
				v9.NotificationsFrame = v16
				return createElement("Frame", v8, v9)
			end)
		end)
	end)
end

local v5 = RoactRodux.connect(function(data, p2)
	local v6 = data.GameDetailsV2[p2.universeId]
	local v7 = {
		gameDetail = v6,
		gameInfo = nil,
		gameFollowings = data.GameFollowings[p2.universeId],
		rootPlaceId = v6 and v6.rootPlaceId or nil,
		notificationsEnabled = data.ExperienceNotificationsEnabled or {},
		ageRecommendations = 0
	}

	local v8 = if (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui()) and p2.showAgeMaturityInHeader then data.AgeRecommendations[p2.universeId] else nil
	v7.ageRecommendations = v8
	return v7
end, function(callback)
	return {
		sendGameFollow = function(p2, p3, p4, p5, p6, p7)
			return callback(module3(p2, p3, p4, p5, p6, p7))
		end
	}
end)(extended)

local v6 = roactServices.connect({
	networking = roactNetworking,
	eventIngest = appEventIngestService
})(v5)

local v7 = roactAppPolicy.connect(function(p2, p3)
	return { showSubtitle = p2.getGameDetailsSubtitle() }
end)(v6)

if not getFFlagNotificationsForceEnableEDPDiscoverability() then
	v7 = RoactAppExperiment.connectUserLayer({ appUserLayers.ExperienceDetailsPageLayer }, function(p2, p3)
		return {
			enableNotificationsDiscoverability = ((p2[appUserLayers.ExperienceDetailsPageLayer] or {})[getNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName] or -1) == 2
		}
	end)(v7)
end

return (module10 or fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp)
	and function(p2)
		local v8

		if module10 then
			local v10 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p2.shouldHydrateLegacyIxp else nil
			v8 = module7(v10)
		end

		local v9, v10

		if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			v9 = module8()
			v10 = useTokens()
		end

		local v12 = if module10 then v8.openCommunityProfilePage else nil

		local v13 = if module10 then v8.openUserProfilePage else nil
		local v14 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then v9 else nil

		if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp) then
			v10 = nil
		end

		local v11 = {
			openCommunityProfilePage = v12,
			openUserProfilePage = v13,
			edpServerIxpVariables = v14,
			foundationTokens = v10,
			showAgeMaturityInHeader = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module9.getShouldInterleaveSdui()) and v9 and v9.showAgeMaturityInHeader == true and true or nil
		}

		local joined = Dash.join(p2, v11)
		return Roact.createElement(v7, joined)
	end
	or v7
