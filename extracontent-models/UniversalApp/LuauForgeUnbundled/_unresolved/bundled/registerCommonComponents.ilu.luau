local module = require("@luauforge/bundled/ilv")

local function registerCommonComponents()
	require("@luauforge/bundled/ilw").registerSharedUiComponents()
	require("@luauforge/bundled/ilx").registerDiscoveryUiComponents()
	require("@luauforge/bundled/ily").registerSocialComponents()

	if module.FFlagEnableFoundationSdui then
		require("@luauforge/bundled/ilz").registerFoundationComponents()
	end

	if module.FFlagEnableAvatarExperienceSdui then
		require("@luauforge/bundled/ilE").registerAvatarExperienceUiComponents()
	end

	if module.FFlagEnableGroupsSdui then
		require("@luauforge/bundled/ilF").registerGroupsUiComponents()
	end

	if module.FFlagSduiCustomFormEnabled then
		require("@luauforge/bundled/ilG").registerCustomFormComponents()
	end

	if
		module.FFlagLuaAppSduiSponsoredTwoByOneTile
		or module.FFlagLuaAppSduiGameTileFeedback
		or module.FFlagSduiPlayWithRewardRefactor
	then
		require("@luauforge/bundled/ilH").registerAdsComponents()
	end

	if
		(module.FFlagSduiDevStoreSeeAllSupport or module.FFlagSduiGameItemsComponent)
		and (module.FFlagSduiGameItemsComponent or module.FFlagSduiLocalFeedFilter)
	then
		require("@luauforge/bundled/ilI").registerExperienceStoreComponents()
	end
end

return registerCommonComponents
