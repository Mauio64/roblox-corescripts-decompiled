local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local CrossDeviceLogin = require(Modules.LuaApp.Thunks.Authentication.CrossDeviceLogin)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local LoginCodeStatus = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.LoginCodeStatus)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local GetIXPLayerParameters = require(Modules.LuaApp.Http.Requests.GetIXPLayerParameters)
local GetFFlagCrossDeviceInstructionExperiment = require(Modules.LuaApp.Flags.GetFFlagCrossDeviceInstructionExperiment)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceLoginUsingQRCodes)
local GetFFlagDisableCDLQrCodeForMaquettes = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDisableCDLQrCodeForMaquettes
local GetFFlagEnableShortLinkCodeForVRCDL = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableShortLinkCodeForVRCDL
local v23 = Roact.PureComponent:extend("LoginCodePrompt")
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local LoginCodeComponent = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.LoginCodeComponent)
local ShortLinkLoginCodeComponent = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.ShortLinkLoginCodeComponent)
local LoginCodeOverlay = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.LoginCodeOverlay)

function v23.init(p1) -- line: 55
	-- upvalues: LoginCodeStatus (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), UrlBuilder (copy)
	p1:setState({
		DeviceCode = "",
		AccountPictureUrl = "",
		DisplayName = "",
		AltTitle = nil,
		AltInstruction = nil,
		AltMobileInstruction = nil,
		AltDesktopInstruction = nil,
		Status = LoginCodeStatus.Created
	})

	function p1.fetchCode(p2) -- line: 68
		-- upvalues: p1 (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), UrlBuilder (copy)
		p1.props.fetchCode(p2):andThen(function(p3) -- line: 69
			-- upvalues: p1 (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), UrlBuilder (copy)
			if p1.isMounted then
				if GetFFlagEnableCrossDeviceLoginUsingQRCodes() and p3.QrCodePath then
					local v63 = UrlBuilder.fromString("apis:auth-token-service" .. p3.QrCodePath)

					p1:setState({
						DeviceCode = p3.DeviceCode,
						QrCodeUrl = v63()
					})
				else
					p1:setState({
						DeviceCode = p3.DeviceCode
					})
				end

				p1.pollLoginStatus(49, p3.DeviceCode, p3.PrivateKey)
			end
		end, function(p4) -- line: 84
			-- upvalues: p1 (copy)
			p1.closeWithError(p4)
		end)
	end

	local function retryPoll(p5, p6, p7) -- line: 89
		-- upvalues: p1 (copy)
		spawn(function() -- line: 90
			-- upvalues: p1 (copy), p5 (copy), p6 (copy), p7 (copy)
			wait(6)

			if p1.isMounted then
				if p5 > 0 then
					p1.pollLoginStatus(p5 - 1, p6, p7)

					return
				end

				p1.codeExpired()
			end
		end)
	end

	function p1.pollLoginStatus(p8, p9, p10) -- line: 102
		-- upvalues: p1 (copy), LoginCodeStatus (copy)
		p1.props.getLoginStatus(p1.props.networking, p9, p10):andThen(function(p11) -- line: 103
			-- upvalues: p1 (copy), LoginCodeStatus (copy), p9 (copy), p10 (copy), p8 (copy)
			if p1.isMounted then
				if p11.Status == LoginCodeStatus.Validated then
					p1.props.closeCentralOverlay()

					if p1.props.loginCallback then
						p1.props.loginCallback(p9, p10)

						return
					end
				else
					if p11.Status == LoginCodeStatus.Expired or p11.Status == LoginCodeStatus.Cancelled then
						p1.codeExpired()

						return
					end

					if p1.state.DisplayName == "" and p11.AccountName ~= "" then
						p1.props.authAnalytics.reportScreenLoaded("confirmPrompt")
					end

					p1:setState({
						Status = p11.Status,
						DisplayName = p11.AccountName,
						AccountPictureUrl = p11.AccountPictureUrl
					})

					local v66 = p8
					local v67 = p9
					local v68 = p10

					spawn(function() -- line: 90
						-- upvalues: p1 (copy), v66 (copy), v67 (copy), v68 (copy)
						wait(6)

						if p1.isMounted then
							if v66 > 0 then
								p1.pollLoginStatus(v66 - 1, v67, v68)

								return
							end

							p1.codeExpired()
						end
					end)
				end
			end
		end, function(p12) -- line: 125
			-- upvalues: p1 (copy)
			if p12.Body == "\"CodeInvalid\"" then
				p1.codeExpired()

				return
			end

			p1.closeWithError(p12)
		end)
	end
	function p1.codeExpired() -- line: 134
		-- upvalues: p1 (copy), LoginCodeStatus (copy)
		if p1.isMounted then
			p1:setState({
				DeviceCode = "",
				AccountPictureUrl = "",
				DisplayName = "",
				Status = LoginCodeStatus.Created
			})
			p1.fetchCode(p1.props.networking)
		end
	end
	function p1.closeButtonPressed() -- line: 146
		-- upvalues: p1 (copy)
		if p1.state.DeviceCode ~= "" then
			p1.props.cancelLoginCode(p1.props.networking, p1.state.DeviceCode)
		end

		p1.props.closeCentralOverlay()
	end
	function p1.closeWithError(p13) -- line: 153
		-- upvalues: p1 (copy)
		if p13 and p13.Body == "\"InvalidLocation\"" then
			p1.props.setLocationErrorToast()
		else
			p1.props.setNetworkingErrorToast()
		end

		p1.closeButtonPressed()
	end
