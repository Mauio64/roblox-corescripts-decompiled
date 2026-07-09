local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local CentralOverlayType = require(AuthCommonParent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(AuthCommonParent.CentralOverlay).Actions.SetCentralOverlay
local PostEnterLoginCode = require(AuthCommon.Http.Requests.PostEnterLoginCode)
local PostConfirmLoginCode = require(AuthCommon.Http.Requests.PostConfirmLoginCode)
local PostCreateLoginCode = require(AuthCommon.Http.Requests.PostCreateLoginCode)
local PostLoginCodeStatus = require(AuthCommon.Http.Requests.PostLoginCodeStatus)
local PostCancelLoginCode = require(AuthCommon.Http.Requests.PostCancelLoginCode)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(AuthCommonParent.SharedFlags).GetFFlagEnableCrossDeviceLoginUsingQRCodes

return {
	EnterCode = function(p1, p2) -- line: 17
		-- upvalues: PostEnterLoginCode (copy)
		return function(_) -- line: 18
			-- upvalues: PostEnterLoginCode (copy), p1 (copy), p2 (copy)
			return PostEnterLoginCode(p1, p2):andThen(function(p4) -- line: 19
				if p4 and p4.responseBody then
					return {
						DeviceInfo = string.format("%s\n%s", p4.responseBody.deviceInfo or "", p4.responseBody.location or "")
					}
				end

				return nil
			end)
		end
	end,
	FetchDeviceCode = function(p5) -- line: 36
		-- upvalues: PostCreateLoginCode (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy)
		return function(_) -- line: 37
			-- upvalues: PostCreateLoginCode (copy), p5 (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy)
			return PostCreateLoginCode(p5):andThen(function(p7) -- line: 38
				-- upvalues: GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy)
				local v35 = p7 and p7.responseBody

				if v35 then
					return {
						DeviceCode = v35.code,
						PrivateKey = v35.privateKey,
						QrCodePath = if not GetFFlagEnableCrossDeviceLoginUsingQRCodes() then nil else v35.imagePath
					}
				end

				return nil
			end)
		end
	end,
	GetLoginStatus = function(p8, p9, p10) -- line: 53
		-- upvalues: PostLoginCodeStatus (copy)
		return function(_) -- line: 54
			-- upvalues: PostLoginCodeStatus (copy), p8 (copy), p9 (copy), p10 (copy)
			return PostLoginCodeStatus(p8, p9, p10):andThen(function(p12) -- line: 55
				local v37 = p12 and p12.responseBody

				if v37 then
					return {
						Status = v37.status,
						AccountName = v37.accountName,
						AccountPictureUrl = v37.accountPictureUrl,
						ExpirationTime = v37.expirationTime
					}
				end

				return nil
			end)
		end
	end,
	OpenLoginCodePrompt = function(p13) -- line: 71
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
		return function(p14) -- line: 72
			-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p13 (copy)
			p14:dispatch(SetCentralOverlay(CentralOverlayType.CrossDeviceCodePrompt, p13))
		end
	end,
	ConfirmDeviceAccess = function(p15, p16) -- line: 77
		-- upvalues: PostConfirmLoginCode (copy)
		return function(_) -- line: 78
			-- upvalues: PostConfirmLoginCode (copy), p15 (copy), p16 (copy)
			return PostConfirmLoginCode(p15, p16)
		end
	end,
	CancelLoginCode = function(p18, p19) -- line: 83
		-- upvalues: PostCancelLoginCode (copy)
		return function(_) -- line: 84
			-- upvalues: PostCancelLoginCode (copy), p18 (copy), p19 (copy)
			return PostCancelLoginCode(p18, p19)
		end
	end,
	OpenConfirmationOverlay = function(p21, p22, p23, p24) -- line: 89
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
		return function(p25) -- line: 90
			-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p21 (copy), p22 (copy), p23 (copy), p24 (copy)
			p25:dispatch(SetCentralOverlay(CentralOverlayType.CrossDeviceLoginConfirmation, {
				loginSuccess = p21,
				closeCallback = p22,
				retryCallback = p23,
				deviceString = p24
			}))
		end
	end
}
