local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails

local fFlagUseSignalsForIsLocalUserUnder13 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserUnder13
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local getIsLocalUserUnder13Store

if fFlagUseSignalsForIsLocalUserUnder13 then
	getIsLocalUserUnder13Store = require("@luauforge/bundled/cgr").Stores.GetIsLocalUserUnder13Store
else
	getIsLocalUserUnder13Store = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(CorePackages.Packages.Signals)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/edB")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module4 = require("@luauforge/bundled/eer")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/bundled/eda")
local module6 = require("@luauforge/bundled/dYU")
local Cryo = require(CorePackages.Packages.Cryo)
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local impressionsTagUtility = require("@luauforge/bundled/edd").ImpressionsTagUtility
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module8 = require("@luauforge/bundled/dCp")
local module9 = require("@luauforge/bundled/fXj")
local module10 = require("@luauforge/bundled/ftp")
local module11 = require("@luauforge/bundled/fvl")
local module12 = require("@luauforge/deferred/fXl")
local module13 = require("@luauforge/deferred/fXt")

local module14 = require("@luauforge/deferred/fXR")

local module15 = require("@luauforge/bundled/dBe")
local experienceCommunityLink = module15.Components.ExperienceCommunityLink
local getCommunityUrl = module15.Utils.getCommunityUrl

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking

local module16 = require("@luauforge/bundled/fsq")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module17 = require("@luauforge/deferred/fXS")
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local guildedLogoWhiteAsset = require("@luauforge/bundled/dBe").Constants.GuildedLogoWhiteAsset
local constants = require("@luauforge/bundled/dBe").Analytics.Constants

local clickCommunityLinkEvent = require("@luauforge/bundled/dBe").Analytics.Events.clickCommunityLinkEvent

local module19 = require("@luauforge/deferred/fXb")

local module20 = require("@luauforge/deferred/fXV")

local module21 = require("@luauforge/deferred/fXW")
local module22 = require("@luauforge/deferred/fXX")

local module23 = require("@luauforge/bundled/fWW")

local fFlagLuaAppUseExperienceLogoTrayInGameInfoList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUseExperienceLogoTrayInGameInfoList

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local module24 = require("@luauforge/deferred/fXY")

local fFlagLuaAppUpdateContentDescriptorsTranslation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUpdateContentDescriptorsTranslation

local module25 = require("@luauforge/deferred/fXN")
local constants2 = module25.Constants
local edpStoreImpressionsDetector = module25.EdpStoreImpressionsDetector
local module26 = require("@luauforge/deferred/fXQ")
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/Localization").abbreviateCount

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local module27 = require("@luauforge/deferred/fXe")

local module28 = require("@luauforge/deferred/fXs")

local fFlagLuaAppBadgesSeeAllEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppBadgesSeeAllEnabled

local fFlagLuaAppAddSocialLinkClickTelemetryToEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp

local fFlagLuaAppHideEdpStoreForUnplayable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppHideEdpStoreForUnplayable

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/fzr").Utils.getSubscriptionPurchaseCloseCallback

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGamePassesDataHydrationMigrationEnabled

local fFlagLuaAppEdpNonSduiBuildAttribution = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpNonSduiBuildAttribution

local module29 = require("@luauforge/bundled/dPI")
local module30 = require("@luauforge/deferred/fYa")
local module31 = require("@luauforge/deferred/fYb")
local module32 = require("@luauforge/deferred/fYc")

local extended = module.PureComponent:extend("GameInfoList")

local v5 = {
	All = "Feature.GameDetails.Label.GenreAll",
	Adventure = "Feature.GameDetails.Label.GenreAdventure",
	Building = "Feature.GameDetails.Label.GenreBuilding",
	Comedy = "Feature.GameDetails.Label.GenreComedy",
	Fighting = "Feature.GameDetails.Label.GenreFighting",
	FPS = "Feature.GameDetails.Label.GenreFPS",
	Horror = "Feature.GameDetails.Label.LabelGenreHorror",
	Medieval = "Feature.GameDetails.Label.GenreMedieval",
	Military = "Feature.GameDetails.Label.GenreMilitary",
	Naval = "Feature.GameDetails.Label.GenreNaval",
	RPG = "Feature.GameDetails.Label.GenreRPG",
	["Sci-Fi"] = "Feature.GameDetails.Label.GenreSciFi",
	Sports = "Feature.GameDetails.Label.LabelGenreSports",
	["Town and City"] = "Feature.GameDetails.Label.LabelGenreTownAndCity",
	Western = "Feature.GameDetails.Label.GenreWestern"
}

