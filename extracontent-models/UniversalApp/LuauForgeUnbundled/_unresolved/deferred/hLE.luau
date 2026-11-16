local CorePackages = game:GetService("CorePackages")

local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/ecR")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local Foundation = require(CorePackages.Packages.Foundation)
local colorMode = Foundation.Enums.ColorMode
local button = Foundation.Button
local sheet = Foundation.Sheet
local text = Foundation.Text
local useSheetNavigation = Foundation.Hooks.useSheetNavigation
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local Cryo = require(CorePackages.Packages.Cryo)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local constants = UIBlox.App.Style.Constants
local uiModeStyleProvider = require("@game/CorePackages/Workspace/Packages/Style").UiModeStyleProvider

local module3 = require("@luauforge/bundled/edC")
local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local module4 = require("@luauforge/bundled/hAH")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module6 = require("@luauforge/bundled/fNq")
local birthdayPicker = module6.Components.BirthdayPicker
local resolveBirthdaySelectVariant = module6.Util.resolveBirthdaySelectVariant

local useSignUpPageNavigationBindings = require("@game/CorePackages/Workspace/Packages/AuthCommon").Hooks.useSignUpPageNavigationBindings

local module7 = require("@luauforge/bundled/fvl")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local getFFlagSignUpBirthdayPickerShowAgeCalculator = SharedFlags.GetFFlagSignUpBirthdayPickerShowAgeCalculator

local getFFlagSignUpBirthdayPickerRequireManualSelection = SharedFlags.GetFFlagSignUpBirthdayPickerRequireManualSelection

local getFIntSignUpBirthdayPickerManualSelectVariantOverride = SharedFlags.GetFIntSignUpBirthdayPickerManualSelectVariantOverride
local getFFlagSignUpBirthdayPickerRemoveBottomBarOffset = SharedFlags.GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset
local getFFlagEnableBirthdayOverlayAnalytics = SharedFlags.GetFFlagEnableBirthdayOverlayAnalytics
local fIntSinglePageSignupMinimumAge = SharedFlags.FIntSinglePageSignupMinimumAge
local module10 = require("@luauforge/bundled/hAJ")

local module11 = require("@luauforge/deferred/hLF")

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dMA").AppBtidLayers
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module12 = require("@luauforge/bundled/fsy")
local module13 = require("@luauforge/bundled/fMG")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Otter = require(CorePackages.Packages.Otter)

local module14 = require("@luauforge/bundled/dwA")

local dateHelper = require("@luauforge/bundled/fAu").DateHelper

local udim = UDim2.new(0, 36, 0, 36)

local iconsnavigationclose = images["icons/navigation/close"]
local vector2 = Vector2.new(540, 360)
local vector2_2 = Vector2.new(100, 340)

local function FoundationBirthdayPicker(p2)
	local v6 = useSheetNavigation()

	return module.createElement(
		birthdayPicker,
		Cryo.Dictionary.join(p2, { NextSelectionUp = v6.closeAffordanceRef })
	)
end

local extended = module.PureComponent:extend("SignUpBirthdayPickerOverlay")

function extended:reportClosedWithoutConfirmation()
	if
		getFFlagEnableBirthdayOverlayAnalytics()
		and not self.firedAnalytics.closedWithoutConfirm
		and self.props.analytics
	then
		self.firedAnalytics.closedWithoutConfirm = true
		self.props.analytics.reportAuthFormInteraction(
			module12.Context.SinglePageSignUpScreen,
			module12.Field.BirthdayPicker,
			module12.State.BirthdayPickerClosedWithoutConfirm
		)
	end
end

function extended:getSelectedBirthday()
	if self.state.hasValidDate then
		return birthday.new({
			Month = self.state.month,
			Day = self.state.day,
			Year = self.state.year
		})
	end

	return nil
end

