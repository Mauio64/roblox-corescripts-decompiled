local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local AmpUpsell = require(parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local PurchaseClientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType

local ProfileFrameAmpConstants = require(AvatarExperienceProfilePictureEditor.Common.ProfileFrameAmpConstants)

local function openProfileFramesSubscriptionUpsell(data)
	local dispatch = data.dispatch
	local onGranted = data.onGranted
	local onDenied = data.onDenied

	local purchaseFlowUuid = data.purchaseFlowUuid
	local v = {
		purchaseUIOptions = { showBackButton = false },
		surfaceName = SurfaceName.ProfileFramesUpsell,
		surfaceContext = SurfaceContext.InApp,
		analyticsContext = purchaseFlowUuid and purchaseFlowUuid ~= "" and {
			clientSessionId = {
				clientSessionIdType = PurchaseClientSessionIdType.PurchaseFlowUUID,
				clientSessionId = purchaseFlowUuid
			}
		} or nil
	}

	dispatch(OpenAmpWizardContainer(ProfileFrameAmpConstants.FEATURE_NAME, function(p, _)
		if p == AccessResponseEnum.Granted then
			if onGranted then
				onGranted()
			end
		elseif onDenied then
			onDenied()
		end
	end, v, ProfileFrameAmpConstants.ENTRY_POINT_EVENT_CTX, nil, ProfileFrameAmpConstants.NAME_SPACE))
end

return openProfileFramesSubscriptionUpsell
