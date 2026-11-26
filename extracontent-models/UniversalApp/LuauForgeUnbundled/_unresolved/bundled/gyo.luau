local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/egZ")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local dividerWithText = require("@game/CorePackages/Workspace/Packages/AuthCommon").Components.DividerWithText
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/geZ")
local module3 = require("@luauforge/bundled/gfH")
local module4 = require("@luauforge/bundled/ehm")
local module5 = require("@luauforge/bundled/ehl")

local module6 = require("@luauforge/bundled/gyk")

local module7 = require("@luauforge/bundled/fJl")

local getFFlagEnableMaquettesShortLinkCDLInstructions = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableMaquettesShortLinkCDLInstructions
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalytics
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local fFlagEnableMagicLogin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMagicLogin

local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local images = UIBlox.App.ImageSet.Images
local iconSize2 = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2

local iconsgraphiclock_xxlarge = images["icons/graphic/lock_xxlarge"]
local iconSizeUDim2 = getIconSizeUDim2(iconSize2.XLarge)
local v5 = getIconSize(iconSize2.XLarge) * 4 / 3

return function(data)
	local isDualLayout = data.isDualLayout
	local hideDeviceCode = data.hideDeviceCode
	local showLockIcon = data.showLockIcon
	local v6 = useDispatch()

	local v7 = useDesignTokens()
	local loginView = v7.LuaApps.LoginView
	local authConsoleLayout = v7.LuaApps.AuthConsoleLayout
	local v8 = useRoactService(appLinking)
	local v9 = useRoactService(roactNetworking)
	local v10 = useRoactService(roactAnalytics)
	local v11 = useAppPolicy(function(p2)
		return p2
	end)

	local function MagicLoginOpenDiscoveryView()
		v6(module4(module5.DeviceSelectorPeekView, {
			launchApp = function()
				return v6(module2(v9, nil, v10, v11, module3.Login))
			end
		}))
	end

	return withStyle(function(p2)
		local deviceCode = data.DeviceCode

		local font = p2.Font.Body.Font
		local baseSize = p2.Font.BaseSize

		local cdlDeviceCodeSize = loginView.cdlDeviceCodeSize or baseSize * p2.Font.Title.RelativeSize
		local textBodySize = loginView.textBodySize or baseSize * p2.Font.Body.RelativeSize
		local v12

		if isDualLayout then
			v12 = loginView.textSmallSize
		else
			v12 = baseSize * p2.Font.CaptionBody.RelativeSize
		end

		local qrWidth = loginView.qrWidth or v5
		local udim = UDim2.fromOffset(qrWidth, qrWidth)

		local transparency = p2.Theme.TextEmphasis.Transparency
		local color = p2.Theme.TextEmphasis.Color

		local v13 = module7() and data.QrCodeUrl and not data.DisableQrCode
		local v14 = not data.DisableQrCode

		if data.isDualLayout then
			v13 = data.QrCodeUrl and not data.DisableQrCode
		end

		local v15 = if v13 then cdlDeviceCodeSize * 0.75 else cdlDeviceCodeSize * 1.5

		local leftAlignText = data.leftAlignText

		if data.isCrossApp and deviceCode ~= "" then
			v8:openURL("robloxglobal://navigation/crossdevice?code=" .. deviceCode .. "&source=vng")
		end

		return module({
			alertTitle = "Authentication.CrossDevice.Heading.LoginCode",
			devicePrompt = "Authentication.CrossDevice.Label.DevicePrompt",
			loginInstructionsV2 = "Authentication.CrossDevice.Label.LoginInstructionsV2",
			loginLocationV2 = "Authentication.CrossDevice.Label.LoginLocationV2",
			qrHeader = "Authentication.CrossDevice.Label.QrHeader",
			qrHeaderDualLayout = "Authentication.CrossDevice.Label.QrCodeLogin",
			qrInstructions = "Authentication.CrossDevice.Label.QrInstructions",
			codeHeader = "Authentication.CrossDevice.Label.CodeHeader",
			codeHeaderDualLayout = "Authentication.CrossDevice.Heading.QuickLogin",
			orYouCan = "CommonUI.Features.Labels.OrYouCan",
			confirmAndLoginAs = "Authentication.CrossDevice.Label.ConfirmAndLoginAs",
			qrCodeError = "Authentication.CrossDevice.Label.QrCodeError",
			shortlinkLoginInstructions = "Authentication.CrossDevice.Label.QuestCDLShortLinkInstruction"
		})(function(props)
			local v16 = module6()
			local altDesktopInstruction = v16 and data.AltMobileInstruction and data.AltDesktopInstruction

			local v17 = v16 and data.AltTitle

			if not v17 then
				if getFFlagEnableMaquettesShortLinkCDLInstructions() and isVRAppBuild() then
					v17 = props.shortlinkLoginInstructions
				else
					v17 = props.devicePrompt
				end
			end

			local altInstruction = v16 and data.AltInstruction or props.loginInstructionsV2

			local v18 = nil
			local v19 = nil
			local v20 = isDualLayout and v14
			local v21, v22

			if v20 then
				v18 = 3
				v21 = 5
				v22 = 6
				v19 = 2
			elseif v13 then
				v18 = 2
				v21 = 6
				v22 = 5
				v19 = 3
			else
				v21 = 4
				v22 = 2
			end

			local v23 = if isDualLayout then props.qrHeaderDualLayout else props.qrHeader
			local v24 = if isDualLayout then props.codeHeaderDualLayout else props.codeHeader
			local v25

			if data.showConfirmLoginText then
				v25 = string.format(props.confirmAndLoginAs, data.DisplayName)
			else
				v25 = props.qrInstructions
			end

			local createFragment = Roact.createFragment
			local v27

			if fFlagEnableMagicLogin then
				local createElement = Roact.createElement
				local v29 = {
					Text = "<b> Option 1 </b>",
					RichText = true,
					FontFace = normalizeFontFace(v7.Typography.BodyLarge.Font),
					TextSize = textBodySize,
					TextColor3 = color,
					TextTransparency = transparency,
					TextWrapped = true,
					TextXAlignment = 0,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = -1
				}

				local v30 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v29.TextXAlignment = v30
				v29.AutomaticSize = Enum.AutomaticSize.XY
				v29.Size = UDim2.new(1, 0, 0, 0)
				v27 = createElement("TextLabel", v29)
			end

			local v28

			if fFlagEnableMagicLogin then
				v28 = Roact.createElement(button, {
					testId = "--auth-login-button-search-nearby-devices",
					text = "Search Nearby Devices",
					variant = buttonVariant.Emphasis,
					onActivated = function()
						MagicLoginOpenDiscoveryView()
					end,
					isDisabled = false,
					size = inputSize.Large,
					LayoutOrder = 0
				})
			end

			local v29

			if v20 or v13 then
				local createElement = Roact.createElement
				local v31 = {
					Text = fFlagEnableMagicLogin and "<b>Option 2</b>" or "<b>" .. v23 .. "</b>",
					RichText = true,
					FontFace = normalizeFontFace(v7.Typography.BodyLarge.Font),
					TextSize = textBodySize,
					TextColor3 = color,
					TextTransparency = transparency,
					TextWrapped = true,
					TextXAlignment = 0,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				}

				local v32 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v31.TextXAlignment = v32
				v31.AutomaticSize = Enum.AutomaticSize.XY
				v31.Size = UDim2.new(1, 0, 0, 0)
				v29 = createElement("TextLabel", v31)
			end

			local v30

			if showLockIcon and not v13 then
				local createElement = Roact.createElement
				local v33 = if data.isDualLayout then udim else iconSizeUDim2
				v30 = createElement(imageSetLabel, {
					Size = v33,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ScaleType = Enum.ScaleType.Fit,
					Image = iconsgraphiclock_xxlarge,
					ImageColor3 = p2.Theme.UIEmphasis.Color,
					ImageTransparency = 0
				})
			end

			local v31 = if v20 and not v13 then Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, loginView.qrErrorPadding),
				LayoutOrder = 3
			}) else nil

			local v32 = v13

			if v32 then
				local createElement = Roact.createElement
				local v34 = {
					Size = udim,
					BackgroundColor3 = Color3.fromHex("#FFFFFF"),
					BackgroundTransparency = 0,
					LayoutOrder = v18
				}

				local v35 = {
					QrImage = Roact.createElement(imageSetLabel, {
						Size = UDim2.new(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						ScaleType = Enum.ScaleType.Fit,
						Image = data.QrCodeUrl,
						ImageTransparency = 0
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					}),
					UIPadding = 0
				}

				local createElement2 = Roact.createElement
				local v38 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				local v39 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				local v40 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				local v41 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				v35.UIPadding = createElement2("UIPadding", {
					PaddingBottom = v38,
					PaddingLeft = v39,
					PaddingRight = v40,
					PaddingTop = v41
				})
				v32 = createElement("Frame", v34, v35)
			end

			local v33 = v13

			if v33 then
				local createElement = Roact.createElement
				local v35 = {
					Text = v25,
					FontFace = normalizeFontFace(v7.Typography.BodyLarge.Font),
					TextSize = v12,
					TextColor3 = color,
					TextTransparency = transparency,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = 0,
					TextYAlignment = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 0
				}
				local v36 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v35.TextXAlignment = v36
				local v37 = if isDualLayout and hideDeviceCode then Enum.TextYAlignment.Top else nil
				v35.TextYAlignment = v37
				local v38 = if isDualLayout and hideDeviceCode then UDim2.new(1, 0, 0, 48) else UDim2.new(1, 0, 0, 24)
				v35.Size = v38

				v35.LayoutOrder = v19

				local createElement2 = Roact.createElement

				local v42 = if isDualLayout and not hideDeviceCode then UDim.new(0, v7.Size.Size_400) else nil
				local udim2

				if isDualLayout and not hideDeviceCode then
					udim2 = UDim.new(0, v7.Size.Size_600)
				else
					udim2 = if isDualLayout and hideDeviceCode then UDim.new(0, v7.Size.Size_400) else UDim.new(0, 24)
				end

				v33 = createElement("TextLabel", v35, {
					UIPadding = createElement2("UIPadding", {
						PaddingTop = v42,
						PaddingBottom = udim2
					})
				})
			end

			local v34 = if v20 and not hideDeviceCode then Roact.createElement(dividerWithText, {
				layoutOrder = 4,
				width = 0,
				height = 0,
				size = UDim2.new(1, 0, 0, loginView.dividerPadding * 2 + loginView.dividerSize),
				font = font,
				fontSize = v7.Typography.CaptionSmall.FontSize,
				color3 = v7.Color.Content.Muted.Color3,
				transparency = v7.Color.Content.Muted.Transparency,
				text = props.orYouCan,
				padding = authConsoleLayout.dividerPadding
			}) else nil
			local v35

			if (v20 or v13) and not hideDeviceCode then
				local createElement = Roact.createElement
				local v37 = {
					Text = fFlagEnableMagicLogin and "<b>Option 3</b>" or "<b>" .. v24 .. "</b>",
					RichText = true,
					FontFace = normalizeFontFace(v7.Typography.BodyLarge.Font),
					TextSize = textBodySize,
					TextColor3 = color,
					TextTransparency = transparency,
					TextXAlignment = 0,
					TextWrapped = true,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 4
				}

				local v38 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v37.TextXAlignment = v38

				v37.AutomaticSize = Enum.AutomaticSize.XY
				v37.Size = UDim2.new(1, 0, 0, 0)
				v35 = createElement("TextLabel", v37)
			end

			local v36

			if not hideDeviceCode then
				local createElement = Roact.createElement
				local v38 = {
					Text = deviceCode,
					FontFace = normalizeFontFace(v7.Typography.HeadingLarge.Font),
					TextSize = cdlDeviceCodeSize,
					TextColor3 = color,
					TextTransparency = transparency,
					TextXAlignment = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 0
				}

				local v39 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v38.TextXAlignment = v39
				v38.Size = UDim2.new(1, 0, 0, v15)

				v38.LayoutOrder = v22
				local v41

				if deviceCode == "" then
					local createElement2 = Roact.createElement
					local v43 = {
						Position = UDim2.new(0.5, 0, 0.5, 0),
						size = 0,
						AnchorPoint = 0
					}
					local v44 = if v13 then iconSize.Small else iconSize.Medium
					v43.size = v44
					v43.AnchorPoint = Vector2.new(0.5, 0.5)
					v41 = createElement2(loading, v43)
				else
					v41 = false
				end

				v36 = createElement("TextLabel", v38, { Spinner = v41 })
			end

			local v37 = not (v13 or hideDeviceCode)

			if v37 then
				local createElement = Roact.createElement

				if v20 then
					v17 = props.qrCodeError
				end

				local v39 = {
					Text = v17,
					Font = normalizeFontFace(v7.Typography.BodyLarge.Font),
					RichText = getFFlagEnableMaquettesShortLinkCDLInstructions() and isVRAppBuild(),
					TextSize = if isDualLayout then v12 else textBodySize,
					TextColor3 = color,
					TextTransparency = transparency,
					TextWrapped = true,
					TextXAlignment = 0,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					width = 0,
					LayoutOrder = 0
				}

				local v41 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v39.TextXAlignment = v41
				local v42 = if isDualLayout then Enum.AutomaticSize.Y else nil
				v39.AutomaticSize = v42
				v39.Size = UDim2.new(1, 0, 0, 0)

				v39.width = UDim.new(1, 0)
				v39.LayoutOrder = isDualLayout and 2 or 3

				local v44 = if isDualLayout then Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v7.Size.Size_400)
				}) else nil
				v37 = createElement(fitTextLabel, v39, { UIPadding = v44 })
			end

			local v38

			if not (getFFlagEnableMaquettesShortLinkCDLInstructions() and isVRAppBuild() or hideDeviceCode) then
				local createElement = Roact.createElement
				local fitFrame = FitChildren.FitFrame
				local v39 = {
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					LayoutOrder = v21,
					BackgroundTransparency = 1
				}

				local v40 = {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, altDesktopInstruction and 12 or 0)
					}),
					UIPadding = 0,
					InstructionText = 0,
					LocationText = 0,
					LocationList = 0
				}

				local v41 = if isDualLayout then Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v7.Size.Size_400),
					PaddingBottom = UDim.new(0, v7.Size.Size_400)
				}) else nil
				v40.UIPadding = v41

				local createElement2 = Roact.createElement
				local v43 = {
					Text = altInstruction,
					Font = normalizeFontFace(v7.Typography.BodyLarge.Font),
					TextSize = v12,
					TextColor3 = color,
					TextTransparency = transparency,
					TextXAlignment = 0,
					TextWrapped = true,
					Size = 0,
					BackgroundTransparency = 1,
					width = 0,
					LayoutOrder = 1
				}

				local v44 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v43.TextXAlignment = v44

				v43.Size = UDim2.new(1, 0, 0, 0)

				v43.width = UDim.new(1, 0)
				v40.InstructionText = createElement2(fitTextLabel, v43)

				local v45 = not altDesktopInstruction

				if v45 then
					local createElement3 = Roact.createElement
					local v47 = {
						Text = props.loginLocationV2,
						RichText = true,
						Font = normalizeFontFace(v7.Typography.BodyLarge.Font),
						TextSize = v12,
						TextColor3 = color,
						TextTransparency = transparency,
						TextWrapped = true,
						TextXAlignment = 0,
						Size = 0,
						BackgroundTransparency = 1,
						width = 0,
						LayoutOrder = 2
					}

					local v48 = if leftAlignText then Enum.TextXAlignment.Left else nil
					v47.TextXAlignment = v48
					v47.Size = UDim2.new(1, 0, 0, 0)

					v47.width = UDim.new(1, 0)
					v45 = createElement3(fitTextLabel, v47)
				end

				v40.LocationText = v45

				v40.LocationList = altDesktopInstruction
					and Roact.createElement(
						"Frame",
						{
							LayoutOrder = 2,
							Size = UDim2.new(1, -48, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1
						},
						{
							List = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, 4)
							}),
							Mobile = Roact.createElement("TextLabel", {
								LayoutOrder = 1,
								Text = data.AltMobileInstruction,
								RichText = true,
								FontFace = normalizeFontFace(v7.Typography.BodyLarge.Font),
								TextSize = v12,
								TextColor3 = color,
								TextTransparency = transparency,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								BackgroundTransparency = 1,
								AutomaticSize = Enum.AutomaticSize.Y
							}),
							Desktop = Roact.createElement("TextLabel", {
								LayoutOrder = 2,
								Text = data.AltDesktopInstruction,
								RichText = true,
								FontFace = normalizeFontFace(v7.Typography.BodyLarge.Font),
								TextSize = v12,
								TextColor3 = color,
								TextTransparency = transparency,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								BackgroundTransparency = 1,
								AutomaticSize = Enum.AutomaticSize.Y
							})
						}
					)
				v38 = createElement(fitFrame, v39, v40)
			end

			return createFragment({
				MagicLoginHeader = v27,
				MagicLoginDiscoveryButton = v28,
				QrHeader = v29,
				HeaderIcon = v30,
				QrErrorPadding = v31,
				QrImageFrame = v32,
				QrInstructions = v33,
				Divider = v34,
				CodeHeader = v35,
				CodeDisplay = v36,
				DevicePrompt = v37,
				Instructions = v38
			})
		end)
	end)
end
