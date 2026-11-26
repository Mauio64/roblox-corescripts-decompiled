local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/grb")
local module3 = require("@luauforge/bundled/fzS")

local module4 = require("@luauforge/bundled/gyh")
local module5 = require("@luauforge/bundled/egt")
local module6 = require("@luauforge/bundled/fCM")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local module7 = require("@luauforge/bundled/gyi")

local module8 = require("@luauforge/bundled/dFm")
local module9 = require("@luauforge/bundled/dzE")

local module10 = require("@luauforge/bundled/fzK")

local module11 = require("@luauforge/bundled/gyj")

local module12 = require("@luauforge/bundled/gyk")

local module13 = require("@luauforge/bundled/fJl")

local getFFlagDisableCDLQrCodeForMaquettes = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagDisableCDLQrCodeForMaquettes

local getFFlagEnableShortLinkCodeForVRCDL = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableShortLinkCodeForVRCDL

local module14 = require("@luauforge/bundled/gyl")

local fFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose

local extended = Roact.PureComponent:extend("LoginCodePrompt")

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module15 = require("@luauforge/bundled/gym")

local module16 = require("@luauforge/bundled/gys")
local module17 = require("@luauforge/bundled/gyt")

function extended:init()
	self.contentStartRef = Roact.createRef()

	self.isClosing = false

	self.dismissedByLoginAttempt = false

	self:setState({
		Status = module7.Created,
		DeviceCode = "",
		AccountPictureUrl = "",
		DisplayName = "",
		AltTitle = nil,
		AltInstruction = nil,
		AltMobileInstruction = nil,
		AltDesktopInstruction = nil
	})

	function self.fetchCode(p2)
		self.props.fetchCode(p2):andThen(function(data)
			if self.isMounted then
				if module13() and data.QrCodePath then
					local v5 = module10.fromString("apis:auth-token-service" .. data.QrCodePath)
					self:setState({ DeviceCode = data.DeviceCode, QrCodeUrl = v5() })
				else
					self:setState({ DeviceCode = data.DeviceCode })
				end

				self.pollLoginStatus(49, data.DeviceCode, data.PrivateKey)
			end
		end, function(p3)
			self.closeWithError(p3)
		end)
	end

	local function retryPoll(p2, p3, p4)
		spawn(function()
			wait(6)

			if self.isMounted then
				if p2 > 0 then
					self.pollLoginStatus(p2 - 1, p3, p4)
				else
					self.codeExpired()
				end
			end
		end)
	end

	function self.pollLoginStatus(p2, p3, p4)
		self.props.getLoginStatus(self.props.networking, p3, p4):andThen(function(data)
			if self.isMounted then
				if module14 and self.isClosing then
					return
				end

				if data.Status == module7.Validated then
					self.dismissedByLoginAttempt = true
					self.props.closeCentralOverlay()

					if self.props.loginCallback then
						self.props.loginCallback(p3, p4)
					end

					if self.props.refreshCodeAfterHandoff then
						self.codeExpired()
					end
				else
					if data.Status == module7.Expired or data.Status == module7.Cancelled then
						self.codeExpired()
						return
					end

					if self.state.DisplayName == "" and data.AccountName ~= "" then
						self.props.authAnalytics.reportScreenLoaded("confirmPrompt")
					end

					self:setState({
						Status = data.Status,
						DisplayName = data.AccountName,
						AccountPictureUrl = data.AccountPictureUrl
					})

					local v5 = p2
					local v6 = p3
					local v7 = p4
					spawn(function()
						wait(6)

						if self.isMounted then
							if v5 > 0 then
								self.pollLoginStatus(v5 - 1, v6, v7)
							else
								self.codeExpired()
							end
						end
					end)
				end
			end
		end, function(p5)
			if p5.Body == "\"CodeInvalid\"" then
				self.codeExpired()
			else
				self.closeWithError(p5)
			end
		end)
	end

	function self.codeExpired()
		if self.isMounted then
			self:setState({
				Status = module7.Created,
				DeviceCode = "",
				AccountPictureUrl = "",
				DisplayName = ""
			})

			self.fetchCode(self.props.networking)
		end
	end

	function self.closeButtonPressed()
		self.isClosing = true

		if self.state.DeviceCode ~= "" then
			self.props.cancelLoginCode(self.props.networking, self.state.DeviceCode)
		end

		self.props.closeCentralOverlay()
	end

	function self.leaveLogin()
		self.closeButtonPressed()
		self.props.onLeaveLogin()
	end

	function self.returnToLogin()
		self.closeButtonPressed()
		self.props.onReturnToLogin()
	end

	function self.closeWithError(p2)
		if p2 and p2.Body == "\"InvalidLocation\"" then
			self.props.setLocationErrorToast()
		else
			self.props.setNetworkingErrorToast()
		end

		self.dismissedByLoginAttempt = true
		self.closeButtonPressed()
	end
end

