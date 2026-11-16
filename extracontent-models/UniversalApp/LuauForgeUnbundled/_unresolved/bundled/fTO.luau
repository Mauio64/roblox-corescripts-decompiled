local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local module2 = require("@luauforge/bundled/dwM")

local defineFastFlag = game:DefineFastFlag("ShouldEnableAuthBirthdayBarUpdates", false)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module3 = require("@luauforge/bundled/edC")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dMA").AppBtidLayers
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local module5 = require("@luauforge/bundled/edp")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local birthdayDropdown = require("@luauforge/bundled/fNq").Components.BirthdayDropdown
local signUpBirthdayField = require("@luauforge/bundled/fNq").Components.SignUpBirthdayField

local resolveBirthdaySelectVariant = require("@luauforge/bundled/fNq").Util.resolveBirthdaySelectVariant
local birthdaySheet = require("@luauforge/bundled/fRq").Components.BirthdaySheet
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local registerAuditContent = AuthCommon.Components.RegisterAuditContent

local v6 = if defineFastFlag then require("@luauforge/bundled/fAu").DateHelper else require("@luauforge/bundled/fTP")

local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local module7 = require("@luauforge/bundled/fsy")
local module8 = require("@luauforge/bundled/fMG")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module9 = require("@luauforge/bundled/fTQ")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fIntSignupMinimumAge = SharedFlags.FIntSignupMinimumAge
local getFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local getFFlagAuthBirthdayBarFoundationColors = SharedFlags.GetFFlagAuthBirthdayBarFoundationColors
local getFFlagEnableBirthdayOverlayAnalytics = SharedFlags.GetFFlagEnableBirthdayOverlayAnalytics
local getFFlagSignUpBirthdayPickerShowAgeCalculator = SharedFlags.GetFFlagSignUpBirthdayPickerShowAgeCalculator

