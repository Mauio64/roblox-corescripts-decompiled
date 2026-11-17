local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")

local Localization = require(parent.Localization)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SocialCommon = require(parent.SocialCommon)
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local AppHeaderBar = require(parent.AppHeaderBar)
local makeBackButton = AppHeaderBar.makeBackButton

local ExternalEventConnection = RoactUtils.ExternalEventConnection
local InputUtilities = SocialCommon.Utils.InputUtilities

local EventNames = require(ProfileQRCode.Analytics.EventNames)
local TextKeys = require(ProfileQRCode.Common.TextKeys)

local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local useLocalization = Localization.Hooks.useLocalization
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local FFlagProfileQRCodeFixFocusNavigation = require(ProfileQRCode.Flags.FFlagProfileQRCodeFixFocusNavigation)
local FFlagProfileQRCodeGamepadBackFix = require(ProfileQRCode.Flags.FFlagProfileQRCodeGamepadBackFix)

local function getTooltipWasShown(appStorageService): boolean -- 1 equivalent call inferred from this helper
	local v = appStorageService or AppStorageService
	assert(v ~= nil, "AppStorageService is not nil")

	local success, result = pcall(function()
		return v:GetItem("QrCodeScannerTooltipSeen")
	end)

	if success and result ~= nil then
		return result == "true"
	end

	return false
end

local function setTooltipWasShown(appStorageService, flag: boolean) -- 1 equivalent call inferred from this helper
	local v = appStorageService or AppStorageService
	assert(v ~= nil, "AppStorageService is not nil")

	pcall(function()
		v:SetItem("QrCodeScannerTooltipSeen", (tostring(flag)))
		v:Flush()
	end)
end

return function(props)
	local v

	if FFlagProfileQRCodeFixFocusNavigation then
		v = useLastInputMode() == "Focus"
	end

	local v2 = useAnalytics()
	local v3 = useLocalization({
		title = TextKeys.Title,
		tooltipBodyText = TextKeys.TooltipText,
		tooltipHeaderText = TextKeys.TooltipTitle
	})

	local v4 = useAppPolicy(function(p)
		return p.getFriendCodeQrCodeScannerEnabled()
	end)

	local state, setState = React.useState(false)
	React.useEffect(function()
		local tooltipWasShown = getTooltipWasShown(props.appStorageService) -- inferred equivalent call
		setState(not tooltipWasShown)

		if not tooltipWasShown then
			v2.fireEvent(EventNames.QRCodeScannerTooltipShown)
		end
	end, {})

	local callback = React.useCallback(function(p)
		if InputUtilities.isActivationInput(p) and state then
			setState(false)
			setTooltipWasShown(props.appStorageService, true) -- inferred equivalent call
		end
	end, { state })

	local onActivated = React.useCallback(function()
		IXPService:LogUserLayerExposure(AppUserLayers.ProfileQRCodeScannerLayer)
		v2.fireEvent(EventNames.QRCodeScannerOpened)
		props.openQrCodeScanner()
	end, { props.openQrCodeScanner })

	local tooltipBodyText = v3.tooltipBodyText
	local tooltipHeaderText = v3.tooltipHeaderText

	local renderRight = React.useCallback(function()
		return withTooltip(
			{ bodyText = tooltipBodyText, headerText = tooltipHeaderText },
			{
				active = state,
				DisplayOrder = 10,
				guiTarget = CoreGui,
				preferredOrientation = TooltipOrientation.Bottom
			},
			function(onAbsolutePositionChanged)
				return React.createElement(IconButton, {
					icon = Images["icons/actions/scan"],
					iconSize = IconSize.Medium,
					onActivated = onActivated,
					size = UDim2.fromOffset(0, 0),
					onAbsolutePositionChanged = onAbsolutePositionChanged,
					[React.Change.AbsoluteSize] = onAbsolutePositionChanged
				}, {
					InputBeganConnection = React.createElement(ExternalEventConnection, {
						event = UserInputService.InputBegan,
						callback = callback
					})
				})
			end
		)
	end, { onActivated, v4, state, tooltipBodyText, tooltipHeaderText })

	local backButton = makeBackButton(props.onClose)

	local createElement = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 56),
		LayoutOrder = props.layoutOrder,
		ZIndex = 2
	}

	local createElement2 = React.createElement
	local v6 = {
		isSecondary = true,
		title = v3.title,
		backgroundTransparency = 1,
		barHeight = 56,
		renderLeft = 0,
		renderRight = 0
	}

	if
		not FFlagProfileQRCodeGamepadBackFix
		and (not FFlagProfileQRCodeFixFocusNavigation or v)
		and FFlagProfileQRCodeFixFocusNavigation
	then
		backButton = nil
	end

	v6.renderLeft = backButton

	if not v4 then
		renderRight = nil
	end

	v6.renderRight = renderRight
	return createElement("Frame", v5, { headerBar = createElement2(HeaderBar, v6) })
end
