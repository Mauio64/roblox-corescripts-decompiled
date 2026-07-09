local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceLoginUsingQRCodes)
local ShowCodeView = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.ShowCodeView)
local ShowProfileView = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.ShowProfileView)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local FitChildren = require(Modules.LuaApp.FitChildren)

return function(p1) -- line: 16
	-- upvalues: useDesignTokens (copy), Roact (copy), FitChildren (copy), ShowCodeView (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), ShowProfileView (copy)
	local LoginView = useDesignTokens().LuaApps.LoginView

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		fitAxis = FitChildren.FitAxis.Height
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = if not p1.isDualLayout then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 12)
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = if not p1.isDualLayout then UDim.new(0, 24) else UDim.new(0, 0),
			PaddingBottom = if not p1.isDualLayout then UDim.new(0, 12) else UDim.new(0, 0),
			PaddingLeft = if not p1.isDualLayout then nil else UDim.new(0, LoginView.dualLayoutPadding)
		}),
		View = p1.showCodeView and Roact.createElement(ShowCodeView, {
			DeviceCode = p1.DeviceCode,
			QrCodeUrl = if not GetFFlagEnableCrossDeviceLoginUsingQRCodes() then nil else p1.QrCodeUrl,
			AltTitle = p1.AltTitle,
			AltInstruction = p1.AltInstruction,
			AltMobileInstruction = p1.AltMobileInstruction,
			AltDesktopInstruction = p1.AltDesktopInstruction,
			DisableQrCode = p1.disableCdlQrCodeForMaquettes or false,
			hideDeviceCode = p1.hideDeviceCode,
			showLockIcon = p1.showLockIcon,
			isDualLayout = p1.isDualLayout,
			leftAlignText = p1.isDualLayout,
			showConfirmLoginText = p1.showConfirmLoginText,
			DisplayName = p1.DisplayName,
			isCrossApp = p1.isCrossApp
		}) or Roact.createElement(ShowProfileView, {
			Url = p1.AccountPictureUrl,
			DisplayName = p1.DisplayName,
			leftAlignText = p1.isDualLayout
		})
	})
end
