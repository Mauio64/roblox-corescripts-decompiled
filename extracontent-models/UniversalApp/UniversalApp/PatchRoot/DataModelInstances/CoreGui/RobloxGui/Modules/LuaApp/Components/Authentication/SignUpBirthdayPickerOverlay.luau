local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = require(CorePackages.Workspace.Packages.Style).UiModeStyleProvider
local withLocalization = require(Modules.LuaApp.withLocalization)
local Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday
local FitChildren = require(Modules.LuaApp.FitChildren)
local BirthdayPicker = require(CorePackages.Workspace.Packages.AuthSignup).Components.BirthdayPicker
local useSignUpPageNavigationBindings = require(CorePackages.Workspace.Packages.AuthCommon).Hooks.useSignUpPageNavigationBindings
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local GetFFlagSignUpBirthdayPickerShowAgeCalculator = SharedFlags.GetFFlagSignUpBirthdayPickerShowAgeCalculator
local GetFFlagSignUpBirthdayPickerRequireManualSelection = SharedFlags.GetFFlagSignUpBirthdayPickerRequireManualSelection
local GetFIntSignUpBirthdayPickerManualSelectVariantOverride = SharedFlags.GetFIntSignUpBirthdayPickerManualSelectVariantOverride
local GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset = SharedFlags.GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset
local GetFFlagEnableBirthdayOverlayAnalytics = SharedFlags.GetFFlagEnableBirthdayOverlayAnalytics
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local v32 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Otter = require(CorePackages.Packages.Otter)
local Constants2 = require(Modules.LuaApp.Constants)
local v44 = game:DefineFastInt("SinglePageSignupMinimumAge", 5)
local DateHelper = require(CorePackages.Workspace.Packages.Time).DateHelper
local uDim2 = UDim2.new(0, 36, 0, 36)
local v47 = Images["icons/navigation/close"]
local vector2 = Vector2.new(540, 360)
local vector2_2 = Vector2.new(100, 340)
local v50 = Roact.PureComponent:extend("SignUpBirthdayPickerOverlay")