end
function v23.didMount(p14) -- line: 163
	-- upvalues: EventStreamConstants (copy), GetFFlagCrossDeviceInstructionExperiment (copy), GetIXPLayerParameters (copy)
	p14.isMounted = true
	p14.props.authAnalytics.reportScreenLoaded(EventStreamConstants.Context.CrossDeviceKey)
	p14.fetchCode(p14.props.networking)

	if GetFFlagCrossDeviceInstructionExperiment() then
		GetIXPLayerParameters(p14.props.networking, "PlayerApp.CrossDeviceLogin.DisplayCode", {
			"alt_title",
			"alt_instruction",
			"alt_mobile_instruction",
			"alt_desktop_instruction"
		}):andThen(function(p15) -- line: 174
			-- upvalues: p14 (copy)
			local v51 = p15 and p15.responseBody

			if type(v51) == "table" and (next(v51) and p14.isMounted) then
				p14:setState({
					AltTitle = v51.alt_title ~= "" and v51.alt_title or nil,
					AltInstruction = v51.alt_instruction ~= "" and v51.alt_instruction or nil,
					AltMobileInstruction = v51.alt_mobile_instruction ~= "" and v51.alt_mobile_instruction or nil,
					AltDesktopInstruction = v51.alt_desktop_instruction ~= "" and v51.alt_desktop_instruction or nil
				})
			end
		end)
	end
end
function v23.willUnmount(p16) -- line: 192
	p16.isMounted = false
