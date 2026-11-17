local SponsoredTiles = script:FindFirstAncestor("SponsoredTiles")
local parent = SponsoredTiles.Parent

local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local GameDetailRodux = require(parent.GameDetailRodux)
local Http = require(parent.Http)
local Loggers = require(parent.Loggers)
local Localization = require(parent.Localization)
local NavigationRodux = require(parent.NavigationRodux)
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)

local AppPage = RobloxAppEnums.AppPage
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Dialog = Foundation.Dialog
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = Localization.Hooks.useLocalization
local useRoactService = RobloxAppHooks.useRoactService
local flaggedMutedError = Loggers.flaggedMutedError
local RoactNetworking = RoactServiceTags.RoactNetworking
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local RetrievalStatus = Http.Enum.RetrievalStatus
local SponsoredUserCohort = require(SponsoredTiles.Enums.SponsoredUserCohort)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType

local SharedFlags2 = require(parent.SharedFlags)
local FStringLuaAppAdPreferencesUrl = SharedFlags2.FStringLuaAppAdPreferencesUrl
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags3.FFlagLuaAppEnableNxMRoduxApportioning

local function useCreatorName(universeId: string)
	local v = useDispatch()
	local v2 = useRoactService(RoactNetworking)

	if FFlagLuaAppEnableNxMRoduxApportioning then
		local v3

		if universeId == nil then
			v3 = false
		else
			v3 = universeId ~= ""
		end

		local v4 = useSelector(function(p)
			return v3 and ApiFetchGameDetails.GetFetchingStatus(p, universeId) or nil
		end)

		local v5 = useSelector(function(p)
			return v3 and p.GameDetails[universeId] or nil
		end)

		React.useEffect(function()
			if v3 and not v5 and v4 ~= RetrievalStatus.Fetching then
				v(ApiFetchGameDetails.Fetch(v2, { universeId }))
			end
		end, { v3, universeId, v5, v4, v, v2 })

		return v5 and v5.creator and v5.creator.name or nil, v4
	else
		local v3 = useSelector(function(p)
			return universeId and ApiFetchGameDetails.GetFetchingStatus(p, universeId) or nil
		end)

		local v4 = useSelector(function(p)
			return universeId and p.GameDetails[universeId] or nil
		end)

		React.useEffect(function()
			if universeId and not v4 and v3 ~= RetrievalStatus.Fetching then
				v(ApiFetchGameDetails.Fetch(v2, { universeId }))
			end
		end, { universeId, v4, v3, v, v2 })

		return v4 and v4.creator and v4.creator.name or nil, v3
	end
end

local function getSponsoredDisclosureTranslationKey(sponsoredUserCohort: string?): string -- 1 equivalent call inferred from this helper
	if sponsoredUserCohort == SponsoredUserCohort.UnderEighteen then
		return "Feature.GameDetails.Message.SponsoredDisclosure.U18"
	end

	if sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosure.O18PersonalizedNoLink"
	end

	if sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosure.O18NonPersonalizedNoLink"
	end

	return "Feature.GameDetails.Message.SponsoredDisclosure.U18"
end

local function getSponsoredDisclosureNoUniverseTranslationKey(sponsoredUserCohort: string?): string -- 1 equivalent call inferred from this helper
	if sponsoredUserCohort == SponsoredUserCohort.UnderEighteen then
		return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.U18"
	end

	if sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.O18PersonalizedNoLink"
	end

	if sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.O18NonPersonalNoLink"
	end

	return "Feature.GameDetails.Message.SponsoredDisclosureNoUniverse.U18"
end

