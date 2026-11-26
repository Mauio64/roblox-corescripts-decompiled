local module = require("@luauforge/bundled/isS")

local function registerCommonComponents()
	require("@luauforge/bundled/isT").registerSharedUiComponents()
	require("@luauforge/bundled/isU").registerDiscoveryUiComponents()
	require("@luauforge/bundled/isV").registerSocialComponents()

	if module.FFlagEnableFoundationSdui then
		require("@luauforge/bundled/isW").registerFoundationComponents()
	end

	if module.FFlagEnableAvatarExperienceSdui then
		require("@luauforge/bundled/itb").registerAvatarExperienceUiComponents()
	end

	if module.FFlagEnableGroupsSdui then
		require("@luauforge/bundled/itc").registerGroupsUiComponents()
	end

	if module.FFlagSduiCustomFormEnabled then
		require("@luauforge/bundled/itd").registerCustomFormComponents()
	end

	if
		module.FFlagLuaAppSduiSponsoredTwoByOneTile
		or module.FFlagLuaAppSduiGameTileFeedback
		or module.FFlagSduiPlayWithRewardRefactor
	then
		require("@luauforge/bundled/ite").registerAdsComponents()
	end

	if
		(module.FFlagSduiDevStoreSeeAllSupport or module.FFlagSduiGameItemsComponent)
		and (module.FFlagSduiGameItemsComponent or module.FFlagSduiLocalFeedFilter)
	then
		require("@luauforge/bundled/itf").registerExperienceStoreComponents()
	end
end

return registerCommonComponents
