local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/edC")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local dividerWithText = require("@game/CorePackages/Workspace/Packages/AuthCommon").Components.DividerWithText
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/fAH")
local module3 = require("@luauforge/bundled/fBo")
local module4 = require("@luauforge/bundled/edP")
local module5 = require("@luauforge/bundled/edO")

local module6 = require("@luauforge/bundled/hDy")

local module7 = require("@luauforge/bundled/hDz")

local getFFlagEnableMaquettesShortLinkCDLInstructions = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableMaquettesShortLinkCDLInstructions
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalytics
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

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
local v6 = getIconSize(iconSize2.XLarge) * 4 / 3

return function(data)
	local isDualLayout = data.isDualLayout
	local hideDeviceCode = data.hideDeviceCode
	local showLockIcon = data.showLockIcon
	local v7 = useDispatch()

	local v8 = useDesignTokens()
	local loginView = v8.LuaApps.LoginView
	local authConsoleLayout = v8.LuaApps.AuthConsoleLayout
	local v9 = useRoactService(appLinking)
	local v10 = useRoactService(roactNetworking)
	local v11 = useRoactService(roactAnalytics)
	local v12 = useAppPolicy(function(p2)
		return p2
	end)

	local function MagicLoginOpenDiscoveryView()
		v7(module4(module5.DeviceSelectorPeekView, {
			launchApp = function()
				return v7(module2(v10, nil, v11, v12, module3.Login))
			end
		}))
	end

	return withStyle(function(p2)
		local deviceCode = data.DeviceCode

		local font = p2.Font.Title.Font
		local font2 = p2.Font.Body.Font
		local baseSize = p2.Font.BaseSize

		local cdlDeviceCodeSize = loginView.cdlDeviceCodeSize or baseSize * p2.Font.Title.RelativeSize
		local textBodySize = loginView.textBodySize or baseSize * p2.Font.Body.RelativeSize
		local v13

		if isDualLayout then
			v13 = loginView.textSmallSize
		else
			v13 = baseSize * p2.Font.CaptionBody.RelativeSize
		end

		local qrWidth = loginView.qrWidth or v6
		local udim = UDim2.fromOffset(qrWidth, qrWidth)

		local transparency = p2.Theme.TextEmphasis.Transparency
		local color = p2.Theme.TextEmphasis.Color

		local v14 = module7() and data.QrCodeUrl and not data.DisableQrCode
		local v15 = not data.DisableQrCode

		if data.isDualLayout then
			v14 = data.QrCodeUrl and not data.DisableQrCode
		end

		local v16 = if v14 then cdlDeviceCodeSize * 0.75 else cdlDeviceCodeSize * 1.5

		local leftAlignText = data.leftAlignText

		if data.isCrossApp and deviceCode ~= "" then
			v9:openURL("robloxglobal://navigation/crossdevice?code=" .. deviceCode .. "&source=vng")
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
			local v17 = module6()
			local v18 = v17 and data.AltMobileInstruction and data.AltDesktopInstruction

			local v19 = v17 and data.AltTitle

			if not v19 then
				if getFFlagEnableMaquettesShortLinkCDLInstructions() and isVRAppBuild() then
					v19 = props.shortlinkLoginInstructions
				else
					v19 = props.devicePrompt
				end
			end

			local altInstruction = v17 and data.AltInstruction or props.loginInstructionsV2

			local v20 = nil
			local v21 = nil
			local v22 = isDualLayout and v15
			local v23, v24

			if v22 then
				v20 = 3
				v23 = 5
				v24 = 6
				v21 = 2
			elseif v14 then
				v20 = 2
				v23 = 6
				v24 = 5
				v21 = 3
			else
				v23 = 4
				v24 = 2
			end

			local v25 = if isDualLayout then props.qrHeaderDualLayout else props.qrHeader
			local v26 = if isDualLayout then props.codeHeaderDualLayout else props.codeHeader
			local v27

			if data.showConfirmLoginText then
				v27 = string.format(props.confirmAndLoginAs, data.DisplayName)
			else
				v27 = props.qrInstructions
			end

			local createFragment = Roact.createFragment
			local v29

			if fFlagEnableMagicLogin then
				local createElement = Roact.createElement
				local v31 = {
					Text = "<b> Option 1 </b>",
					RichText = true,
					Font = if not foundationFontFaceMigration then font2 else nil,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextWrapped = true,
					TextXAlignment = 0,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = -1
				}

				local v33 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
				v31.FontFace = v33

				v31.TextSize = textBodySize
				v31.TextColor3 = color
				v31.TextTransparency = transparency

				local v34 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v31.TextXAlignment = v34
				v31.AutomaticSize = Enum.AutomaticSize.XY
				v31.Size = UDim2.new(1, 0, 0, 0)
				v29 = createElement("TextLabel", v31)
			end

			local v30

			if fFlagEnableMagicLogin then
				v30 = Roact.createElement(button, {
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

			local v31

			if v22 or v14 then
				local createElement = Roact.createElement
				local v33 = {
					Text = fFlagEnableMagicLogin and "<b>Option 2</b>" or "<b>" .. v25 .. "</b>",
					RichText = true,
					Font = if not foundationFontFaceMigration then font2 else nil,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextWrapped = true,
					TextXAlignment = 0,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				}

				local v35 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
				v33.FontFace = v35

				v33.TextSize = textBodySize
				v33.TextColor3 = color
				v33.TextTransparency = transparency

				local v36 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v33.TextXAlignment = v36
				v33.AutomaticSize = Enum.AutomaticSize.XY
				v33.Size = UDim2.new(1, 0, 0, 0)
				v31 = createElement("TextLabel", v33)
			end

			local v32

			if showLockIcon and not v14 then
				local createElement = Roact.createElement
				local v35 = if data.isDualLayout then udim else iconSizeUDim2
				v32 = createElement(imageSetLabel, {
					Size = v35,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ScaleType = Enum.ScaleType.Fit,
					Image = iconsgraphiclock_xxlarge,
					ImageColor3 = p2.Theme.UIEmphasis.Color,
					ImageTransparency = 0
				})
			end

			local v33 = if v22 and not v14 then Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, loginView.qrErrorPadding),
				LayoutOrder = 3
			}) else nil

			local v34 = v14

			if v34 then
				local createElement = Roact.createElement
				local v36 = {
					Size = udim,
					BackgroundColor3 = Color3.fromHex("#FFFFFF"),
					BackgroundTransparency = 0,
					LayoutOrder = v20
				}

				local v37 = {
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
				local v40 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				local v41 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				local v42 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				local v43 = if isDualLayout then loginView.qrPadding else UDim.new(0, 4)
				v37.UIPadding = createElement2("UIPadding", {
					PaddingBottom = v40,
					PaddingLeft = v41,
					PaddingRight = v42,
					PaddingTop = v43
				})
				v34 = createElement("Frame", v36, v37)
			end

			local v35 = v14

			if v35 then
				local createElement = Roact.createElement
				local v37 = {
					Text = v27,
					Font = if not foundationFontFaceMigration then font2 else nil,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextWrapped = true,
					AutomaticSize = 0,
					TextXAlignment = 0,
					TextYAlignment = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 0
				}

				local v39 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
				v37.FontFace = v39

				v37.TextSize = v13
				v37.TextColor3 = color
				v37.TextTransparency = transparency

				v37.AutomaticSize = Enum.AutomaticSize.XY
				local v40 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v37.TextXAlignment = v40
				local v41 = if isDualLayout and hideDeviceCode then Enum.TextYAlignment.Top else nil
				v37.TextYAlignment = v41
				local v42 = if isDualLayout and hideDeviceCode then UDim2.new(1, 0, 0, 48) else UDim2.new(1, 0, 0, 24)
				v37.Size = v42

				v37.LayoutOrder = v21

				local createElement2 = Roact.createElement

				local v46 = if isDualLayout and not hideDeviceCode then UDim.new(0, v8.Size.Size_400) else nil
				local udim2

				if isDualLayout and not hideDeviceCode then
					udim2 = UDim.new(0, v8.Size.Size_600)
				else
					udim2 = if isDualLayout and hideDeviceCode then UDim.new(0, v8.Size.Size_400) else UDim.new(0, 24)
				end

				v35 = createElement("TextLabel", v37, {
					UIPadding = createElement2("UIPadding", {
						PaddingTop = v46,
						PaddingBottom = udim2
					})
				})
			end

			local v36 = if v22 and not hideDeviceCode then Roact.createElement(dividerWithText, {
				layoutOrder = 4,
				width = 0,
				height = 0,
				size = UDim2.new(1, 0, 0, loginView.dividerPadding * 2 + loginView.dividerSize),
				font = font2,
				fontSize = v8.Typography.CaptionSmall.FontSize,
				color3 = v8.Color.Content.Muted.Color3,
				transparency = v8.Color.Content.Muted.Transparency,
				text = props.orYouCan,
				padding = authConsoleLayout.dividerPadding
			}) else nil
			local v37

			if (v22 or v14) and not hideDeviceCode then
				local createElement = Roact.createElement
				local v39 = {
					Text = fFlagEnableMagicLogin and "<b>Option 3</b>" or "<b>" .. v26 .. "</b>",
					RichText = true,
					Font = if not foundationFontFaceMigration then font2 else nil,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					TextWrapped = true,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 4
				}

				local v41 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
				v39.FontFace = v41

				v39.TextSize = textBodySize
				v39.TextColor3 = color
				v39.TextTransparency = transparency
				local v42 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v39.TextXAlignment = v42

				v39.AutomaticSize = Enum.AutomaticSize.XY
				v39.Size = UDim2.new(1, 0, 0, 0)
				v37 = createElement("TextLabel", v39)
			end

			local v38

			if not hideDeviceCode then
				local createElement = Roact.createElement
				local v40 = {
					Text = deviceCode,
					Font = if not foundationFontFaceMigration then font else nil,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					Size = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 0
				}

				local v42 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.HeadingLarge.Font) else nil
				v40.FontFace = v42

				v40.TextSize = cdlDeviceCodeSize
				v40.TextColor3 = color
				v40.TextTransparency = transparency
				local v43 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v40.TextXAlignment = v43
				v40.Size = UDim2.new(1, 0, 0, v16)

				v40.LayoutOrder = v24
				local v45

				if deviceCode == "" then
					local createElement2 = Roact.createElement
					local v47 = {
						Position = UDim2.new(0.5, 0, 0.5, 0),
						size = 0,
						AnchorPoint = 0
					}
					local v48 = if v14 then iconSize.Small else iconSize.Medium
					v47.size = v48
					v47.AnchorPoint = Vector2.new(0.5, 0.5)
					v45 = createElement2(loading, v47)
				else
					v45 = false
				end

				v38 = createElement("TextLabel", v40, { Spinner = v45 })
			end

			local v39 = not (v14 or hideDeviceCode)

			if v39 then
				local createElement = Roact.createElement

				if v22 then
					v19 = props.qrCodeError
				end

				local v42 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else font2
				local v41 = {
					Text = v19,
					Font = v42,
					RichText = getFFlagEnableMaquettesShortLinkCDLInstructions() and isVRAppBuild(),
					TextSize = if isDualLayout then v13 else textBodySize,
					TextColor3 = color,
					TextTransparency = transparency,
					TextWrapped = true,
					TextXAlignment = 0,
					AutomaticSize = 0,
					Size = 0,
					BackgroundTransparency = 1,
					fitAxis = 0,
					width = 0,
					LayoutOrder = 0
				}

				local v44 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v41.TextXAlignment = v44
				local v45 = if isDualLayout then Enum.AutomaticSize.Y else nil
				v41.AutomaticSize = v45
				v41.Size = UDim2.new(1, 0, 0, 0)

				local v46 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
				v41.fitAxis = v46
				local v47 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
				v41.width = v47
				v41.LayoutOrder = isDualLayout and 2 or 3

				local v49 = if isDualLayout then Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v8.Size.Size_400)
				}) else nil
				v39 = createElement(v5, v41, { UIPadding = v49 })
			end

			local v40

			if not (getFFlagEnableMaquettesShortLinkCDLInstructions() and isVRAppBuild() or hideDeviceCode) then
				local createElement = Roact.createElement
				local fitFrame = FitChildren.FitFrame
				local v41 = {
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					LayoutOrder = v23,
					BackgroundTransparency = 1
				}

				local v42 = {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, v18 and 12 or 0)
					}),
					UIPadding = 0,
					InstructionText = 0,
					LocationText = 0,
					LocationList = 0
				}

				local v43 = if isDualLayout then Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v8.Size.Size_400),
					PaddingBottom = UDim.new(0, v8.Size.Size_400)
				}) else nil
				v42.UIPadding = v43

				local createElement2 = Roact.createElement

				local v46 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else font2
				local v45 = {
					Text = altInstruction,
					Font = v46,
					TextSize = v13,
					TextColor3 = color,
					TextTransparency = transparency,
					TextXAlignment = 0,
					TextWrapped = true,
					Size = 0,
					BackgroundTransparency = 1,
					fitAxis = 0,
					width = 0,
					LayoutOrder = 1
				}

				local v47 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v45.TextXAlignment = v47

				v45.Size = UDim2.new(1, 0, 0, 0)

				local v48 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
				v45.fitAxis = v48
				local v49 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
				v45.width = v49
				v42.InstructionText = createElement2(v5, v45)

				local v50 = not v18

				if v50 then
					local createElement3 = Roact.createElement
					local v52 = {
						Text = props.loginLocationV2,
						RichText = true,
						Font = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextWrapped = true,
						TextXAlignment = 0,
						Size = 0,
						BackgroundTransparency = 1,
						fitAxis = 0,
						width = 0,
						LayoutOrder = 2
					}

					local v53 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else font2
					v52.Font = v53

					v52.TextSize = v13
					v52.TextColor3 = color
					v52.TextTransparency = transparency

					local v54 = if leftAlignText then Enum.TextXAlignment.Left else nil
					v52.TextXAlignment = v54
					v52.Size = UDim2.new(1, 0, 0, 0)

					local v55 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
					v52.fitAxis = v55
					local v56 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
					v52.width = v56
					v50 = createElement3(v5, v52)
				end

				v42.LocationText = v50

				if v18 then
					local createElement3 = Roact.createElement
					local v52 = {
						LayoutOrder = 2,
						Size = UDim2.new(1, -48, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1
					}

					local children = {
						List = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 4)
						}),
						Mobile = 0,
						Desktop = 0
					}

					local createElement4 = Roact.createElement
					local v54 = {
						LayoutOrder = 1,
						Text = data.AltMobileInstruction,
						RichText = true,
						Font = if not foundationFontFaceMigration then font2 else nil,
						FontFace = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextWrapped = true,
						Size = 0,
						BackgroundTransparency = 1,
						AutomaticSize = 0
					}

					local v56 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
					v54.FontFace = v56

					v54.TextSize = v13
					v54.TextColor3 = color
					v54.TextTransparency = transparency

					v54.Size = UDim2.new(1, 0, 0, 0)

					v54.AutomaticSize = Enum.AutomaticSize.Y
					children.Mobile = createElement4("TextLabel", v54)

					local createElement5 = Roact.createElement
					local v58 = {
						LayoutOrder = 2,
						Text = data.AltDesktopInstruction,
						RichText = true,
						Font = if not foundationFontFaceMigration then font2 else nil,
						FontFace = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextWrapped = true,
						Size = 0,
						BackgroundTransparency = 1,
						AutomaticSize = 0
					}

					local v60 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
					v58.FontFace = v60

					v58.TextSize = v13
					v58.TextColor3 = color
					v58.TextTransparency = transparency

					v58.Size = UDim2.new(1, 0, 0, 0)

					v58.AutomaticSize = Enum.AutomaticSize.Y
					children.Desktop = createElement5("TextLabel", v58)
					v18 = createElement3("Frame", v52, children)
				end

				v42.LocationList = v18
				v40 = createElement(fitFrame, v41, v42)
			end

			return createFragment({
				MagicLoginHeader = v29,
				MagicLoginDiscoveryButton = v30,
				QrHeader = v31,
				HeaderIcon = v32,
				QrErrorPadding = v33,
				QrImageFrame = v34,
				QrInstructions = v35,
				Divider = v36,
				CodeHeader = v37,
				CodeDisplay = v38,
				DevicePrompt = v39,
				Instructions = v40
			})
		end)
	end)
end
