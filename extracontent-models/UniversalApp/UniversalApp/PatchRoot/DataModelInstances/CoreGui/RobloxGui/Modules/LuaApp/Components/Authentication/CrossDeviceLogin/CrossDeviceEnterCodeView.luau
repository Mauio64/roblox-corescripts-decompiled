local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FoundationText = Foundation.Text
local TextInput = Foundation.TextInput
local InputSize = Foundation.Enums.InputSize
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local CrossDeviceLogin = require(Modules.LuaApp.Thunks.Authentication.CrossDeviceLogin)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local GetIXPLayerParameters = require(Modules.LuaApp.Http.Requests.GetIXPLayerParameters)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceLoginUsingQRCodes)
local GetFFlagEnableCrossDeviceEnterCodeRefresh = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceEnterCodeRefresh)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local reportCrossDeviceEnterCodeClick = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.reportCrossDeviceEnterCodeClick)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local TextInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local CrossDevicePhoneLayout = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.CrossDevicePhoneLayout)
local CrossDeviceTabletLayout = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.CrossDeviceTabletLayout)
local Logger = require(Modules.LuaApp.Components.Authentication.Logger)
local GetFFlagEnableAuthsecImageUpdate = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuthsecImageUpdate
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v42 = Images["icons/graphic/lock_xxlarge"]

local function sanitizeEnterCode(s1: string) -- line: 77
	return s1:gsub("[^%w]", ""):upper():sub(1, 6)
end
local function getLocalPlayerDisplayName() -- line: 81
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return "Player"
	end

	local DisplayName = LocalPlayer.DisplayName

	if DisplayName and DisplayName ~= "" then
		return DisplayName
	end

	return LocalPlayer.Name
end
local function escapeForRichText(s2: string) -- line: 93
	return s2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

local v46 = Roact.PureComponent:extend("CrossDeviceEnterCodePage")

