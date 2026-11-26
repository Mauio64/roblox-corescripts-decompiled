local SduiPolicyFieldKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiPolicyFieldKey")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/UniversalAppPolicy")

local function resolveSduiPolicyField(data, p2)
	if p2 == SduiPolicyFieldKey.SearchBar then
		return true, data.getSearchBar()
	end

	if p2 == SduiPolicyFieldKey.GameDetailsMorePage then
		return true, data.getGameDetailsMorePage()
	end

	if p2 == SduiPolicyFieldKey.GameDetailsSubtitle then
		return true, data.getGameDetailsSubtitle()
	end

	if p2 == SduiPolicyFieldKey.GameDetailsPlayWithFriends then
		return true, data.getGameDetailsPlayWithFriends()
	end

	if p2 == SduiPolicyFieldKey.ShowGlobalCounters then
		return true, data.getShowGlobalCounters()
	end

	if p2 == SduiPolicyFieldKey.GameInfoList then
		return true, data.getGameInfoList()
	end

	if p2 == SduiPolicyFieldKey.GamePlaysAndRatings then
		return true, data.getGamePlaysAndRatings()
	end

	if p2 == SduiPolicyFieldKey.GameReportingDisabled then
		return true, data.getGameReportingDisabled()
	end

	if p2 == SduiPolicyFieldKey.RecommendedGames then
		return true, data.getRecommendedGames()
	end

	if p2 == SduiPolicyFieldKey.SocialLinks then
		return true, data.getSocialLinks()
	end

	if p2 == SduiPolicyFieldKey.SocialGroupLinks then
		return true, data.getSocialGroupLinks()
	end

	if p2 == SduiPolicyFieldKey.CommunityLinksEnabled then
		return true, data.getCommunityLinksEnabled()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowBadges then
		return true, data.getGameInfoShowBadges()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowCreated then
		return true, data.getGameInfoShowCreated()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowGamepasses then
		return true, data.getGameInfoShowGamepasses()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowGenre then
		return true, data.getGameInfoShowGenre()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowSubgenre then
		return true, data.getGameInfoShowSubgenre()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowMaxPlayers then
		return true, data.getGameInfoShowMaxPlayers()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowServers then
		return true, data.getGameInfoShowServers()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowUpdated then
		return true, data.getGameInfoShowUpdated()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowAgeRecommendation then
		return true, data.getGameInfoShowAgeRecommendation()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowVoiceAndChatFeatures then
		return true, data.getGameInfoShowVoiceAndChatFeatures()
	end

	if p2 == SduiPolicyFieldKey.GameInfoShowChatFeatures then
		return true, data.getGameInfoShowChatFeatures()
	end

	if p2 == SduiPolicyFieldKey.GameInfoListDeveloper then
		return true, data.getGameInfoListDeveloper()
	end

	if p2 == SduiPolicyFieldKey.GameInfoListShowRNVDeveloper then
		return true, data.getGameInfoListShowRNVDeveloper()
	end

	if p2 == SduiPolicyFieldKey.ShowPassesOnExperienceDetails then
		return true, data.getShowPassesOnExperienceDetails()
	end

	if p2 == SduiPolicyFieldKey.EnableAggregateLikesFavoritesCount then
		return true, data.getEnableAggregateLikesFavoritesCount()
	end

	if p2 == SduiPolicyFieldKey.ExperienceDetailsNoticeType then
		return true, data.getExperienceDetailsNoticeType()
	end

	if p2 == SduiPolicyFieldKey.NotificationsCanReceiveExperience then
		return true, data.getNotificationsCanReceiveExperience()
	end

	if p2 == SduiPolicyFieldKey.InviteFriendsDisabled then
		return true, data.getInviteFriendsDisabled()
	end

	if p2 == SduiPolicyFieldKey.WebViewSupport then
		return true, data.getWebViewSupport()
	end

	if p2 == SduiPolicyFieldKey.UseRoundedCorners then
		return true, data.getUseRoundedCorners()
	end

	if p2 == SduiPolicyFieldKey.RenameFriendsToConnections then
		return true, data.getRenameFriendsToConnections()
	end

	if p2 == SduiPolicyFieldKey.UseLuafiedReportFlow then
		return true, data.getUseLuafiedReportFlow()
	end

	if p2 == SduiPolicyFieldKey.ExperienceInviteShareLinkEnabled then
		return true, data.getExperienceInviteShareLinkEnabled()
	end

	if p2 == SduiPolicyFieldKey.ExperienceChatAvailability then
		return true, data.getExperienceChatAvailability()
	end

	if p2 == SduiPolicyFieldKey.DisableIAPEntryPoint then
		return true, data.getDisableIAPEntryPoint()
	end

	if p2 == SduiPolicyFieldKey.PurchasePromptIncludingWarning then
		return true, data.getPurchasePromptIncludingWarning()
	end

	if p2 == SduiPolicyFieldKey.DisableResellingCollectiblesForCompliance then
		return true, data.getDisableResellingCollectiblesForCompliance()
	end

	if p2 == SduiPolicyFieldKey.CatalogPremiumCategory then
		return true, data.getCatalogPremiumCategory()
	end

	if p2 == SduiPolicyFieldKey.CatalogPremiumContent then
		return true, data.getShowCatalogPremiumContent()
	end

	if p2 == SduiPolicyFieldKey.ShowVNGTosForRobuxUpsell then
		return true, data.getShowVNGTosForRobuxUpsell()
	end

	if p2 == SduiPolicyFieldKey.ShouldUseDMCCALegalDisclosureInApp then
		return true, data.getShouldUseDMCCALegalDisclosureInApp()
	end

	if p2 == SduiPolicyFieldKey.RedirectBuyRobuxToVNG then
		return true, data.getRedirectBuyRobuxToVNG()
	end

	if p2 == SduiPolicyFieldKey.RobuxUpsellFlowMobile then
		return true, data.getRobuxUpsellFlowMobile()
	end

	if p2 == SduiPolicyFieldKey.EnablePremiumUserFeatures then
		return true, data.getEnablePremiumUserFeatures()
	end

	if p2 == SduiPolicyFieldKey.DisablePremiumEntrypoint then
		return true, data.getDisablePremiumEntrypoint()
	end

	return false, nil
end

return resolveSduiPolicyField
