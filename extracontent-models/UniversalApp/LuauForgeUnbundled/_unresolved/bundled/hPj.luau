local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/egZ")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/egx")
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local module3 = require("@luauforge/bundled/gyh")
local module4 = require("@luauforge/bundled/grb")
local module5 = require("@luauforge/bundled/hPk")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module7 = require("@luauforge/bundled/hPh")

local module8 = require("@luauforge/bundled/hPi")

local module9 = require("@luauforge/bundled/hPl")
local getFFlagEnableAuthsecImageUpdate = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuthsecImageUpdate
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local module10 = require("@luauforge/bundled/hPe")

local module11 = require("@luauforge/bundled/hPn")

local fFlagEnableCrossDeviceApproverDialog = require("@game/CorePackages/Workspace/Packages/AuthCommon").Flags.FFlagEnableCrossDeviceApproverDialog

local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconsgraphicdevices_xxlarge = images["icons/graphic/devices_xxlarge"]

local iconSize2 = getIconSize(iconSize.XLarge)

local iconsstatusalert = images["icons/status/alert"]
local iconSizeUDim2 = getIconSizeUDim2(iconSize.Medium)

local extended = Roact.PureComponent:extend("CrossDeviceConfirmLoginView")
local module12 = require("@luauforge/bundled/fzS")

function extended:init()
	self:setState({ isConfirming = false, approverPhase = "confirm" })

	function self.getVerifyCodeImage(p2): string
		if p2 == Foundation.Enums.ColorMode.Dark then
			return "icons/graphic/verifyCode_dark"
		end

		return "icons/graphic/verifyCode_light"
	end

	self.confirming = false
	function self.reportApproverButton(p2)
		if module11() then
			self.props.authAnalytics.reportAuthButtonClick(module12.Context.ApproveQuickLogin, p2)
		else
			self.props.authAnalytics.reportButtonClicked(module12.Context.ApproveQuickLogin, p2)
		end
	end
	function self.confirmButtonPressed()
		if not self.confirming then
			self.confirming = true
			self:setState({ isConfirming = true })

			self.reportApproverButton(module12.Button.GrantAccess)
			local v5

			if fFlagEnableCrossDeviceApproverDialog then
				v5 = self.approverConfirmCallback
			else
				v5 = self.confirmCallback
			end

			self.props.confirmDeviceAccess(self.props.networking, self.props.deviceCode):andThen(
				function(p2)
					v5(true)
				end,
				function(p2)
					v5(false)
				end
			)
		end
	end

	function self.allowButtonPressed()
		if not self.confirming then
			self:setState({ pendingAction = "allow" })

			self.confirmButtonPressed()
		end
	end

	function self.denyButtonPressed()
		if not self.confirming then
			self.confirming = true
			self:setState({ pendingAction = "deny" })

			self.reportApproverButton(module12.Button.DenyAccess)
			self.props.cancelLoginCode(self.props.networking, self.props.deviceCode):andThen(function()
				if self.confirming then
					self.confirming = false
					self:setState({
						approverPhase = "denied",
						pendingAction = Roact.None
					})

					self.props.authAnalytics.reportScreenLoaded(module12.Context.QuickLoginDenied)
				end
			end, function()
				if self.confirming then
					self.confirming = false
					self.props.authAnalytics.reportScreenLoaded(module12.Context.QuickLoginFailed)
					self.props.failCallback()
				end
			end)
		end
	end

	function self.approverConfirmCallback(p2)
		if self.confirming then
			self.confirming = false

			if p2 then
				self:setState({
					approverPhase = "allowed",
					isConfirming = false,
					pendingAction = Roact.None
				})

				self.props.authAnalytics.reportScreenLoaded(module12.Context.QuickLoginSucceeded)

				if self.props.source == "vng" then
					default:logEphemeralCounterEvent(module5, 1)
					self.props.linking:openURL("robloxvng://")
				end
			else
				self.props.authAnalytics.reportScreenLoaded(module12.Context.QuickLoginFailed)
				self.props.failCallback()
			end
		end
	end

	function self.confirmCallback(p2)
		if self.confirming then
			self.confirming = false
			self:setState({ isConfirming = false })

			self.props.openConfirmationModal(
				p2,
				self.props.closeCallback,
				self.props.retryCallback,
				self.props.deviceString
			)

			if self.props.source == "vng" then
				RbxAnalyticsService:ReportCounter("CrossAppLoginSuccess", 1)
				self.props.linking:openURL("robloxvng://")
			end
		end
	end

	function self.closeButtonPressed()
		self.props.cancelLoginCode(self.props.networking, self.props.deviceCode)

		if self.props.closeCallback then
			self.props.closeCallback()
		end
	end

	function self.doneButtonPressed()
		self.reportApproverButton(module12.Button.Done)
		self.props.closeCallback()
	end