local function resolveSponsoredDisclosure(payerName: string?, flag: boolean, flag2: boolean, p: string?, sponsoredUserCohort: string?, data)
	local v

	if payerName == nil then
		v = false
	else
		v = payerName ~= ""
	end

	if not v then
		flaggedMutedError("WhyThisAdDisclosureError", "Missing payerName in WhyThisAdModal")
		return data.sponsoredDisclosureError, false
	end

	local v2 = sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized
		or sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized

	if flag then
		if flag2 then
			flaggedMutedError("WhyThisAdDisclosureError", "Unexpected universeId for AdLink in WhyThisAdModal")
		end

		return data.sponsoredDisclosureNoUniverse, v2
	end

	if not flag2 then
		flaggedMutedError("WhyThisAdDisclosureError", "Missing universeId in WhyThisAdModal")
		return data.sponsoredDisclosureError, v2
	end

	if p then
		return data.sponsoredDisclosure, v2
	end

	flaggedMutedError("WhyThisAdDisclosureError", "Missing creatorName in WhyThisAdModal")
	return data.sponsoredDisclosureError, v2
end

local function WhyThisAdModal(props)
	local v = useDispatch()
	local creatorName, v2 = useCreatorName(props.universeId)

	local v3 = {
		sponsoredDisclosure = {
			getSponsoredDisclosureTranslationKey(props.sponsoredUserCohort), -- inferred equivalent call
			CreatorName = creatorName,
			PayerName = props.payerName
		},
		sponsoredDisclosureError = "Feature.GameDetails.Message.SponsoredDisclosure.Error",
		whyThisAd = "Feature.GameDetails.Label.WhyThisAd",
		adPreferences = "Feature.GameDetails.Message.AdPreferences",
		sponsoredDisclosureNoUniverse = 0
	}
	local sponsoredDisclosureNoUniverse

	if FFlagLuaAppEnableNxMRoduxApportioning then
		sponsoredDisclosureNoUniverse = {
			getSponsoredDisclosureNoUniverseTranslationKey(props.sponsoredUserCohort), -- inferred equivalent call
			PayerName = props.payerName
		}
	end

	v3.sponsoredDisclosureNoUniverse = sponsoredDisclosureNoUniverse
	local v4 = useLocalization(v3)

	local onClose = React.useCallback(function()
		v(CloseCentralOverlay())
	end, { v })

	local onActivated = React.useCallback(function()
		v(CloseCentralOverlay())
		local v5 = {
			name = AppPage.GenericWebPage,
			detail = FStringLuaAppAdPreferencesUrl,
			extraProps = { title = v4.adPreferences }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			v(NavigateDown(v5))
		end
	end, { v, v4.adPreferences })

	if v2 == RetrievalStatus.NotStarted or v2 == RetrievalStatus.Fetching then
		return nil
	end

	local v5 = nil
	local text

	if FFlagLuaAppEnableNxMRoduxApportioning then
		local v6 = props.contentType == OmniRecommendationsContentType.AdLink
		local v7

		if props.universeId == nil then
			v7 = false
		else
			v7 = props.universeId ~= ""
		end

		text, v5 = resolveSponsoredDisclosure(props.payerName, v6, v7, creatorName, props.sponsoredUserCohort, v4)
	elseif creatorName and props.payerName then
		text = v4.sponsoredDisclosure
		v5 = props.sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized
			or props.sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized
	else
		flaggedMutedError("WhyThisAdDisclosureError", "Missing creatorName or payerName in WhyThisAdModal")
		text = v4.sponsoredDisclosureError
	end

	local createElement = React.createElement
	local root = Dialog.Root

	local v6 = {
		DialogTitle = React.createElement(Dialog.Title, { text = v4.whyThisAd }),
		DialogContent = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	local createElement3 = React.createElement

	local v7 = {
		DialogText = React.createElement(Dialog.Text, { Text = text, LayoutOrder = 1 }),
		AdPreferences = 0
	}
	local adPreferences

	if v5 then
		adPreferences = React.createElement(Button, {
			text = v4.adPreferences,
			variant = ButtonVariant.Text,
			onActivated = onActivated,
			LayoutOrder = 2
		})
	end

	v7.AdPreferences = adPreferences
	v6.DialogContent = createElement2(content, { LayoutOrder = 1 }, {
		ContentView = createElement3(View, { tag = "col auto-xy gap-small" }, v7)
	})
	return createElement(root, { onClose = onClose, hasBackdrop = true }, v6)
end

return WhyThisAdModal
