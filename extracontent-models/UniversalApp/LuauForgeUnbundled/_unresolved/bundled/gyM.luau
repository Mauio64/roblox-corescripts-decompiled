local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local module2 = require("@luauforge/bundled/dzP")

local defineFastFlag = game:DefineFastFlag("ShouldEnableAuthBirthdayBarUpdates", false)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module3 = require("@luauforge/bundled/egZ")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel
local module5 = require("@luauforge/bundled/egM")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local birthdayDropdown = require("@luauforge/bundled/grL").Components.BirthdayDropdown
local signUpBirthdayField = require("@luauforge/bundled/grL").Components.SignUpBirthdayField

local resolveBirthdaySelectVariant = require("@luauforge/bundled/grL").Util.resolveBirthdaySelectVariant
local birthdaySheet = require("@luauforge/bundled/gvU").Components.BirthdaySheet
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local registerAuditContent = AuthCommon.Components.RegisterAuditContent

local v5 = if defineFastFlag then require("@luauforge/bundled/geM").DateHelper else require("@luauforge/bundled/gyN")

local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local module7 = require("@luauforge/bundled/fzS")
local module8 = require("@luauforge/bundled/grb")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module9 = require("@luauforge/bundled/gyO")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fIntSignupMinimumAge = SharedFlags.FIntSignupMinimumAge
local getFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local getFFlagAuthBirthdayBarFoundationColors = SharedFlags.GetFFlagAuthBirthdayBarFoundationColors
local getFFlagEnableBirthdayOverlayAnalytics = SharedFlags.GetFFlagEnableBirthdayOverlayAnalytics
local getFFlagSignUpBirthdayPickerShowAgeCalculator = SharedFlags.GetFFlagSignUpBirthdayPickerShowAgeCalculator

local getFIntSignUpBirthdayPickerManualSelectVariantOverride = SharedFlags.GetFIntSignUpBirthdayPickerManualSelectVariantOverride
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local iconsactionscalendar = images["icons/actions/calendar"]

local extended = Roact.PureComponent:extend("AuthBirthdayBar")