function v50.init(p1) -- line: 86
	-- upvalues: Roact (copy), GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset (copy), Constants2 (copy), GetFFlagEnableBirthdayOverlayAnalytics (copy), EventStreamConstants (copy), Otter (copy), Birthday (copy), DateHelper (copy), v44 (copy)
	local initialBirthday = p1.props.initialBirthday
	local Month = nil
	local Day = nil
	local Year = nil

	if initialBirthday then
		Month = initialBirthday.Month
		Day = initialBirthday.Day
		Year = initialBirthday.Year
	end

	local screenSize = p1.props.screenSize

	p1.state = {
		hasValidDate = false,
		closingOverlay = false,
		shouldReturnBirthdayOnClose = false,
		month = Month,
		day = Day,
		year = Year
	}
	p1.backButtonRef = Roact.createRef()
	p1.confirmButtonRef = Roact.createRef()
	p1.firedAnalytics = {
		opened = false,
		allPicked = false,
		ageSummaryShown = false,
		closedWithoutConfirm = false
	}

	local v59, v60 = Roact.createBinding(screenSize.Y)

	p1.currentYOffset = v59
	p1.updateCurrentYOffset = v60

	function p1.updatePositionFromAnimation(p2) -- line: 122
		-- upvalues: GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset (copy), Constants2 (copy), p1 (copy), screenSize (copy)
		local v88 = if not GetFFlagSignUpBirthdayPickerRemoveBottomBarOffset() then Constants2.BOTTOM_BAR_SIZE else 0

		p1.updateCurrentYOffset((1 - p2) * screenSize.Y - v88)
	end
	function p1.onCloseOverlay(p3) -- line: 129
		-- upvalues: p1 (copy), GetFFlagEnableBirthdayOverlayAnalytics (copy), EventStreamConstants (copy), Otter (copy)
		if p1.isMounted and not p1.state.closingOverlay then
			if GetFFlagEnableBirthdayOverlayAnalytics() and not p3 and not p1.firedAnalytics.closedWithoutConfirm and p1.props.analytics then
				p1.firedAnalytics.closedWithoutConfirm = true
				p1.props.analytics.reportAuthFormInteraction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.BirthdayPicker, EventStreamConstants.State.BirthdayPickerClosedWithoutConfirm)
			end

			if p1.props.navigateBackWithoutSelection and not p3 then
				p1.isMounted = false
				p1.props.closeCentralOverlay()
				p1.props.navigateBack()

				return
			end

			p1.motor:setGoal(Otter.spring(0, p1.springOptions))
			spawn(function() -- line: 151
				-- upvalues: p1 (copy), p3 (copy)
				if p1.isMounted then
					p1:setState({
						closingOverlay = true,
						shouldReturnBirthdayOnClose = p3
					})
				end
			end)
		end
	end
	function p1.onOverlayAnimatedOut() -- line: 163
		-- upvalues: p1 (copy), Birthday (copy), Otter (copy)
		local onClose = p1.props.onClose
		local closeCentralOverlay = p1.props.closeCentralOverlay
		local month = p1.state.month
		local day = p1.state.day
		local year = p1.state.year
		local hasValidDate = p1.state.hasValidDate
		local v96 = p1.state.shouldReturnBirthdayOnClose and (not not hasValidDate and Birthday.new({
			Month = month,
			Day = day,
			Year = year
		})) or nil

		p1.motor:setGoal(Otter.spring(0, p1.springOptions))

		if onClose then
			onClose(v96)
		end

		closeCentralOverlay()
	end
	function p1.updateBirthday(p4, p5, p6) -- line: 190
		-- upvalues: p1 (copy), DateHelper (copy), v44 (copy), Birthday (copy), GetFFlagEnableBirthdayOverlayAnalytics (copy), EventStreamConstants (copy)
		if p4 == nil or (p5 == nil or p6 == nil) then
			spawn(function() -- line: 194
				-- upvalues: p1 (copy), p4 (copy), p5 (copy), p6 (copy)
				if p1.isMounted then
					p1:setState({
						hasValidDate = false,
						month = p4,
						day = p5,
						year = p6
					})
				end
			end)

			return
		end

		local u100 = DateHelper:isValidDate(p4, p5, p6)
		local v101 = v44
		local AgeInYears = Birthday.new({
			Month = p4,
			Day = p5,
			Year = p6
		}):GetAgeInYears()

		if AgeInYears < v101 then
			u100 = false
		end

		if GetFFlagEnableBirthdayOverlayAnalytics() and not p1.firedAnalytics.allPicked and p1.props.analytics then
			p1.firedAnalytics.allPicked = true
			p1.props.analytics.reportAuthFormInteraction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.BirthdayPicker, EventStreamConstants.State.BirthdayPickerAllPicked)
		end

		if GetFFlagEnableBirthdayOverlayAnalytics() and p1:shouldShowAgeCalculator() and u100 and not p1.firedAnalytics.ageSummaryShown and p1.props.analytics then
			p1.firedAnalytics.ageSummaryShown = true
			p1.props.analytics.reportAuthFormInteraction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.BirthdayPickerAgeCalculatorShown, (tostring(AgeInYears)))
		end

		spawn(function() -- line: 245
			-- upvalues: p1 (copy), p4 (copy), p5 (copy), p6 (copy), u100 (ref)
			if p1.isMounted then
				p1:setState({
					month = p4,
					day = p5,
					year = p6,
					hasValidDate = u100
				})
			end
		end)
	end

	p1.springOptions = {
		frequency = 3
	}
	p1.isMounted = false
end
function v50.getManualSelectVariant(p7) -- line: 266
	-- upvalues: GetFIntSignUpBirthdayPickerManualSelectVariantOverride (copy)
	local v62 = GetFIntSignUpBirthdayPickerManualSelectVariantOverride()

	if v62 >= 0 then
		return v62
	end

	return p7.props.birthdayManualSelectVariant or 0
