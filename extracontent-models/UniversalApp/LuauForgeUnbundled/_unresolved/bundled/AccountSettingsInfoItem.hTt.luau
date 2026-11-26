local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/hTu")
local displayQRCode = module.DisplayQRCode
local ecLevels = module.ECLevels
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local module2 = require("@luauforge/bundled/fzK")

local module3 = require("@luauforge/bundled/hSv")
local bodyText = module3.BodyText
local subheaderText = module3.SubheaderText
local boldBodyText = module3.BoldBodyText
require("@luauforge/bundled/hSx")

local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage

local account = module2.static.settings.account()

local function TextInfo(props)
	local layoutOrder = props.layoutOrder
	local itemsPadding = props.itemsPadding
	local subheaderText2 = props.subheaderText
	local bodyText2 = props.bodyText
	local boldBodyText2 = props.boldBodyText

	local createElement = React.createElement
	local v6 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}

	local v7 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = itemsPadding
		}),
		Subheader = React.createElement(subheaderText, {
			layoutOrder = 1,
			text = subheaderText2
		}),
		Body = 0,
		BoldBody = 0
	}

	local v8 = if bodyText2 then React.createElement(bodyText, {
		layoutOrder = 2,
		text = bodyText2
	}) else nil
	v7.Body = v8

	local v9 = if boldBodyText2 then React.createElement(boldBodyText, {
		layoutOrder = 3,
		text = boldBodyText2
	}) else nil
	v7.BoldBody = v9
	return createElement("Frame", v6, v7)
end

local function AccountSettingsInfoItem(p2)
	local v5 = useDesignTokens()
	local udim = UDim.new(0, v5.Size.Size_400)
	local qrSize = v5.LuaApps.More.QrSize

	local v6 = useLocalization({
		accountSettingsWebsite = "Feature.Settings.Subheading.AccountSettingsWebsite",
		accountSettingsWebsiteDescription = "Feature.Settings.Description.AccountSettingsWebsite",
		accountSettingsScan = "Feature.Settings.Subheading.AccountSettingsScan",
		accountSettingsScanDescription = "Feature.Settings.Description.AccountSettingsScan"
	})

	if fFlagUnifyConsoleSettingsPage then
		return React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				LayoutOrder = p2.layoutOrder,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				LeftPanel = React.createElement(
					"Frame",
					{
						Size = UDim2.new(0.5, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 1
					},
					{
						Layout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = udim
						}),
						WebsiteInfo = React.createElement(TextInfo, {
							layoutOrder = 1,
							itemsPadding = udim,
							subheaderText = v6.accountSettingsWebsite,
							bodyText = v6.accountSettingsWebsiteDescription
						}),
						URLContainer = React.createElement(
							"Frame",
							{
								LayoutOrder = 2,
								Size = UDim2.fromScale(1, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1
							},
							{
								UIPadding = React.createElement("UIPadding", {
									PaddingLeft = UDim.new(0, v5.Size.Size_600)
								}),
								URL = React.createElement(boldBodyText, {
									layoutOrder = 1,
									text = account
								})
							}
						)
					}
				),
				RightPanel = React.createElement(
					"Frame",
					{
						Size = UDim2.new(0.5, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 2
					},
					{
						Layout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = udim
						}),
						ScanInfo = React.createElement(TextInfo, {
							layoutOrder = 1,
							itemsPadding = udim,
							subheaderText = v6.accountSettingsScan,
							bodyText = v6.accountSettingsScanDescription
						}),
						QRCodeContainer = React.createElement(
							"Frame",
							{
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								LayoutOrder = 2
							},
							{
								UIPadding = React.createElement("UIPadding", {
									PaddingLeft = UDim.new(0, v5.Size.Size_600 * 2)
								}),
								QRCodeFocusTarget = React.createElement(
									"Frame",
									{
										Size = UDim2.fromOffset(qrSize, qrSize),
										BackgroundTransparency = 1,
										Selectable = true
									},
									{
										QRCode = React.createElement(displayQRCode, {
											ecLevel = ecLevels.EC_LEVEL_1,
											sideLength = qrSize,
											toEncode = account
										})
									}
								)
							}
						)
					}
				)
			}
		)
	end

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = p2.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{ React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				React.createElement("Frame", {
					Size = UDim2.new(1, -qrSize, 1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				}, React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = udim
				}), React.createElement(TextInfo, {
					layoutOrder = 1,
					itemsPadding = udim,
					subheaderText = v6.accountSettingsWebsite,
					bodyText = v6.accountSettingsWebsiteDescription,
					boldBodyText = account
				}), React.createElement(TextInfo, {
					layoutOrder = 2,
					itemsPadding = udim,
					subheaderText = v6.accountSettingsScan,
					bodyText = v6.accountSettingsScanDescription
				})),
				React.createElement(
					"Frame",
					{ BackgroundTransparency = 1, LayoutOrder = 2 },
					React.createElement(displayQRCode, {
						ecLevel = ecLevels.EC_LEVEL_1,
						sideLength = qrSize,
						toEncode = account
					})
				)
			) }
	)
end

return AccountSettingsInfoItem
