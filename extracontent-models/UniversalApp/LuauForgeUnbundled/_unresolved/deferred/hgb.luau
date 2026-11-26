local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/deferred/hcO")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module3 = require("@luauforge/bundled/fHh")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
require("@luauforge/bundled/dPs")

local backgroundsPlusLocalizationKeys = module.BackgroundsPlusLocalizationKeys
local backgroundsPlusAnalytics = module.BackgroundsPlusAnalytics
local entrySource = backgroundsPlusAnalytics.EntrySource
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics
local fFlagBackgroundsUpsellFreeTrial = AvatarExperienceFlags.FFlagBackgroundsUpsellFreeTrial

return (React.forwardRef(function(p2, p3)
	local v5 = module.useBackgroundsPlusAccess()
	local v6

	if fFlagAXBackgroundGenerationAnalytics then
		v6 = backgroundsPlusAnalytics.useUpsellImpressionTarget(
			entrySource.MarketplaceBanner,
			nil,
			v5.backgroundVariants.showMarketplaceExclusiveSection,
			true
		)
	end

	local v7 = {
		subscribe = backgroundsPlusLocalizationKeys.Subscribe,
		unlockExclusiveBackgrounds = backgroundsPlusLocalizationKeys.UnlockExclusiveBackgroundsWithPlus
	}

	if fFlagBackgroundsUpsellFreeTrial then
		v7.tryItForFree = backgroundsPlusLocalizationKeys.TryItForFree
	end

	local v8 = useLocalization(v7)

	local openUpsellSubscriptionPurchase = if fFlagAXBackgroundGenerationAnalytics then v5.openUpsellSubscriptionPurchase else nil

	local v9 = React.useCallback(function()
		if fFlagAXBackgroundGenerationAnalytics then
			if openUpsellSubscriptionPurchase then
				openUpsellSubscriptionPurchase(entrySource.MarketplaceBanner, nil)
			end
		else
			v5.openSubscriptionPurchase()
		end
	end, { openUpsellSubscriptionPurchase, v5.openSubscriptionPurchase })

	if not v5.backgroundVariants.showMarketplaceExclusiveSection then
		return nil
	end

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v10 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ref = p3,
		NextSelectionUp = p2.NextSelectionUp,
		NextSelectionDown = p2.NextSelectionDown
	}

	local createElement2 = React.createElement
	local view = Foundation.View

	if not fFlagAXBackgroundGenerationAnalytics then
		v6 = nil
	end

	local v14

	if fFlagBackgroundsUpsellFreeTrial then
		v14 = React.createElement(module3.Components.RobloxPlusUpsellBanner, {
			message = v8.unlockExclusiveBackgrounds,
			subscribeText = v8.subscribe,
			freeTrialText = v8.tryItForFree,
			onActivated = v9,
			showPlusIcon = true,
			testId = "BackgroundsPlusSubscribeBanner",
			renderBanner = function(p4)
				return React.createElement(module.BackgroundsPlusSubscribeBanner, p4)
			end
		})
	else
		v14 = React.createElement(module.BackgroundsPlusSubscribeBanner, {
			message = v8.unlockExclusiveBackgrounds,
			actionText = v8.subscribe,
			onActivated = v9,
			showPlusIcon = true
		})
	end

	return createElement(frame, v10, {
		Banner = createElement2(view, {
			tag = "size-full-0 auto-y padding-bottom-medium",
			ref = v6
		}, {
			Content = v14
		})
	})
end))
