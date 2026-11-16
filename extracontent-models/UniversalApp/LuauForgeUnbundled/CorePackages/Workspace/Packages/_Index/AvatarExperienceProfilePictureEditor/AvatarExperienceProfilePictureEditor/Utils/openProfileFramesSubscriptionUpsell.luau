local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AmpUpsell")
local openAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RobloxSubscriptionPurchaseApp")
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local purchaseClientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType

local ProfileFrameAmpConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/ProfileFrameAmpConstants")

local function openProfileFramesSubscriptionUpsell(data)
	local dispatch = data.dispatch
	local onGranted = data.onGranted
	local onDenied = data.onDenied

	local purchaseFlowUuid = data.purchaseFlowUuid
	local v5 = {
		purchaseUIOptions = { showBackButton = false },
		surfaceName = surfaceName.ProfileFramesUpsell,
		surfaceContext = surfaceContext.InApp,
		analyticsContext = purchaseFlowUuid and purchaseFlowUuid ~= "" and {
			clientSessionId = {
				clientSessionIdType = purchaseClientSessionIdType.PurchaseFlowUUID,
				clientSessionId = purchaseFlowUuid
			}
		} or nil
	}

	dispatch(openAmpWizardContainer(ProfileFrameAmpConstants.FEATURE_NAME, function(p2, p3)
		if p2 == accessResponseEnum.Granted then
			if onGranted then
				onGranted()
			end
		elseif onDenied then
			onDenied()
		end
	end, v5, ProfileFrameAmpConstants.ENTRY_POINT_EVENT_CTX, nil, ProfileFrameAmpConstants.NAME_SPACE))
end

return openProfileFramesSubscriptionUpsell