end
function v50.shouldRequireManualSelection(p8) -- line: 275
	-- upvalues: GetFFlagSignUpBirthdayPickerRequireManualSelection (copy)
	return GetFFlagSignUpBirthdayPickerRequireManualSelection() and p8:getManualSelectVariant() >= 1
end
function v50.shouldShowAgeCalculator(p9) -- line: 280
	-- upvalues: GetFFlagSignUpBirthdayPickerShowAgeCalculator (copy)
	return GetFFlagSignUpBirthdayPickerShowAgeCalculator() and p9:getManualSelectVariant() >= 2
end
function v50.didMount(p10) -- line: 285
	-- upvalues: GetFFlagEnableBirthdayOverlayAnalytics (copy), EventStreamConstants (copy), Otter (copy)
	p10.isMounted = true

	if GetFFlagEnableBirthdayOverlayAnalytics() and (not p10.firedAnalytics.opened and p10.props.analytics) then
		p10.firedAnalytics.opened = true
		p10.props.analytics.reportAuthFormInteraction(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.BirthdayPicker, EventStreamConstants.State.BirthdayPickerOpened)
	end

	p10.motor = Otter.createSingleMotor(0)
	p10.motor:onStep(function(p11) -- line: 299
		-- upvalues: p10 (copy)
		p10.updatePositionFromAnimation(p11)

		if p10.state.closingOverlay and p11 <= 0.1 then
			spawn(function() -- line: 303
				-- upvalues: p10 (copy)
				if p10.isMounted then
					p10:setState({
						closingOverlay = false
					})
				end
			end)
			p10.onOverlayAnimatedOut()
		end
	end)
	delay(0, function() -- line: 314
		-- upvalues: p10 (copy), Otter (copy)
		p10.motor:setGoal(Otter.spring(1, p10.springOptions))
	end)
end
function v50.willUnmount(p12) -- line: 319
	p12.isMounted = false
	p12.motor:destroy()
