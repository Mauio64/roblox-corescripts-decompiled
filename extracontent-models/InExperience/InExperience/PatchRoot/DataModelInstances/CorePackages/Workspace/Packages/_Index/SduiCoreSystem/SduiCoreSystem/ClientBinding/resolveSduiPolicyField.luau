local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local SduiPolicyFieldKey = require(SduiCoreSystem.ClientBinding.SduiPolicyFieldKey)

require(SduiCoreSystemParent.UniversalAppPolicy)

local function resolveSduiPolicyField(p1, s1: string) -- line: 16
	-- upvalues: SduiPolicyFieldKey (copy)
	if s1 == SduiPolicyFieldKey.SearchBar then
		return true, p1.getSearchBar()
	end

	if s1 == SduiPolicyFieldKey.GameDetailsMorePage then
		return true, p1.getGameDetailsMorePage()
	end

	if s1 == SduiPolicyFieldKey.GameDetailsSubtitle then
		return true, p1.getGameDetailsSubtitle()
	end

	if s1 == SduiPolicyFieldKey.GameDetailsPlayWithFriends then
		return true, p1.getGameDetailsPlayWithFriends()
	end

	if s1 == SduiPolicyFieldKey.ShowGlobalCounters then
		return true, p1.getShowGlobalCounters()
	end

	if s1 == SduiPolicyFieldKey.GameInfoList then
		return true, p1.getGameInfoList()
	end

	if s1 == SduiPolicyFieldKey.GamePlaysAndRatings then
		return true, p1.getGamePlaysAndRatings()
	end

	if s1 == SduiPolicyFieldKey.GameReportingDisabled then
		return true, p1.getGameReportingDisabled()
	end

	if s1 == SduiPolicyFieldKey.RecommendedGames then
		return true, p1.getRecommendedGames()
	end

	if s1 == SduiPolicyFieldKey.SocialLinks then
		return true, p1.getSocialLinks()
	end

	if s1 == SduiPolicyFieldKey.SocialGroupLinks then
		return true, p1.getSocialGroupLinks()
	end

	if s1 == SduiPolicyFieldKey.CommunityLinksEnabled then
		return true, p1.getCommunityLinksEnabled()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowBadges then
		return true, p1.getGameInfoShowBadges()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowCreated then
		return true, p1.getGameInfoShowCreated()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowGamepasses then
		return true, p1.getGameInfoShowGamepasses()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowGenre then
		return true, p1.getGameInfoShowGenre()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowSubgenre then
		return true, p1.getGameInfoShowSubgenre()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowMaxPlayers then
		return true, p1.getGameInfoShowMaxPlayers()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowServers then
		return true, p1.getGameInfoShowServers()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowUpdated then
		return true, p1.getGameInfoShowUpdated()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowAgeRecommendation then
		return true, p1.getGameInfoShowAgeRecommendation()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowVoiceAndChatFeatures then
		return true, p1.getGameInfoShowVoiceAndChatFeatures()
	end

	if s1 == SduiPolicyFieldKey.GameInfoShowChatFeatures then
		return true, p1.getGameInfoShowChatFeatures()
	end

	if s1 == SduiPolicyFieldKey.GameInfoListDeveloper then
		return true, p1.getGameInfoListDeveloper()
	end

	if s1 == SduiPolicyFieldKey.GameInfoListShowRNVDeveloper then
		return true, p1.getGameInfoListShowRNVDeveloper()
	end

	if s1 == SduiPolicyFieldKey.ShowPassesOnExperienceDetails then
		return true, p1.getShowPassesOnExperienceDetails()
	end

	if s1 == SduiPolicyFieldKey.EnableAggregateLikesFavoritesCount then
		return true, p1.getEnableAggregateLikesFavoritesCount()
	end

	if s1 == SduiPolicyFieldKey.ExperienceDetailsNoticeType then
		return true, p1.getExperienceDetailsNoticeType()
	end

	if s1 == SduiPolicyFieldKey.NotificationsCanReceiveExperience then
		return true, p1.getNotificationsCanReceiveExperience()
	end

	if s1 == SduiPolicyFieldKey.InviteFriendsDisabled then
		return true, p1.getInviteFriendsDisabled()
	end

	if s1 == SduiPolicyFieldKey.WebViewSupport then
		return true, p1.getWebViewSupport()
	end

	if s1 == SduiPolicyFieldKey.UseRoundedCorners then
		return true, p1.getUseRoundedCorners()
	end

	if s1 == SduiPolicyFieldKey.RenameFriendsToConnections then
		return true, p1.getRenameFriendsToConnections()
	end

	if s1 == SduiPolicyFieldKey.UseLuafiedReportFlow then
		return true, p1.getUseLuafiedReportFlow()
	end

	if s1 == SduiPolicyFieldKey.ExperienceInviteShareLinkEnabled then
		return true, p1.getExperienceInviteShareLinkEnabled()
	end

	if s1 == SduiPolicyFieldKey.ExperienceChatAvailability then
		return true, p1.getExperienceChatAvailability()
	end

	if s1 == SduiPolicyFieldKey.DisableIAPEntryPoint then
		return true, p1.getDisableIAPEntryPoint()
	end

	if s1 == SduiPolicyFieldKey.PurchasePromptIncludingWarning then
		return true, p1.getPurchasePromptIncludingWarning()
	end

	if s1 == SduiPolicyFieldKey.DisableResellingCollectiblesForCompliance then
		return true, p1.getDisableResellingCollectiblesForCompliance()
	end

	if s1 == SduiPolicyFieldKey.CatalogPremiumCategory then
		return true, p1.getCatalogPremiumCategory()
	end

	if s1 == SduiPolicyFieldKey.CatalogPremiumContent then
		return true, p1.getShowCatalogPremiumContent()
	end

	if s1 == SduiPolicyFieldKey.ShowVNGTosForRobuxUpsell then
		return true, p1.getShowVNGTosForRobuxUpsell()
	end

	if s1 == SduiPolicyFieldKey.ShouldUseDMCCALegalDisclosureInApp then
		return true, p1.getShouldUseDMCCALegalDisclosureInApp()
	end

	if s1 == SduiPolicyFieldKey.RedirectBuyRobuxToVNG then
		return true, p1.getRedirectBuyRobuxToVNG()
	end

	if s1 == SduiPolicyFieldKey.RobuxUpsellFlowMobile then
		return true, p1.getRobuxUpsellFlowMobile()
	end

	if s1 == SduiPolicyFieldKey.EnablePremiumUserFeatures then
		return true, p1.getEnablePremiumUserFeatures()
	end

	if s1 == SduiPolicyFieldKey.DisablePremiumEntrypoint then
		return true, p1.getDisablePremiumEntrypoint()
	end

	return false, nil
end

return resolveSduiPolicyField
