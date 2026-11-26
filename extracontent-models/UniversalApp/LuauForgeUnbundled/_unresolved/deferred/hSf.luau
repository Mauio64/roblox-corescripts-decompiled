local CorePackages = game:GetService("CorePackages")

local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local React = require(CorePackages.Packages.React)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder
local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/ecq")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local text = Foundation.Text
local view = Foundation.View
local divider = Foundation.Divider
local orientation = Foundation.Enums.Orientation
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local module2 = require("@luauforge/bundled/gxM")
local linkButton = UIBlox.App.Button.LinkButton
local module3 = require("@luauforge/bundled/fAJ")
local module4 = require("@luauforge/bundled/fCM")
local module5 = require("@luauforge/deferred/fGo")
local module6 = require("@luauforge/deferred/hSg")
local module7 = require("@luauforge/deferred/hSi")

local function Divider(p2)
	local style = p2.style
	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = style.Theme.Divider.Color,
		BackgroundTransparency = style.Theme.Divider.Transparency,
		LayoutOrder = p2.layoutOrder
	})
end

local function VRSettingsContent(props)
	local ref = Roact.createRef()
	local v5 = useStyle()
	local v6 = module2({
		accountSettings = "Application.Settings.AccountSettingsTitle",
		accountSettingsSubtitle = "Application.Settings.VRAccountSettingsSubtitle",
		accountSettingsExplanation = "Application.Settings.VRAccountSettingsExplanation",
		appSettingsTitle = "Application.Settings.AppSettingsTitle",
		deviceSettingsTitle = "Application.Settings.DeviceSettings.Title",
		comfortSettingsTitle = "Application.Settings.VR.Comfort.Title",
		comfortSettingsDescription = "Application.Settings.VR.Comfort.Description"
	})

	local baseSize = v5.Font.BaseSize
	local v7 = baseSize * v5.Font.Title.RelativeSize
	local v8 = baseSize * v5.Font.Header2.RelativeSize
	local nextOrder = createNextOrder()

	local v9 = React.useCallback(function()
		props.linking:openURL("https://www.roblox.com/my/account#!/info"):andThen(function(p2)
			if p2 == false then
				props.linking:openURL("https://www.roblox.com/my/account#!/info")
			end
		end)
		props.closeAlert()
	end, { props.linking, props.closeAlert })

	if module7 then
		return React.createElement(view, {
			tag = "col gap-xxlarge size-full-0 auto-y",
			LayoutOrder = 0
		}, {
			AccountSettings = React.createElement(
				view,
				{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 0 },
				{
					AccountSettingsTitle = React.createElement(text, {
						Text = v6.accountSettings,
						tag = "auto-xy padding-bottom-medium text-heading-large content-default",
						LayoutOrder = 0
					}),
					AccountSettingsSubTitle = React.createElement(text, {
						Text = v6.accountSettingsSubtitle,
						tag = "auto-xy text-title-large content-emphasis",
						LayoutOrder = 1
					}),
					AccessExplanation = React.createElement(text, {
						Text = v6.accountSettingsExplanation,
						tag = "auto-xy text-body-large content-default",
						LayoutOrder = 2
					}),
					Link = React.createElement(view, {
						tag = "auto-xy",
						LayoutOrder = 3
					}, {
						React.createElement(linkButton, {
							text = "https://www.roblox.com/my/account#!/info",
							minPaddingX = 0,
							minPaddingY = 0,
							onActivated = function()
								props.openLeaveRobloxAlertUIBlox(v9)
							end
						})
					})
				}
			),
			Divider1 = React.createElement(divider, {
				orientation = orientation.Horizontal,
				LayoutOrder = 2
			}),
			AppSettings = React.createElement(
				view,
				{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 3 },
				{
					AppSettingsTitle = React.createElement(text, {
						Text = v6.appSettingsTitle,
						tag = "auto-xy padding-bottom-medium text-heading-large content-default",
						LayoutOrder = nextOrder()
					}),
					DeviceSettingsTitle = React.createElement(text, {
						Text = v6.deviceSettingsTitle,
						tag = "auto-xy text-heading-small content-emphasis",
						LayoutOrder = nextOrder()
					}),
					DeviceSettings = React.createElement(
						view,
						{
							tag = "col gap-small size-full-0 auto-y",
							LayoutOrder = nextOrder()
						},
						{ Content = React.createElement(module5) }
					),
					DeviceSettingsDivider = React.createElement(divider, {
						orientation = orientation.Horizontal,
						LayoutOrder = nextOrder()
					}),
					ComfortSettingsTitle = React.createElement(text, {
						Text = v6.comfortSettingsTitle,
						tag = "auto-xy text-heading-small content-emphasis",
						LayoutOrder = nextOrder()
					}),
					ComfortSettingsDescription = React.createElement(text, {
						Text = v6.comfortSettingsDescription,
						tag = "auto-xy text-body-large content-default",
						LayoutOrder = nextOrder()
					}),
					VRComfortSettings = React.createElement(module6, {
						LayoutOrder = nextOrder()
					})
				}
			)
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		[Roact.Ref] = ref
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 30)
		}),
		AccountSettings = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 0
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8)
			}),
			AccountSettingsTitle = React.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Text = v6.accountSettings,
				FontFace = normalizeFontFace(v5.Tokens.Typography.HeadingLarge.Font),
				TextSize = v7,
				TextColor3 = v5.Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 0
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 10)
				})
			}),
			AccountSettingsSubTitle = React.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Text = v6.accountSettingsSubtitle,
				FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
				TextSize = v8,
				TextColor3 = v5.Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			AccessExplanation = React.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Text = v6.accountSettingsExplanation,
				FontFace = normalizeFontFace(v5.Tokens.Typography.HeadingLarge.Font),
				TextSize = baseSize * v5.Font.Body.RelativeSize,
				TextColor3 = v5.Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			}),
			Link = React.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1
				},
				React.createElement(linkButton, {
					text = "https://www.roblox.com/my/account#!/info",
					minPaddingX = 0,
					minPaddingY = 0,
					onActivated = function()
						props.openLeaveRobloxAlertUIBlox(v9)
					end
				})
			)
		}),
		Divider1 = Divider({ style = v5, layoutOrder = 2 }),
		AppSettings = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 8)
				}),
				AppSettingsTitle = React.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Text = v6.appSettingsTitle,
					FontFace = normalizeFontFace(v5.Tokens.Typography.HeadingLarge.Font),
					TextSize = v7,
					TextColor3 = v5.Theme.TextDefault.Color,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 0
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 10)
					})
				}),
				DeviceSettings = React.createElement(module5)
			}
		)
	})
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		openLeaveRobloxAlertUIBlox = function(p2)
			callback(module3(p2))
		end,
		closeAlert = function()
			callback(module4())
		end
	}
end)(VRSettingsContent)

return roactServices.connect({ roactAnalytics = module, linking = appLinking })(v5)
