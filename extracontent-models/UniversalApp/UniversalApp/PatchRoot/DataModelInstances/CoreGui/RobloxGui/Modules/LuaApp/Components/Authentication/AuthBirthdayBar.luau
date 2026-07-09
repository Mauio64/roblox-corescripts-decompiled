local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Cryo = require(CorePackages.Packages.Cryo)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local v11 = game:DefineFastFlag("ShouldEnableAuthBirthdayBarUpdates", false)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local BirthdayDropdown = require(CorePackages.Workspace.Packages.AuthSignup).Components.BirthdayDropdown
local RegisterAuditContent = AuthCommon.Components.RegisterAuditContent
local v26 = if not v11 then require(Modules.LuaApp.Util.DateHelper) else require(CorePackages.Workspace.Packages.Time).DateHelper
local Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local OpenCentralOverlayForSignUpBirthdayPicker = require(Modules.LuaApp.Thunks.OpenCentralOverlayForSignUpBirthdayPicker)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseBirthdayDropdownForGamepad = SharedFlags.FFlagUseBirthdayDropdownForGamepad
local FIntSignupMinimumAge = SharedFlags.FIntSignupMinimumAge
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags.GetFFlagEnableAuditForSinglePageSignUp
local GetFFlagAuthBirthdayBarFoundationColors = SharedFlags.GetFFlagAuthBirthdayBarFoundationColors
local v37 = Images["icons/actions/calendar"]
local v38 = Roact.PureComponent:extend("AuthBirthdayBar")

function v38.init(p1) -- line: 65
	-- upvalues: FFlagUseBirthdayDropdownForGamepad (copy), Responsive (copy), ArgCheck (copy), Birthday (copy), EventStreamConstants (copy), v11 (copy)
	p1.state = {
		isFocused = false,
		isHovering = false,
		selectedBirthday = nil,
		age = nil
	}
	p1.isMounted = false
	p1.showBirthdayDropdown = FFlagUseBirthdayDropdownForGamepad and p1.props.preferredInput == Responsive.Input.Directional

	function p1.updateState(p2) -- line: 77
		-- upvalues: p1 (copy)
		spawn(function() -- line: 78
			-- upvalues: p1 (copy), p2 (copy)
			if p1.isMounted then
				p1:setState(p2)
			end
		end)
	end
	function p1.onBirthdayPickerClose(p3) -- line: 84
		-- upvalues: ArgCheck (copy), Birthday (copy), p1 (copy), EventStreamConstants (copy), v11 (copy)
		local t1 = {
			isFocused = false
		}

		if p3 ~= nil then
			ArgCheck.assert(Birthday.is(p3), "CentralOverlayForSignUpBirthdayPicker should pass back a Birthday when closing.")

			local onBirthdaySelected = p1.props.onBirthdaySelected

			if onBirthdaySelected then
				p1.props.analytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.ConfirmBirthday)
				onBirthdaySelected(p3)
			end

			t1.selectedBirthday = p3

			if v11 and p3.Day ~= nil and p3.Month ~= nil and p3.Year ~= nil then
				local AgeInYears = p3:GetAgeInYears()

				t1.age = AgeInYears

				if AgeInYears ~= nil and p1.props.shouldUseBirthdayAgeLabel then
					p1.props.analytics.reportAuthFormInteraction(EventStreamConstants.Context.SignupForm, EventStreamConstants.Field.BirthdayAgeLabel, (tostring(AgeInYears)))
				end
			end
		end

		if p1.props.onBirthdayFocused then
			p1.props.onBirthdayFocused(false)
		end

		p1.updateState(t1)
	end
	function p1.onBirthdaySelected(p4, p5, p6) -- line: 128
		-- upvalues: ArgCheck (copy), Birthday (copy), p1 (copy)
		ArgCheck.assert(Birthday.is(p4), "BirthdayDropdown should pass a Birthday.")

		local t2 = {
			selectedBirthday = p4,
			age = p5
		}
		local onBirthdaySelected = p1.props.onBirthdaySelected

		if onBirthdaySelected then
			onBirthdaySelected(p4, p6)
		end

		p1.updateState(t2)
	end
	function p1.onActivated() -- line: 144
		-- upvalues: p1 (copy), EventStreamConstants (copy)
		p1.props.analytics.reportFocus(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.Birthday)
		p1.props.openCentralOverlayForSignUpBirthdayPicker({
			initialBirthday = p1.state.selectedBirthday,
			onClose = p1.onBirthdayPickerClose,
			navigateBackWithoutSelection = p1.props.autoFocusOnMount and not p1.state.selectedBirthday,
			forceDarkTheme = p1.props.forceDarkTheme
		})

		if p1.props.onBirthdayFocused then
			p1.props.onBirthdayFocused(true)
		end

		spawn(function() -- line: 160
			-- upvalues: p1 (copy)
			if p1.isMounted then
				p1:setState({
					isFocused = true
				})
			end
		end)
	end
	function p1.onMouseEnter() -- line: 169
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				isHovering = true
			})
		end
	end
	function p1.onMouseLeave() -- line: 177
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				isHovering = false
			})
		end
	end