function extended:init()
	self.state = {
		isFocused = false,
		isHovering = false,
		selectedBirthday = nil,
		age = nil,
		isBirthdaySheetOpen = false
	}

	self.isMounted = false
	self.showBirthdayDropdown = self.props.preferredInput == Responsive.Input.Directional

	function self.updateState(p2)
		spawn(function()
			if self.isMounted then
				self:setState(p2)
			end
		end)
	end
	function self.onBirthdayPickerClose(selectedBirthday)
		local v6 = { isFocused = false }

		if selectedBirthday ~= nil then
			module2.assert(
				birthday.is(selectedBirthday),
				"CentralOverlayForSignUpBirthdayPicker should pass back a Birthday when closing."
			)

			local onBirthdaySelected = self.props.onBirthdaySelected

			if onBirthdaySelected then
				self.props.analytics.reportButtonClicked(
					module7.Context.SinglePageSignUpScreen,
					module7.Button.ConfirmBirthday
				)

				onBirthdaySelected(selectedBirthday)
			end

			v6.selectedBirthday = selectedBirthday

			if
				defineFastFlag
				and selectedBirthday.Day ~= nil
				and selectedBirthday.Month ~= nil
				and selectedBirthday.Year ~= nil
			then
				local ageInYears = selectedBirthday:GetAgeInYears()
				v6.age = ageInYears

				if
					ageInYears ~= nil
					and self.props.shouldUseBirthdayAgeLabel
					and not self.props.hideAgeInLabel
				then
					self.props.analytics.reportAuthFormInteraction(
						module7.Context.SignupForm,
						module7.Field.BirthdayAgeLabel,
						(tostring(ageInYears))
					)
				end
			end
		end

		if self.props.onBirthdayFocused then
			self.props.onBirthdayFocused(false)
		end

		self.updateState(v6)
	end

	function self.onBirthdaySelected(p2, p3, p4)
		module2.assert(birthday.is(p2), "BirthdayDropdown should pass a Birthday.")

		local onBirthdaySelected = self.props.onBirthdaySelected

		if onBirthdaySelected then
			onBirthdaySelected(p2, p4)
		end

		self.updateState({ selectedBirthday = p2, age = p3 })
	end

	function self.reportBirthdayPicker(p2)
		if getFFlagEnableBirthdayOverlayAnalytics() then
			self.props.analytics.reportAuthFormInteraction(
				module7.Context.SinglePageSignUpScreen,
				module7.Field.BirthdayPicker,
				p2
			)
		end
	end

	function self.onBirthdaySheetClosed()
		self.reportBirthdayPicker(module7.State.BirthdayPickerClosedWithoutConfirm)
		self:setState({ isBirthdaySheetOpen = false })

		if self.navigatesBackWithoutSelection then
			self.props.navigateBack()
		else
			self.onBirthdayPickerClose(nil)
		end
	end

	function self.onBirthdaySheetConfirmed(p2)
		self:setState({ isBirthdaySheetOpen = false })

		self.onBirthdayPickerClose(p2)
	end

	function self.onBirthdaySheetAllPicked()
		self.reportBirthdayPicker(module7.State.BirthdayPickerAllPicked)
	end

	function self.onAgeSummaryShown(p2)
		if getFFlagEnableBirthdayOverlayAnalytics() then
			self.props.analytics.reportAuthFormInteraction(
				module7.Context.SinglePageSignUpScreen,
				module7.Field.BirthdayPickerAgeCalculatorShown,
				(tostring(p2))
			)
		end
	end

	function self.onActivated()
		self.props.analytics.reportFocus(module7.Context.SinglePageSignUpScreen, module7.Field.Birthday)

		if self.props.useFoundationField then
			self.reportBirthdayPicker(module7.State.BirthdayPickerOpened)
			self.navigatesBackWithoutSelection = self.props.autoFocusOnMount
				and not self.state.selectedBirthday
			self:setState({ isBirthdaySheetOpen = true })
		else
			self.props.openCentralOverlayForSignUpBirthdayPicker({
				initialBirthday = self.state.selectedBirthday,
				onClose = self.onBirthdayPickerClose,
				navigateBackWithoutSelection = self.props.autoFocusOnMount and not self.state.selectedBirthday,
				forceDarkTheme = self.props.forceDarkTheme
			})
		end

		if self.props.onBirthdayFocused then
			self.props.onBirthdayFocused(true)
		end

		spawn(function()
			if self.isMounted then
				self:setState({ isFocused = true })
			end
		end)
	end

	function self.onMouseEnter()
		if self.isMounted then
			self:setState({ isHovering = true })
		end
	end

	function self.onMouseLeave()
		if self.isMounted then
			self:setState({ isHovering = false })
		end
	end
end