function v46.init(p1) -- line: 99
	-- upvalues: Foundation (copy), Logger (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), reportCrossDeviceEnterCodeClick (copy), Roact (copy)
	p1.latestSanitizedCode = ""
	p1:setState({
		inputCode = "",
		inputErrorKey = "",
		placeholderTextOverride = "",
		disableSubmissionForBadCode = false,
		isConfirming = false,
		isFocused = false
	})

	function p1.onFocus() -- line: 111
		-- upvalues: p1 (copy)
		p1:setState({
			inputErrorKey = "",
			isFocused = true
		})
	end
	function p1.onFocusLost(_, p3) -- line: 118
		-- upvalues: p1 (copy)
		if p3 and #p1.state.inputCode == 6 then
			p1.confirmButtonPressed()

			return
		end

		p1:setState({
			isFocused = false
		})
	end
	function p1.getVerifyCodeImage(s3: string) -- line: 128
		-- upvalues: Foundation (copy)
		if s3 == Foundation.Enums.Theme.Dark then
			return "icons/graphic/verifyCode_dark"
		end

		return "icons/graphic/verifyCode_light"
	end
	function p1.onTextChanged(p4) -- line: 136
		-- upvalues: p1 (copy), Logger (copy)
		local ok, result = pcall(function() -- line: 143
			-- upvalues: p4 (copy), p1 (copy)
			local v127 = p4.Text:gsub("[^%w]", ""):upper():sub(1, 6)

			if v127 ~= p4.Text then
				p4.Text = v127

				return
			end

			p1:setState({
				inputCode = p4.Text
			})
		end)

		if not ok then
			Logger:warning(string.format("Text validation error in CrossDeviceEnderCodeView: %s", (tostring(result))))
		end
	end
	function p1.onRefreshCodeChanged(s4: string) -- line: 158
		-- upvalues: p1 (copy), Logger (copy)
		local ok, result = pcall(function() -- line: 159
			-- upvalues: s4 (copy), p1 (copy)
			local v128 = s4:gsub("[^%w]", ""):upper():sub(1, 6)

			p1.latestSanitizedCode = v128
			p1.setInputText(v128)
			p1:setState({
				inputCode = v128
			})
		end)

		if not ok then
			Logger:warning(string.format("Text validation error in CrossDeviceEnderCodeView: %s", (tostring(result))))
		end
	end

	p1.attemptDeeplinkCode = true
	p1.confirmingCode = false

	function p1.confirmButtonPressed() -- line: 174
		-- upvalues: p1 (copy), GetFFlagEnableCrossDeviceLoginUsingQRCodes (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), reportCrossDeviceEnterCodeClick (copy)
		if not p1.confirmingCode then
			p1.confirmingCode = true
			p1:setState({
				isConfirming = true,
				isFocused = false
			})

			local code, s5

			if GetFFlagEnableCrossDeviceLoginUsingQRCodes() and p1.attemptDeeplinkCode and p1.props.code then
				code = p1.props.code
				s5 = "qrCode"
			else
				code = p1.state.inputCode
				s5 = "alphaNumericCode"
			end

			if GetFFlagEnableCrossDeviceEnterCodeRefresh() and s5 == "alphaNumericCode" then
				code = p1.latestSanitizedCode
			end

			p1.attemptDeeplinkCode = false
			reportCrossDeviceEnterCodeClick(p1.props.authAnalytics, s5)
			p1.props.validateCode(p1.props.networking, code):andThen(function(p5) -- line: 200
				-- upvalues: p1 (copy), code (ref)
				p1.acceptInputCode(code, p5.DeviceInfo)
			end, p1.clearInputCode)
		end
	end

	local v57, v58 = Roact.createBinding("")

	p1.inputText = v57
	p1.setInputText = v58

	function p1.clearInputCode(p6) -- line: 207
		-- upvalues: p1 (copy)
		p1.confirmingCode = false
		p1.latestSanitizedCode = ""
		p1.setInputText("")

		local s6 = "Authentication.Login.Response.SomethingWentWrong"

		if p6.Body == "\"CodeInvalid\"" then
			s6 = "Authentication.CrossDevice.Response.InvalidCode"
		elseif p6.Body == "\"InvalidLocation\"" then
			s6 = "Authentication.CrossDevice.Label.InvalidLocationError"
		end

		p1:setState({
			inputCode = "",
			isConfirming = false,
			inputErrorKey = s6
		})
	end
	function p1.acceptInputCode(p7, p8) -- line: 224
		-- upvalues: p1 (copy)
		if p1.props.confirmDeviceCode then
			p1.props.confirmDeviceCode(p7, p8)
		end
	end
end
function v46.didMount(p9) -- line: 231
	-- upvalues: EventStreamConstants (copy), GetIXPLayerParameters (copy)
	if p9.props.code then
		local v60 = p9.props.code:gsub("[^%w]", ""):upper():sub(1, 6)

		p9.setInputText(v60)
		p9.latestSanitizedCode = v60
		p9:setState({
			inputCode = v60
		})
		p9.confirmButtonPressed()
	end

	p9.isMounted = true
	p9.props.authAnalytics.reportScreenLoaded(EventStreamConstants.Context.QuickLogin)
	GetIXPLayerParameters(p9.props.networking, "PlayerApp.CrossDeviceLogin.ConfirmCode", { "HintTextOverride" }):andThen(function(p10) -- line: 249
		-- upvalues: p9 (copy)
		local v96 = p10 and p10.responseBody

		if v96 and p9.isMounted then
			local HintTextOverride = v96.HintTextOverride
			local ShouldDisableSubmissionForBadCode = v96.ShouldDisableSubmissionForBadCode

			p9:setState({
				placeholderTextOverride = HintTextOverride or "",
				disableSubmissionForBadCode = ShouldDisableSubmissionForBadCode or false
			})
		end
	end, function() -- line: 259
	end)
end
function v46.willUnmount(p11) -- line: 264
	p11.isMounted = false