end
function v50.renderContent(p13) -- line: 324
	-- upvalues: vector2 (copy), DateHelper (copy), Birthday (copy), withStyle (copy), withLocalization (copy), LocalizationService (copy), FormFactor (copy), v44 (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy), vector2_2 (copy), ImageSetButton (copy), uDim2 (copy), v47 (copy), FitTextLabel (copy), FitChildren (copy), BirthdayPicker (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local hasValidDate = p13.state.hasValidDate
	local month = p13.state.month
	local day = p13.state.day
	local year = p13.state.year
	local v72 = p13:shouldShowAgeCalculator()
	local v73 = if not v72 then vector2 else Vector2.new(vector2.X, vector2.Y + 44)
	local v74 = month and DateHelper.MonthsLocalizationKeys[month] or nil
	local v75 = v72 and (hasValidDate and (month and (day and year)))
	local v76 = if not v75 then nil else Birthday.new({
		Month = month,
		Day = day,
		Year = year
	}):GetAgeInYears()

	return withStyle(function(p14) -- line: 346
		-- upvalues: withLocalization (copy), v74 (copy), DateHelper (copy), v75 (copy), day (copy), year (copy), LocalizationService (copy), v76 (copy), p13 (copy), FormFactor (copy), v44 (copy), Roact (copy), ImageSetLabel (copy), v73 (copy), GetImageData (copy), vector2_2 (copy), ImageSetButton (copy), uDim2 (copy), v47 (copy), FitTextLabel (copy), FitChildren (copy), BirthdayPicker (copy), v72 (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), hasValidDate (copy)
		return withLocalization({
			monthText = v74,
			dayAffix = DateHelper.DayAffixLocalizationKey,
			yearAffix = DateHelper.YearAffixLocalizationKey
		})(function(p15) -- line: 353
			-- upvalues: v75 (copy), DateHelper (copy), day (copy), year (copy), LocalizationService (copy), withLocalization (copy), v76 (copy), p13 (copy), FormFactor (copy), v44 (copy), Roact (copy), ImageSetLabel (copy), v73 (copy), GetImageData (copy), p14 (copy), vector2_2 (copy), ImageSetButton (copy), uDim2 (copy), v47 (copy), FitTextLabel (copy), FitChildren (copy), BirthdayPicker (copy), v72 (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), hasValidDate (copy)
			local FormattedFullString = nil

			if v75 and p15.monthText then
				FormattedFullString = DateHelper:GetFormattedFullString(p15.monthText, day, p15.dayAffix or "", year, p15.yearAffix or "", " ", LocalizationService.RobloxLocaleId)
			end

			return withLocalization({
				confirmBirthdayText = "Authentication.SignUp.Label.ConfirmBirthday",
				titleText = "Authentication.SignUp.Label.Birthday",
				ageSummaryText = if not FormattedFullString then nil else {
					"Authentication.SignUp.Label.BirthdayPickerWithDateAndAge",
					date = FormattedFullString,
					yearsOld = tostring(v76 or 0)
				}
			})(function(p16) -- line: 377
				-- upvalues: p13 (copy), FormFactor (copy), v44 (copy), Roact (copy), ImageSetLabel (copy), v73 (copy), GetImageData (copy), p14 (copy), vector2_2 (copy), ImageSetButton (copy), uDim2 (copy), v47 (copy), FitTextLabel (copy), FitChildren (copy), BirthdayPicker (copy), v72 (copy), v75 (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), hasValidDate (copy)
				local v108 = p13.props.formFactor == FormFactor.WIDE
				local v109 = not v108 and 1 or 0.5
				local v110 = not v108 and 1 or 0.5
				local v111 = v44

				return Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, v73.Y),
					Position = p13.currentYOffset:map(function(p17) -- line: 386
						-- upvalues: v110 (copy)
						return UDim2.new(0.5, 0, v110, p17)
					end),
					AnchorPoint = Vector2.new(0.5, v109),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = p14.Theme.BackgroundUIDefault.Color,
					ref = p13.props.eventHandlerRef
				}, {
					SizeConstraint = v108 and Roact.createElement("UISizeConstraint", {
						MaxSize = v73,
						MinSize = vector2_2
					}),
					HeaderFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Text = nil,
						Size = UDim2.new(1, 0, 0, 48),
						Position = UDim2.new(0.5, 0, 0, 0),
						AnchorPoint = Vector2.new(0.5, 0)
					}, {
						BackButton = Roact.createElement(ImageSetButton, {
							Size = uDim2,
							AutoButtonColor = false,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 12, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							ScaleType = Enum.ScaleType.Fit,
							Image = v47,
							ImageColor3 = p14.Theme.UIEmphasis.Color,
							ImageTransparency = 0,
							[Roact.Ref] = p13.backButtonRef,
							[Roact.Event.Activated] = function() -- line: 425
								-- upvalues: p13 (copy)
								p13.onCloseOverlay(false)
							end
						}),
						Title = p16.titleText and Roact.createElement(FitTextLabel, {
							BackgroundTransparency = 1,
							TextWrapped = true,
							Position = UDim2.new(0, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							fitAxis = FitChildren.FitAxis.Height,
							Text = p16.titleText or "",
							Font = p14.Font.CaptionHeader.Font,
							TextSize = p14.Font.BaseSize * p14.Font.Header1.RelativeSize,
							TextColor3 = p14.Theme.TextEmphasis.Color,
							TextTransparency = p14.Theme.TextEmphasis.Transparency,
							TextXAlignment = Enum.TextXAlignment.Center
						})
					}),
					Divider = Roact.createElement("Frame", {
						BackgroundTransparency = 0,
						Size = UDim2.new(1, 0, 0, 1),
						Position = UDim2.new(0.5, 0, 0, 48),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundColor3 = p14.Theme.UIEmphasis.Color
					}),
					ContentFrame = Roact.createElement(FitChildren.FitFrame, {
						BackgroundTransparency = 1,
						Text = nil,
						Size = UDim2.new(1, 0, 1, -49),
						Position = UDim2.new(0.5, 0, 0, 49),
						AnchorPoint = Vector2.new(0.5, 0),
						fitAxis = FitChildren.FitAxis.Height
					}, {
						ListLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 20),
							PaddingRight = UDim.new(0, 20),
							PaddingTop = UDim.new(0, 20),
							PaddingBottom = UDim.new(0, 20)
						}),
						Content = Roact.createElement(BirthdayPicker, {
							layoutOrder = 1,
							minAgeAllowed = v111,
							updateBirthday = p13.updateBirthday,
							initialMonth = p13.state.month,
							initialDay = p13.state.day,
							initialYear = p13.state.year,
							NextSelectionUp = p13.backButtonRef,
							NextSelectionDown = p13.confirmButtonRef,
							requireManualSelection = p13:shouldRequireManualSelection()
						}),
						Spacing = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 30)
						}),
						AgeSummary = if not v72 then nil else Roact.createElement("Frame", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 14)
						}, {
							Label = if not v75 then nil else Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 1, 0),
								Text = p16.ageSummaryText or "",
								Font = p14.Tokens.Typography.LabelMedium.Font,
								TextSize = p14.Tokens.Typography.LabelMedium.FontSize,
								TextColor3 = p14.Theme.TextDefault.Color,
								TextTransparency = p14.Theme.TextDefault.Transparency,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center
							})
						}),
						ConfirmButtonSpacing = if not v72 then nil else Roact.createElement("Frame", {
							LayoutOrder = 4,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 30)
						}),
						ConfirmBirthdayButton = Roact.createElement(Button, {
							LayoutOrder = 5,
							variant = ButtonVariant.SubEmphasis,
							size = ButtonSize.Medium,
							text = p16.confirmBirthdayText,
							isDisabled = not hasValidDate,
							onActivated = function() -- line: 525
								-- upvalues: hasValidDate (copy), p13 (copy)
								if hasValidDate then
									p13.onCloseOverlay(true)
								end
							end,
							width = UDim.new(1, 0),
							ref = p13.confirmButtonRef
						})
					})
				})
			end)
		end)
	end)