end
function v38.didMount(p7) -- line: 186
	p7.isMounted = true

	if p7.showBirthdayDropdown then
		return
	end

	if p7.props.autoFocusOnMount then
		spawn(p7.onActivated)
	end
end
function v38.willUnmount(p8) -- line: 196
	p8.isMounted = false
end
function v38.render(p9) -- line: 200
	-- upvalues: LocalizationService (copy), v26 (copy), v11 (copy), withStyle (copy), GetFFlagAuthBirthdayBarFoundationColors (copy), withLocalization (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), AuthStatefulRoundCornerBorder (copy), Roact (copy), FitChildren (copy), FitTextLabel (copy), RegisterAuditContent (copy), BirthdayDropdown (copy), FIntSignupMinimumAge (copy), EventStreamConstants (copy), DEPRECATED_ImageSetButton (copy), ImageSetLabel (copy), v37 (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local layoutOrder = p9.props.layoutOrder
	local isFocused = p9.state.isFocused
	local isHovering = p9.state.isHovering
	local selectedBirthday = p9.state.selectedBirthday
	local buttonRef = p9.props.buttonRef
	local birthdayContainerRef = p9.props.birthdayContainerRef
	local v53 = selectedBirthday and v26.MonthsLocalizationKeys[selectedBirthday.Month] or nil
	local v54 = not v11 and "" or tostring(p9.state.age or 0)

	return withStyle(function(p10) -- line: 214
		-- upvalues: GetFFlagAuthBirthdayBarFoundationColors (copy), p9 (copy), withLocalization (copy), v53 (copy), v26 (copy), v11 (copy), v54 (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), AuthStatefulRoundCornerBorder (copy), selectedBirthday (copy), RobloxLocaleId (copy), isFocused (copy), isHovering (copy), Roact (copy), FitChildren (copy), layoutOrder (copy), birthdayContainerRef (copy), FitTextLabel (copy), RegisterAuditContent (copy), BirthdayDropdown (copy), FIntSignupMinimumAge (copy), EventStreamConstants (copy), DEPRECATED_ImageSetButton (copy), buttonRef (copy), ImageSetLabel (copy), v37 (copy)
		local foundationTokens = nil
		local u74 = false

		if GetFFlagAuthBirthdayBarFoundationColors() then
			foundationTokens = p9.props.foundationTokens
			u74 = p9.props.shouldUseFoundationBirthdayBarColors and (foundationTokens ~= nil and foundationTokens.Config ~= nil)
		end

		return withLocalization({
			titleText = "Authentication.SignUp.Label.Birthday",
			datePlaceholder = "CommonUI.Controls.Birthdaypicker.Label.Date",
			monthText = v53,
			dayAffix = v26.DayAffixLocalizationKey,
			yearAffix = v26.YearAffixLocalizationKey,
			titleTextWithAge = if not v11 then nil else {
				"Authentication.SignUp.Label.BirthdayWithAge",
				yearsOld = v54
			},
			titleTextWithAgeTemplate = if not GetFFlagEnableAuditForSinglePageSignUp() then nil else "Authentication.SignUp.Label.BirthdayWithAge"
		})(function(p11) -- line: 238
			-- upvalues: u74 (ref), foundationTokens (ref), p10 (copy), v11 (copy), p9 (copy), v54 (copy), AuthStatefulRoundCornerBorder (copy), selectedBirthday (copy), v26 (copy), RobloxLocaleId (copy), isFocused (copy), isHovering (copy), Roact (copy), FitChildren (copy), layoutOrder (copy), birthdayContainerRef (copy), FitTextLabel (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), BirthdayDropdown (copy), FIntSignupMinimumAge (copy), EventStreamConstants (copy), DEPRECATED_ImageSetButton (copy), buttonRef (copy), ImageSetLabel (copy), v37 (copy)
			local datePlaceholder = p11.datePlaceholder
			local v78 = if not u74 then p10.Theme.TextDefault.Color else foundationTokens.Color.Content.Muted.Color3
			local v79 = if not u74 then p10.Theme.TextDefault.Transparency else foundationTokens.Color.Content.Muted.Transparency
			local v80 = if not u74 then p10.Theme.IconDefault.Color else foundationTokens.Color.Content.Muted.Color3
			local v81 = if not u74 then p10.Theme.IconDefault.Transparency else foundationTokens.Color.Content.Muted.Transparency
			local titleText = p11.titleText
			local s1 = "Authentication.SignUp.Label.Birthday"
			local t3 = nil
			local titleText2 = p11.titleText

			if v11 and (p9.state.age ~= nil and p9.props.shouldUseBirthdayAgeLabel) then
				titleText = p11.titleTextWithAge
				s1 = "Authentication.SignUp.Label.BirthdayWithAge"
				t3 = {
					yearsOld = v54
				}
				titleText2 = p11.titleTextWithAgeTemplate
			end

			local Default = AuthStatefulRoundCornerBorder.BorderState.Default

			if selectedBirthday then
				datePlaceholder = v26:GetFormattedFullString(p11.monthText, selectedBirthday.Day, p11.dayAffix, selectedBirthday.Year, p11.yearAffix, " ", RobloxLocaleId)
				v78 = if not u74 then p10.Theme.TextDefault.Color else foundationTokens.Color.Content.Emphasis.Color3
				v79 = if not u74 then p10.Theme.TextDefault.Transparency else foundationTokens.Color.Content.Emphasis.Transparency
			end

			if isFocused then
				v80 = if not u74 then p10.Theme.TextDefault.Color else foundationTokens.Color.Content.Emphasis.Color3
				v81 = if not u74 then p10.Theme.TextDefault.Transparency else foundationTokens.Color.Content.Emphasis.Transparency
				Default = AuthStatefulRoundCornerBorder.BorderState.Focused
			elseif isHovering then
				v80 = if not u74 then p10.Theme.IconDefault.Color else foundationTokens.Color.Content.Muted.Color3
				v81 = if not u74 then p10.Theme.IconDefault.Transparency else foundationTokens.Color.Content.Muted.Transparency
				Default = AuthStatefulRoundCornerBorder.BorderState.Hover
			end

			local EmphasisColor3 = nil
			local EmphasisTransparency = nil
			local n1 = 36

			if u74 then
				n1 = foundationTokens.Size.Size_1200

				if Default == AuthStatefulRoundCornerBorder.BorderState.Focused then
					EmphasisColor3 = foundationTokens.Color.System.Emphasis.Color3
					EmphasisTransparency = foundationTokens.Color.System.Emphasis.Transparency
				else
					EmphasisColor3 = foundationTokens.Color.Stroke.Emphasis.Color3
					EmphasisTransparency = foundationTokens.Color.Stroke.Emphasis.Transparency
				end
			end

			return Roact.createElement(FitChildren.FitFrame, {
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				[Roact.Ref] = birthdayContainerRef
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				Title = Roact.createElement(FitTextLabel, {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					Text = titleText,
					Font = p10.Font.CaptionHeader.Font,
					TextSize = p10.Font.BaseSize * p10.Font.CaptionHeader.RelativeSize,
					TextColor3 = p10.Theme.TextEmphasis.Color,
					TextTransparency = p10.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				RegisterAuditContent = if not GetFFlagEnableAuditForSinglePageSignUp() or (not RegisterAuditContent or not p9.props.enableAuditContentCapture) then nil else Roact.createElement(RegisterAuditContent, {
					translationKey = s1,
					translatedSourceString = titleText2,
					parameters = t3
				}),
				BirthdayDropdown = p9.showBirthdayDropdown and Roact.createElement(BirthdayDropdown, {
					layoutOrder = 1,
					focusOnMount = true,
					localeId = RobloxLocaleId,
					onBirthdaySelected = p9.onBirthdaySelected,
					onDropdownOpened = p9.props.onBirthdayFocused,
					minAgeAllowed = FIntSignupMinimumAge,
					analyticsEventContext = EventStreamConstants.Context.SinglePageSignUpScreen
				}),
				TextInput = not p9.showBirthdayDropdown and Roact.createElement(AuthStatefulRoundCornerBorder, {
					layoutOrder = 1,
					size = UDim2.new(1, 0, 0, n1),
					borderState = Default,
					borderColorOverride = EmphasisColor3,
					borderTransparencyOverride = EmphasisTransparency
				}, {
					Base = Roact.createElement(DEPRECATED_ImageSetButton, {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = "LuaApp/buttons/buttonFill",
						ImageColor3 = if not u74 then p10.Theme.BackgroundUIContrast.Color else foundationTokens.Color.Shift.Shift_100.Color3,
						ImageTransparency = if not u74 then p10.Theme.BackgroundUIContrast.Transparency else foundationTokens.Color.Shift.Shift_100.Transparency,
						BorderSizePixel = 0,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9),
						[Roact.Ref] = buttonRef,
						[Roact.Event.Activated] = p9.onActivated,
						[Roact.Event.MouseEnter] = p9.onMouseEnter,
						[Roact.Event.MouseLeave] = p9.onMouseLeave
					}, {
						UIPadding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 0),
							PaddingBottom = UDim.new(0, 0),
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}),
						TextLabel = Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -16, 1, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							Text = datePlaceholder,
							Font = p10.Font.Body.Font,
							TextSize = p10.Font.BaseSize * p10.Font.Body.RelativeSize,
							TextColor3 = v78,
							TextTransparency = v79
						}),
						ImageLabel = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(1, 0, 0.5, 0),
							AnchorPoint = Vector2.new(1, 0.5),
							Image = v37,
							ImageColor3 = v80,
							ImageTransparency = v81
						})
					})
				})
			})
		end)
	end)
