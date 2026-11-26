local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Promise")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")

local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")

local FFlagProfileInspectAndBuyKeepUpsellDialogOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAndBuyKeepUpsellDialogOpen")

local FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagSocialEnableProfileInspectAndBuyAnalyticsV2")
local fFlagEnableRecentActivityInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableRecentActivityInspectAndBuy

local function useOpenRobuxUpsell(p2, callback)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = useProfileWrapperContext()

	local useCallback = React.useCallback
	local function fn()
		local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/PurchasePromptLite")
		local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CentralOverlay").Thunks.CloseCentralOverlay

		v5(PurchasePromptLite.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt({
			productPayload = { kind = "RobuxUpsell" },
			purchaseAnalyticsMetadata = FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 and {
				surface = PurchasePromptLite.Enums.ProductPurchaseSurface.Profile
			} or nil,
			purchaseCallbacks = {
				onFlowComplete = function()
					v5(closeCentralOverlay())
					local refreshRobuxBalance = if v7.postPurchase then v7.postPurchase.refreshRobuxBalance else nil

					if refreshRobuxBalance then
						refreshRobuxBalance()
					end

					if fFlagEnableRecentActivityInspectAndBuy and callback then
						callback()
					elseif not FFlagProfileInspectAndBuyKeepUpsellDialogOpen then
						v6.goBack()
					end
				end,
				fetchProductInfo = function()
					return Promise.resolve({
						PriceInRobux = p2,
						IsForSale = true,
						Name = "RobuxUpsell"
					})
				end
			}
		}))
	end

	return useCallback(fn, {
		v5,
		v6,
		v7.postPurchase,
		p2,
		if fFlagEnableRecentActivityInspectAndBuy then callback else nil
	})
end

return useOpenRobuxUpsell
