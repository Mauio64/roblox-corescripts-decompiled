local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/CentralOverlay").Actions.SetCentralOverlay
local PostEnterLoginCode = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/PostEnterLoginCode")
local PostConfirmLoginCode = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/PostConfirmLoginCode")
local PostCreateLoginCode = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/PostCreateLoginCode")
local PostLoginCodeStatus = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/PostLoginCodeStatus")
local PostCancelLoginCode = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/PostCancelLoginCode")

local getFFlagEnableCrossDeviceLoginUsingQRCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableCrossDeviceLoginUsingQRCodes
local FFlagEnableCrossDeviceApproverDialog = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnableCrossDeviceApproverDialog")

return {
	EnterCode = function(p2, p3)
		return function(p4)
			return PostEnterLoginCode(p2, p3):andThen(function(p5)
				if not (p5 and p5.responseBody) then
					return nil
				end

				local v5 = {
					DeviceInfo = string.format(
						"%s\n%s",
						p5.responseBody.deviceInfo or "",
						p5.responseBody.location or ""
					)
				}

				if FFlagEnableCrossDeviceApproverDialog then
					v5.Location = p5.responseBody.location or ""
					v5.MapImagePath = p5.responseBody.mapImagePath or ""
				end

				return v5
			end)
		end
	end,
	FetchDeviceCode = function(p2)
		return function(p3)
			return PostCreateLoginCode(p2):andThen(function(p4)
				local responseBody = p4 and p4.responseBody

				if not responseBody then
					return nil
				end

				local v5 = {
					DeviceCode = responseBody.code,
					PrivateKey = responseBody.privateKey,
					QrCodePath = 0
				}
				local v6 = if getFFlagEnableCrossDeviceLoginUsingQRCodes() then responseBody.imagePath else nil
				v5.QrCodePath = v6
				return v5
			end)
		end
	end,
	GetLoginStatus = function(p2, p3, p4)
		return function(p5)
			return PostLoginCodeStatus(p2, p3, p4):andThen(function(p6)
				local responseBody = p6 and p6.responseBody

				if responseBody then
					return {
						Status = responseBody.status,
						AccountName = responseBody.accountName,
						AccountPictureUrl = responseBody.accountPictureUrl,
						ExpirationTime = responseBody.expirationTime
					}
				end

				return nil
			end)
		end
	end,
	OpenLoginCodePrompt = function(p2)
		return function(object)
			object:dispatch(setCentralOverlay(centralOverlayType.CrossDeviceCodePrompt, p2))
		end
	end,
	ConfirmDeviceAccess = function(p2, p3)
		return function(p4)
			return PostConfirmLoginCode(p2, p3)
		end
	end,
	CancelLoginCode = function(p2, p3)
		return function(p4)
			return PostCancelLoginCode(p2, p3)
		end
	end,
	OpenConfirmationOverlay = function(p2, p3, p4, p5)
		return function(object)
			object:dispatch(setCentralOverlay(centralOverlayType.CrossDeviceLoginConfirmation, {
				loginSuccess = p2,
				closeCallback = p3,
				retryCallback = p4,
				deviceString = p5
			}))
		end
	end
}