local getFIntSignUpBirthdayPickerManualSelectVariantOverride = SharedFlags.GetFIntSignUpBirthdayPickerManualSelectVariantOverride
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

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
		local v7 = { isFocused = false }

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

			v7.selectedBirthday = selectedBirthday

			if
				defineFastFlag
				and selectedBirthday.Day ~= nil
				and selectedBirthday.Month ~= nil
				and selectedBirthday.Year ~= nil
			then
				local ageInYears = selectedBirthday:GetAgeInYears()
				v7.age = ageInYears

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

		self.updateState(v7)
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

	local v7 = if selectedBirthday then v6.MonthsLocalizationKeys[selectedBirthday.Month] or nil else nil
	local v8 = not defineFastFlag and "" or tostring(data.state.age or 0)

	return withStyle(function(data2)
		local foundationTokens, v9

		if getFFlagAuthBirthdayBarFoundationColors() then
			foundationTokens = data.props.foundationTokens
			v9 = data.props.shouldUseFoundationBirthdayBarColors

			if v9 then
				v9 = not (foundationTokens == nil) and foundationTokens.Config ~= nil
			end
		else
			v9 = false
			foundationTokens = nil
		end

		return module3({
			monthText = v7,
			dayAffix = v6.DayAffixLocalizationKey,
			yearAffix = v6.YearAffixLocalizationKey,
			titleText = "Authentication.SignUp.Label.Birthday",
			datePlaceholder = "CommonUI.Controls.Birthdaypicker.Label.Date",
			birthdayHint = data.props.useFoundationField and "Authentication.SignUp.Description.BirthdayHint" or nil,
			titleTextWithAge = defineFastFlag and {
				"Authentication.SignUp.Label.BirthdayWithAge",
				yearsOld = v8
			} or nil,
			titleTextWithAgeTemplate = getFFlagEnableAuditForSinglePageSignUp() and "Authentication.SignUp.Label.BirthdayWithAge" or nil
		})(function(props)
			local v10 = props.datePlaceholder

			local v11 = if v9 then foundationTokens.Color.Content.Muted.Color3 else data2.Theme.TextDefault.Color
			local transparency

			if v9 then
				transparency = foundationTokens.Color.Content.Muted.Transparency
			else
				transparency = data2.Theme.TextDefault.Transparency
			end

			local v12 = if v9 then foundationTokens.Color.Content.Muted.Color3 else data2.Theme.IconDefault.Color
			local transparency2

			if v9 then
				transparency2 = foundationTokens.Color.Content.Muted.Transparency
			else
				transparency2 = data2.Theme.IconDefault.Transparency
			end

			local v13 = props.titleText

			local v14 = props.titleText
			local v15, v16

			if
				defineFastFlag
				and data.state.age ~= nil
				and data.props.shouldUseBirthdayAgeLabel
				and not data.props.hideAgeInLabel
			then
				v13 = props.titleTextWithAge

				v15 = { yearsOld = v8 }
				v14 = props.titleTextWithAgeTemplate
				v16 = "Authentication.SignUp.Label.BirthdayWithAge"
			else
				v16 = "Authentication.SignUp.Label.Birthday"
			end

			local v17 = authStatefulRoundCornerBorder.BorderState.Default

			if selectedBirthday then
				v10 = v6:GetFormattedFullString(
					props.monthText,
					selectedBirthday.Day,
					props.dayAffix,
					selectedBirthday.Year,
					props.yearAffix,
					" ",
					robloxLocaleId
				)

				if v9 then
					v11 = foundationTokens.Color.Content.Emphasis.Color3
				else
					v11 = data2.Theme.TextDefault.Color
				end

				if v9 then
					transparency = foundationTokens.Color.Content.Emphasis.Transparency
				else
					transparency = data2.Theme.TextDefault.Transparency
				end
			end

			if isFocused then
				if v9 then
					v12 = foundationTokens.Color.Content.Emphasis.Color3
				else
					v12 = data2.Theme.TextDefault.Color
				end

				if v9 then
					transparency2 = foundationTokens.Color.Content.Emphasis.Transparency
				else
					transparency2 = data2.Theme.TextDefault.Transparency
				end

				v17 = authStatefulRoundCornerBorder.BorderState.Focused
			elseif isHovering then
				v12 = if v9 then foundationTokens.Color.Content.Muted.Color3 else data2.Theme.IconDefault.Color

				if v9 then
					transparency2 = foundationTokens.Color.Content.Muted.Transparency
				else
					transparency2 = data2.Theme.IconDefault.Transparency
				end

				v17 = authStatefulRoundCornerBorder.BorderState.Hover
			end

			local v18, color3, transparency3

			if v9 then
				v18 = foundationTokens.Size.Size_1200

				if v17 == authStatefulRoundCornerBorder.BorderState.Focused then
					color3 = foundationTokens.Color.System.Emphasis.Color3
					transparency3 = foundationTokens.Color.System.Emphasis.Transparency
				else
					color3 = foundationTokens.Color.Stroke.Emphasis.Color3
					transparency3 = foundationTokens.Color.Stroke.Emphasis.Transparency
				end
			else
				v18 = 36
			end

			local v19

			if
				getFFlagEnableAuditForSinglePageSignUp()
				and registerAuditContent
				and data.props.enableAuditContentCapture
			then
				v19 = Roact.createElement(registerAuditContent, {
					translationKey = v16,
					translatedSourceString = v14,
					parameters = v15
				})
			end

			if data.props.useFoundationField and not data.showBirthdayDropdown then
				local createFragment = Roact.createFragment
				local createElement = Roact.createElement
				local v21 = {
					LayoutOrder = layoutOrder,
					label = v13,
					isLabelBold = data.props.boldFoundationLabel,
					placeholder = props.birthdayHint,
					text = 0,
					isFocused = 0,
					onActivated = 0,
					buttonRef = 0,
					containerRef = 0
				}

				if not selectedBirthday then
					v10 = nil
				end

				v21.text = v10
				v21.isFocused = isFocused
				v21.onActivated = data.onActivated
				v21.buttonRef = buttonRef
				v21.containerRef = birthdayContainerRef
				return createFragment({
					BirthdayField = createElement(signUpBirthdayField, v21),
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
					RegisterAuditContent = v19
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
				local v20 = {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 5)
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 5),
						PaddingBottom = UDim.new(0, 5)
					}),
					Title = 0,
					RegisterAuditContent = 0,
					BirthdayDropdown = 0,
					TextInput = 0
				}

				local createElement2 = Roact.createElement
				local v22 = {
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = 0,
					width = 0,
					BackgroundTransparency = 1,
					Text = 0,
					TextWrapped = true,
					Font = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0
				}
				local v23 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
				v22.fitAxis = v23
				local v24 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
				v22.width = v24

				v22.Text = v13

				local v25 = if foundationFontFaceMigration then normalizeFontFace(data2.Tokens.Typography.CaptionLarge.Font) else data2.Font.CaptionHeader.Font
				v22.Font = v25

				v22.TextSize = data2.Font.BaseSize * data2.Font.CaptionHeader.RelativeSize
				v22.TextColor3 = data2.Theme.TextEmphasis.Color
				v22.TextTransparency = data2.Theme.TextEmphasis.Transparency
				v22.TextXAlignment = Enum.TextXAlignment.Left
				v20.Title = createElement2(v5, v22)

				v20.RegisterAuditContent = v19
				v20.BirthdayDropdown = data.showBirthdayDropdown and Roact.createElement(birthdayDropdown, {
					localeId = robloxLocaleId,
					layoutOrder = 1,
					onBirthdaySelected = data.onBirthdaySelected,
					onDropdownOpened = data.props.onBirthdayFocused,
					focusOnMount = true,
					minAgeAllowed = fIntSignupMinimumAge,
					analyticsEventContext = module7.Context.SinglePageSignUpScreen
				})

				local v26 = not data.showBirthdayDropdown

				if v26 then
					local createElement3 = Roact.createElement
					local v28 = {
						layoutOrder = 1,
						size = UDim2.new(1, 0, 0, v18),
						borderState = v17,
						borderColorOverride = color3,
						borderTransparencyOverride = transparency3
					}

					local createElement4 = Roact.createElement
					local v31 = {
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

					local v32 = if v9 then foundationTokens.Color.Shift.Shift_100.Color3 else data2.Theme.BackgroundUIContrast.Color
					v31.ImageColor3 = v32

					local v33 = if v9 then foundationTokens.Color.Shift.Shift_100.Transparency else data2.Theme.BackgroundUIContrast.Transparency
					v31.ImageTransparency = v33

					v31.BorderSizePixel = 0
					v31.ScaleType = Enum.ScaleType.Slice
					v31.SliceCenter = Rect.new(8, 8, 9, 9)
					v31[Roact.Ref] = buttonRef
					v31[Roact.Event.Activated] = data.onActivated
					v31[Roact.Event.MouseEnter] = data.onMouseEnter
					v31[Roact.Event.MouseLeave] = data.onMouseLeave
					local children = {
						UIPadding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 0),
							PaddingBottom = UDim.new(0, 0),
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}),
						TextLabel = 0,
						ImageLabel = 0
					}

					local createElement5 = Roact.createElement
					local v35 = {
						Size = UDim2.new(1, -16, 1, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						BackgroundTransparency = 1,
						Text = v10,
						Font = 0,
						FontFace = 0,
						TextSize = 0,
						TextColor3 = 0,
						TextTransparency = 0
					}

					local v36 = if not foundationFontFaceMigration then data2.Font.Body.Font else nil
					v35.Font = v36

					local v37 = if foundationFontFaceMigration then normalizeFontFace(data2.Tokens.Typography.BodyLarge.Font) else nil
					v35.FontFace = v37

					v35.TextSize = data2.Font.BaseSize * data2.Font.Body.RelativeSize
					v35.TextColor3 = v11
					v35.TextTransparency = transparency
					children.TextLabel = createElement5("TextLabel", v35)

					children.ImageLabel = Roact.createElement(imageSetLabel, {
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(1, 0, 0.5, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 1,
						Image = iconsactionscalendar,
						ImageColor3 = v12,
						ImageTransparency = transparency2
					})
					v26 = createElement3(authStatefulRoundCornerBorder, v28, {
						Base = createElement4(module5, v31, children)
					})
				end

				v20.TextInput = v26
				return createElement(fitFrame, birthdayContainerRefsByRef, v20)
			end
		end)
	end)
