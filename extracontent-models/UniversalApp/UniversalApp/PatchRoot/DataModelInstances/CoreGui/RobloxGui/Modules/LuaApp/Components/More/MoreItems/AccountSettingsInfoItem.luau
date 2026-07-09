local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local QRCodeDisplay = require(CorePackages.Workspace.Packages.QRCodeDisplay)
local DisplayQRCode = QRCodeDisplay.DisplayQRCode
local ECLevels = QRCodeDisplay.ECLevels
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local MoreText = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreText)
local BodyText = MoreText.BodyText
local SubheaderText = MoreText.SubheaderText
local BoldBodyText = MoreText.BoldBodyText

require(script.Parent.Types)

local v14 = UrlBuilder.static.settings.account()

local function TextInfo(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), SubheaderText (copy), BodyText (copy), BoldBodyText (copy)
	local layoutOrder = t1.layoutOrder
	local itemsPadding = t1.itemsPadding
	local subheaderText = t1.subheaderText
	local bodyText = t1.bodyText
	local boldBodyText = t1.boldBodyText

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = itemsPadding
		}),
		Subheader = React.createElement(SubheaderText, {
			layoutOrder = 1,
			text = subheaderText
		}),
		Body = if not bodyText then nil else React.createElement(BodyText, {
			layoutOrder = 2,
			text = bodyText
		}),
		BoldBody = if not boldBodyText then nil else React.createElement(BoldBodyText, {
			layoutOrder = 3,
			text = boldBodyText
		})
	})
end
local function AccountSettingsInfoItem(p1) -- line: 69
	-- upvalues: useDesignTokens (copy), useLocalization (copy), React (copy), TextInfo (copy), v14 (copy), DisplayQRCode (copy), ECLevels (copy)
	local v24 = useDesignTokens()
	local uDim = UDim.new(0, v24.Size.Size_400)
	local QrSize = v24.LuaApps.More.QrSize
	local v27 = useLocalization({
		accountSettingsWebsite = "Feature.Settings.Subheading.AccountSettingsWebsite",
		accountSettingsWebsiteDescription = "Feature.Settings.Description.AccountSettingsWebsite",
		accountSettingsScan = "Feature.Settings.Subheading.AccountSettingsScan",
		accountSettingsScanDescription = "Feature.Settings.Description.AccountSettingsScan"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		LayoutOrder = p1.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}, { React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder
	}), React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, -QrSize, 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = uDim
	}), React.createElement(TextInfo, {
		layoutOrder = 1,
		itemsPadding = uDim,
		subheaderText = v27.accountSettingsWebsite,
		bodyText = v27.accountSettingsWebsiteDescription,
		boldBodyText = v14
	}), React.createElement(TextInfo, {
		layoutOrder = 2,
		itemsPadding = uDim,
		subheaderText = v27.accountSettingsScan,
		bodyText = v27.accountSettingsScanDescription
	})), React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}, React.createElement(DisplayQRCode, {
		ecLevel = ECLevels.EC_LEVEL_1,
		sideLength = QrSize,
		toEncode = v14
	}))) })
end

return AccountSettingsInfoItem
