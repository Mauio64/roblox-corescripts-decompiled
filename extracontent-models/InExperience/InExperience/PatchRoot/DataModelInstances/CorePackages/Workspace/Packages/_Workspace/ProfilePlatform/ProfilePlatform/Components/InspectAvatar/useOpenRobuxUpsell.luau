local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Promise = require(parent.Promise)
local Navigation = require(parent.Navigation)
local RoactUtils = require(parent.RoactUtils)

local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

local FFlagProfileInspectAndBuyKeepUpsellDialogOpen = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyKeepUpsellDialogOpen)

local FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 = require(ProfilePlatform.Flags.FFlagSocialEnableProfileInspectAndBuyAnalyticsV2)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableRecentActivityInspectAndBuy = SharedFlags.FFlagEnableRecentActivityInspectAndBuy

local function useOpenRobuxUpsell(priceInRobux: number, callback)
	local v = useDispatch()
	local v2 = useNavigation()
	local v3 = useProfileWrapperContext()

	local useCallback = React.useCallback
	local function fn()
		local PurchasePromptLite = require(parent.PurchasePromptLite)
		local CentralOverlay = require(parent.CentralOverlay)
		local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

		v(PurchasePromptLite.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt({
			productPayload = { kind = "RobuxUpsell" },
			purchaseAnalyticsMetadata = FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 and {
				surface = PurchasePromptLite.Enums.ProductPurchaseSurface.Profile
			} or nil,
			purchaseCallbacks = {
				onFlowComplete = function()
					v(closeCentralOverlay())
					local refreshRobuxBalance

					if v3.postPurchase then
						refreshRobuxBalance = v3.postPurchase.refreshRobuxBalance
					end

					if refreshRobuxBalance then
						refreshRobuxBalance()
					end

					if FFlagEnableRecentActivityInspectAndBuy and callback then
						callback()
					elseif not FFlagProfileInspectAndBuyKeepUpsellDialogOpen then
						v2.goBack()
					end
				end,
				fetchProductInfo = function()
					return Promise.resolve({
						PriceInRobux = priceInRobux,
						IsForSale = true,
						Name = "RobuxUpsell"
					})
				end
			}
		}))
	end

	local postPurchase = v3.postPurchase
	local v4

	if FFlagEnableRecentActivityInspectAndBuy then
		v4 = callback
	end

	return useCallback(fn, { v, v2, postPurchase, priceInRobux, v4 })
end

return useOpenRobuxUpsell
