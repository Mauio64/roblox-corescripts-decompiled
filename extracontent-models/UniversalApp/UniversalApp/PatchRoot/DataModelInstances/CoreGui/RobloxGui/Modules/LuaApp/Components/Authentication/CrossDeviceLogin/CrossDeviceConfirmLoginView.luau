local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local CrossDeviceLogin = require(Modules.LuaApp.Thunks.Authentication.CrossDeviceLogin)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local CrossDevicePhoneLayout = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.CrossDevicePhoneLayout)
local CrossDeviceTabletLayout = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.CrossDeviceTabletLayout)
local GetFFlagEnableAuthsecImageUpdate = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuthsecImageUpdate
local GetFFlagEnableCrossDeviceEnterCodeRefresh = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceEnterCodeRefresh)
local GetFFlagEnableApproveQuickLoginAuthButtonClickSchematization = require(Modules.LuaApp.Flags.GetFFlagEnableApproveQuickLoginAuthButtonClickSchematization)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v34 = Images["icons/graphic/devices_xxlarge"]
local v35 = getIconSize(IconSize.XLarge)
local v36 = Images["icons/status/alert"]
local v37 = getIconSizeUDim2(IconSize.Medium)
local v38 = Roact.PureComponent:extend("CrossDeviceConfirmLoginView")
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)

function v38.init(p1) -- line: 55
	-- upvalues: Foundation (copy), GetFFlagEnableApproveQuickLoginAuthButtonClickSchematization (copy), EventStreamConstants (copy), RbxAnalyticsService (copy)
	p1:setState({
		isConfirming = false
	})

	function p1.getVerifyCodeImage(s1: string) -- line: 60
		-- upvalues: Foundation (copy)
		if s1 == Foundation.Enums.Theme.Dark then
			return "icons/graphic/verifyCode_dark"
		end

		return "icons/graphic/verifyCode_light"
	end

	p1.confirming = false

	function p1.confirmButtonPressed() -- line: 69
		-- upvalues: p1 (copy), GetFFlagEnableApproveQuickLoginAuthButtonClickSchematization (copy), EventStreamConstants (copy)
		if not p1.confirming then
			p1.confirming = true
			p1:setState({
				isConfirming = true
			})

			if GetFFlagEnableApproveQuickLoginAuthButtonClickSchematization() then
				p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.ApproveQuickLogin, EventStreamConstants.Button.GrantAccess)
			else
				p1.props.authAnalytics.reportButtonClicked(EventStreamConstants.Context.ApproveQuickLogin, EventStreamConstants.Button.GrantAccess)
			end

			p1.props.confirmDeviceAccess(p1.props.networking, p1.props.deviceCode):andThen(function(_) -- line: 86
				-- upvalues: p1 (copy)
				p1.confirmCallback(true)
			end, function(_) -- line: 88
				-- upvalues: p1 (copy)
				p1.confirmCallback(false)
			end)
		end
	end
	function p1.confirmCallback(p4) -- line: 94
		-- upvalues: p1 (copy), RbxAnalyticsService (copy)
		if p1.confirming then
			p1.confirming = false
			p1:setState({
				isConfirming = false
			})
			p1.props.openConfirmationModal(p4, p1.props.closeCallback, p1.props.retryCallback, p1.props.deviceString)

			if p1.props.source == "vng" then
				RbxAnalyticsService:ReportCounter("CrossAppLoginSuccess", 1)
				p1.props.linking:openURL("robloxvng://")
			end
		end
	end
	function p1.closeButtonPressed() -- line: 115
		-- upvalues: p1 (copy)
		p1.props.cancelLoginCode(p1.props.networking, p1.props.deviceCode)

		if p1.props.closeCallback then
			p1.props.closeCallback()
		end
	end
end
function v38.didMount(p5) -- line: 123
	-- upvalues: EventStreamConstants (copy)
	p5.props.authAnalytics.reportScreenLoaded(EventStreamConstants.Context.ApproveQuickLogin)
end
function v38.willUnmount(p6) -- line: 127
	p6.confirming = false
