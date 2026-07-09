local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local withLocalization = require(Modules.LuaApp.withLocalization)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local DividerWithText = require(CorePackages.Workspace.Packages.AuthCommon).Components.DividerWithText
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local GetFFlagCrossDeviceInstructionExperiment = require(Modules.LuaApp.Flags.GetFFlagCrossDeviceInstructionExperiment)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceLoginUsingQRCodes)
local GetFFlagEnableCorrectedLoginInstructions = require(Modules.LuaApp.Flags.GetFFlagEnableCorrectedLoginInstructions)
local GetFFlagEnableMaquettesShortLinkCDLInstructions = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableMaquettesShortLinkCDLInstructions
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local RoactAnalytics = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalytics
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local FFlagEnableMagicLogin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMagicLogin
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Images = UIBlox.App.ImageSet.Images
local IconSize2 = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local v38 = Images["icons/graphic/lock_xxlarge"]
local v39 = getIconSizeUDim2(IconSize2.XLarge)
local v40 = getIconSize(IconSize2.XLarge) * 4 / 3

return function(p1) -- line: 58
	-- upvalues: useDispatch (copy), useDesignTokens (copy), useRoactService (copy), AppLinking (copy), RoactNetworking (copy), RoactAnalytics (copy), useAppPolicy (copy), SetCentralOverlay (copy), OverlayType (copy), LaunchApp (copy), LaunchContext (copy), withStyle (copy), v40 (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), withLocalization (copy), GetFFlagCrossDeviceInstructionExperiment (copy), GetFFlagEnableMaquettesShortLinkCDLInstructions (copy), IsVRAppBuild (copy), GetFFlagEnableCorrectedLoginInstructions (copy), Roact (copy), FFlagEnableMagicLogin (copy), Button (copy), ButtonVariant (copy), InputSize (copy), ImageSetLabel (copy), v39 (copy), v38 (copy), DividerWithText (copy), Loading (copy), IconSize (copy), FitTextLabel (copy), FitChildren (copy)
	local isDualLayout = p1.isDualLayout
	local hideDeviceCode = p1.hideDeviceCode
	local showLockIcon = p1.showLockIcon
	local v45 = useDispatch()
	local v46 = useDesignTokens()
	local LoginView = v46.LuaApps.LoginView
	local EngagementScreen = v46.LuaApps.EngagementScreen
	local v49 = useRoactService(AppLinking)
	local v50 = useRoactService(RoactNetworking)
	local v51 = useRoactService(RoactAnalytics)
	local v52 = useAppPolicy(function(p2) -- line: 70
		return p2
	end)

	local function MagicLoginOpenDiscoveryView() -- line: 74
		-- upvalues: v45 (copy), SetCentralOverlay (copy), OverlayType (copy), LaunchApp (copy), v50 (copy), v51 (copy), v52 (copy), LaunchContext (copy)
		v45(SetCentralOverlay(OverlayType.DeviceSelectorPeekView, {
			launchApp = function() -- line: 76
				-- upvalues: v45 (copy), LaunchApp (copy), v50 (copy), v51 (copy), v52 (copy), LaunchContext (copy)
				return v45(LaunchApp(v50, nil, v51, v52, LaunchContext.Login))
			end
		}))
	end

	return withStyle(function(p3) -- line: 82
		-- upvalues: p1 (copy), LoginView (copy), isDualLayout (copy), v40 (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), v49 (copy), withLocalization (copy), GetFFlagCrossDeviceInstructionExperiment (copy), GetFFlagEnableMaquettesShortLinkCDLInstructions (copy), IsVRAppBuild (copy), GetFFlagEnableCorrectedLoginInstructions (copy), Roact (copy), FFlagEnableMagicLogin (copy), Button (copy), ButtonVariant (copy), MagicLoginOpenDiscoveryView (copy), InputSize (copy), showLockIcon (copy), ImageSetLabel (copy), v39 (copy), v38 (copy), hideDeviceCode (copy), v46 (copy), DividerWithText (copy), EngagementScreen (copy), Loading (copy), IconSize (copy), FitTextLabel (copy), FitChildren (copy)
		local DeviceCode = p1.DeviceCode
		local TitleFont = p3.Font.Title.Font
		local BodyFont = p3.Font.Body.Font
		local BaseSize = p3.Font.BaseSize
		local v60 = LoginView.cdlDeviceCodeSize or BaseSize * p3.Font.Title.RelativeSize
		local v61 = LoginView.textBodySize or BaseSize * p3.Font.Body.RelativeSize
		local v62 = if not isDualLayout then BaseSize * p3.Font.CaptionBody.RelativeSize else LoginView.textSmallSize
		local v63 = LoginView.qrWidth or v40
		local uDim2 = UDim2.fromOffset(v63, v63)
		local TextEmphasisTransparency = p3.Theme.TextEmphasis.Transparency
		local TextEmphasisColor = p3.Theme.TextEmphasis.Color
		local u67 = GetFFlagEnableCrossDeviceLoginUsingQRCodes() and (p1.QrCodeUrl and not p1.DisableQrCode)
		local v68 = not p1.DisableQrCode

		if p1.isDualLayout then
			u67 = p1.QrCodeUrl and not p1.DisableQrCode
		end

		local u69 = if not u67 then v60 * 1.5 else v60 * 0.75
		local leftAlignText = p1.leftAlignText

		if p1.isCrossApp and DeviceCode ~= "" then
			v49:openURL("robloxglobal://navigation/crossdevice?code=" .. DeviceCode .. "&" .. "source=vng")
		end

		return withLocalization({
			alertTitle = "Authentication.CrossDevice.Heading.LoginCode",
			devicePrompt = "Authentication.CrossDevice.Label.DevicePrompt",
			loginInstructions = "Authentication.CrossDevice.Label.LoginInstructions",
			loginInstructionsV2 = "Authentication.CrossDevice.Label.LoginInstructionsV2",
			loginLocation = "Authentication.CrossDevice.Label.LoginLocation",
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
		})(function(p4) -- line: 139
			-- upvalues: GetFFlagCrossDeviceInstructionExperiment (copy), p1 (copy), GetFFlagEnableMaquettesShortLinkCDLInstructions (copy), IsVRAppBuild (copy), GetFFlagEnableCorrectedLoginInstructions (copy), isDualLayout (copy), v68 (copy), u67 (ref), Roact (copy), FFlagEnableMagicLogin (copy), BodyFont (copy), v61 (copy), TextEmphasisColor (copy), TextEmphasisTransparency (copy), leftAlignText (copy), Button (copy), ButtonVariant (copy), MagicLoginOpenDiscoveryView (copy), InputSize (copy), showLockIcon (copy), ImageSetLabel (copy), uDim2 (copy), v39 (copy), v38 (copy), p3 (copy), LoginView (copy), v62 (copy), hideDeviceCode (copy), v46 (copy), DividerWithText (copy), EngagementScreen (copy), DeviceCode (copy), TitleFont (copy), v60 (copy), u69 (ref), Loading (copy), IconSize (copy), FitTextLabel (copy), FitChildren (copy)
			local v72 = GetFFlagCrossDeviceInstructionExperiment()
			local v73 = v72 and (p1.AltMobileInstruction and p1.AltDesktopInstruction)
			local v74 = v72 and p1.AltTitle or if not GetFFlagEnableMaquettesShortLinkCDLInstructions() or not IsVRAppBuild() then p4.devicePrompt else p4.shortlinkLoginInstructions
			local v75 = v72 and p1.AltInstruction or if not GetFFlagEnableCorrectedLoginInstructions() then p4.loginInstructions else p4.loginInstructionsV2
			local n1 = nil
			local n2 = nil
			local v78 = isDualLayout and v68
			local n3, n4

			if v78 then
				n1 = 3
				n2 = 2
				n3 = 6
				n4 = 5
			elseif u67 then
				n1 = 2
				n2 = 3
				n3 = 5
				n4 = 6
			else
				n3 = 2
				n4 = 4
			end

			local v81 = if not isDualLayout then p4.qrHeader else p4.qrHeaderDualLayout
			local v82 = if not isDualLayout then p4.codeHeader else p4.codeHeaderDualLayout
			local v83 = if not p1.showConfirmLoginText then p4.qrInstructions else string.format(p4.confirmAndLoginAs, p1.DisplayName)

			return Roact.createFragment({
				MagicLoginHeader = if not FFlagEnableMagicLogin then nil else Roact.createElement("TextLabel", {
					Text = "<b> Option 1 </b>",
					RichText = true,
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = -1,
					Font = BodyFont,
					TextSize = v61,
					TextColor3 = TextEmphasisColor,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(1, 0, 0, 0)
				}),
				MagicLoginDiscoveryButton = if not FFlagEnableMagicLogin then nil else Roact.createElement(Button, {
					text = "Search Nearby Devices",
					isDisabled = false,
					LayoutOrder = 0,
					variant = ButtonVariant.Emphasis,
					onActivated = function() -- line: 204
						-- upvalues: MagicLoginOpenDiscoveryView (copy)
						MagicLoginOpenDiscoveryView()
					end,
					size = InputSize.Large
				}),
				QrHeader = if not v78 and not u67 then nil else Roact.createElement("TextLabel", {
					RichText = true,
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Text = if not FFlagEnableMagicLogin then "<b>" .. v81 .. "</b>" else "<b>Option 2</b>",
					Font = BodyFont,
					TextSize = v61,
					TextColor3 = TextEmphasisColor,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(1, 0, 0, 0)
				}),
				HeaderIcon = if not showLockIcon or u67 then nil else Roact.createElement(ImageSetLabel, {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ImageTransparency = 0,
					Size = if not p1.isDualLayout then v39 else uDim2,
					ScaleType = Enum.ScaleType.Fit,
					Image = v38,
					ImageColor3 = p3.Theme.UIEmphasis.Color
				}),
				QrErrorPadding = if not v78 or u67 then nil else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, LoginView.qrErrorPadding)
				}),
				QrImageFrame = u67 and Roact.createElement("Frame", {
					BackgroundTransparency = 0,
					Size = uDim2,
					BackgroundColor3 = Color3.fromHex("#FFFFFF"),
					LayoutOrder = n1
				}, {
					QrImage = Roact.createElement(ImageSetLabel, {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						ImageTransparency = 0,
						Size = UDim2.new(1, 0, 1, 0),
						ScaleType = Enum.ScaleType.Fit,
						Image = p1.QrCodeUrl
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingBottom = if not isDualLayout then UDim.new(0, 4) else LoginView.qrPadding,
						PaddingLeft = if not isDualLayout then UDim.new(0, 4) else LoginView.qrPadding,
						PaddingRight = if not isDualLayout then UDim.new(0, 4) else LoginView.qrPadding,
						PaddingTop = if not isDualLayout then UDim.new(0, 4) else LoginView.qrPadding
					})
				}),
				QrInstructions = u67 and Roact.createElement("TextLabel", {
					TextWrapped = true,
					BackgroundTransparency = 1,
					Text = v83,
					Font = BodyFont,
					TextSize = v62,
					TextColor3 = TextEmphasisColor,
					TextTransparency = TextEmphasisTransparency,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
					TextYAlignment = if not isDualLayout or not hideDeviceCode then nil else Enum.TextYAlignment.Top,
					Size = if not isDualLayout or not hideDeviceCode then UDim2.new(1, 0, 0, 24) else UDim2.new(1, 0, 0, 48),
					LayoutOrder = n2
				}, {
					UIPadding = Roact.createElement("UIPadding", {
						PaddingTop = if not isDualLayout or hideDeviceCode then nil else UDim.new(0, v46.Size.Size_400),
						PaddingBottom = if not isDualLayout or hideDeviceCode then if not isDualLayout or not hideDeviceCode then UDim.new(0, 24) else UDim.new(0, v46.Size.Size_400) else UDim.new(0, v46.Size.Size_600)
					})
				}),
				Divider = if not v78 or hideDeviceCode then nil else Roact.createElement(DividerWithText, {
					layoutOrder = 4,
					width = 0,
					height = 0,
					size = UDim2.new(1, 0, 0, LoginView.dividerPadding * 2 + LoginView.dividerSize),
					font = BodyFont,
					fontSize = v46.Typography.CaptionSmall.FontSize,
					color3 = v46.Color.Content.Muted.Color3,
					transparency = v46.Color.Content.Muted.Transparency,
					text = p4.orYouCan,
					padding = EngagementScreen.dividerPadding
				}),
				CodeHeader = if not v78 and not u67 or hideDeviceCode then nil else Roact.createElement("TextLabel", {
					RichText = true,
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Text = if not FFlagEnableMagicLogin then "<b>" .. v82 .. "</b>" else "<b>Option 3</b>",
					Font = BodyFont,
					TextSize = v61,
					TextColor3 = TextEmphasisColor,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(1, 0, 0, 0)
				}),
				CodeDisplay = if hideDeviceCode then nil else Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = DeviceCode,
					Font = TitleFont,
					TextSize = v60,
					TextColor3 = TextEmphasisColor,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, u69),
					LayoutOrder = n3
				}, {
					Spinner = DeviceCode == "" and Roact.createElement(Loading, {
						Position = UDim2.new(0.5, 0, 0.5, 0),
						size = if not u67 then IconSize.Medium else IconSize.Small,
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}),
				DevicePrompt = not u67 and (not hideDeviceCode and Roact.createElement(FitTextLabel, {
					TextWrapped = true,
					BackgroundTransparency = 1,
					Text = if not v78 then v74 else p4.qrCodeError,
					Font = BodyFont,
					RichText = GetFFlagEnableMaquettesShortLinkCDLInstructions() and IsVRAppBuild(),
					TextSize = if not isDualLayout then v61 else v62,
					TextColor3 = TextEmphasisColor,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
					AutomaticSize = if not isDualLayout then nil else Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					LayoutOrder = not isDualLayout and 3 or 2
				}, {
					UIPadding = if not isDualLayout then nil else Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v46.Size.Size_400)
					})
				})),
				Instructions = if GetFFlagEnableMaquettesShortLinkCDLInstructions() and IsVRAppBuild() or hideDeviceCode then nil else Roact.createElement(FitChildren.FitFrame, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					LayoutOrder = n4
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, not v73 and 0 or 12)
					}),
					UIPadding = if not isDualLayout then nil else Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v46.Size.Size_400),
						PaddingBottom = UDim.new(0, v46.Size.Size_400)
					}),
					InstructionText = Roact.createElement(FitTextLabel, {
						TextWrapped = true,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Text = v75,
						Font = BodyFont,
						TextSize = v62,
						TextColor3 = TextEmphasisColor,
						TextTransparency = TextEmphasisTransparency,
						TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height
					}),
					LocationText = not v73 and Roact.createElement(FitTextLabel, {
						RichText = true,
						TextWrapped = true,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Text = if not GetFFlagEnableCorrectedLoginInstructions() then p4.loginLocation else p4.loginLocationV2,
						Font = BodyFont,
						TextSize = v62,
						TextColor3 = TextEmphasisColor,
						TextTransparency = TextEmphasisTransparency,
						TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height
					}),
					LocationList = v73 and Roact.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -48, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						List = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 4)
						}),
						Mobile = Roact.createElement("TextLabel", {
							LayoutOrder = 1,
							RichText = true,
							TextWrapped = true,
							BackgroundTransparency = 1,
							Text = p1.AltMobileInstruction,
							Font = BodyFont,
							TextSize = v62,
							TextColor3 = TextEmphasisColor,
							TextTransparency = TextEmphasisTransparency,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}),
						Desktop = Roact.createElement("TextLabel", {
							LayoutOrder = 2,
							RichText = true,
							TextWrapped = true,
							BackgroundTransparency = 1,
							Text = p1.AltDesktopInstruction,
							Font = BodyFont,
							TextSize = v62,
							TextColor3 = TextEmphasisColor,
							TextTransparency = TextEmphasisTransparency,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						})
					})
				})
			})
		end)
	end)
end