end
function v46.renderEnterCodeRefresh(p12, p13, p14, _) -- line: 268
	-- upvalues: withLocalization (copy), Text (copy), Players (copy), Roact (copy), View (copy), FoundationText (copy), TextInput (copy), InputSize (copy), Button (copy), ButtonType (copy)
	return withLocalization({
		refreshHeadline = "Authentication.CrossDevice.Heading.SigninAnotherDevice",
		refreshIntro = "Authentication.CrossDevice.Label.SigninInstructionHeading",
		refreshStep1 = "Authentication.CrossDevice.Label.SigninInstructionOne",
		refreshStep2 = "Authentication.CrossDevice.Label.SigninInstructionTwo",
		refreshStep3 = "Authentication.CrossDevice.Label.SigninInstructionThree",
		refreshSecurityFooter = "Authentication.CrossDevice.Label.QuickSignInWarning",
		refreshContinue = "Authentication.CrossDevice.Label.Continue",
		refreshPlaceholder = "Authentication.CrossDevice.Label.EnterCodeTextBox"
	})(function(p16) -- line: 278
		-- upvalues: p12 (copy), p13 (copy), Text (copy), Players (copy), Roact (copy), View (copy), FoundationText (copy), TextInput (copy), InputSize (copy), Button (copy), ButtonType (copy), p14 (copy)
		local inputCode = p12.state.inputCode
		local v101 = p12.state.inputErrorKey == ""
		local isConfirming = p12.state.isConfirming
		local designTokens = p12.props.designTokens
		local bodyFontFont = designTokens.LuaApps.CrossDeviceLogin.bodyFont.Font
		local bodyTextColorColor3 = designTokens.LuaApps.CrossDeviceLogin.bodyTextColor.Color3
		local headerTextColorTransparency = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Transparency
		local textAlertColorColor3 = designTokens.LuaApps.CrossDeviceLogin.textAlertColor.Color3
		local BaseSize = p13.Font.BaseSize
		local refreshContinue = p16.refreshContinue
		local v110 = p12.props.tokens.Padding.Medium * 2
		local v111 = Text.GetTextWidth(refreshContinue, bodyFontFont, BaseSize) + v110
		local refreshIntro = p16.refreshIntro
		local LocalPlayer = Players.LocalPlayer
		local s7

		if not LocalPlayer then
			s7 = "Player"
		else
			local DisplayName = LocalPlayer.DisplayName

			s7 = if not DisplayName or DisplayName == "" then LocalPlayer.Name else DisplayName
		end

		local v116 = refreshIntro:gsub("{username}", "<b>" .. s7:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>")
		local v117 = p12.state.placeholderTextOverride ~= "" and p12.state.placeholderTextOverride or p16.refreshPlaceholder
		local t1 = {
			Color3 = textAlertColorColor3,
			Transparency = headerTextColorTransparency
		}
		local t2 = {
			Color3 = bodyTextColorColor3,
			Transparency = headerTextColorTransparency
		}
		local Global = designTokens.Global
		local Size_1000 = p12.props.tokens.Size.Size_1000
		local Space_150 = Global.Space_150
		local v123 = p12.props.keyboardOffset or 0

		return Roact.createElement(View, {
			tag = "col align-x-left gap-xsmall size-full-0 auto-y",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = if not (v123 > 0) then nil else UDim2.new(0, 0, 0, -v123),
			padding = {
				left = UDim.new(0, 0),
				right = UDim.new(0, 0)
			}
		}, {
			CopyBlock = Roact.createElement(View, {
				tag = "col align-x-left gap-xsmall size-full-0 auto-y",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				padding = {
					bottom = UDim.new(0, Space_150)
				}
			}, {
				HeadlineWrap = Roact.createElement(View, {
					tag = "col size-full-0 auto-y",
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					padding = {
						bottom = UDim.new(0, Space_150)
					}
				}, {
					Headline = Roact.createElement(FoundationText, {
						tag = "size-full-0 auto-xy text-heading-small text-wrap text-align-x-left",
						LayoutOrder = 1,
						TextWrapped = true,
						Text = p16.refreshHeadline
					})
				}),
				Intro = Roact.createElement(FoundationText, {
					tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
					LayoutOrder = 2,
					RichText = true,
					TextWrapped = true,
					Text = v116
				}),
				StepsIndent = Roact.createElement(View, {
					tag = "col gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					padding = {
						left = UDim.new(0, 18)
					}
				}, {
					Step1 = Roact.createElement(FoundationText, {
						tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
						LayoutOrder = 1,
						TextWrapped = true,
						Text = p16.refreshStep1
					}),
					Step2 = Roact.createElement(FoundationText, {
						tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
						LayoutOrder = 2,
						TextWrapped = true,
						Text = p16.refreshStep2
					}),
					Step3 = Roact.createElement(FoundationText, {
						tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
						LayoutOrder = 3,
						TextWrapped = true,
						Text = p16.refreshStep3
					})
				})
			}),
			InputRow = Roact.createElement(View, {
				tag = "row items-stretch gap-small size-full-0 auto-y",
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				padding = {
					bottom = UDim.new(0, Space_150)
				}
			}, {
				InputWrap = Roact.createElement(View, {
					tag = "grow auto-y",
					LayoutOrder = 1,
					BackgroundTransparency = 1
				}, {
					CodeField = Roact.createElement(TextInput, {
						LayoutOrder = 1,
						label = "",
						text = p12.inputText,
						onChanged = p12.onRefreshCodeChanged,
						placeholder = v117,
						width = UDim.new(1, 0),
						hasError = not v101,
						size = InputSize.Medium,
						ref = p12.props.codeFieldRef,
						onFocusGained = p12.onFocus,
						onFocusLost = function() -- line: 409
							-- upvalues: p12 (copy)
							p12:setState({
								isFocused = false
							})
						end,
						onReturnPressed = function() -- line: 414
							-- upvalues: p12 (copy)
							if #p12.state.inputCode == 6 then
								p12.confirmButtonPressed()
							end
						end
					})
				}),
				ContinueButtonWrap = Roact.createElement(View, {
					tag = "col",
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, v111, 0, Size_1000)
				}, {
					ContinueButton = Roact.createElement(Button, {
						buttonType = ButtonType.PrimarySystem,
						size = UDim2.new(1, 0, 1, 0),
						text = refreshContinue,
						isDisabled = p12.state.disableSubmissionForBadCode and #inputCode < 6 or inputCode == "",
						isLoading = isConfirming,
						onActivated = p12.confirmButtonPressed,
						[Roact.Ref] = p12.props.continueButtonRef
					})
				})
			}),
			InputError = not v101 and Roact.createElement(View, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				padding = {
					bottom = UDim.new(0, Space_150)
				}
			}, {
				ErrorText = Roact.createElement(FoundationText, {
					tag = "size-full-0 auto-xy text-body-small text-wrap text-align-x-left",
					LayoutOrder = 1,
					TextWrapped = true,
					Text = p14.inputError,
					textStyle = t1
				})
			}) or nil,
			SecurityFooter = Roact.createElement(FoundationText, {
				tag = "size-full-0 auto-xy text-body-small text-wrap text-align-x-left",
				LayoutOrder = 6,
				TextWrapped = true,
				Text = p16.refreshSecurityFooter,
				textStyle = t2
			})
		})
	end)