end
function v38.render(p7) -- line: 131
	-- upvalues: GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), withStyle (copy), withLocalization (copy), GetFFlagEnableAuthsecImageUpdate (copy), Roact (copy), FoundationImage (copy), ImageSetLabel (copy), v34 (copy), CrossDeviceTabletLayout (copy), CrossDevicePhoneLayout (copy), FitChildren (copy), v35 (copy), v37 (copy), v36 (copy), FitTextLabel (copy), Button (copy), ButtonType (copy)
	local isWideView = p7.props.isWideView
	local isConfirming = p7.state.isConfirming
	local v48 = not GetFFlagEnableCrossDeviceEnterCodeRefresh() and "Authentication.CrossDevice.Action.ConfirmLogin" or "Authentication.CrossDevice.Label.Confirm"

	return withStyle(function(p8) -- line: 138
		-- upvalues: withLocalization (copy), v48 (copy), p7 (copy), isWideView (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), GetFFlagEnableAuthsecImageUpdate (copy), Roact (copy), FoundationImage (copy), ImageSetLabel (copy), v34 (copy), CrossDeviceTabletLayout (copy), CrossDevicePhoneLayout (copy), FitChildren (copy), v35 (copy), v37 (copy), v36 (copy), FitTextLabel (copy), Button (copy), ButtonType (copy), isConfirming (copy)
		return withLocalization({
			heading = "Authentication.CrossDevice.Heading.Warning",
			confirmation1 = "Authentication.CrossDevice.Label.ConfirmationMessage1",
			confirmation2 = "Authentication.CrossDevice.Label.ConfirmationMessage2",
			confirmation3 = "Authentication.CrossDevice.Label.ConfirmationMessage3",
			cancel = "Authentication.CrossDevice.Action.CancelLogin",
			confirm = v48
		})(function(p9) -- line: 146
			-- upvalues: p7 (copy), isWideView (copy), p8 (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), GetFFlagEnableAuthsecImageUpdate (copy), Roact (copy), FoundationImage (copy), ImageSetLabel (copy), v34 (copy), CrossDeviceTabletLayout (copy), CrossDevicePhoneLayout (copy), FitChildren (copy), v35 (copy), v37 (copy), v36 (copy), FitTextLabel (copy), Button (copy), ButtonType (copy), isConfirming (copy)
			local designTokens = p7.props.designTokens
			local uDim2 = UDim2.fromOffset(designTokens.LuaApps.CrossDeviceLogin.iconSize, designTokens.LuaApps.CrossDeviceLogin.iconSize)
			local headerFontFont = designTokens.LuaApps.CrossDeviceLogin.headerFont.Font
			local FontSize = designTokens.LuaApps.CrossDeviceLogin.headerFont.FontSize
			local headerTextColorColor3 = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Color3
			local v74 = isWideView and p7.props.tokens.Size.Size_2000 * 2 or p7.props.tokens.Size.Size_2000 * 4
			local v75 = isWideView and p7.props.tokens.Size.Size_2200 or p7.props.tokens.Size.Size_2200 * 2
			local v76 = not isWideView and p7.props.tokens.Size.Size_350 or 0
			local bodyFontFont = designTokens.LuaApps.CrossDeviceLogin.bodyFont.Font
			local FontSize2 = designTokens.LuaApps.CrossDeviceLogin.bodyFont.FontSize
			local bodyTextColorColor3 = designTokens.LuaApps.CrossDeviceLogin.bodyTextColor.Color3
			local headerTextColorTransparency = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Transparency
			local textAlertFontFont = designTokens.LuaApps.CrossDeviceLogin.textAlertFont.Font
			local FontSize3 = designTokens.LuaApps.CrossDeviceLogin.textAlertFont.FontSize
			local textAlertColorColor3 = designTokens.LuaApps.CrossDeviceLogin.textAlertColor.Color3
			local BaseSize = p8.Font.BaseSize
			local UIEmphasisColor = p8.Theme.UIEmphasis.Color
			local v86 = nil

			if not GetFFlagEnableCrossDeviceEnterCodeRefresh() then
				v86 = if not GetFFlagEnableAuthsecImageUpdate() then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ImageTransparency = 0,
					Size = uDim2,
					ScaleType = Enum.ScaleType.Fit,
					Image = v34,
					ImageColor3 = UIEmphasisColor
				}) else Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = isWideView and uDim2 or UDim2.new(0, v74, 0, v75 - v76)
				}, {
					Image = Roact.createElement(FoundationImage, {
						Image = p7.getVerifyCodeImage(p7.props.tokens.Config.ColorMode.Name),
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.new(0, v74, 0, v75),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				})
			end

			return Roact.createElement(isWideView and CrossDeviceTabletLayout or CrossDevicePhoneLayout, {
				TabletHeaderText = p9.tabletHeader,
				Style = p8,
				HighKeyboardMode = p7.props.highKeyboardMode,
				Icon = v86,
				WarningText = Roact.createElement(FitChildren.FitFrame, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, isWideView and -50 - v35 or -20, 0, 0),
					fitAxis = FitChildren.FitAxis.Height
				}, {
					Align = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 6),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					TopWarning = not GetFFlagEnableAuthsecImageUpdate() and Roact.createElement(FitChildren.FitFrame, {
						BackgroundTransparency = 1,
						fitAxis = FitChildren.FitAxis.Height,
						Size = UDim2.new(1, 0, 1, 0)
					}, {
						ListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = isWideView and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 0),
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						WarningIcon1 = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							ImageTransparency = 0,
							Size = v37,
							ScaleType = Enum.ScaleType.Fit,
							Image = v36,
							ImageColor3 = UIEmphasisColor
						}),
						WarningText = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							TextWrapped = true,
							BackgroundTransparency = 1,
							Size = UDim2.new(0, BaseSize, 1, 0),
							Text = p9.heading,
							Font = headerFontFont,
							TextSize = FontSize,
							TextColor3 = headerTextColorColor3,
							TextTransparency = headerTextColorTransparency,
							TextXAlignment = isWideView and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
							fitAxis = FitChildren.FitAxis.Width
						}),
						WarningIcon2 = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							ImageTransparency = 0,
							Size = v37,
							ScaleType = Enum.ScaleType.Fit,
							Image = v36,
							ImageColor3 = UIEmphasisColor
						})
					}) or nil,
					Warning1 = Roact.createElement(FitTextLabel, {
						LayoutOrder = 3,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Text = string.format(p9.confirmation1, p7.props.deviceString),
						Font = bodyFontFont,
						TextSize = FontSize2,
						TextColor3 = bodyTextColorColor3,
						TextTransparency = headerTextColorTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						fitAxis = FitChildren.FitAxis.Height
					}),
					Warning2 = Roact.createElement(FitTextLabel, {
						LayoutOrder = 4,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p9.confirmation2,
						Font = textAlertFontFont,
						TextSize = FontSize3,
						TextColor3 = textAlertColorColor3,
						TextTransparency = headerTextColorTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						fitAxis = FitChildren.FitAxis.Height
					}),
					Warning3 = Roact.createElement(FitTextLabel, {
						LayoutOrder = 5,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p9.confirmation3,
						Font = bodyFontFont,
						TextSize = FontSize2,
						TextColor3 = bodyTextColorColor3,
						TextTransparency = headerTextColorTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						fitAxis = FitChildren.FitAxis.Height
					})
				}),
				LoginButton = Roact.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					size = UDim2.new(1, 0, 1, 0),
					text = p9.confirm,
					onActivated = p7.confirmButtonPressed,
					isLoading = isConfirming
				}),
				CancelButton = Roact.createElement(Button, {
					buttonType = ButtonType.Secondary,
					size = UDim2.new(1, 0, 1, 0),
					text = p9.cancel,
					onActivated = p7.closeButtonPressed
				})
			})
		end)
	end)
