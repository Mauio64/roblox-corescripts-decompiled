local module = require("@luauforge/bundled/ilv")

local function registerCommonActions()
	require("@luauforge/bundled/ilw").registerSharedActions()
	require("@luauforge/bundled/ilx").registerDiscoveryActions()
	require("@luauforge/bundled/ily").registerSocialActions()
	require("@luauforge/bundled/ilK").registerVerificationUpsellActions()

	if module.FFlagSduiCustomFormEnabled then
		require("@luauforge/bundled/ilG").registerCustomFormActions()
	end

	if module.FFlagEnableAvatarExperienceSdui then
		require("@luauforge/bundled/ilE").registerAvatarExperienceActions()
	end

	if
		module.FFlagLuaAppSduiMovePromptsActions
		or module.FFlagSduiRequestPushNotificationPermissionActionHandler
		or module.FFlagSduiMilestoneCountActions
	then
		require("@luauforge/bundled/ilL").registerPromptsActions()
	end

	if module.FFlagLuaAppSduiGameTileFeedback or module.FFlagSduiPlayWithRewardRefactor then
		require("@luauforge/bundled/ilH").registerAdsActions()
	end

	if
		module.FFlagLuaAppSduiUpdateUserSettingsAction
		and module.FFlagMoveSduiUpdateUserSettingsToAccountManagement
	then
		require("@luauforge/bundled/ilM").registerUserSettingsActions()
	end

	if module.FFlagSduiDevStoreSeeAllSupport or module.FFlagSduiGameItemsComponent then
		require("@luauforge/bundled/ilI").registerExperienceStoreActions()
	end

	if module.FFlagSduiOpenIncomingTransferUpsellAction then
		require("@luauforge/bundled/ilN").registerCurrencyTransferSduiActions()
	end

	if module.FFlagEnableBuyRobuxSdui then
		require("@luauforge/bundled/ilO").registerBuyRobuxSduiActions()
	end
end

return registerCommonActions