function extended:init()
	local initialBirthday = self.props.initialBirthday
	local month, day, year

	if initialBirthday then
		month = initialBirthday.Month
		day = initialBirthday.Day
		year = initialBirthday.Year
	end

	local screenSize = self.props.screenSize

	self.state = {
		month = month,
		day = day,
		year = year,
		hasValidDate = false,
		closingOverlay = false,
		shouldReturnBirthdayOnClose = false,
		isFoundationSheetOpen = true
	}

	self.backButtonRef = module.createRef()
	self.confirmButtonRef = module.createRef()

	self.firedAnalytics = {
		opened = false,
		allPicked = false,
		ageSummaryShown = false,
		closedWithoutConfirm = false
	}

	self.foundationSheetCloseRequested = false
	self.foundationSheetFinalized = false
	self.shouldReturnBirthdayOnFoundationSheetClose = false

	local binding, v6 = module.createBinding(screenSize.Y)
	self.currentYOffset = binding
	self.updateCurrentYOffset = v6

	function self.updatePositionFromAnimation(p2)
		local v7 = getFFlagSignUpBirthdayPickerRemoveBottomBarOffset() and 0 or module14.BOTTOM_BAR_SIZE
		self.updateCurrentYOffset((1 - p2) * screenSize.Y - v7)
	end

	function self.onCloseOverlay(p2)
		if self.isMounted and not self.state.closingOverlay then
			if not p2 then
				self:reportClosedWithoutConfirmation()
			end

			if self.props.navigateBackWithoutSelection and not p2 then
				self.isMounted = false
				self.props.closeCentralOverlay()
				self.props.navigateBack()
			else
				self.motor:setGoal(Otter.spring(0, self.springOptions))
				spawn(function()
					if self.isMounted then
						self:setState({
							shouldReturnBirthdayOnClose = p2,
							closingOverlay = true
						})
					end
				end)
			end
		end
	end

	function self.onOverlayAnimatedOut()
		local onClose = self.props.onClose
		local closeCentralOverlay = self.props.closeCentralOverlay

		local v7 = self.state.shouldReturnBirthdayOnClose and self:getSelectedBirthday() or nil

		self.motor:setGoal(Otter.spring(0, self.springOptions))

		if onClose then
			onClose(v7)
		end

		closeCentralOverlay()
	end

	function self.onFoundationSheetConfirm()
		if
			not self.isMounted
			or not self.state.hasValidDate
			or not self.state.isFoundationSheetOpen
			or self.foundationSheetCloseRequested
			or self.foundationSheetFinalized
		then
			return
		end

		self.foundationSheetCloseRequested = true
		self.shouldReturnBirthdayOnFoundationSheetClose = true
		self:setState({ isFoundationSheetOpen = false })
	end

	function self.onFoundationSheetClosed()
		if not self.isMounted or self.foundationSheetFinalized then
			return
		end

		self.foundationSheetCloseRequested = true
		self.foundationSheetFinalized = true

		local shouldReturnBirthdayOnFoundationSheetClose = self.shouldReturnBirthdayOnFoundationSheetClose

		if not shouldReturnBirthdayOnFoundationSheetClose then
			self:reportClosedWithoutConfirmation()
		end

		if self.props.navigateBackWithoutSelection and not shouldReturnBirthdayOnFoundationSheetClose then
			self.isMounted = false
			self.props.closeCentralOverlay()
			self.props.navigateBack()
		else
			if self.props.onClose then
				local onClose = self.props.onClose
				local v7 = if shouldReturnBirthdayOnFoundationSheetClose then self:getSelectedBirthday() else nil
				onClose(v7)
			end

			self.props.closeCentralOverlay()
		end
	end

	function self.updateBirthday(p2, p3, p4)
		if p2 == nil or p3 == nil or p4 == nil then
			spawn(function()
				if self.isMounted then
					self:setState({
						month = p2,
						day = p3,
						year = p4,
						hasValidDate = false
					})
				end
			end)
			return
		end

		local v7 = dateHelper:isValidDate(p2, p3, p4)

		local ageInYears = birthday.new({ Month = p2, Day = p3, Year = p4 }):GetAgeInYears()

		if ageInYears < fIntSinglePageSignupMinimumAge then
			v7 = false
		end

		if
			getFFlagEnableBirthdayOverlayAnalytics()
			and not self.firedAnalytics.allPicked
			and self.props.analytics
		then
			self.firedAnalytics.allPicked = true
			self.props.analytics.reportAuthFormInteraction(
				module12.Context.SinglePageSignUpScreen,
				module12.Field.BirthdayPicker,
				module12.State.BirthdayPickerAllPicked
			)
		end

		if
			getFFlagEnableBirthdayOverlayAnalytics()
			and self:shouldShowAgeCalculator()
			and v7
			and not self.firedAnalytics.ageSummaryShown
			and self.props.analytics
		then
			self.firedAnalytics.ageSummaryShown = true
			self.props.analytics.reportAuthFormInteraction(
				module12.Context.SinglePageSignUpScreen,
				module12.Field.BirthdayPickerAgeCalculatorShown,
				(tostring(ageInYears))
			)
		end

		spawn(function()
			if self.isMounted then
				self:setState({ month = p2, day = p3, year = p4, hasValidDate = v7 })
			end
		end)
	end

	self.springOptions = { frequency = 3 }

	self.isMounted = false
