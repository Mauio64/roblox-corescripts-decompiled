local SponsoredTiles = script:FindFirstAncestor("SponsoredTiles")
local SponsoredTilesParent = SponsoredTiles.Parent
local CentralOverlay = require(SponsoredTilesParent.CentralOverlay)
local Foundation = require(SponsoredTilesParent.Foundation)
local GameDetailRodux = require(SponsoredTilesParent.GameDetailRodux)
local Http = require(SponsoredTilesParent.Http)
local Loggers = require(SponsoredTilesParent.Loggers)
local Localization = require(SponsoredTilesParent.Localization)
local NavigationRodux = require(SponsoredTilesParent.NavigationRodux)
local React = require(SponsoredTilesParent.React)
local RobloxAppEnums = require(SponsoredTilesParent.RobloxAppEnums)
local RobloxAppHooks = require(SponsoredTilesParent.RobloxAppHooks)
local RoactServiceTags = require(SponsoredTilesParent.RoactServiceTags)
local RoactUtils = require(SponsoredTilesParent.RoactUtils)
local AppPage = RobloxAppEnums.AppPage
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Dialog = Foundation.Dialog
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(SponsoredTilesParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v23 = if not FFlagSignalsNavP3Dispatch then nil else require(SponsoredTilesParent.RobloxAppNavigation).NavigationCommands
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = Localization.Hooks.useLocalization
local useRoactService = RobloxAppHooks.useRoactService
local flaggedMutedError = Loggers.flaggedMutedError
local RoactNetworking = RoactServiceTags.RoactNetworking
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local RetrievalStatus = Http.Enum.RetrievalStatus
local SponsoredUserCohort = require(SponsoredTiles.Enums.SponsoredUserCohort)
local FStringLuaAppAdPreferencesUrl = require(SponsoredTilesParent.SharedFlags).FStringLuaAppAdPreferencesUrl

local function useCreatorName(s1: string) -- line: 46
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), ApiFetchGameDetails (copy), React (copy), RetrievalStatus (copy)
	local v38 = useDispatch()
	local v39 = useRoactService(RoactNetworking)
	local v40 = useSelector(function(p1) -- line: 50
		-- upvalues: s1 (copy), ApiFetchGameDetails (copy)
		return s1 and ApiFetchGameDetails.GetFetchingStatus(p1, s1) or nil
	end)
	local v41 = useSelector(function(p2) -- line: 54
		-- upvalues: s1 (copy)
		return s1 and p2.GameDetails[s1] or nil
	end)

	React.useEffect(function() -- line: 58
		-- upvalues: s1 (copy), v41 (copy), v40 (copy), RetrievalStatus (copy), v38 (copy), ApiFetchGameDetails (copy), v39 (copy)
		if s1 and (not v41 and v40 ~= RetrievalStatus.Fetching) then
			v38(ApiFetchGameDetails.Fetch(v39, { s1 }))
		end
	end, {
		s1,
		v41,
		v40,
		v38,
		v39
	})

	return v41 and (not not v41.creator and v41.creator.name) or nil, v40
end
local function getSponsoredDisclosureTranslationKey(s2: string?) -- line: 68
	-- upvalues: SponsoredUserCohort (copy)
	if s2 == SponsoredUserCohort.UnderEighteen then
		return "Feature.GameDetails.Message.SponsoredDisclosure.U18"
	end

	if s2 == SponsoredUserCohort.EighteenPlusPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosure.O18PersonalizedNoLink"
	end

	if s2 == SponsoredUserCohort.EighteenPlusNonPersonalized then
		return "Feature.GameDetails.Message.SponsoredDisclosure.O18NonPersonalizedNoLink"
	end

	return "Feature.GameDetails.Message.SponsoredDisclosure.U18"
end
local function WhyThisAdModal(t1: {[any]: any}) -- line: 80
	-- upvalues: useDispatch (copy), useCreatorName (copy), useLocalization (copy), SponsoredUserCohort (copy), React (copy), CloseCentralOverlay (copy), AppPage (copy), FStringLuaAppAdPreferencesUrl (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateDown (copy), RetrievalStatus (copy), flaggedMutedError (copy), Dialog (copy), View (copy), Button (copy), ButtonVariant (copy)
	local v44 = useDispatch()
	local v45, v46 = useCreatorName(t1.universeId)
	local v47 = useLocalization
	local t2 = {
		sponsoredDisclosureError = "Feature.GameDetails.Message.SponsoredDisclosure.Error",
		whyThisAd = "Feature.GameDetails.Label.WhyThisAd",
		adPreferences = "Feature.GameDetails.Message.AdPreferences"
	}
	local t3 = {}
	local sponsoredUserCohort = t1.sponsoredUserCohort
	local v51 = if sponsoredUserCohort ~= SponsoredUserCohort.UnderEighteen then if sponsoredUserCohort ~= SponsoredUserCohort.EighteenPlusPersonalized then sponsoredUserCohort ~= SponsoredUserCohort.EighteenPlusNonPersonalized and "Feature.GameDetails.Message.SponsoredDisclosure.U18" or "Feature.GameDetails.Message.SponsoredDisclosure.O18NonPersonalizedNoLink" else "Feature.GameDetails.Message.SponsoredDisclosure.O18PersonalizedNoLink" else "Feature.GameDetails.Message.SponsoredDisclosure.U18"

	t3[1] = v51
	t3.CreatorName = v45
	t3.PayerName = t1.payerName
	t2.sponsoredDisclosure = t3

	local v52 = v47(t2)
	local v53 = React.useCallback(function() -- line: 95
		-- upvalues: v44 (copy), CloseCentralOverlay (copy)
		v44(CloseCentralOverlay())
	end, { v44 })
	local v54 = React.useCallback(function() -- line: 99
		-- upvalues: v44 (copy), CloseCentralOverlay (copy), AppPage (copy), FStringLuaAppAdPreferencesUrl (copy), v52 (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateDown (copy)
		v44(CloseCentralOverlay())

		local t4 = {
			name = AppPage.GenericWebPage,
			detail = FStringLuaAppAdPreferencesUrl,
			extraProps = {
				title = v52.adPreferences
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v23.down(v23.fromLegacyPage(t4))

			return
		end

		v44(NavigateDown(t4))
	end, {
		v44,
		v52.adPreferences
	})

	if v46 == RetrievalStatus.NotStarted or v46 == RetrievalStatus.Fetching then
		return nil
	end

	local v55 = nil
	local sponsoredDisclosure

	if v45 and t1.payerName then
		sponsoredDisclosure = v52.sponsoredDisclosure
		v55 = t1.sponsoredUserCohort == SponsoredUserCohort.EighteenPlusPersonalized or t1.sponsoredUserCohort == SponsoredUserCohort.EighteenPlusNonPersonalized
	else
		flaggedMutedError("WhyThisAdDisclosureError", "Missing creatorName or payerName in WhyThisAdModal")
		sponsoredDisclosure = v52.sponsoredDisclosureError
	end

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		onClose = v53
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v52.whyThisAd
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 1
		}, {
			ContentView = React.createElement(View, {
				tag = "col auto-xy gap-small"
			}, {
				DialogText = React.createElement(Dialog.Text, {
					LayoutOrder = 1,
					Text = sponsoredDisclosure
				}),
				AdPreferences = if not v55 then nil else React.createElement(Button, {
					LayoutOrder = 2,
					text = v52.adPreferences,
					variant = ButtonVariant.Text,
					onActivated = v54
				})
			})
		})
	})
end

return WhyThisAdModal