end
function v50.render(p18) -- line: 541
	-- upvalues: Roact (copy), UiModeStyleProvider (copy), Constants (copy)
	local forceDarkTheme = p18.props.forceDarkTheme
	local v79 = p18:renderContent()

	if forceDarkTheme then
		return Roact.createElement(UiModeStyleProvider, {
			style = {
				themeName = Constants.ThemeName.Dark,
				fontName = Constants.FontName.Gotham
			}
		}, {
			Child = v79
		})
	end

	return v79
end

local v51 = RoactRodux.connect(function(p19, _) -- line: 559
	return {
		screenSize = p19.ScreenSize,
		formFactor = p19.FormFactor
	}
end, function(p21) -- line: 564
	-- upvalues: CloseCentralOverlay (copy), FFlagSignalsNavP3Dispatch (copy), v32 (copy), NavigateBack (copy)
	return {
		closeCentralOverlay = function() -- line: 566
			-- upvalues: p21 (copy), CloseCentralOverlay (copy)
			p21(CloseCentralOverlay())
		end,
		navigateBack = function() -- line: 569
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v32 (copy), p21 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v32.back()
			end

			return p21(NavigateBack())
		end
	}
end)(v50)
local u52 = RoactServices.connect({
	analytics = RoactAnalyticsAuthEvents
})(v51)

if GetFFlagSignUpBirthdayPickerRequireManualSelection() or GetFFlagSignUpBirthdayPickerShowAgeCalculator() then
	u52 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.SignupLayer }, function(p22, _) -- line: 588
		-- upvalues: AppBtidLayers (copy)
		return {
			birthdayManualSelectVariant = (p22[AppBtidLayers.SignupLayer] or {}).birthdayManualSelectVariant
		}
	end)(u52)
end

return function(p24) -- line: 596
	-- upvalues: useSignUpPageNavigationBindings (copy), Roact (copy), u52 (ref), Cryo (copy)
	local v86 = useSignUpPageNavigationBindings()

	return Roact.createElement(u52, Cryo.Dictionary.join(p24, {
		eventHandlerRef = v86
	}))
end