end

function extended:getManualSelectVariant()
	local fIntSignUpBirthdayPickerManualSelectVariantOverride = getFIntSignUpBirthdayPickerManualSelectVariantOverride()

	if fIntSignUpBirthdayPickerManualSelectVariantOverride >= 0 then
		return fIntSignUpBirthdayPickerManualSelectVariantOverride
	end

	return self.props.birthdayManualSelectVariant or 0
end

function extended:shouldRequireManualSelection()
	if module11() then
		return resolveBirthdaySelectVariant(
			getFFlagSignUpBirthdayPickerRequireManualSelection(),
			getFIntSignUpBirthdayPickerManualSelectVariantOverride(),
			self.props.birthdayManualSelectVariant
		)
	end

	return getFFlagSignUpBirthdayPickerRequireManualSelection() and self:getManualSelectVariant() >= 1
end

function extended:shouldShowAgeCalculator()
	if module11() then
		return resolveBirthdaySelectVariant(
			getFFlagSignUpBirthdayPickerShowAgeCalculator(),
			getFIntSignUpBirthdayPickerManualSelectVariantOverride(),
			self.props.birthdayManualSelectVariant,
			2
		)
	end

	return getFFlagSignUpBirthdayPickerShowAgeCalculator() and self:getManualSelectVariant() >= 2
end

function extended:shouldUseFoundationPicker()
	return module10() and self.props.enableSignUpV2 == true
end

function extended:didMount()
	self.isMounted = true

	if
		getFFlagEnableBirthdayOverlayAnalytics()
		and not self.firedAnalytics.opened
		and self.props.analytics
	then
		self.firedAnalytics.opened = true
		self.props.analytics.reportAuthFormInteraction(
			module12.Context.SinglePageSignUpScreen,
			module12.Field.BirthdayPicker,
			module12.State.BirthdayPickerOpened
		)
	end

	if self:shouldUseFoundationPicker() then
		return
	end

	self.motor = Otter.createSingleMotor(0)

	self.motor:onStep(function(p2)
		self.updatePositionFromAnimation(p2)

		if self.state.closingOverlay and p2 <= 0.1 then
			spawn(function()
				if self.isMounted then
					self:setState({ closingOverlay = false })
				end
			end)
			self.onOverlayAnimatedOut()
		end
	end)

	delay(0, function()
		self.motor:setGoal(Otter.spring(1, self.springOptions))
	end)
end

function extended:willUnmount()
	self.isMounted = false

	if self.motor then
		self.motor:destroy()
	end
end