extended.defaultProps = { leftPadding = 0, rightPadding = 0 }

function extended:init()
	function self.createGamePassPreviewRow(universeId, p3, props, p4)
		local rootPlaceId = self.props.gameDetail and self.props.gameDetail.rootPlaceId
		local passes = self.props.passes

		if not (passes and rootPlaceId) then
			return
		end

		local leftPadding = self.props.leftPadding
		local rightPadding = self.props.rightPadding
		local width = self.props.width

		local ref = module.createRef()
		local ref2 = module.createRef()
		ref2.current = AppCommonLib.Signal.new()

		local function fn(p5)
			ref2.current:fire()
		end

		local element = module.createElement(edpStoreImpressionsDetector, {
			parentRef = ref,
			scrollViewPositionChangedSignal = ref2,
			impressionsTag = constants2.ImpressionsTags.Preview,
			parameters = {
				universeId = universeId,
				productType = constants2.StoreEnums.ProductType.GamePasses,
				locationType = constants2.StoreEnums.LocationType.Edp
			}
		})

		local function fn2(current)
			ref.current = current
			impressionsTagUtility.AddTag(ref, constants2.ImpressionsTags.Preview, p3)
		end

		local createElement = module.createElement
		local v7 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = p3
		}

		local children = {
			UIListLayout = module.createElement("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			PassesAndGears = 0,
			GamePassPreview = 0,
			ImpressionsDetecter = 0
		}

		local createElement2 = module.createElement
		local v9 = {
			Size = UDim2.new(1, 0, 0, 57),
			useVerifiedBadgeEmojiWrapper = props.useVerifiedBadgeEmojiWrapper,
			LayoutOrder = 1,
			viewWidth = 0,
			placeId = 0,
			infoName = 0,
			infoData = 0,
			linkPage = 0,
			linkView = 0,
			universeId = 0,
			leftPadding = 0,
			rightPadding = 0,
			topPadding = 10,
			bottomPadding = 10,
			analyticsSubPage = 0,
			testId = 0
		}

		local v10 = if module28() then width else nil
		v9.viewWidth = v10
		v9.placeId = rootPlaceId
		v9.infoName = props.infoName
		v9.infoData = props.infoData
		v9.linkPage = props.linkPage
		v9.linkView = props.linkView
		v9.universeId = universeId
		v9.leftPadding = leftPadding
		v9.rightPadding = rightPadding

		v9.analyticsSubPage = props.analyticsSubPage
		v9.testId = props.testId
		children.PassesAndGears = createElement2(module12, v9)

		local createElement3 = module.createElement
		local v12 = {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			[module.Ref] = fn2,
			[module.Change.AbsolutePosition] = fn
		}
		local v13 = {
			Layout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Padding = module.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, leftPadding),
				PaddingRight = UDim.new(0, rightPadding)
			}),
			Grid = 0
		}

		local createElement4 = module.createElement

		local v16 = if module26() then constants2.StoreEnums.LocationType.Edp else nil
		v13.Grid = createElement4(module13, {
			universeId = universeId,
			passes = passes,
			numRows = 1,
			viewWidth = width,
			textSizeOffset = p4,
			locationType = v16
		})
		children.GamePassPreview = createElement3("Frame", v12, v13)

		children.ImpressionsDetecter = element
		return createElement("Frame", v7, children)
	end

	function self.checkCommunityLinkExposureLogging()
		if self.props.communityLink then
			IXPService:LogUserLayerExposure(appUserLayers.EDPCommunityLinksLayer)
		end
	end
end