end

function extended.didMount(p2)
	p2.props.authAnalytics.reportScreenLoaded(module12.Context.ApproveQuickLogin)
end

function extended:willUnmount()
	self.confirming = false
end

function extended.render(props)
	local isWideView = props.props.isWideView
	local isConfirming = props.state.isConfirming

	if fFlagEnableCrossDeviceApproverDialog then
		return Roact.createElement(module9, {
			phase = props.state.approverPhase,
			pendingAction = props.state.pendingAction,
			onAllow = props.allowButtonPressed,
			onDeny = props.denyButtonPressed,
			onDone = props.doneButtonPressed,
			location = props.props.location,
			mapImagePath = props.props.mapImagePath
		})
	end

	local v5 = module10() and "Authentication.CrossDevice.Label.Confirm"
		or "Authentication.CrossDevice.Action.ConfirmLogin"

	return withStyle(function(p2)
		return module({
			heading = "Authentication.CrossDevice.Heading.Warning",
			confirmation1 = "Authentication.CrossDevice.Label.ConfirmationMessage1",
			confirmation2 = "Authentication.CrossDevice.Label.ConfirmationMessage2",
			confirmation3 = "Authentication.CrossDevice.Label.ConfirmationMessage3",
			confirm = v5,
			cancel = "Authentication.CrossDevice.Action.CancelLogin"
		})(function(props2)
			local designTokens = props.props.designTokens
			local udim = UDim2.fromOffset(
				designTokens.LuaApps.CrossDeviceLogin.iconSize,
				designTokens.LuaApps.CrossDeviceLogin.iconSize
			)

			local fontSize = designTokens.LuaApps.CrossDeviceLogin.headerFont.FontSize
			local color3 = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Color3
			local v6 = isWideView and props.props.tokens.Size.Size_2000 * 2
				or props.props.tokens.Size.Size_2000 * 4
			local size_2200 = isWideView and props.props.tokens.Size.Size_2200
				or props.props.tokens.Size.Size_2200 * 2
			local v7 = isWideView and 0 or props.props.tokens.Size.Size_350 or 0
			local fontSize2 = designTokens.LuaApps.CrossDeviceLogin.bodyFont.FontSize
			local color3_2 = designTokens.LuaApps.CrossDeviceLogin.bodyTextColor.Color3
			local transparency = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Transparency
			local fontSize3 = designTokens.LuaApps.CrossDeviceLogin.textAlertFont.FontSize
			local color3_3 = designTokens.LuaApps.CrossDeviceLogin.textAlertColor.Color3
			local baseSize = p2.Font.BaseSize
			local color = p2.Theme.UIEmphasis.Color
			local v8

			if not module10() then
				if getFFlagEnableAuthsecImageUpdate() then
					v8 = Roact.createElement("Frame", {
						LayoutOrder = 1,
						Size = isWideView and udim or UDim2.new(0, v6, 0, size_2200 - v7),
						BackgroundTransparency = 1
					}, {
						Image = Roact.createElement(image, {
							Image = props.getVerifyCodeImage(props.props.tokens.Config.ColorMode.Name),
							ScaleType = Enum.ScaleType.Fit,
							Size = UDim2.new(0, v6, 0, size_2200),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5)
						})
					})
				else
					v8 = Roact.createElement(imageSetLabel, {
						Size = udim,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						ScaleType = Enum.ScaleType.Fit,
						Image = iconsgraphicdevices_xxlarge,
						ImageColor3 = color,
						ImageTransparency = 0
					})
				end
			end

			local createElement = Roact.createElement
			local children = {
				TabletHeaderText = props2.tabletHeader,
				Style = p2,
				HighKeyboardMode = props.props.highKeyboardMode,
				Icon = v8,
				WarningText = 0,
				LoginButton = 0,
				CancelButton = 0
			}

			local createElement2 = Roact.createElement
			local fitFrame = FitChildren.FitFrame
			local v10 = {
				LayoutOrder = 2,
				Size = UDim2.new(1, isWideView and -50 - iconSize2 or -20, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1
			}

			local children2 = {
				Align = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				TopWarning = 0,
				Warning1 = 0,
				Warning2 = 0,
				Warning3 = 0
			}

			local v11 = if not getFFlagEnableAuthsecImageUpdate() then Roact.createElement(
				FitChildren.FitFrame,
				{
					fitAxis = FitChildren.FitAxis.Height,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1
				},
				{
					ListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = isWideView and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 0),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					WarningIcon1 = Roact.createElement(imageSetLabel, {
						Size = iconSizeUDim2,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						ScaleType = Enum.ScaleType.Fit,
						Image = iconsstatusalert,
						ImageColor3 = color,
						ImageTransparency = 0
					}),
					WarningText = Roact.createElement(fitTextLabel, {
						LayoutOrder = 2,
						Size = UDim2.new(0, baseSize, 1, 0),
						Text = props2.heading,
						TextWrapped = true,
						Font = normalizeFontFace(designTokens.LuaApps.CrossDeviceLogin.headerTypography.Font),
						TextSize = fontSize,
						TextColor3 = color3,
						TextTransparency = transparency,
						TextXAlignment = isWideView and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						width = fitTextLabel.Width.FitToText,
						BackgroundTransparency = 1
					}),
					WarningIcon2 = Roact.createElement(imageSetLabel, {
						Size = iconSizeUDim2,
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						ScaleType = Enum.ScaleType.Fit,
						Image = iconsstatusalert,
						ImageColor3 = color,
						ImageTransparency = 0
					})
				}
			) or nil else nil
			children2.TopWarning = v11

			children2.Warning1 = Roact.createElement(fitTextLabel, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 0),
				Text = string.format(props2.confirmation1, props.props.deviceString),
				TextWrapped = true,
				Font = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
				TextSize = fontSize2,
				TextColor3 = color3_2,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				width = UDim.new(1, 0),
				BackgroundTransparency = 1
			})

			children2.Warning2 = Roact.createElement(fitTextLabel, {
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 0),
				Text = props2.confirmation2,
				TextWrapped = true,
				Font = normalizeFontFace(designTokens.Typography.BodySmall.Font),
				TextSize = fontSize3,
				TextColor3 = color3_3,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				width = UDim.new(1, 0),
				BackgroundTransparency = 1
			})

			children2.Warning3 = Roact.createElement(fitTextLabel, {
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, 0),
				Text = props2.confirmation3,
				TextWrapped = true,
				Font = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
				TextSize = fontSize2,
				TextColor3 = color3_2,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				width = UDim.new(1, 0),
				BackgroundTransparency = 1
			})
			children.WarningText = createElement2(fitFrame, v10, children2)

			children.LoginButton = Roact.createElement(button, {
				buttonType = buttonType.PrimarySystem,
				size = UDim2.new(1, 0, 1, 0),
				text = props2.confirm,
				onActivated = props.confirmButtonPressed,
				isLoading = isConfirming
			})

			children.CancelButton = Roact.createElement(button, {
				buttonType = buttonType.Secondary,
				size = UDim2.new(1, 0, 1, 0),
				text = props2.cancel,
				onActivated = props.closeButtonPressed
			})
			return createElement(isWideView and module8 or module7, children)
		end)
	end)
end

local v5 = roactServices.connect({
	networking = module2,
	authAnalytics = module4,
	linking = appLinking
})(extended)

local v6 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		confirmDeviceAccess = function(p2, p3)
			return callback(module3.ConfirmDeviceAccess(p2, p3))
		end,
		cancelLoginCode = function(p2, p3)
			return callback(module3.CancelLoginCode(p2, p3))
		end,
		openConfirmationModal = function(p2, p3, p4, p5)
			return callback(module3.OpenConfirmationOverlay(p2, p3, p4, p5))
		end
	}
end)(v5)

return function(p2)
	local v7 = useDesignTokens()
	local v8 = useTokens()

	return React.createElement(v6, Cryo.Dictionary.join(p2, {
		designTokens = v7,
		tokens = v8
	}))
end
