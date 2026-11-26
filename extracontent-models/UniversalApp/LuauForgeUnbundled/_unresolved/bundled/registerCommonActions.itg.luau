local module = require("@luauforge/bundled/isS")

local function registerCommonActions()
	require("@luauforge/bundled/isT").registerSharedActions()
	require("@luauforge/bundled/isU").registerDiscoveryActions()
	require("@luauforge/bundled/isV").registerSocialActions()
	require("@luauforge/bundled/ith").registerVerificationUpsellActions()

	if module.FFlagSduiCustomFormEnabled then
		require("@luauforge/bundled/itd").registerCustomFormActions()
	end

	if module.FFlagEnableAvatarExperienceSdui then
		require("@luauforge/bundled/itb").registerAvatarExperienceActions()
	end

	if
		module.FFlagLuaAppSduiMovePromptsActions
		or module.FFlagSduiRequestPushNotificationPermissionActionHandler
		or module.FFlagSduiMilestoneCountActions
	then
		require("@luauforge/bundled/iti").registerPromptsActions()
	end

	if module.FFlagLuaAppSduiGameTileFeedback or module.FFlagSduiPlayWithRewardRefactor then
		require("@luauforge/bundled/ite").registerAdsActions()
	end

	if
		module.FFlagLuaAppSduiUpdateUserSettingsAction
		and module.FFlagMoveSduiUpdateUserSettingsToAccountManagement
	then
		require("@luauforge/bundled/itj").registerUserSettingsActions()
	end

	if module.FFlagSduiDevStoreSeeAllSupport or module.FFlagSduiGameItemsComponent then
		require("@luauforge/bundled/itf").registerExperienceStoreActions()
	end

	if module.FFlagSduiOpenIncomingTransferUpsellAction then
		require("@luauforge/bundled/itk").registerCurrencyTransferSduiActions()
	end

	if module.FFlagEnableBuyRobuxSdui then
		require("@luauforge/bundled/itl").registerBuyRobuxSduiActions()
	end

	if module.FFlagSduiOpenAccountSettingsAction then
		require("@luauforge/bundled/itm").registerAccountSettingsEntryPointsActions()
	end
end

return registerCommonActions