function extended:makeGameInfoListData()
	local localization = self.props.localization

	local universeId = self.props.universeId
	local maxPlayers = self.props.gameDetail.maxPlayers
	local creator = self.props.gameDetail.creator
	local id = self.props.gameDetail.creator.id
	local kind = self.props.gameDetail.creator.type
	local name = self.props.gameDetail.creator.name
	local creatorVerified = self.props.creatorVerified

	local v6 = self.props.gameDetail.genre
	local genre_l1 = self.props.gameDetail.genre_l1
	local genre_l2 = self.props.gameDetail.genre_l2

	local dateTime = DateTime.fromIsoDate(self.props.gameDetail.created)
	local dateTime2 = DateTime.fromIsoDate(self.props.gameDetail.updated)
	local v7 = self.props.showPasses
	local v8 = self.props.showSubscriptionProducts
	local v9 = self.props.showDeveloperProducts
	local v10 = self.props.showBadges
	local groupLink = self.props.groupLink
	local displayName, minimumAgeDisplay

	if self.props.ageRecommendations then
		local summary = self.props.ageRecommendations.summary

		if summary and summary.ageRecommendation then
			displayName = summary.ageRecommendation.displayName
		end

		if summary and summary.ageRecommendation then
			minimumAgeDisplay = summary.ageRecommendation.minimumAgeDisplay
		end
	end

	local enableGroupLinks = self.props.enableGroupLinks
	local showBadgesRow = self.props.showBadgesRow
	local showCreatedRow = self.props.showCreatedRow
	local showDeveloperRow = self.props.showDeveloperRow
	local showRNVDeveloper = self.props.showRNVDeveloper
	local showGamepassesRow = self.props.showGamepassesRow
	local showGenreRow = self.props.showGenreRow
	local showSubgenreRow = self.props.showSubgenreRow
	local showMaxPlayersRow = self.props.showMaxPlayersRow
	local v11 = if module21() then self.props.showServersRow else self.props.showGamepassesRow
	local showUpdatedRow = self.props.showUpdatedRow
	local experienceVoiceEnabled = self.props.experienceVoiceEnabled
	local experienceVideoEnabled = self.props.experienceVideoEnabled
	local enableGamePassPreview = self.props.enableGamePassPreview

	if showBadgesRow == false then
		v10 = false
	end

	if showGamepassesRow == false then
		v7 = false
		v8 = false
		v9 = false
	end

	self.gameInfoListData = {}

	local locale = localization:GetLocale()
	local formatLocalTime = dateTime:FormatLocalTime("l", locale)
	local formatLocalTime2 = dateTime2:FormatLocalTime("l", locale)

	if
		v7
		and enableGamePassPreview
		and (not fFlagLuaAppHideEdpStoreForUnplayable or self.props.isPlayable)
	then
		table.insert(self.gameInfoListData, {
			renderFunction = self.createGamePassPreviewRow,
			itemInfo = {
				infoName = "Feature.GameDetails.Label.Store",
				infoData = "",
				linkView = module8.PassesPage,
				analyticsSubPage = "PassesAndGear",
				testId = "--store-row-tail"
			}
		})
	end

	local communityLink = self.props.communityLink
	local communityLinksEnabled = self.props.communityLinksEnabled
	local communityLinkVariant = self.props.communityLinkVariant

	if communityLinksEnabled and communityLinkVariant == "infolist" and communityLink then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Community",
			infoData = "",
			infoIcon = guildedLogoWhiteAsset,
			linkUrl = getCommunityUrl(communityLink.communityId),
			testId = "--community-row-tail",
			linkClickCallback = function()
				clickCommunityLinkEvent(self.props.eventIngest, constants.Context.ExperienceInfoList, {
					guildedServerId = communityLink.communityId,
					entityType = "universe",
					entityId = universeId
				})
			end
		})
	end

	local edpServerIxpVariables = self.props.edpServerIxpVariables

	if
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module19.getShouldInterleaveSdui())
		and edpServerIxpVariables
		and edpServerIxpVariables.showVisitsInInfoList == true
	then
		local visits = self.props.gameDetail and self.props.gameDetail.visits or 0
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Visits",
			infoData = abbreviateCount(visits, locale) or "--",
			testId = "--visits-row-tail"
		})
	end

	local gameInfoListData = self.gameInfoListData
	local v12 = {
		infoName = not self.props.ageRecommendationHeader and "Feature.GameDetails.Label.ContentMaturity" or self.props.ageRecommendationHeader,
		infoData = displayName or localization:Format("Feature.GameDetails.Label.Unavailable"),
		linkView = 0,
		analyticsSubPage = 0,
		disableInfoNameLocalization = 0,
		testId = "--content-maturity-row-tail"
	}
	local v13 = if displayName then module8.ExperienceGuidelinesExplained else nil
	v12.linkView = v13
	v12.analyticsSubPage = module8.ExperienceGuidelinesExplained
	v12.disableInfoNameLocalization = self.props.ageRecommendationHeader ~= nil
	table.insert(gameInfoListData, v12)

	if minimumAgeDisplay and minimumAgeDisplay ~= "" then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Age",
			infoData = minimumAgeDisplay,
			testId = "--age-row-tail"
		})
	end

	if
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module19.getShouldInterleaveSdui())
		and edpServerIxpVariables
		and edpServerIxpVariables.showContentDescriptorsInInfoList == true
		and self.props.ageRecommendations
		and self.props.ageRecommendations.descriptorUsages
		and #self.props.ageRecommendations.descriptorUsages > 0
	then
		for i, descriptorUsage in ipairs(self.props.ageRecommendations.descriptorUsages) do
			if descriptorUsage.name == "strong-language" and descriptorUsage.contains then
				table.insert(self.gameInfoListData, {
					infoName = fFlagLuaAppUpdateContentDescriptorsTranslation and "Feature.AgeGuidelines.Label.CreatorEnabled" or "Feature.AccountSettings.Heading.Communication",
					infoData = localization:Format("Feature.AgeGuidelines.DisplayName.StrongLanguage"),
					testId = "--content-descriptors-row-tail"
				})
				break
			end
		end
	end

	if showDeveloperRow or showRNVDeveloper and creator.isRNVAccount then
		if
			module23.FFlagIsSetupEnabled
			and self.props.communityProfilePageEnabled
			and kind == Enum.CreatorType.Group.Name
		then
			table.insert(self.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Developer",
				infoData = name,
				linkView = "CommunityProfilePlatform",
				linkViewData = id,
				analyticsSubPage = "Developer",
				useVerifiedBadgeEmojiWrapper = creatorVerified,
				testId = "--developer-row-tail"
			})
		elseif kind == Enum.CreatorType.User.Name then
			table.insert(self.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Developer",
				infoData = name,
				linkView = "UserProfilePlatform",
				linkViewData = id,
				analyticsSubPage = "Developer",
				useVerifiedBadgeEmojiWrapper = creatorVerified,
				testId = "--developer-row-tail"
			})
		else
			table.insert(self.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Developer",
				infoData = name,
				linkPage = module16.game.info.creator({
					creatorType = kind,
					creatorId = id
				}),
				analyticsSubPage = "Developer",
				useVerifiedBadgeEmojiWrapper = creatorVerified,
				testId = "--developer-row-tail"
			})
		end
	end

	if showMaxPlayersRow then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.MaxPlayers",
			infoData = tostring(maxPlayers),
			testId = "--server-size-row-tail"
		})
	end

	local v14 = nil

	if genre_l1 and genre_l1 ~= "" then
		v14 = genre_l1
	elseif module22 == "N/A" then
		v14 = localization:Format("Feature.GameDetails.Label.Unavailable")
	elseif module22 == "All" then
		v14 = localization:Format("Feature.GameDetails.Label.GenreAll")
	end

	local v15 = v5[v6]

	if v14 then
		v6 = v14
	elseif v15 ~= nil then
		v6 = localization:Format(v15)
	end

	if showGenreRow then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Genre",
			infoData = v6,
			testId = "--genre-row-tail"
		})
	end

	if showSubgenreRow and genre_l2 and genre_l2 ~= "" then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Subgenre",
			infoData = genre_l2,
			testId = "--subgenre-row-tail"
		})
	end

	if showCreatedRow then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Created",
			infoData = formatLocalTime,
			testId = "--created-row-tail"
		})
	end

	if showUpdatedRow then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Updated",
			infoData = formatLocalTime2,
			testId = "--updated-row-tail"
		})
	end

	if module20() then
		local v16 = localization:Format("Feature.GameDetails.Label.NotSupported")
		local v17 = localization:Format("Feature.GameDetails.Label.NotSupported")

		if experienceVideoEnabled then
			v17 = localization:Format("Feature.GameDetails.Label.Supported")
		end

		if experienceVoiceEnabled then
			v16 = localization:Format("Feature.GameDetails.Label.Supported")
		end

		if not self.props.isLocalUserUnder13 then
			table.insert(self.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.VoiceChat",
				infoData = v16,
				testId = "--voice-chat-row-tail"
			})
		end

		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Camera",
			infoData = v17,
			testId = "--camera-row-tail"
		})
	else
		local v16 = {}

		if experienceVoiceEnabled and not self.props.isLocalUserUnder13 then
			table.insert(v16, localization:Format("Feature.GameDetails.Label.Microphone"))
		end

		if experienceVideoEnabled then
			table.insert(v16, localization:Format("Feature.GameDetails.Label.Camera"))
		end

		if #v16 < 1 then
			table.insert(v16, localization:Format("Feature.GameDetails.Label.None"))
		end

		table.insert(self.gameInfoListData, {
			infoName = "Feature.AccountSettings.Heading.Communication",
			infoData = table.concat(v16, ", "),
			testId = "--communication-row-tail"
		})
	end

	if
		not enableGamePassPreview
		and (v7 or v8 or v9)
		and (not fFlagLuaAppHideEdpStoreForUnplayable or self.props.isPlayable)
	then
		table.insert(self.gameInfoListData, {
			infoName = "Feature.GameDetails.Label.Store",
			infoData = "",
			linkView = module8.PassesPage,
			analyticsSubPage = "PassesAndGear",
			testId = "--store-row-tail"
		})
	end

	if v10 then
		local gameInfoListData2 = self.gameInfoListData

		local v17 = if not fFlagLuaAppBadgesSeeAllEnabled then module16.game.info.badges({
			universeId = universeId
		}) else nil

		local v18 = if fFlagLuaAppBadgesSeeAllEnabled then module8.BadgesSeeAll else nil
		table.insert(gameInfoListData2, {
			infoName = "CommonUI.Features.Label.Badges",
			infoData = "",
			linkPage = v17,
			linkView = v18,
			analyticsSubPage = "Badges",
			testId = "--badges-row-tail"
		})
	end

	if v11 then
		local gameInfoListData2 = self.gameInfoListData
		local v16 = {
			infoName = "Feature.GameDetails.Label.Servers",
			infoData = "",
			linkPage = module16.game.info.servers({ universeId = universeId }),
			analyticsSubPage = "Servers",
			testId = "--servers-row-tail",
			onClose = 0
		}

		local v17 = if fFlagEnableBlackbirdPageCloseCallback and getSubscriptionPurchaseCloseCallback then getSubscriptionPurchaseCloseCallback() else nil
		v16.onClose = v17
		table.insert(gameInfoListData2, v16)
	end

	if groupLink and enableGroupLinks then
		if
			module23.FFlagIsSetupEnabled
			and self.props.communityProfilePageEnabled
			and groupLink.communityId ~= nil
		then
			table.insert(self.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Group",
				infoData = "",
				linkView = "CommunityProfilePlatform",
				linkViewData = groupLink.communityId,
				analyticsSubPage = "Group",
				testId = "--group-row-tail"
			})
		else
			table.insert(self.gameInfoListData, {
				infoName = "Feature.GameDetails.Label.Group",
				infoData = "",
				linkPage = groupLink.url,
				analyticsSubPage = "Group",
				testId = "--group-row-tail"
			})
		end
	end
