local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Foundation")
local GameDetailRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameDetailRodux")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Http")
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Loggers")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Localization")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/NavigationRodux")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppHooks")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RoactUtils")

local appPage = RobloxAppEnums.AppPage
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local dialog = Foundation.Dialog
local view = Foundation.View
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppNavigation").NavigationCommands else nil

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = Localization.Hooks.useLocalization
local useRoactService = RobloxAppHooks.useRoactService
local flaggedMutedError = Loggers.flaggedMutedError
local roactNetworking = RoactServiceTags.RoactNetworking
local apiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local retrievalStatus = Http.Enum.RetrievalStatus
local SponsoredUserCohort = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/Enums/SponsoredUserCohort")
local omniRecommendationsContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryTypes").OmniRecommendationsContentType

local fStringLuaAppAdPreferencesUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags").FStringLuaAppAdPreferencesUrl
local fFlagLuaAppEnableHomepageOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags").FFlagLuaAppEnableHomepageOneByTwoTile

local function useCreatorName(universeId)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)

	if fFlagLuaAppEnableHomepageOneByTwoTile then
		local v7 = not (universeId == nil) and universeId ~= ""

		local v8 = useSelector(function(p2)
			return v7 and apiFetchGameDetails.GetFetchingStatus(p2, universeId) or nil
		end)

		local v9 = useSelector(function(p2)
			return v7 and p2.GameDetails[universeId] or nil
		end)

		React.useEffect(function()
			if v7 and not v9 and v8 ~= retrievalStatus.Fetching then
				v5(apiFetchGameDetails.Fetch(v6, { universeId }))
			end
		end, { v7, universeId, v9, v8, v5, v6 })

		return v9 and v9.creator and v9.creator.name or nil, v8
	else
		local v7 = useSelector(function(p2)
			return universeId and apiFetchGameDetails.GetFetchingStatus(p2, universeId) or nil
		end)

		local v8 = useSelector(function(p2)
			return universeId and p2.GameDetails[universeId] or nil
		end)

		React.useEffect(function()
			if universeId and not v8 and v7 ~= retrievalStatus.Fetching then
				v5(apiFetchGameDetails.Fetch(v6, { universeId }))
			end
		end, { universeId, v8, v7, v5, v6 })

		return v8 and v8.creator and v8.creator.name or nil, v7
	end
end

local function getSponsoredDisclosureTranslationKey(p2): string
	if p2 == SponsoredUserCohort.UnderEighteen then
		return "Feature.GameDetails.Message.SponsoredDisclosure.U18"
	end

	if p2 == SponsoredUserCohort.EighteenPlusPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosure.O18PersonalizedNoLink"
	end

	if p2 == SponsoredUserCohort.EighteenPlusNonPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosure.O18NonPersonalizedNoLink"
	end

	return "Feature.GameDetails.Message.SponsoredDisclosure.U18"
end

local function getSponsoredDisclosureNoUniverseTranslationKey(p2): string
	if p2 == SponsoredUserCohort.UnderEighteen then
		return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.U18"
	end

	if p2 == SponsoredUserCohort.EighteenPlusPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.O18PersonalizedNoLink"
	end

	if p2 == SponsoredUserCohort.EighteenPlusNonPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.O18NonPersonalNoLink"
	end

	return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.U18"
end

local function resolveSponsoredDisclosure(payerName, p2, p3, p4, sponsoredUserCohort, data)
	local v5 = not (payerName == nil) and payerName ~= ""

	if not v5 then
		flaggedMutedError("WhyThisAdDisclosureError", "Missing payerName in WhyThisAdModal")
		return data.sponsoredDisclosureError, false
	end

	local v6 = sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized
		or sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized

	if p2 then
		if p3 then
			flaggedMutedError(
				"WhyThisAdDisclosureError",
				"Unexpected universeId for AdLink in WhyThisAdModal"
			)
		end

		return data.sponsoredDisclosureNoUniverse, v6
	end

	if not p3 then
		flaggedMutedError("WhyThisAdDisclosureError", "Missing universeId in WhyThisAdModal")
		return data.sponsoredDisclosureError, v6
	end

	if p4 then
		return data.sponsoredDisclosure, v6
	end

	flaggedMutedError("WhyThisAdDisclosureError", "Missing creatorName in WhyThisAdModal")
	return data.sponsoredDisclosureError, v6