end
function v23.render(p17) -- line: 196
	-- upvalues: withStyle (copy), GetFFlagEnableShortLinkCodeForVRCDL (copy), IsVRAppBuild (copy), Roact (copy), ShortLinkLoginCodeComponent (copy), LoginCodeComponent (copy), LoginCodeOverlay (copy)
	local v35 = p17.props.isDualLayout or p17.state.DisplayName == ""
	local v36 = p17.props.isDualLayout and p17.state.DisplayName ~= ""

	return withStyle(function(_) -- line: 199
		-- upvalues: GetFFlagEnableShortLinkCodeForVRCDL (copy), IsVRAppBuild (copy), Roact (copy), ShortLinkLoginCodeComponent (copy), p17 (copy), LoginCodeComponent (copy), v35 (copy), v36 (copy), LoginCodeOverlay (copy)
		local v53 = if not GetFFlagEnableShortLinkCodeForVRCDL() or not IsVRAppBuild() then Roact.createElement(LoginCodeComponent, {
			Status = p17.state.Status,
			DeviceCode = p17.state.DeviceCode,
			AccountPictureUrl = p17.state.AccountPictureUrl,
			DisplayName = p17.state.DisplayName,
			QrCodeUrl = p17.state.QrCodeUrl,
			showCodeView = v35,
			showConfirmLoginText = v36,
			AltTitle = p17.state.AltTitle,
			AltInstruction = p17.state.AltInstruction,
			AltMobileInstruction = p17.state.AltMobileInstruction,
			AltDesktopInstruction = p17.state.AltDesktopInstruction,
			disableCdlQrCodeForMaquettes = p17.props.disableCdlQrCodeForMaquettes,
			hideDeviceCode = p17.props.hideDeviceCode,
			showLockIcon = p17.props.showLockIcon,
			isDualLayout = p17.props.isDualLayout,
			isCrossApp = p17.props.isCrossApp
		}) else Roact.createElement(ShortLinkLoginCodeComponent, {
			ShortLink = "roblox.com/quest",
			DeviceCode = p17.state.DeviceCode
		})

		if p17.props.isOverlay then
			return Roact.createElement(LoginCodeOverlay, {
				loginCode = v53,
				screenSize = p17.props.screenSize,
				onCloseClicked = p17.closeButtonPressed
			}, {
				ViewContainer = v53
			})
		end

		return v53
	end)
end

local v28 = RoactServices.connect({
	networking = RoactNetworking,
	authAnalytics = RoactAnalyticsAuthEvents
})(v23)
local v29 = RoactRodux.connect(function(p19, _) -- line: 246
	return {
		screenSize = p19.ScreenSize
	}
end, function(p21) -- line: 250
	-- upvalues: CloseCentralOverlay (copy), CrossDeviceLogin (copy), SetNetworkingErrorToast (copy), SetCurrentToastMessage (copy), ToastType (copy)
	return {
		closeCentralOverlay = function() -- line: 252
			-- upvalues: p21 (copy), CloseCentralOverlay (copy)
			return p21(CloseCentralOverlay())
		end,
		fetchCode = function(p22) -- line: 255
			-- upvalues: p21 (copy), CrossDeviceLogin (copy)
			return p21(CrossDeviceLogin.FetchDeviceCode(p22))
		end,
		getLoginStatus = function(p23, p24, p25) -- line: 258
			-- upvalues: p21 (copy), CrossDeviceLogin (copy)
			return p21(CrossDeviceLogin.GetLoginStatus(p23, p24, p25))
		end,
		cancelLoginCode = function(p26, p27) -- line: 261
			-- upvalues: p21 (copy), CrossDeviceLogin (copy)
			return p21(CrossDeviceLogin.CancelLoginCode(p26, p27))
		end,
		setNetworkingErrorToast = function(_) -- line: 264
			-- upvalues: p21 (copy), SetNetworkingErrorToast (copy)
			p21(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))
		end,
		setLocationErrorToast = function(_) -- line: 267
			-- upvalues: p21 (copy), SetCurrentToastMessage (copy), ToastType (copy)
			p21(SetCurrentToastMessage({
				toastMessage = "Authentication.CrossDevice.Label.NotAvailableOnNetwork",
				toastType = ToastType.NetworkingError
			}))
		end
	}
end)(v28)

if GetFFlagDisableCDLQrCodeForMaquettes() then
	v29 = RoactAppPolicy.connect(function(p30, _) -- line: 277
		return {
			disableCdlQrCodeForMaquettes = p30.getDisableCDLQrCodeForMaquettes() or false
		}
	end)(v29)
end

return v29