function extended:didMount()
	self.isMounted = true

	if self.showBirthdayDropdown then
		return
	end

	if self.props.autoFocusOnMount then
		spawn(self.onActivated)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(data)
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local layoutOrder = data.props.layoutOrder

	local isFocused = data.state.isFocused
	local isHovering = data.state.isHovering
	local selectedBirthday = data.state.selectedBirthday
	local buttonRef = data.props.buttonRef
	local birthdayContainerRef = data.props.birthdayContainerRef

	local v6 = if selectedBirthday then v5.MonthsLocalizationKeys[selectedBirthday.Month] or nil else nil
	local v7 = not defineFastFlag and "" or tostring(data.state.age or 0)

	return withStyle(function(data2)
		local foundationTokens, v8

		if getFFlagAuthBirthdayBarFoundationColors() then
			foundationTokens = data.props.foundationTokens
			v8 = data.props.shouldUseFoundationBirthdayBarColors

			if v8 then
				v8 = not (foundationTokens == nil) and foundationTokens.Config ~= nil
			end
		else
			v8 = false
			foundationTokens = nil
		end

		return module3({
			monthText = v6,
			dayAffix = v5.DayAffixLocalizationKey,
			yearAffix = v5.YearAffixLocalizationKey,
			titleText = "Authentication.SignUp.Label.Birthday",
			datePlaceholder = "CommonUI.Controls.Birthdaypicker.Label.Date",
			birthdayHint = data.props.useFoundationField and "Authentication.SignUp.Description.BirthdayHint" or nil,
			titleTextWithAge = defineFastFlag and {
				"Authentication.SignUp.Label.BirthdayWithAge",
				yearsOld = v7
			} or nil,
			titleTextWithAgeTemplate = getFFlagEnableAuditForSinglePageSignUp() and "Authentication.SignUp.Label.BirthdayWithAge" or nil
		})(function(props)
			local v9 = props.datePlaceholder

			local v10 = if v8 then foundationTokens.Color.Content.Muted.Color3 else data2.Theme.TextDefault.Color
			local transparency

			if v8 then
				transparency = foundationTokens.Color.Content.Muted.Transparency
			else
				transparency = data2.Theme.TextDefault.Transparency
			end

			local v11 = if v8 then foundationTokens.Color.Content.Muted.Color3 else data2.Theme.IconDefault.Color
			local transparency2

			if v8 then
				transparency2 = foundationTokens.Color.Content.Muted.Transparency
			else
				transparency2 = data2.Theme.IconDefault.Transparency
			end

			local v12 = props.titleText

			local v13 = props.titleText
			local v14, v15

			if
				defineFastFlag
				and data.state.age ~= nil
				and data.props.shouldUseBirthdayAgeLabel
				and not data.props.hideAgeInLabel
			then
				v12 = props.titleTextWithAge

				v14 = { yearsOld = v7 }
				v13 = props.titleTextWithAgeTemplate
				v15 = "Authentication.SignUp.Label.BirthdayWithAge"
			else
				v15 = "Authentication.SignUp.Label.Birthday"
			end

			local v16 = authStatefulRoundCornerBorder.BorderState.Default

			if selectedBirthday then
				v9 = v5:GetFormattedFullString(
					props.monthText,
					selectedBirthday.Day,
					props.dayAffix,
					selectedBirthday.Year,
					props.yearAffix,
					" ",
					robloxLocaleId
				)

				if v8 then
					v10 = foundationTokens.Color.Content.Emphasis.Color3
				else
					v10 = data2.Theme.TextDefault.Color
				end

				if v8 then
					transparency = foundationTokens.Color.Content.Emphasis.Transparency
				else
					transparency = data2.Theme.TextDefault.Transparency
				end
			end

			if isFocused then
				if v8 then
					v11 = foundationTokens.Color.Content.Emphasis.Color3
				else
					v11 = data2.Theme.TextDefault.Color
				end

				if v8 then
					transparency2 = foundationTokens.Color.Content.Emphasis.Transparency
				else
					transparency2 = data2.Theme.TextDefault.Transparency
				end

				v16 = authStatefulRoundCornerBorder.BorderState.Focused
			elseif isHovering then
				v11 = if v8 then foundationTokens.Color.Content.Muted.Color3 else data2.Theme.IconDefault.Color

				if v8 then
					transparency2 = foundationTokens.Color.Content.Muted.Transparency
				else
					transparency2 = data2.Theme.IconDefault.Transparency
				end

				v16 = authStatefulRoundCornerBorder.BorderState.Hover
			end

			local v17, color3, transparency3

			if v8 then
				v17 = foundationTokens.Size.Size_1200

				if v16 == authStatefulRoundCornerBorder.BorderState.Focused then
					color3 = foundationTokens.Color.System.Emphasis.Color3
					transparency3 = foundationTokens.Color.System.Emphasis.Transparency
				else
					color3 = foundationTokens.Color.Stroke.Emphasis.Color3
					transparency3 = foundationTokens.Color.Stroke.Emphasis.Transparency
				end
			else
				v17 = 36
			end

			local v18

			if
				getFFlagEnableAuditForSinglePageSignUp()
				and registerAuditContent
				and data.props.enableAuditContentCapture
			then
				v18 = Roact.createElement(registerAuditContent, {
					translationKey = v15,
					translatedSourceString = v13,
					parameters = v14
				})
			end

			if data.props.useFoundationField and not data.showBirthdayDropdown then
				local createFragment = Roact.createFragment
				local createElement = Roact.createElement
				local v20 = {
					LayoutOrder = layoutOrder,
					label = v12,
					isLabelBold = data.props.boldFoundationLabel,
					placeholder = props.birthdayHint,
					text = 0,
					isFocused = 0,
					onActivated = 0,
					buttonRef = 0,
					containerRef = 0
				}

				if not selectedBirthday then
					v9 = nil
				end

				v20.text = v9
				v20.isFocused = isFocused
				v20.onActivated = data.onActivated
				v20.buttonRef = buttonRef
				v20.containerRef = birthdayContainerRef
				return createFragment({
					BirthdayField = createElement(signUpBirthdayField, v20),
					BirthdaySheet = Roact.createElement(birthdaySheet, {
						isOpen = data.state.isBirthdaySheetOpen,
						birthday = selectedBirthday,
						onClose = data.onBirthdaySheetClosed,
						onConfirm = data.onBirthdaySheetConfirmed,
						showsAgeSummary = resolveBirthdaySelectVariant(
							getFFlagSignUpBirthdayPickerShowAgeCalculator(),
							getFIntSignUpBirthdayPickerManualSelectVariantOverride(),
							data.props.birthdayManualSelectVariant,
							2
						),
						isCentered = data.props.formFactor == formFactor.WIDE,
						onAllPicked = data.onBirthdaySheetAllPicked,
						onAgeSummaryShown = data.onAgeSummaryShown
					}),
					RegisterAuditContent = v18
				})
			else
				local createElement = Roact.createElement
				local fitFrame = FitChildren.FitFrame
				local birthdayContainerRefsByRef = {
					LayoutOrder = layoutOrder,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					[Roact.Ref] = birthdayContainerRef
				}
				local v19 = {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 5)
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 5),
						PaddingBottom = UDim.new(0, 5)
					}),
					Title = Roact.createElement(fitTextLabel, {
						LayoutOrder = 0,
						Size = UDim2.new(1, 0, 0, 0),
						width = UDim.new(1, 0),
						BackgroundTransparency = 1,
						Text = v12,
						TextWrapped = true,
						Font = normalizeFontFace(data2.Tokens.Typography.CaptionLarge.Font),
						TextSize = data2.Font.BaseSize * data2.Font.CaptionHeader.RelativeSize,
						TextColor3 = data2.Theme.TextEmphasis.Color,
						TextTransparency = data2.Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					RegisterAuditContent = v18,
					BirthdayDropdown = data.showBirthdayDropdown and Roact.createElement(birthdayDropdown, {
						localeId = robloxLocaleId,
						layoutOrder = 1,
						onBirthdaySelected = data.onBirthdaySelected,
						onDropdownOpened = data.props.onBirthdayFocused,
						focusOnMount = true,
						minAgeAllowed = fIntSignupMinimumAge,
						analyticsEventContext = module7.Context.SinglePageSignUpScreen
					}),
					TextInput = 0
				}

				local v20 = not data.showBirthdayDropdown

				if v20 then
					local createElement2 = Roact.createElement
					local v22 = {
						layoutOrder = 1,
						size = UDim2.new(1, 0, 0, v17),
						borderState = v16,
						borderColorOverride = color3,
						borderTransparencyOverride = transparency3
					}

					local createElement3 = Roact.createElement
					local v25 = {
						["Size"] = nil,
						["Size"] = nil,
						["Size"] = nil,
						["Size"] = nil,
						["Size"] = nil,
						["Size"] = nil,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "LuaApp/buttons/buttonFill"
					}

					local v26 = if v8 then foundationTokens.Color.Shift.Shift_100.Color3 else data2.Theme.BackgroundUIContrast.Color
					v25.ImageColor3 = v26

					local v27 = if v8 then foundationTokens.Color.Shift.Shift_100.Transparency else data2.Theme.BackgroundUIContrast.Transparency
					v25.ImageTransparency = v27

					v25.BorderSizePixel = 0
					v25.ScaleType = Enum.ScaleType.Slice
					v25.SliceCenter = Rect.new(8, 8, 9, 9)
					v25[Roact.Ref] = buttonRef
					v25[Roact.Event.Activated] = data.onActivated
					v25[Roact.Event.MouseEnter] = data.onMouseEnter
					v25[Roact.Event.MouseLeave] = data.onMouseLeave
					v20 = createElement2(authStatefulRoundCornerBorder, v22, {
						Base = createElement3(module5, v25, {
							UIPadding = Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 0),
								PaddingBottom = UDim.new(0, 0),
								PaddingLeft = UDim.new(0, 12),
								PaddingRight = UDim.new(0, 12)
							}),
							TextLabel = Roact.createElement("TextLabel", {
								Size = UDim2.new(1, -16, 1, 0),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								BackgroundTransparency = 1,
								Text = v9,
								FontFace = normalizeFontFace(data2.Tokens.Typography.BodyLarge.Font),
								TextSize = data2.Font.BaseSize * data2.Font.Body.RelativeSize,
								TextColor3 = v10,
								TextTransparency = transparency
							}),
							ImageLabel = Roact.createElement(imageSetLabel, {
								Size = UDim2.new(0, 16, 0, 16),
								Position = UDim2.new(1, 0, 0.5, 0),
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundTransparency = 1,
								Image = iconsactionscalendar,
								ImageColor3 = v11,
								ImageTransparency = transparency2
							})
						})
					})
				end

				v19.TextInput = v20
				return createElement(fitFrame, birthdayContainerRefsByRef, v19)
			end
		end)
	end)