end

local function WhyThisAdModal(props)
	local v5 = useDispatch()
	local v6, v7 = useCreatorName(props.universeId)

	local sponsoredUserCohort = props.sponsoredUserCohort
	local v9 = {
		sponsoredDisclosure = {
			sponsoredUserCohort == SponsoredUserCohort.UnderEighteen and "Feature.GameDetails.Message.SponsoredDisclosure.U18" or sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized and "Feature.GameDetails.Message.SponsoredDisclosure.O18PersonalizedNoLink" or sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized and "Feature.GameDetails.Message.SponsoredDisclosure.O18NonPersonalizedNoLink" or "Feature.GameDetails.Message.SponsoredDisclosure.U18",
			CreatorName = v6,
			PayerName = props.payerName
		},
		sponsoredDisclosureError = "Feature.GameDetails.Message.SponsoredDisclosure.Error",
		whyThisAd = "Feature.GameDetails.Label.WhyThisAd",
		adPreferences = "Feature.GameDetails.Message.AdPreferences",
		sponsoredDisclosureNoUniverse = 0
	}
	local v10

	if fFlagLuaAppEnableHomepageOneByTwoTile then
		local sponsoredUserCohort2 = props.sponsoredUserCohort
		v10 = {
			sponsoredUserCohort2 == SponsoredUserCohort.UnderEighteen and "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.U18" or sponsoredUserCohort2 == SponsoredUserCohort.EighteenPlusPersonalized and "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.O18PersonalizedNoLink" or sponsoredUserCohort2 == SponsoredUserCohort.EighteenPlusNonPersonalized and "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.O18NonPersonalNoLink" or "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.U18",
			PayerName = props.payerName
		}
	end

	v9.sponsoredDisclosureNoUniverse = v10
	local v11 = useLocalization(v9)

	local v12 = React.useCallback(function()
		v5(closeCentralOverlay())
	end, { v5 })

	local v13 = React.useCallback(function()
		v5(closeCentralOverlay())
		local v14 = {
			name = appPage.GenericWebPage,
			detail = fStringLuaAppAdPreferencesUrl,
			extraProps = { title = v11.adPreferences }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v14))
		else
			v5(navigateDown(v14))
		end
	end, { v5, v11.adPreferences })

	if v7 == retrievalStatus.NotStarted or v7 == retrievalStatus.Fetching then
		return nil
	end

	local v14 = nil
	local v15

	if fFlagLuaAppEnableHomepageOneByTwoTile then
		local v16 = props.contentType == omniRecommendationsContentType.AdLink
		local v17 = not (props.universeId == nil) and props.universeId ~= ""
		v15, v14 = resolveSponsoredDisclosure(props.payerName, v16, v17, v6, props.sponsoredUserCohort, v11)
	elseif v6 and props.payerName then
		v15 = v11.sponsoredDisclosure
		v14 = props.sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized
			or props.sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized
	else
		flaggedMutedError("WhyThisAdDisclosureError", "Missing creatorName or payerName in WhyThisAdModal")
		v15 = v11.sponsoredDisclosureError
	end

	local createElement = React.createElement
	local root = dialog.Root

	local v17 = {
		DialogTitle = React.createElement(dialog.Title, { text = v11.whyThisAd }),
		DialogContent = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local createElement3 = React.createElement

	local v22 = {
		DialogText = React.createElement(dialog.Text, { Text = v15, LayoutOrder = 1 }),
		AdPreferences = 0
	}

	local v23 = if v14 then React.createElement(button, {
		text = v11.adPreferences,
		variant = buttonVariant.Text,
		onActivated = v13,
		LayoutOrder = 2
	}) else nil
	v22.AdPreferences = v23
	v17.DialogContent = createElement2(content, { LayoutOrder = 1 }, {
		ContentView = createElement3(view, { tag = "col auto-xy gap-small" }, v22)
	})
	return createElement(root, { onClose = v12, hasBackdrop = true }, v17)
end

return WhyThisAdModal