function extended:didMount()
	self.isMounted = true
	self.props.authAnalytics.reportScreenLoaded(module3.Context.CrossDeviceKey)
	self.fetchCode(self.props.networking)

	if module12() then
		module11(self.props.networking, "PlayerApp.CrossDeviceLogin.DisplayCode", {
			"alt_title",
			"alt_instruction",
			"alt_mobile_instruction",
			"alt_desktop_instruction"
		}):andThen(function(p2)
			local responseBody = p2 and p2.responseBody
			local v5 = type(responseBody) == "table" and (next(responseBody) and self.isMounted)

			if v5 then
				local v8 = if responseBody.alt_title ~= "" then responseBody.alt_title or nil else nil
				local v9 = if responseBody.alt_instruction ~= "" then responseBody.alt_instruction or nil else nil
				local v10 = if responseBody.alt_mobile_instruction ~= "" then responseBody.alt_mobile_instruction or nil else nil

				local v11 = if responseBody.alt_desktop_instruction ~= "" then responseBody.alt_desktop_instruction or nil else nil
				self:setState({
					AltTitle = v8,
					AltInstruction = v9,
					AltMobileInstruction = v10,
					AltDesktopInstruction = v11
				})
			end
		end)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if fFlagShowSavedCredentialsPromptOnCrossDeviceLoginClose and self.props.onDismiss then
		self.props.onDismiss(self.dismissedByLoginAttempt)
	end
end

function extended.render(data)
	if data.props.renderCodePanel then
		return data.props.renderCodePanel({
			deviceCode = data.state.DeviceCode,
			qrCodeUrl = data.state.QrCodeUrl,
			status = data.state.Status
		})
	end

	local isDualLayout = data.props.isDualLayout or data.state.DisplayName == ""
	local v5 = data.props.isDualLayout and data.state.DisplayName ~= ""
	return withStyle(function(p2)
		local v6

		if getFFlagEnableShortLinkCodeForVRCDL() and isVRAppBuild() then
			v6 = Roact.createElement(module16, {
				DeviceCode = data.state.DeviceCode,
				ShortLink = "roblox.com/quest"
			})
		else
			local createElement = Roact.createElement
			local v8 = {
				Status = data.state.Status,
				DeviceCode = data.state.DeviceCode,
				AccountPictureUrl = data.state.AccountPictureUrl,
				DisplayName = data.state.DisplayName,
				QrCodeUrl = data.state.QrCodeUrl,
				showCodeView = isDualLayout,
				showConfirmLoginText = v5,
				AltTitle = data.state.AltTitle,
				AltInstruction = data.state.AltInstruction,
				AltMobileInstruction = data.state.AltMobileInstruction,
				AltDesktopInstruction = data.state.AltDesktopInstruction,
				disableCdlQrCodeForMaquettes = data.props.disableCdlQrCodeForMaquettes,
				hideDeviceCode = data.props.hideDeviceCode,
				showLockIcon = data.props.showLockIcon,
				isDualLayout = data.props.isDualLayout,
				isCrossApp = data.props.isCrossApp,
				usesFoundationSheetOverlay = data.props.useFoundationSheet and data.props.isOverlay,
				contentStartRef = data.contentStartRef,
				onHavingTroubleActivated = 0,
				renderNeedHelpButton = 0
			}
			local v9 = if data.props.renderNeedHelpButton then data.closeButtonPressed else nil
			v8.onHavingTroubleActivated = v9
			v8.renderNeedHelpButton = data.props.renderNeedHelpButton
			v6 = createElement(module15, v8)
		end

		if not data.props.isOverlay then
			return v6
		end

		local createElement = Roact.createElement
		local v8 = {
			loginCode = v6,
			screenSize = data.props.screenSize,
			onCloseClicked = 0,
			onLeaveLogin = 0,
			useFoundationSheet = 0,
			contentStartRef = 0,
			isWaitingForConfirmation = 0
		}
		local v9 = if data.props.onReturnToLogin then data.returnToLogin else data.closeButtonPressed
		v8.onCloseClicked = v9
		local v10 = if data.props.onLeaveLogin then data.leaveLogin else nil
		v8.onLeaveLogin = v10
		v8.useFoundationSheet = data.props.useFoundationSheet
		v8.contentStartRef = data.contentStartRef
		local v11 = if data.props.useFoundationSheet then not isDualLayout else nil
		v8.isWaitingForConfirmation = v11
		return createElement(module17, v8, { ViewContainer = v6 })
	end)
end

local v5 = roactServices.connect({ networking = module, authAnalytics = module2 })(extended)

local v6 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(module6())
		end,
		fetchCode = function(p2)
			return callback(module4.FetchDeviceCode(p2))
		end,
		getLoginStatus = function(p2, p3, p4)
			return callback(module4.GetLoginStatus(p2, p3, p4))
		end,
		cancelLoginCode = function(p2, p3)
			return callback(module4.CancelLoginCode(p2, p3))
		end,
		setNetworkingErrorToast = function(p2)
			callback(module5({ HttpError = Enum.HttpError.OK }))
		end,
		setLocationErrorToast = function(p2)
			callback(module8({
				toastType = module9.NetworkingError,
				toastMessage = "Authentication.CrossDevice.Label.NotAvailableOnNetwork"
			}))
		end
	}
end)(v5)

if getFFlagDisableCDLQrCodeForMaquettes() then
	v6 = roactAppPolicy.connect(function(p2, p3)
		return {
			disableCdlQrCodeForMaquettes = p2.getDisableCDLQrCodeForMaquettes() or false
		}
	end)(v6)
end

return v6