end

local v6 = roactServices.connect({ analytics = module8 })(extended)

local v7 = RoactRodux.connect(function(p2)
	return { formFactor = p2.FormFactor }
end, function(callback)
	return {
		openCentralOverlayForSignUpBirthdayPicker = function(p2)
			callback(module9(p2))
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end
	}
end)(v6)

if getFFlagSignUpBirthdayPickerShowAgeCalculator() then
	v7 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.SignupLayer }, function(p2)
		return {
			birthdayManualSelectVariant = (p2[appBtidLayers.SignupLayer] or {}).birthdayManualSelectVariant
		}
	end)(v7)
end

if defineFastFlag then
	v7 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.SignupLayer }, function(p2, p3)
		return {
			shouldUseBirthdayAgeLabel = (p2[appBtidLayers.SignupLayer] or {}).shouldUseBirthdayAgeLabel
		}
	end)(v7)
end

if getFFlagAuthBirthdayBarFoundationColors() then
	v7 = RoactAppExperiment.connectBrowserTrackerLayer(
		{ appBtidLayers.AuthenticationStylingLayer },
		function(p2, p3)
			return {
				shouldUseFoundationBirthdayBarColors = (p2[appBtidLayers.AuthenticationStylingLayer] or {}).shouldUseFoundationBirthdayBarColors
			}
		end
	)(v7)
end

return getFFlagAuthBirthdayBarFoundationColors() and function(options)
	local v8 = useTokens()

	return React.createElement(v7, Cryo.Dictionary.join(options or {}, {
		foundationTokens = v8
	}))
end or v7