function extended:renderFoundationSheet(props2, p2, p3, p4)
	local createElement = module.createElement
	local root = sheet.Root
	local v6 = {
		isOpen = self.state.isFoundationSheetOpen,
		onClose = self.onFoundationSheetClosed,
		preferCenterSheet = true,
		ref = self.props.eventHandlerRef
	}
	local children = {
		Header = module.createElement(sheet.Header, { hasCloseAffordance = true }, {
			Title = module.createElement(text, {
				LayoutOrder = 1,
				Text = props2.titleText or "",
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = module.createElement
	local content = sheet.Content
	local v8 = {
		BirthdayPicker = module.createElement(FoundationBirthdayPicker, {
			layoutOrder = 1,
			minAgeAllowed = p4,
			updateBirthday = self.updateBirthday,
			initialMonth = self.state.month,
			initialDay = self.state.day,
			initialYear = self.state.year,
			NextSelectionDown = self.confirmButtonRef,
			requireManualSelection = self:shouldRequireManualSelection()
		}),
		AgeSummary = 0
	}

	local v9 = if p2 and p3 then module.createElement(text, {
		LayoutOrder = 2,
		Text = props2.ageSummaryText or "",
		tag = "size-full-0 auto-y text-label-medium text-wrap text-align-x-center content-default"
	}) else nil
	v8.AgeSummary = v9
	children.Content = createElement2(content, nil, v8)

	children.Actions = module.createElement(sheet.Actions, nil, {
		ConfirmBirthdayButton = module.createElement(button, {
			testId = "--auth-signup-button-confirm-birthday",
			variant = buttonVariant.Emphasis,
			size = buttonSize.Medium,
			text = props2.confirmBirthdayText,
			isDisabled = not self.state.hasValidDate,
			onActivated = self.onFoundationSheetConfirm,
			width = UDim.new(1, 0),
			ref = self.confirmButtonRef,
			LayoutOrder = 1
		})
	})
	return createElement(root, v6, children)
end

function extended:renderContent()
	local hasValidDate = self.state.hasValidDate
	local month = self.state.month
	local day = self.state.day
	local year = self.state.year

	local shouldShowAgeCalculator = self:shouldShowAgeCalculator()

	local v6 = if shouldShowAgeCalculator then Vector2.new(vector2.X, vector2.Y + 44) else vector2

	local v7 = if month then dateHelper.MonthsLocalizationKeys[month] or nil else nil
	local v8 = shouldShowAgeCalculator and hasValidDate and month and day and year
	local ageInYears

	if v8 then
		ageInYears = birthday.new({ Month = month, Day = day, Year = year }):GetAgeInYears()
	else
		ageInYears = nil
	end

	local v10 = if module10() then self.props.enableSignUpV2 else nil
	local v11 = module4(v10)

	return withStyle(function(data)
		return module3({
			monthText = v7,
			dayAffix = dateHelper.DayAffixLocalizationKey,
			yearAffix = dateHelper.YearAffixLocalizationKey
		})(function(data2)
			local formattedFullString

			if v8 and data2.monthText then
				formattedFullString = dateHelper:GetFormattedFullString(
					data2.monthText,
					day,
					data2.dayAffix or "",
					year,
					data2.yearAffix or "",
					" ",
					LocalizationService.RobloxLocaleId
				)
			end

			return module3({
				confirmBirthdayText = v11.birthdayPickerConfirmButton,
				titleText = v11.birthdayPickerHeading,
				ageSummaryText = formattedFullString and {
					"Authentication.SignUp.Label.BirthdayPickerWithDateAndAge",
					date = formattedFullString,
					yearsOld = tostring(ageInYears or 0)
				} or nil
			})(function(props)
				local v12 = self.props.formFactor == formFactor.WIDE
				local v14 = v12 and 0.5 or 1
				local v15 = fIntSinglePageSignupMinimumAge

				if self:shouldUseFoundationPicker() then
					return self:renderFoundationSheet(props, shouldShowAgeCalculator, v8, v15)
				end

				local createElement = module.createElement
				local v17 = {
					Size = UDim2.new(1, 0, 0, v6.Y),
					Position = self.currentYOffset:map(function(p2)
						return UDim2.new(0.5, 0, v14, p2)
					end),
					AnchorPoint = Vector2.new(0.5, v12 and 0.5 or 1),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = data.Theme.BackgroundUIDefault.Color,
					ClipsDescendants = true,
					ref = self.props.eventHandlerRef
				}
				local children = {
					SizeConstraint = v12 and module.createElement("UISizeConstraint", {
						MaxSize = v6,
						MinSize = vector2_2
					}),
					HeaderFrame = 0,
					Divider = 0,
					ContentFrame = 0
				}

				local createElement2 = module.createElement
				local v19 = {
					Size = UDim2.new(1, 0, 0, 48),
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Text = nil
				}

				local v20 = {
					BackButton = module.createElement(imageSetButton, {
						Size = udim,
						AutoButtonColor = false,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 12, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						ScaleType = Enum.ScaleType.Fit,
						Image = iconsnavigationclose,
						ImageColor3 = data.Theme.UIEmphasis.Color,
						ImageTransparency = 0,
						[module.Ref] = self.backButtonRef,
						[module.Event.Activated] = function()
							self.onCloseOverlay(false)
						end
					}),
					Title = 0
				}

				local v23 = props.titleText

				if v23 then
					local createElement4 = module.createElement
					local v25 = {
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 0),
						AnchorPoint = Vector2.new(0, 0.5),
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
					local v26 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
					v25.fitAxis = v26
					local v27 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
					v25.width = v27

					v25.Text = props.titleText or ""

					local v28 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.CaptionLarge.Font) else data.Font.CaptionHeader.Font
					v25.Font = v28

					v25.TextSize = data.Font.BaseSize * data.Font.Header1.RelativeSize
					v25.TextColor3 = data.Theme.TextEmphasis.Color
					v25.TextTransparency = data.Theme.TextEmphasis.Transparency
					v25.TextXAlignment = Enum.TextXAlignment.Center
					v23 = createElement4(v5, v25)
				end

				v20.Title = v23
				children.HeaderFrame = createElement2("Frame", v19, v20)

				children.Divider = module.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0.5, 0, 0, 48),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 0,
					BackgroundColor3 = data.Theme.UIEmphasis.Color
				})

				local createElement4 = module.createElement
				local fitFrame = FitChildren.FitFrame
				local v24 = {
					Size = UDim2.new(1, 0, 1, -49),
					Position = UDim2.new(0.5, 0, 0, 49),
					AnchorPoint = Vector2.new(0.5, 0),
					fitAxis = FitChildren.FitAxis.Height,
					BackgroundTransparency = 1,
					Text = nil
				}

				local v25 = {
					ListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Padding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 20),
						PaddingRight = UDim.new(0, 20),
						PaddingTop = UDim.new(0, 20),
						PaddingBottom = UDim.new(0, 20)
					}),
					Content = module.createElement(birthdayPicker, {
						layoutOrder = 1,
						minAgeAllowed = v15,
						updateBirthday = self.updateBirthday,
						initialMonth = self.state.month,
						initialDay = self.state.day,
						initialYear = self.state.year,
						NextSelectionUp = self.backButtonRef,
						NextSelectionDown = self.confirmButtonRef,
						requireManualSelection = self:shouldRequireManualSelection()
					}),
					Spacing = module.createElement("Frame", {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 30),
						BackgroundTransparency = 1
					}),
					AgeSummary = 0,
					ConfirmButtonSpacing = 0,
					ConfirmBirthdayButton = 0
				}
				local v26

				if shouldShowAgeCalculator then
					local createElement5 = module.createElement
					local v28 = {
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, 14),
						BackgroundTransparency = 1
					}
					local v30

					if v8 then
						local createElement6 = module.createElement
						local v32 = {
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = props.ageSummaryText or "",
							TextWrapped = true,
							Font = 0,
							FontFace = 0,
							TextSize = 0,
							TextColor3 = 0,
							TextTransparency = 0,
							TextXAlignment = 0,
							TextYAlignment = 0
						}

						local v33 = if not foundationFontFaceMigration then data.Tokens.Typography.LabelMedium.Font else nil
						v32.Font = v33

						local v34 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.LabelMedium.Font) else nil
						v32.FontFace = v34

						v32.TextSize = data.Tokens.Typography.LabelMedium.FontSize
						v32.TextColor3 = data.Theme.TextDefault.Color
						v32.TextTransparency = data.Theme.TextDefault.Transparency
						v32.TextXAlignment = Enum.TextXAlignment.Center
						v32.TextYAlignment = Enum.TextYAlignment.Center
						v30 = createElement6("TextLabel", v32)
					end

					v26 = createElement5("Frame", v28, { Label = v30 })
				end

				v25.AgeSummary = v26

				local v27 = if shouldShowAgeCalculator then module.createElement("Frame", {
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 1
				}) else nil
				v25.ConfirmButtonSpacing = v27

				v25.ConfirmBirthdayButton = module.createElement(button, {
					testId = "--auth-signup-button-confirm-birthday",
					variant = buttonVariant.SubEmphasis,
					size = buttonSize.Medium,
					text = props.confirmBirthdayText,
					isDisabled = not hasValidDate,
					onActivated = function()
						if hasValidDate then
							self.onCloseOverlay(true)
						end
					end,
					width = UDim.new(1, 0),
					ref = self.confirmButtonRef,
					LayoutOrder = 5
				})
				children.ContentFrame = createElement4(fitFrame, v24, v25)
				return createElement(imageSetLabel, v17, children)
			end)
		end)
	end)