end

local v39 = RoactServices.connect({
	analytics = RoactAnalyticsAuthEvents
})(v38)
local v40 = RoactRodux.connect(nil, function(p12) -- line: 435
	-- upvalues: OpenCentralOverlayForSignUpBirthdayPicker (copy)
	return {
		openCentralOverlayForSignUpBirthdayPicker = function(p13) -- line: 437
			-- upvalues: p12 (copy), OpenCentralOverlayForSignUpBirthdayPicker (copy)
			p12(OpenCentralOverlayForSignUpBirthdayPicker(p13))
		end
	}
end)(v39)

if v11 then
	v40 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.SignupLayer }, function(p14, _) -- line: 446
		-- upvalues: AppBtidLayers (copy)
		return {
			shouldUseBirthdayAgeLabel = (p14[AppBtidLayers.SignupLayer] or {}).shouldUseBirthdayAgeLabel
		}
	end)(v40)
end

if GetFFlagAuthBirthdayBarFoundationColors() then
	v40 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.AuthenticationStylingLayer }, function(p16, _) -- line: 457
		-- upvalues: AppBtidLayers (copy)
		return {
			shouldUseFoundationBirthdayBarColors = (p16[AppBtidLayers.AuthenticationStylingLayer] or {}).shouldUseFoundationBirthdayBarColors
		}
	end)(v40)
end

if GetFFlagAuthBirthdayBarFoundationColors() then
	local v41 = v40

	function v40(p18) -- line: 467
		-- upvalues: useTokens (copy), React (copy), v41 (copy), Cryo (copy)
		local v61 = useTokens()

		return React.createElement(v41, Cryo.Dictionary.join(p18 or {}, {
			foundationTokens = v61
		}))
	end
end

return v40
