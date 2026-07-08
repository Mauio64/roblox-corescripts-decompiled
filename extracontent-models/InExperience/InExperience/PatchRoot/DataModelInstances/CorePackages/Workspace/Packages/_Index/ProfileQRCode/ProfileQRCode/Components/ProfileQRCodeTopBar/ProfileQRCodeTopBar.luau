local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")
local Localization = require(ProfileQRCodeParent.Localization)
local React = require(ProfileQRCodeParent.React)
local RoactUtils = require(ProfileQRCodeParent.RoactUtils)
local SocialCommon = require(ProfileQRCodeParent.SocialCommon)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local UniversalAppPolicy = require(ProfileQRCodeParent.UniversalAppPolicy)
local AppUserLayers = require(ProfileQRCodeParent.ExperimentLayers).AppUserLayers
local FocusNavigationUtils = require(ProfileQRCodeParent.FocusNavigationUtils)
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local makeBackButton = require(ProfileQRCodeParent.AppHeaderBar).makeBackButton
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local InputUtilities = SocialCommon.Utils.InputUtilities
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useLocalization = Localization.Hooks.useLocalization
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local FFlagProfileQRCodeFixFocusNavigation = require(ProfileQRCode.Flags.FFlagProfileQRCodeFixFocusNavigation)

local function getTooltipWasShown(p1) -- line: 42
	-- upvalues: AppStorageService (copy)
	local u34 = p1 or AppStorageService

	assert(u34 ~= nil, "AppStorageService is not nil")

	local ok, result = pcall(function() -- line: 46
		-- upvalues: u34 (ref)
		return u34:GetItem("QrCodeScannerTooltipSeen")
	end)

	if not ok or result == nil then
		return false
	end

	return result == "true"
end
local function setTooltipWasShown(p2, b1: boolean) -- line: 57
	-- upvalues: AppStorageService (copy)
	local u39 = p2 or AppStorageService

	assert(u39 ~= nil, "AppStorageService is not nil")
	pcall(function() -- line: 61
		-- upvalues: u39 (ref), b1 (copy)
		u39:SetItem("QrCodeScannerTooltipSeen", (tostring(b1)))
		u39:Flush()
	end)
end

return function(t1: {[any]: any}) -- line: 75
	-- upvalues: FFlagProfileQRCodeFixFocusNavigation (copy), useLastInputMode (copy), useAnalytics (copy), useLocalization (copy), TextKeys (copy), useAppPolicy (copy), React (copy), AppStorageService (copy), EventNames (copy), InputUtilities (copy), IXPService (copy), AppUserLayers (copy), CoreGui (copy), TooltipOrientation (copy), withTooltip (copy), IconButton (copy), Images (copy), IconSize (copy), ExternalEventConnection (copy), UserInputService (copy), makeBackButton (copy), HeaderBar (copy)
	local v41 = if not FFlagProfileQRCodeFixFocusNavigation then nil else useLastInputMode() == "Focus"
	local v42 = useAnalytics()
	local v43 = useLocalization({
		title = TextKeys.Title,
		tooltipBodyText = TextKeys.TooltipText,
		tooltipHeaderText = TextKeys.TooltipTitle
	})
	local v44 = useAppPolicy(function(p3) -- line: 84
		return p3.getFriendCodeQrCodeScannerEnabled()
	end)
	local v45, v46 = React.useState(false)

	React.useEffect(function() -- line: 89
		-- upvalues: t1 (copy), AppStorageService (copy), v46 (copy), v42 (copy), EventNames (copy)
		local u54 = t1.appStorageService or AppStorageService

		assert(u54 ~= nil, "AppStorageService is not nil")

		local ok, result = pcall(function() -- line: 46
			-- upvalues: u54 (ref)
			return u54:GetItem("QrCodeScannerTooltipSeen")
		end)
		local v57

		if not ok or result == nil then
			v57 = false
		else
			v57 = result == "true"
		end

		v46(not v57)

		if not v57 then
			v42.fireEvent(EventNames.QRCodeScannerTooltipShown)
		end
	end, {})

	local v47 = React.useCallback(function(p4) -- line: 97
		-- upvalues: InputUtilities (copy), v45 (copy), v46 (copy), t1 (copy), AppStorageService (copy)
		if InputUtilities.isActivationInput(p4) and v45 then
			v46(false)

			local u59 = t1.appStorageService or AppStorageService

			assert(u59 ~= nil, "AppStorageService is not nil")

			local v60 = true

			pcall(function() -- line: 61
				-- upvalues: u59 (ref), v60 (copy)
				u59:SetItem("QrCodeScannerTooltipSeen", (tostring(v60)))
				u59:Flush()
			end)
		end
	end, { v45 })
	local v48 = React.useCallback(function() -- line: 106
		-- upvalues: IXPService (copy), AppUserLayers (copy), v42 (copy), EventNames (copy), t1 (copy)
		IXPService:LogUserLayerExposure(AppUserLayers.ProfileQRCodeScannerLayer)
		v42.fireEvent(EventNames.QRCodeScannerOpened)
		t1.openQrCodeScanner()
	end, { t1.openQrCodeScanner })
	local tooltipBodyText = v43.tooltipBodyText
	local tooltipHeaderText = v43.tooltipHeaderText
	local v51 = React.useCallback(function() -- line: 115
		-- upvalues: tooltipBodyText (copy), tooltipHeaderText (copy), v45 (copy), CoreGui (copy), TooltipOrientation (copy), withTooltip (copy), React (copy), IconButton (copy), Images (copy), IconSize (copy), v48 (copy), ExternalEventConnection (copy), UserInputService (copy), v47 (copy)
		local t2 = {
			bodyText = tooltipBodyText,
			headerText = tooltipHeaderText
		}
		local t3 = {
			DisplayOrder = 10,
			active = v45,
			guiTarget = CoreGui,
			preferredOrientation = TooltipOrientation.Bottom
		}

		return withTooltip(t2, t3, function(p5) -- line: 128
			-- upvalues: React (copy), IconButton (copy), Images (copy), IconSize (copy), v48 (copy), ExternalEventConnection (copy), UserInputService (copy), v47 (copy)
			return React.createElement(IconButton, {
				icon = Images["icons/actions/scan"],
				iconSize = IconSize.Medium,
				onActivated = v48,
				size = UDim2.fromOffset(0, 0),
				onAbsolutePositionChanged = p5,
				[React.Change.AbsoluteSize] = p5
			}, {
				InputBeganConnection = React.createElement(ExternalEventConnection, {
					event = UserInputService.InputBegan,
					callback = v47
				})
			})
		end)
	end, {
		v48,
		v44,
		v45,
		tooltipBodyText,
		tooltipHeaderText
	})
	local v52 = makeBackButton(t1.onClose)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, 56),
		LayoutOrder = t1.layoutOrder
	}, {
		headerBar = React.createElement(HeaderBar, {
			isSecondary = true,
			backgroundTransparency = 1,
			barHeight = 56,
			title = v43.title,
			renderLeft = if not (not not FFlagProfileQRCodeFixFocusNavigation and not v41) and FFlagProfileQRCodeFixFocusNavigation then nil else v52,
			renderRight = if not v44 then nil else v51
		})
	})
end
