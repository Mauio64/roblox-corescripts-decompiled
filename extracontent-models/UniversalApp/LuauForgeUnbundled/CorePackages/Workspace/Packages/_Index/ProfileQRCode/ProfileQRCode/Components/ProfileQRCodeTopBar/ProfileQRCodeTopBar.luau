local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SocialCommon")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UIBlox")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UniversalAppPolicy")
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/ExperimentLayers").AppUserLayers
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/FocusNavigationUtils")

local headerBar = UIBlox.App.Bar.HeaderBar
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local makeBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/AppHeaderBar").makeBackButton

local externalEventConnection = RoactUtils.ExternalEventConnection
local inputUtilities = SocialCommon.Utils.InputUtilities

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/TextKeys")

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local useLocalization = Localization.Hooks.useLocalization
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local FFlagProfileQRCodeFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagProfileQRCodeFixFocusNavigation")

local function getTooltipWasShown(p2): boolean
	local v5 = p2 or AppStorageService
	assert(v5 ~= nil, "AppStorageService is not nil")

	local success, result = pcall(function()
		return v5:GetItem("QrCodeScannerTooltipSeen")
	end)

	if success and result ~= nil then
		return result == "true"
	end

	return false
end

local function setTooltipWasShown(p2, p3)
	local v5 = p2 or AppStorageService
	assert(v5 ~= nil, "AppStorageService is not nil")

	pcall(function()
		v5:SetItem("QrCodeScannerTooltipSeen", (tostring(p3)))
		v5:Flush()
	end)
end

return function(props)
	local v5 = if FFlagProfileQRCodeFixFocusNavigation then useLastInputMode() == "Focus" else nil
	local v6 = useAnalytics()
	local v7 = useLocalization({
		title = TextKeys.Title,
		tooltipBodyText = TextKeys.TooltipText,
		tooltipHeaderText = TextKeys.TooltipTitle
	})

	local v8 = useAppPolicy(function(p2)
		return p2.getFriendCodeQrCodeScannerEnabled()
	end)

	local state, setState = React.useState(false)
	React.useEffect(function()
		local appStorageService = props.appStorageService or AppStorageService
		assert(appStorageService ~= nil, "AppStorageService is not nil")

		local success, result = pcall(function()
			return appStorageService:GetItem("QrCodeScannerTooltipSeen")
		end)
		local v9 = if success and result ~= nil then result == "true" else false
		setState(not v9)

		if not v9 then
			v6.fireEvent(EventNames.QRCodeScannerTooltipShown)
		end
	end, {})

	local v9 = React.useCallback(function(p2)
		if inputUtilities.isActivationInput(p2) and state then
			setState(false)
			local appStorageService = props.appStorageService or AppStorageService
			assert(appStorageService ~= nil, "AppStorageService is not nil")

			local v10 = true
			pcall(function()
				appStorageService:SetItem("QrCodeScannerTooltipSeen", (tostring(v10)))
				appStorageService:Flush()
			end)
		end
	end, { state })

	local v10 = React.useCallback(function()
		IXPService:LogUserLayerExposure(appUserLayers.ProfileQRCodeScannerLayer)
		v6.fireEvent(EventNames.QRCodeScannerOpened)
		props.openQrCodeScanner()
	end, { props.openQrCodeScanner })

	local tooltipBodyText = v7.tooltipBodyText
	local tooltipHeaderText = v7.tooltipHeaderText

	local v11 = React.useCallback(function()
		return withTooltip(
			{ bodyText = tooltipBodyText, headerText = tooltipHeaderText },
			{
				active = state,
				DisplayOrder = 10,
				guiTarget = CoreGui,
				preferredOrientation = tooltipOrientation.Bottom
			},
			function(onAbsolutePositionChanged)
				return React.createElement(iconButton, {
					icon = images["icons/actions/scan"],
					iconSize = iconSize.Medium,
					onActivated = v10,
					size = UDim2.fromOffset(0, 0),
					onAbsolutePositionChanged = onAbsolutePositionChanged,
					[React.Change.AbsoluteSize] = onAbsolutePositionChanged
				}, {
					InputBeganConnection = React.createElement(externalEventConnection, {
						event = UserInputService.InputBegan,
						callback = v9
					})
				})
			end
		)
	end, { v10, v8, state, tooltipBodyText, tooltipHeaderText })

	local backButton = makeBackButton(props.onClose)

	local createElement = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 56),
		LayoutOrder = props.layoutOrder,
		ZIndex = 2
	}

	local createElement2 = React.createElement
	local v16 = {
		isSecondary = true,
		title = v7.title,
		backgroundTransparency = 1,
		barHeight = 56,
		renderLeft = 0,
		renderRight = 0
	}

	if (not FFlagProfileQRCodeFixFocusNavigation or v5) and FFlagProfileQRCodeFixFocusNavigation then
		backButton = nil
	end

	v16.renderLeft = backButton

	if not v8 then
		v11 = nil
	end

	v16.renderRight = v11
	return createElement("Frame", v13, { headerBar = createElement2(headerBar, v16) })
end