end

function extended:createSocialMediaRow(universeId, p3)
	local formatted = `EXPERIENCE_SOCIAL_LINKS_{universeId}`

	local ref = module.createRef()

	local signal = AppCommonLib.Signal.new()

	local leftPadding = self.props.leftPadding
	local rightPadding = self.props.rightPadding
	local createElement = module.createElement
	local v7 = {
		LayoutOrder = p3,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		[module.Ref] = ref,
		[module.Change.AbsolutePosition] = function(p4)
			signal:fire()
		end
	}
	local v8 = {
		ListLayout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		EdpSocialLinksImpressionsDetector = 0,
		SocialLinks = 0
	}

	local createElement2 = module.createElement
	local v10 = {
		parentRef = ref,
		scrollViewPositionChangedSignal = signal,
		pageContext = module8.GameDetail,
		impressionsTag = formatted,
		socialLinks = 0,
		universeId = 0
	}

	local v11 = if self.props.socialLinks then self.props.socialLinks.externalLinks else nil
	v10.socialLinks = v11
	v10.universeId = universeId
	v8.EdpSocialLinksImpressionsDetector = createElement2(module14, v10)
	local v12

	if fFlagLuaAppUseExperienceLogoTrayInGameInfoList then
		if self.props.socialLinks and self.props.socialLinks.externalLinks then
			local createElement3 = module.createElement
			local v14 = {
				socialLinks = self.props.socialLinks.externalLinks,
				linking = self.props.linking,
				openLeaveRobloxAlertUIBlox = self.props.openLeaveRobloxAlertUIBlox,
				closeAlert = self.props.closeAlert,
				impressionsTag = formatted,
				universeId = 0
			}

			local v15 = if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then self.props.universeId else nil
			v14.universeId = v15
			v12 = createElement3(module24, v14)
		end
	else
		v12 = module.createElement(module17, {
			universeId = universeId,
			impressionsTag = formatted
		})
	end

	v8.SocialLinks = v12
	return createElement("Frame", v7, v8)