end

function extended:render()
	local forceDarkTheme = self.props.forceDarkTheme
	local content = self:renderContent()

	if forceDarkTheme then
		return module.createElement(uiModeStyleProvider, {
			style = { themeName = colorMode.Dark, fontName = constants.FontName.Gotham }
		}, { Child = content })
	end

	return content
end

local v6 = module2.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize, formFactor = p2.FormFactor }
end, function(callback)
	return {
		closeCentralOverlay = function()
			callback(module7())
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end
	}
end)(extended)

local v7 = roactServices.connect({ analytics = module13 })(v6)

if
	getFFlagSignUpBirthdayPickerRequireManualSelection()
	or getFFlagSignUpBirthdayPickerShowAgeCalculator()
	or module10()
then
	v7 = RoactAppExperiment.connectBrowserTrackerLayer({ appBtidLayers.SignupLayer }, function(p2, p3)
		local v8 = p2[appBtidLayers.SignupLayer] or {}
		return {
			birthdayManualSelectVariant = v8.birthdayManualSelectVariant,
			enableSignUpV2 = v8.enableSignUpV2
		}
	end)(v7)
end

return function(p2)
	local v8 = useSignUpPageNavigationBindings()

	return module.createElement(v7, Cryo.Dictionary.join(p2, { eventHandlerRef = v8 }))
end