end

local v40 = RoactServices.connect({
	networking = RoactNetworking,
	authAnalytics = RoactAnalyticsAuthEvents,
	linking = AppLinking
})(v38)
local v41 = RoactRodux.connect(function(p10, _) -- line: 328
	return {
		screenSize = p10.ScreenSize
	}
end, function(p12) -- line: 332
	-- upvalues: CrossDeviceLogin (copy)
	return {
		confirmDeviceAccess = function(p13, p14) -- line: 334
			-- upvalues: p12 (copy), CrossDeviceLogin (copy)
			return p12(CrossDeviceLogin.ConfirmDeviceAccess(p13, p14))
		end,
		cancelLoginCode = function(p15, p16) -- line: 337
			-- upvalues: p12 (copy), CrossDeviceLogin (copy)
			return p12(CrossDeviceLogin.CancelLoginCode(p15, p16))
		end,
		openConfirmationModal = function(p17, p18, p19, p20) -- line: 340
			-- upvalues: p12 (copy), CrossDeviceLogin (copy)
			return p12(CrossDeviceLogin.OpenConfirmationOverlay(p17, p18, p19, p20))
		end
	}
end)(v40)

return function(p21) -- line: 349
	-- upvalues: useDesignTokens (copy), useTokens (copy), React (copy), v41 (copy), Cryo (copy)
	local v53 = useDesignTokens()
	local v54 = useTokens()

	return React.createElement(v41, Cryo.Dictionary.join(p21, {
		designTokens = v53,
		tokens = v54
	}))
end