end
function v46.render(p17) -- line: 466
	-- upvalues: withStyle (copy), withLocalization (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), Roact (copy), CrossDeviceTabletLayout (copy), CrossDevicePhoneLayout (copy), GetFFlagEnableAuthsecImageUpdate (copy), FoundationImage (copy), ImageSetLabel (copy), v42 (copy), FitChildren (copy), FitTextLabel (copy), TextInputBoxWithBorder (copy), AuthStatefulRoundCornerBorder (copy), Button (copy), ButtonType (copy), Text (copy)
	local isWideView = p17.props.isWideView
	local inputCode = p17.state.inputCode
	local v69 = p17.state.inputErrorKey == ""
	local isConfirming = p17.state.isConfirming
	local isFocused = p17.state.isFocused

	return withStyle(function(p18) -- line: 474
		-- upvalues: withLocalization (copy), v69 (copy), p17 (copy), isWideView (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), Roact (copy), CrossDeviceTabletLayout (copy), CrossDevicePhoneLayout (copy), GetFFlagEnableAuthsecImageUpdate (copy), FoundationImage (copy), ImageSetLabel (copy), v42 (copy), FitChildren (copy), FitTextLabel (copy), TextInputBoxWithBorder (copy), AuthStatefulRoundCornerBorder (copy), isFocused (copy), Button (copy), ButtonType (copy), isConfirming (copy), inputCode (copy), Text (copy)
		return withLocalization({
			tabletHeader = "Authentication.CrossDevice.Heading.LoginAnotherDevice",
			warningHeader = "Authentication.CrossDevice.Heading.LoginWarning",
			warning1 = "Authentication.CrossDevice.Label.Warning1",
			warning2 = "Authentication.CrossDevice.Label.Warning2",
			placeholderText = "Authentication.CrossDevice.Label.EnterOtherDeviceCode",
			enter = "Authentication.CrossDevice.Action.Enter",
			inputError = not v69 and p17.state.inputErrorKey or nil
		})(function(p19) -- line: 483
			-- upvalues: p17 (copy), isWideView (copy), p18 (copy), GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), Roact (copy), CrossDeviceTabletLayout (copy), CrossDevicePhoneLayout (copy), GetFFlagEnableAuthsecImageUpdate (copy), FoundationImage (copy), ImageSetLabel (copy), v42 (copy), FitChildren (copy), FitTextLabel (copy), TextInputBoxWithBorder (copy), v69 (copy), AuthStatefulRoundCornerBorder (copy), isFocused (copy), Button (copy), ButtonType (copy), isConfirming (copy), inputCode (copy), Text (copy)
			local designTokens = p17.props.designTokens
			local v132 = isWideView and p17.props.tokens.Size.Size_2000 * 2 or p17.props.tokens.Size.Size_2000 * 4
			local v133 = isWideView and p17.props.tokens.Size.Size_2200 or p17.props.tokens.Size.Size_2200 * 2
			local v134 = not isWideView and p17.props.tokens.Size.Size_350 or 0
			local uDim2 = UDim2.fromOffset(designTokens.LuaApps.CrossDeviceLogin.iconSize, designTokens.LuaApps.CrossDeviceLogin.iconSize)
			local headerFontFont = designTokens.LuaApps.CrossDeviceLogin.headerFont.Font
			local FontSize = designTokens.LuaApps.CrossDeviceLogin.headerFont.FontSize
			local headerTextColorColor3 = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Color3
			local headerPadding = designTokens.LuaApps.CrossDeviceLogin.headerPadding
			local bodyFontFont = designTokens.LuaApps.CrossDeviceLogin.bodyFont.Font
			local FontSize2 = designTokens.LuaApps.CrossDeviceLogin.bodyFont.FontSize
			local bodyTextColorColor3 = designTokens.LuaApps.CrossDeviceLogin.bodyTextColor.Color3
			local headerTextColorTransparency = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Transparency
			local textAlertFontFont = designTokens.LuaApps.CrossDeviceLogin.textAlertFont.Font
			local FontSize3 = designTokens.LuaApps.CrossDeviceLogin.textAlertFont.FontSize
			local textAlertColorColor3 = designTokens.LuaApps.CrossDeviceLogin.textAlertColor.Color3
			local BaseSize = p18.Font.BaseSize
			local v148 = p17.state.placeholderTextOverride ~= "" and p17.state.placeholderTextOverride or p19.placeholderText

			if GetFFlagEnableCrossDeviceEnterCodeRefresh() then
				return p17:renderEnterCodeRefresh(p18, p19, isWideView)
			end

			return Roact.createElement(isWideView and CrossDeviceTabletLayout or CrossDevicePhoneLayout, {
				TabletHeaderText = p19.tabletHeader,
				Style = p18,
				HighKeyboardMode = p17.props.highKeyboardMode,
				Icon = GetFFlagEnableAuthsecImageUpdate() and Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = isWideView and uDim2 or UDim2.new(0, v132, 0, v133 - v134)
				}, {
					Image = Roact.createElement(FoundationImage, {
						Image = p17.getVerifyCodeImage(p17.props.tokens.Config.ColorMode.Name),
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.new(0, v132, 0, v133),
						Position = UDim2.new(0.5, 0, 0.5, -v134 / 2),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}) or Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ImageTransparency = 0,
					Size = uDim2,
					ScaleType = Enum.ScaleType.Fit,
					Image = v42,
					ImageColor3 = p18.Theme.UIEmphasis.Color
				}),
				WarningText = Roact.createElement(FitChildren.FitFrame, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -20, 0, 0),
					fitAxis = FitChildren.FitAxis.Height
				}, {
					Align = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 6),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					TopWarning = Roact.createElement(FitTextLabel, {
						LayoutOrder = 1,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p19.warningHeader,
						Font = headerFontFont,
						TextSize = FontSize,
						TextColor3 = headerTextColorColor3,
						TextTransparency = headerTextColorTransparency,
						TextXAlignment = isWideView and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						fitAxis = FitChildren.FitAxis.Height
					}),
					Padding = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, headerPadding)
					}),
					BulletPoint1 = Roact.createElement(FitTextLabel, {
						LayoutOrder = 3,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p19.warning1,
						Font = bodyFontFont,
						TextSize = FontSize2,
						TextColor3 = bodyTextColorColor3,
						TextTransparency = headerTextColorTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						fitAxis = FitChildren.FitAxis.Height
					}),
					BulletPoint2 = Roact.createElement(FitTextLabel, {
						LayoutOrder = 4,
						TextWrapped = true,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p19.warning2,
						Font = bodyFontFont,
						TextSize = FontSize2,
						TextColor3 = bodyTextColorColor3,
						TextTransparency = headerTextColorTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						fitAxis = FitChildren.FitAxis.Height
					})
				}),
				InputBox = Roact.createElement(TextInputBoxWithBorder, {
					layoutOrder = 3,
					placeholderText = v148,
					borderState = not v69 and AuthStatefulRoundCornerBorder.BorderState.Error or (isFocused and AuthStatefulRoundCornerBorder.BorderState.Focused or AuthStatefulRoundCornerBorder.BorderState.Default),
					text = p17.inputText,
					onFocused = p17.onFocus,
					onFocusLost = p17.onFocusLost,
					onChangeTextCallback = p17.onTextChanged
				}),
				InputWarning = not v69 and Roact.createElement(FitTextLabel, {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, -6, 0, FontSize3),
					Position = UDim2.new(0, 3, 1, 3),
					Font = textAlertFontFont,
					TextSize = FontSize3,
					TextColor3 = textAlertColorColor3,
					TextTransparency = headerTextColorTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = p19.inputError,
					fitAxis = FitChildren.FitAxis.Height
				}),
				ConfirmCodeButton = Roact.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					size = UDim2.new(1, 0, 1, 0),
					text = p19.enter,
					[Roact.Ref] = p17.props.continueButtonRef,
					onActivated = p17.confirmButtonPressed,
					isLoading = isConfirming,
					isDisabled = p17.state.disableSubmissionForBadCode and #inputCode < 6 or inputCode == ""
				}),
				ConfirmCodeButtonWidth = Text.GetTextWidth(p19.enter, bodyFontFont, BaseSize) + 40
			})
		end)
	end)
end

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local v49 = RoactAppExperiment.connectUserLayer({
	AppUserLayers.ExposureLayer,
	AppUserLayers.AccessLayer
}, function(_, _) -- line: 646
	return {}
end)(v46)
local v50 = RoactServices.connect({
	networking = RoactNetworking,
	authAnalytics = RoactAnalyticsAuthEvents
})(v49)
local v51 = RoactRodux.connect(function(p22, _) -- line: 655
	return {
		screenSize = p22.ScreenSize
	}
end, function(p24) -- line: 659
	-- upvalues: CrossDeviceLogin (copy)
	return {
		validateCode = function(p25, p26) -- line: 661
			-- upvalues: p24 (copy), CrossDeviceLogin (copy)
			return p24(CrossDeviceLogin.EnterCode(p25, p26))
		end
	}
end)(v50)

return function(p27) -- line: 668
	-- upvalues: useDesignTokens (copy), useTokens (copy), React (copy), v51 (copy), Cryo (copy)
	local v78 = useDesignTokens()
	local v79 = useTokens()

	return React.createElement(v51, Cryo.Dictionary.join(p27, {
		designTokens = v78,
		tokens = v79
	}))
end
