local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SduiPolicyFieldKey = require(SduiCoreSystem.ClientBinding.SduiPolicyFieldKey)
require(parent.UniversalAppPolicy)

local function resolveSduiPolicyField(data, p: string)
	if p == SduiPolicyFieldKey.SearchBar then
		return true, data.getSearchBar()
	end

	if p == SduiPolicyFieldKey.GameDetailsMorePage then
		return true, data.getGameDetailsMorePage()
	end

	if p == SduiPolicyFieldKey.GameDetailsSubtitle then
		return true, data.getGameDetailsSubtitle()
	end

	if p == SduiPolicyFieldKey.GameDetailsPlayWithFriends then
		return true, data.getGameDetailsPlayWithFriends()
	end

	if p == SduiPolicyFieldKey.ShowGlobalCounters then
		return true, data.getShowGlobalCounters()
	end

	if p == SduiPolicyFieldKey.GameInfoList then
		return true, data.getGameInfoList()
	end

	if p == SduiPolicyFieldKey.GamePlaysAndRatings then
		return true, data.getGamePlaysAndRatings()
	end

	if p == SduiPolicyFieldKey.GameReportingDisabled then
		return true, data.getGameReportingDisabled()
	end

	if p == SduiPolicyFieldKey.RecommendedGames then
		return true, data.getRecommendedGames()
	end

	if p == SduiPolicyFieldKey.SocialLinks then
		return true, data.getSocialLinks()
	end

	if p == SduiPolicyFieldKey.SocialGroupLinks then
		return true, data.getSocialGroupLinks()
	end

	if p == SduiPolicyFieldKey.CommunityLinksEnabled then
		return true, data.getCommunityLinksEnabled()
	end

	if p == SduiPolicyFieldKey.GameInfoShowBadges then
		return true, data.getGameInfoShowBadges()
	end

	if p == SduiPolicyFieldKey.GameInfoShowCreated then
		return true, data.getGameInfoShowCreated()
	end

	if p == SduiPolicyFieldKey.GameInfoShowGamepasses then
		return true, data.getGameInfoShowGamepasses()
	end

	if p == SduiPolicyFieldKey.GameInfoShowGenre then
		return true, data.getGameInfoShowGenre()
	end

	if p == SduiPolicyFieldKey.GameInfoShowSubgenre then
		return true, data.getGameInfoShowSubgenre()
	end

	if p == SduiPolicyFieldKey.GameInfoShowMaxPlayers then
		return true, data.getGameInfoShowMaxPlayers()
	end

	if p == SduiPolicyFieldKey.GameInfoShowServers then
		return true, data.getGameInfoShowServers()
	end

	if p == SduiPolicyFieldKey.GameInfoShowUpdated then
		return true, data.getGameInfoShowUpdated()
	end

	if p == SduiPolicyFieldKey.GameInfoShowAgeRecommendation then
		return true, data.getGameInfoShowAgeRecommendation()
	end

	if p == SduiPolicyFieldKey.GameInfoShowVoiceAndChatFeatures then
		return true, data.getGameInfoShowVoiceAndChatFeatures()
	end

	if p == SduiPolicyFieldKey.GameInfoShowChatFeatures then
		return true, data.getGameInfoShowChatFeatures()
	end

	if p == SduiPolicyFieldKey.GameInfoListDeveloper then
		return true, data.getGameInfoListDeveloper()
	end

	if p == SduiPolicyFieldKey.GameInfoListShowRNVDeveloper then
		return true, data.getGameInfoListShowRNVDeveloper()
	end

	if p == SduiPolicyFieldKey.ShowPassesOnExperienceDetails then
		return true, data.getShowPassesOnExperienceDetails()
	end

	if p == SduiPolicyFieldKey.EnableAggregateLikesFavoritesCount then
		return true, data.getEnableAggregateLikesFavoritesCount()
	end

	if p == SduiPolicyFieldKey.ExperienceDetailsNoticeType then
		return true, data.getExperienceDetailsNoticeType()
	end

	if p == SduiPolicyFieldKey.NotificationsCanReceiveExperience then
		return true, data.getNotificationsCanReceiveExperience()
	end

	if p == SduiPolicyFieldKey.InviteFriendsDisabled then
		return true, data.getInviteFriendsDisabled()
	end

	if p == SduiPolicyFieldKey.WebViewSupport then
		return true, data.getWebViewSupport()
	end

	if p == SduiPolicyFieldKey.UseRoundedCorners then
		return true, data.getUseRoundedCorners()
	end

	if p == SduiPolicyFieldKey.RenameFriendsToConnections then
		return true, data.getRenameFriendsToConnections()
	end

	if p == SduiPolicyFieldKey.UseLuafiedReportFlow then
		return true, data.getUseLuafiedReportFlow()
	end

	if p == SduiPolicyFieldKey.ExperienceInviteShareLinkEnabled then
		return true, data.getExperienceInviteShareLinkEnabled()
	end

	if p == SduiPolicyFieldKey.ExperienceChatAvailability then
		return true, data.getExperienceChatAvailability()
	end

	if p == SduiPolicyFieldKey.DisableIAPEntryPoint then
		return true, data.getDisableIAPEntryPoint()
	end

	if p == SduiPolicyFieldKey.PurchasePromptIncludingWarning then
		return true, data.getPurchasePromptIncludingWarning()
	end

	if p == SduiPolicyFieldKey.DisableResellingCollectiblesForCompliance then
		return true, data.getDisableResellingCollectiblesForCompliance()
	end

	if p == SduiPolicyFieldKey.CatalogPremiumCategory then
		return true, data.getCatalogPremiumCategory()
	end

	if p == SduiPolicyFieldKey.CatalogPremiumContent then
		return true, data.getShowCatalogPremiumContent()
	end

	if p == SduiPolicyFieldKey.ShowVNGTosForRobuxUpsell then
		return true, data.getShowVNGTosForRobuxUpsell()
	end

	if p == SduiPolicyFieldKey.ShouldUseDMCCALegalDisclosureInApp then
		return true, data.getShouldUseDMCCALegalDisclosureInApp()
	end

	if p == SduiPolicyFieldKey.RedirectBuyRobuxToVNG then
		return true, data.getRedirectBuyRobuxToVNG()
	end

	if p == SduiPolicyFieldKey.RobuxUpsellFlowMobile then
		return true, data.getRobuxUpsellFlowMobile()
	end

	if p == SduiPolicyFieldKey.EnablePremiumUserFeatures then
		return true, data.getEnablePremiumUserFeatures()
	end

	if p == SduiPolicyFieldKey.DisablePremiumEntrypoint then
		return true, data.getDisablePremiumEntrypoint()
	end

	return false, nil
end

return resolveSduiPolicyField
