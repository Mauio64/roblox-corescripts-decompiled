local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Promise = require(ProfilePlatformParent.Promise)
local Navigation = require(ProfilePlatformParent.Navigation)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

local function useOpenRobuxUpsell(n1: number) -- line: 13
	-- upvalues: useDispatch (copy), useNavigation (copy), useProfileWrapperContext (copy), React (copy), ProfilePlatformParent (copy), Promise (copy)
	local v12 = useDispatch()
	local v13 = useNavigation()
	local v14 = useProfileWrapperContext()

	return React.useCallback(function() -- line: 18
		-- upvalues: ProfilePlatformParent (copy), v12 (copy), v14 (copy), v13 (copy), Promise (copy), n1 (copy)
		local PurchasePromptLite = require(ProfilePlatformParent.PurchasePromptLite)
		local CloseCentralOverlay = require(ProfilePlatformParent.CentralOverlay).Thunks.CloseCentralOverlay

		v12(PurchasePromptLite.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt({
			productPayload = {
				kind = "RobuxUpsell"
			},
			purchaseCallbacks = {
				onFlowComplete = function() -- line: 27
					-- upvalues: v12 (copy), CloseCentralOverlay (copy), v14 (copy), v13 (copy)
					v12(CloseCentralOverlay())

					local v17 = if not v14.postPurchase then nil else v14.postPurchase.refreshRobuxBalance

					if v17 then
						v17()
					end

					v13.goBack()
				end,
				fetchProductInfo = function() -- line: 37
					-- upvalues: Promise (copy), n1 (copy)
					return Promise.resolve({
						IsForSale = true,
						Name = "RobuxUpsell",
						PriceInRobux = n1
					})
				end
			}
		}))
	end, {
		v12,
		v13,
		v14.postPurchase,
		n1
	})
end

return useOpenRobuxUpsell
