local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/hDz")

local module2 = require("@luauforge/bundled/hDC")
local module3 = require("@luauforge/bundled/hDD")
local module4 = require("@luauforge/bundled/hDE")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

return function(props)
	local loginView = useDesignTokens().LuaApps.LoginView

	local state, setState = React.useState(false)
	local v5 = React.useCallback(function()
		setState(true)
	end, {})
	local onHavingTroubleActivated = props.onHavingTroubleActivated or v5

	local qrCodeUrl = if module() then props.QrCodeUrl else nil
	local v6

	if
		props.usesFoundationSheetOverlay
		and not state
		and module()
		and not (props.disableCdlQrCodeForMaquettes or props.hideDeviceCode)
	then
		v6 = Roact.createElement(module2, {
			contentStartRef = props.contentStartRef,
			deviceCode = props.DeviceCode,
			qrCodeUrl = qrCodeUrl,
			onHavingTroubleActivated = onHavingTroubleActivated,
			renderNeedHelpButton = props.renderNeedHelpButton
		})
	else
		v6 = Roact.createElement(module3, {
			DeviceCode = props.DeviceCode,
			QrCodeUrl = qrCodeUrl,
			AltTitle = props.AltTitle,
			AltInstruction = props.AltInstruction,
			AltMobileInstruction = props.AltMobileInstruction,
			AltDesktopInstruction = props.AltDesktopInstruction,
			DisableQrCode = props.disableCdlQrCodeForMaquettes or state,
			hideDeviceCode = props.hideDeviceCode,
			showLockIcon = props.showLockIcon,
			isDualLayout = props.isDualLayout,
			leftAlignText = props.isDualLayout,
			showConfirmLoginText = props.showConfirmLoginText,
			DisplayName = props.DisplayName,
			isCrossApp = props.isCrossApp
		})
	end

	local createElement = Roact.createElement
	local fitFrame = FitChildren.FitFrame
	local v7 = {
		Size = UDim2.new(1, 0, 0, 0),
		fitAxis = FitChildren.FitAxis.Height,
		BackgroundTransparency = 1
	}

	local createElement2 = Roact.createElement
	local v9 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = 0,
		Padding = 0
	}
	local v10 = if props.isDualLayout then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center
	v9.HorizontalAlignment = v10

	v9.Padding = UDim.new(0, 12)
	local children = {
		UIListLayout = createElement2("UIListLayout", v9),
		Padding = 0,
		View = 0
	}

	local createElement3 = Roact.createElement
	local v13 = if props.isDualLayout or props.usesFoundationSheetOverlay then UDim.new(0, 0) else UDim.new(0, 24)
	local udim

	if props.usesFoundationSheetOverlay then
		udim = UDim.new(0, 8)
	else
		udim = if props.isDualLayout then UDim.new(0, 0) else UDim.new(0, 12)
	end

	local v14 = if props.isDualLayout then UDim.new(0, loginView.dualLayoutPadding) else nil
	children.Padding = createElement3("UIPadding", {
		PaddingTop = v13,
		PaddingBottom = udim,
		PaddingLeft = v14
	})

	children.View = props.showCodeView and v6
		or Roact.createElement(module4, {
			Url = props.AccountPictureUrl,
			DisplayName = props.DisplayName,
			leftAlignText = props.isDualLayout,
			useFoundationSheet = props.usesFoundationSheetOverlay
		})
	return createElement(fitFrame, v7, children)
end