end

local v7 = roactServices.connect({ analytics = module8 })(extended)

local v8 = RoactRodux.connect(function(p2)
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
end)(v7)

if getFFlagSignUpBirthdayPickerShowAgeCalculator() then
	v8 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.SignupLayer }, function(p2)
		return {
			birthdayManualSelectVariant = (p2[appBtidLayers.SignupLayer] or {}).birthdayManualSelectVariant
		}
	end)(v8)
end

if defineFastFlag then
	v8 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.SignupLayer }, function(p2, p3)
		return {
			shouldUseBirthdayAgeLabel = (p2[appBtidLayers.SignupLayer] or {}).shouldUseBirthdayAgeLabel
		}
	end)(v8)
end

if getFFlagAuthBirthdayBarFoundationColors() then
	v8 = RoactAppExperiment.connectBrowserTrackerLayer(
		{ appBtidLayers.AuthenticationStylingLayer },
		function(p2, p3)
			return {
				shouldUseFoundationBirthdayBarColors = (p2[appBtidLayers.AuthenticationStylingLayer] or {}).shouldUseFoundationBirthdayBarColors
			}
		end
	)(v8)
end

return getFFlagAuthBirthdayBarFoundationColors() and function(options)
	local v9 = useTokens()

	return React.createElement(v8, Cryo.Dictionary.join(options or {}, {
		foundationTokens = v9
	}))
end or v8
