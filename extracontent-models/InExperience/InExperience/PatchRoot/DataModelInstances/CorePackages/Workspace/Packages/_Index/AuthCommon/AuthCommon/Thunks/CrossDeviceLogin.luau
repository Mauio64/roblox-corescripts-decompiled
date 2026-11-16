local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local PostEnterLoginCode = require(AuthCommon.Http.Requests.PostEnterLoginCode)
local PostConfirmLoginCode = require(AuthCommon.Http.Requests.PostConfirmLoginCode)
local PostCreateLoginCode = require(AuthCommon.Http.Requests.PostCreateLoginCode)
local PostLoginCodeStatus = require(AuthCommon.Http.Requests.PostLoginCodeStatus)
local PostCancelLoginCode = require(AuthCommon.Http.Requests.PostCancelLoginCode)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = SharedFlags.GetFFlagEnableCrossDeviceLoginUsingQRCodes
local FFlagEnableCrossDeviceApproverDialog = require(AuthCommon.Flags.FFlagEnableCrossDeviceApproverDialog)
local CrossDeviceLogin = {}

function CrossDeviceLogin.EnterCode(p, p2)
	return function(_)
		return PostEnterLoginCode(p, p2):andThen(function(p3)
			if not (p3 and p3.responseBody) then
				return nil
			end

			local v = {
				DeviceInfo = string.format("%s\n%s", p3.responseBody.deviceInfo or "", p3.responseBody.location or "")
			}

			if FFlagEnableCrossDeviceApproverDialog then
				v.Location = p3.responseBody.location or ""
				v.MapImagePath = p3.responseBody.mapImagePath or ""
			end

			return v
		end)
	end
end

function CrossDeviceLogin.FetchDeviceCode(p)
	return function(_)
		return PostCreateLoginCode(p):andThen(function(p2)
			local responseBody = p2 and p2.responseBody

			if not responseBody then
				return nil
			end

			local v = {
				DeviceCode = responseBody.code,
				PrivateKey = responseBody.privateKey,
				QrCodePath = 0
			}
			local qrCodePath

			if GetFFlagEnableCrossDeviceLoginUsingQRCodes() then
				qrCodePath = responseBody.imagePath
			end

			v.QrCodePath = qrCodePath
			return v
		end)
	end
end

function CrossDeviceLogin.GetLoginStatus(p, p2, p3)
	return function(_)
		return PostLoginCodeStatus(p, p2, p3):andThen(function(p4)
			local responseBody = p4 and p4.responseBody

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
end

function CrossDeviceLogin.OpenLoginCodePrompt(p)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.CrossDeviceCodePrompt, p))
	end
end

function CrossDeviceLogin.ConfirmDeviceAccess(p, p2)
	return function(_)
		return PostConfirmLoginCode(p, p2)
	end
end

function CrossDeviceLogin.CancelLoginCode(p, p2)
	return function(_)
		return PostCancelLoginCode(p, p2)
	end
end

function CrossDeviceLogin.OpenConfirmationOverlay(loginSuccess, closeCallback, retryCallback, deviceString)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.CrossDeviceLoginConfirmation, {
			loginSuccess = loginSuccess,
			closeCallback = closeCallback,
			retryCallback = retryCallback,
			deviceString = deviceString
		}))
	end
end

return CrossDeviceLogin
