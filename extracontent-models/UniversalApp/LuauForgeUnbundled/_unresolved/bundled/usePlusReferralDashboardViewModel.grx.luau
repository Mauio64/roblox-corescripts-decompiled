local module = require("@luauforge/bundled/grg")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Localization")
local module3 = require("@luauforge/bundled/gry")
local module4 = require("@luauforge/bundled/grz")
local module5 = require("@luauforge/bundled/grA")
local universalShareSheet = require("@luauforge/bundled/grB").UniversalShareSheet

local useLocalization = Localization.Hooks.useLocalization
local useNavigation = module3.useNavigation
local useDeviceInsets = module4.useDeviceInsets
local useSignalState = module5.useSignalState

local fFlagEnablePlusReferralDashboard = require("@luauforge/bundled/grw").FFlagEnablePlusReferralDashboard

local module6 = require("@luauforge/bundled/grl")
local formatPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/InExperienceShop/Utils/formatPrice")
local module8 = require("@luauforge/bundled/gtY")
local module9 = require("@luauforge/bundled/guc")
local module10 = require("@luauforge/bundled/gub")
local module11 = require("@luauforge/bundled/gui")
local module12 = require("@luauforge/bundled/guk")
local module13 = require("@luauforge/bundled/gul")
local module14 = require("@luauforge/bundled/gum")

require("@luauforge/bundled/grh")

local function usePlusReferralDashboardViewModel(value)
	local v5 = value or "referralDashboard"
	local v6 = useNavigation()
	local v7 = useDeviceInsets()
	local REFERRAL_REWARD_ROBUX = tostring(module6.REFERRAL_REWARD_ROBUX)
	local v8 = module8.get()

	local v9 = useSignalState(v8.getScreenLoadStatus)
	local v10 = useSignalState(v8.getShareUrl)
	local v11 = useSignalState(v8.getBenefits)

	local ref = module.useRef(v6.goBack)
	ref.current = v6.goBack

	local v12 = useLocalization({
		titlePrefix = "Feature.RobloxSubscription.Heading.ReferralShare",
		description = {
			"Feature.RobloxSubscription.Description.ReferralShare",
			amount = REFERRAL_REWARD_ROBUX
		},
		rewardRobux = {
			"Feature.RobloxSubscription.Label.ReferralRewardRobux",
			amount = REFERRAL_REWARD_ROBUX
		},
		youGetLabel = "Feature.RobloxSubscription.Label.ReferralYouGet",
		youGetDescription = "Feature.RobloxSubscription.Description.ReferralReferrerReward",
		theyGetLabel = "Feature.RobloxSubscription.Label.ReferralTheyGet",
		theyGetDescription = "Feature.RobloxSubscription.Description.ReferralRecipientReward",
		referralHistoryHeading = "Feature.RobloxSubscription.Heading.ReferralHistory",
		successfulReferralsLabel = "Feature.RobloxSubscription.Label.SuccessfulReferrals",
		robuxEarnedLabel = "Feature.RobloxSubscription.Label.RobuxEarned",
		pendingRobuxLabel = "Feature.RobloxSubscription.Label.PendingRobux",
		referButton = "Feature.RobloxSubscription.Action.ReferToPlus"
	})

	module.useEffect(function()
		module9()
	end, { module9 })

	module.useEffect(function()
		if v9 == module10.Ready and fFlagEnablePlusReferralDashboard then
			module13(module11.PlusReferralDashboardImpressedCounter)
			module14(module12.DashboardImpressed, v5)
		end
	end, { v9 })

	module.useEffect(function()
		if v9 == module10.Invalid then
			ref.current()

			v8.reset()
		end
	end, { v9, v8.reset })

	local v13 = module.useCallback(function()
		v6.goBack()
	end, { v6 })

	local v14 = module.useCallback(function()
		if fFlagEnablePlusReferralDashboard then
			module13(module11.PlusReferralReferToPlusClickedCounter)
			module14(module12.ReferToPlusClicked, v5)
		end

		local shareUrl = v8.getShareUrl(false)

		if shareUrl == nil or shareUrl == "" then
			return
		end

		universalShareSheet.show({ context = "PlusReferralDashboard", url = shareUrl })
	end, { v8.getShareUrl })

	if v9 ~= module10.Ready then
		return nil
	end

	local pendingRobuxEarnedFromReferrals = v11 and v11.pendingRobuxEarnedFromReferrals
	local v15 = not (pendingRobuxEarnedFromReferrals == nil) and pendingRobuxEarnedFromReferrals > 0

	local v16 = {
		topInset = v7.top,
		bottomInset = v7.bottom,
		titlePrefix = v12.titlePrefix,
		titleAmount = REFERRAL_REWARD_ROBUX,
		description = v12.description,
		youGet = {
			label = v12.youGetLabel,
			title = v12.rewardRobux,
			description = v12.youGetDescription
		},
		theyGet = {
			label = v12.theyGetLabel,
			title = v12.rewardRobux,
			description = v12.theyGetDescription
		},
		referralHistoryHeading = v12.referralHistoryHeading,
		successfulReferralsLabel = v12.successfulReferralsLabel,
		robuxEarnedLabel = v12.robuxEarnedLabel,
		successfulReferrals = formatPrice(v11 and v11.referralsCount),
		robuxEarned = formatPrice(v11 and v11.robuxEarnedFromReferrals),
		pendingRobuxLabel = 0,
		pendingRobux = 0,
		referButton = 0,
		isReferDisabled = 0,
		onClose = 0,
		onReferActivated = 0
	}
	local v17 = if v15 then v12.pendingRobuxLabel else nil
	v16.pendingRobuxLabel = v17
	local v18 = if v15 then formatPrice(pendingRobuxEarnedFromReferrals) else nil
	v16.pendingRobux = v18
	v16.referButton = v12.referButton
	v16.isReferDisabled = v10 == nil
	v16.onClose = v13
	v16.onReferActivated = v14
	return v16
end

return usePlusReferralDashboardViewModel