end

function extended:createCommunityRow(p3)
	local leftPadding = self.props.leftPadding
	local rightPadding = self.props.rightPadding

	return module.createElement("Frame", {
		LayoutOrder = p3,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Padding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding),
			PaddingTop = UDim.new(0, 30),
			PaddingBottom = UDim.new(0, 10)
		}),
		ExperienceCommunityLink = module.createElement(experienceCommunityLink, {
			communityInfo = self.props.communityLink,
			experienceName = self.props.gameDetail.name,
			universeId = self.props.universeId
		})
	})
end

function extended:render()
	local textSizeOffset = self.props.textSizeOffset
	self:makeGameInfoListData()

	local rootPlaceId = self.props.gameDetail.rootPlaceId
	local universeId = self.props.universeId
	local showSocial = self.props.showSocial

	local layoutOrder = self.props.LayoutOrder
	local leftPadding = self.props.leftPadding
	local rightPadding = self.props.rightPadding

	local children = {
		Layout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}

	return withStyle(function(p2)
		local color = p2.Theme.Divider.Color
		local transparency = p2.Theme.Divider.Transparency

		local count = #self.gameInfoListData
		local v6 = 0

		for i, v7 in ipairs(self.gameInfoListData) do
			local renderFunction = v7.renderFunction
			local v8 = v6 + 1

			if renderFunction then
				children["GameInfoRow" .. i] = renderFunction(universeId, v8, v7.itemInfo, textSizeOffset)
			else
				local children2 = children
				local v9 = "GameInfoRow" .. i
				local createElement = module.createElement
				local v11 = {
					Size = UDim2.new(1, 0, 0, 57),
					useVerifiedBadgeEmojiWrapper = v7.useVerifiedBadgeEmojiWrapper,
					LayoutOrder = v8,
					placeId = rootPlaceId,
					infoName = v7.infoName,
					infoData = v7.infoData,
					infoIcon = v7.infoIcon,
					linkPage = v7.linkPage,
					linkView = v7.linkView,
					linkViewData = 0,
					linkUrl = 0,
					linkClickCallback = 0,
					universeId = 0,
					leftPadding = 0,
					rightPadding = 0,
					topPadding = 10,
					bottomPadding = 10,
					analyticsSubPage = 0,
					disableInfoNameLocalization = 0,
					testId = 0,
					onClose = 0
				}
				local v12 = if module23.FFlagIsSetupEnabled then v7.linkViewData else nil
				v11.linkViewData = v12
				v11.linkUrl = v7.linkUrl
				v11.linkClickCallback = v7.linkClickCallback
				v11.universeId = universeId
				v11.leftPadding = leftPadding
				v11.rightPadding = rightPadding

				v11.analyticsSubPage = v7.analyticsSubPage
				v11.disableInfoNameLocalization = v7.disableInfoNameLocalization
				v11.testId = v7.testId
				local v13 = if fFlagEnableBlackbirdPageCloseCallback then v7.onClose else nil
				v11.onClose = v13
				children2[v9] = createElement(module12, v11)
			end

			v6 = v8 + 1
			children["Divider" .. i] = module.createElement("Frame", {
				Size = UDim2.new(1, -leftPadding, 0, 1),
				BackgroundColor3 = color,
				BackgroundTransparency = transparency,
				BorderSizePixel = 0,
				LayoutOrder = v6
			})
		end

		if fFlagLuaAppEdpNonSduiBuildAttribution and module31(self.props.gameDetail) then
			v6 += 1
			children.BuildDisclaimer = module.createElement(module32, {
				layoutOrder = v6,
				horizontalPadding = leftPadding,
				rightPadding = rightPadding
			})
		end

		local communityLinksEnabled = self.props.communityLinksEnabled
		local communityLinkVariant = self.props.communityLinkVariant

		if communityLinksEnabled and communityLinkVariant == "banner" then
			local v7 = if self.props.communityLink then self:createCommunityRow(v6 + 1) or nil else nil

			if v7 ~= nil then
				count += 1
				v6 += 1
				children["GameInfoRow" .. count] = v7
			end
		end

		local v7 = v6 + 1
		local v8 = showSocial and self:createSocialMediaRow(universeId, v7) or nil

		if v8 ~= nil then
			children["GameInfoRow" .. count + 1] = v8
		end

		return module.createElement("Frame", {
			Size = UDim2.new(1, leftPadding + rightPadding, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ClipsDescendants = false
		}, children)
	end)
end

function extended.didMount(p2)
	p2.checkCommunityLinkExposureLogging()
end

function extended.didUpdate(p2, data, p3)
	if fFlagSignalsNavP3fGameDetails then
		if data.isOnUnownedPassWebview and not p2.props.isOnUnownedPassWebview then
			if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
				module29.Game.getGamePassStore(false).fetchPassesForUniverse(p2.props.universeId)
			else
				p2.props.fetchGamePasses(p2.props.networking, p2.props.universeId)
			end
		end
	else
		local topPage = p2.props.topPage
		local topPage2 = data.topPage

		if topPage.name ~= topPage2.name and topPage2.name == module8.GenericWebPage then
			local v6 = if topPage2.extraProps then topPage2.extraProps.passOwned else nil

			if v6 == false then
				if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
					module29.Game.getGamePassStore(false).fetchPassesForUniverse(p2.props.universeId)
				else
					p2.props.fetchGamePasses(p2.props.networking, p2.props.universeId)
				end
			end
		end
	end

	if not data.communityLink then
		p2.checkCommunityLinkExposureLogging()
	end
end

local v6 = module4(function(list)
	local result = {}

	if not list then
		return result
	end

	for i, item in ipairs(list) do
		if item.price ~= nil then
			table.insert(result, item)
		end
	end

	return result
end)

local function getTopPageInfo(p2)
	local v7

	if fFlagUseNavigationSelectors then
		v7 = selectors.selectLegacyHistory(p2)
	else
		v7 = p2.Navigation.history
	end

	local v8 = v7[#v7]
	return v8[#v8]
end

local v7 = useSheetNavigation.connect(function(data, p2)
	local v8 = data.GamePasses and v6(data.GamePasses[p2.universeId])
	local gameSubscriptionProduct = data.GameSubscriptionProducts[p2.universeId]
	local gameDeveloperProduct = data.GameDeveloperProducts[p2.universeId]
	local gameBadge = data.GameBadges[p2.universeId]

	local v9 = gameSubscriptionProduct and #gameSubscriptionProduct > 0
	local v10 = gameDeveloperProduct and #gameDeveloperProduct > 0

	local gameSocialLink = data.GameSocialLinks[p2.universeId]
	local groupLink = gameSocialLink and gameSocialLink.groupLink

	local creatorOfGameVerified = VerifiedBadges.isCreatorOfGameVerified(
		data,
		(fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp) and {
			universeId = p2.universeId,
			shouldUseV2GameDetails = true
		} or p2
	)

	local v11 = data.CommunityLinks.ExperienceCommunityLinks[p2.universeId] or nil

	local v12 = not v8 or #v8 ~= 0

	local v13 = not gameBadge or #gameBadge ~= 0

	local isUserOptIn = data.VoiceChatOptInStatus.isUserOptIn or false
	local v14, v15

	if data.ShowAgeVerificationOverlay[p2.universeId] == nil then
		v14 = false
		v15 = false
	else
		v14 = data.ShowAgeVerificationOverlay[p2.universeId].isUniverseEnabledForVoice or false
		v15 = data.ShowAgeVerificationOverlay[p2.universeId].isUniverseEnabledForAvatarVideo or false
	end

	local v17 = if fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp then data.GameDetailsV2[p2.universeId] else data.GameDetails[p2.universeId]

	if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		v12 = nil
	end

	if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		v8 = nil
	end

	local v18 = if not fFlagUseSignalsForIsLocalUserUnder13 then data.IsLocalUserUnder13 else nil
	local v19

	if not fFlagSignalsNavP3fGameDetails then
		local v20

		if fFlagUseNavigationSelectors then
			v20 = selectors.selectLegacyHistory(data)
		else
			v20 = data.Navigation.history
		end

		local v21 = v20[#v20]
		v19 = v21[#v21]
	end

	local v16 = {
		gameDetail = v17,
		creatorVerified = creatorOfGameVerified,
		showPasses = v12,
		passes = v8,
		showSubscriptionProducts = v9,
		showDeveloperProducts = v10,
		showBadges = v13,
		groupLink = groupLink,
		communityLink = v11,
		userVoiceEnabled = isUserOptIn,
		experienceVoiceEnabled = v14,
		experienceVideoEnabled = v15,
		isLocalUserUnder13 = v18,
		topPage = v19,
		ageRecommendationHeader = data.AgeRecommendationHeaders.headerDisplayName,
		socialLinks = gameSocialLink,
		isPlayable = 0
	}

	local v20 = if fFlagLuaAppHideEdpStoreForUnplayable then data.PlayabilityStatus and data.PlayabilityStatus[p2.universeId] and data.PlayabilityStatus[p2.universeId].isPlayable else nil
	v16.isPlayable = v20
	return v16
end, function(callback)
	return {
		fetchGamePasses = not fFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p2, p3)
			return callback(module9(p2, p3))
		end or nil,
		openLeaveRobloxAlertUIBlox = fFlagLuaAppUseExperienceLogoTrayInGameInfoList and function(p2)
			callback(module10(p2))
		end or nil,
		closeAlert = fFlagLuaAppUseExperienceLogoTrayInGameInfoList and function()
			callback(module11())
		end or nil
	}
end)(extended)

local v8 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.EDPCommunityLinksLayer, module23.EnableCommunityProfilePageExperimentLayer },
	function(p2)
		local communityLinkDisplayConfig = (p2[appUserLayers.EDPCommunityLinksLayer] or {}).communityLinkDisplayConfig
			or {}
		local v9 = if module23.FFlagIsSetupEnabled then module23.isFeatureActive(p2) else nil

		local v10 = {
			communityLinksEnabled = communityLinkDisplayConfig.inTreatment,
			communityLinkVariant = communityLinkDisplayConfig.linkVariant,
			communityProfilePageEnabled = 0
		}

		if not module23.FFlagIsSetupEnabled then
			v9 = nil
		end

		v10.communityProfilePageEnabled = v9
		return v10
	end,
	false
)(v7)

local v9 = roactAppPolicy.connect(function(data, p2)
	return {
		enableGroupLinks = data.getSocialGroupLinks(),
		showBadgesRow = data.getGameInfoShowBadges(),
		showCreatedRow = data.getGameInfoShowCreated(),
		showDeveloperRow = data.getGameInfoListDeveloper(),
		showRNVDeveloper = data.getGameInfoListShowRNVDeveloper(),
		showGamepassesRow = data.getGameInfoShowGamepasses(),
		showGenreRow = data.getGameInfoShowGenre(),
		showSubgenreRow = data.getGameInfoShowSubgenre(),
		showMaxPlayersRow = data.getGameInfoShowMaxPlayers(),
		showServersRow = data.getGameInfoShowServers(),
		showUpdatedRow = data.getGameInfoShowUpdated()
	}
end)(v8)

local connect = roactServices.connect

if not fFlagLuaAppUseExperienceLogoTrayInGameInfoList then
	appLinking = nil
end

local v11 = connect({
	localization = module2,
	networking = module5,
	eventIngest = module6,
	linking = appLinking
})(v9)

return function(p2)
	local v12 = useTextSizeOffset()
	local v13

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v13 = module27()
	end

	local v14, v15

	if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		local v16 = module30(p2.universeId)

		if v16 then
			v14 = v6(v16)
		end

		v15 = v14 == nil or #v14 > 0
	end

	local v16

	if fFlagSignalsNavP3fGameDetails then
		v16 = useSignalState((React.useMemo(function()
			local legacyNavigationStore = getLegacyNavigationStore(false)
			return Signals.createComputed(function(p3): boolean
				local currentPage = legacyNavigationStore.getCurrentPage(p3)

				return currentPage ~= nil
					and currentPage.name == module8.GenericWebPage
					and currentPage.extraProps ~= nil
					and currentPage.extraProps.passOwned == false
			end)
		end, {})))
	end

	local v17

	if fFlagUseSignalsForIsLocalUserUnder13 then
		v17 = useSignalState(getIsLocalUserUnder13Store(false).getIsLocalUserUnder13)
	end

	local join = Cryo.Dictionary.join

	if not fFlagUseSignalsForIsLocalUserUnder13 then
		v17 = nil
	end

	if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module19.getShouldInterleaveSdui()) then
		v13 = nil
	end

	if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		v14 = nil
	end

	if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		v15 = nil
	end

	if not fFlagSignalsNavP3fGameDetails then
		v16 = nil
	end

	local v19 = join(p2, {
		textSizeOffset = v12,
		isLocalUserUnder13 = v17,
		edpServerIxpVariables = v13,
		passes = v14,
		showPasses = v15,
		isOnUnownedPassWebview = v16
	})

	return module.createElement(v11, v19)
end
