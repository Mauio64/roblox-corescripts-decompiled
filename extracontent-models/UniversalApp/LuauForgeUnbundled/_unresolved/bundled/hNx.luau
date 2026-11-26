local LocalizationService = game:GetService("LocalizationService")
local robloxLocaleId = LocalizationService.RobloxLocaleId
local module = require("@luauforge/bundled/hNw")
local module2 = require("@luauforge/bundled/hMJ")
local module3 = require("@luauforge/bundled/hNy")
local module4 = require("@luauforge/bundled/hNz")
local module5 = require("@luauforge/bundled/hNA")
local module6 = require("@luauforge/bundled/hNB")

local birthday = module3.Models.Birthday
local birthdayPicker = module4.Components.BirthdayPicker
local fullPageActivationFrameworkContext = module2.Context.FullPageActivationFrameworkContext
local activationFrameworkWrapper = module2.Components.ActivationFrameworkWrapper
local callbackStatus = module2.Enums.CallbackStatus
local payloadKey = module2.Enums.PayloadKey

local styledTextLabel = module5.App.Text.StyledTextLabel
local useLocalization = require("@luauforge/bundled/hNC").Hooks.useLocalization
local useStyle = module5.Core.Style.useStyle
local useDesignTokens = require("@luauforge/bundled/hND").useDesignTokens
local titleAndParagraph = module3.Components.TitleAndParagraph
local disclaimerLinks = module3.Components.DisclaimerLinks

local getFFlagEnableSignupFoundationText = require("@luauforge/bundled/hNE").GetFFlagEnableSignupFoundationText
local module7 = require("@luauforge/bundled/hNF")
local text = module7.Text

local module8 = require("@luauforge/bundled/hNE")

local fIntSignupMinimumAge = module8.FIntSignupMinimumAge
local module9 = require("@luauforge/bundled/hNG")
local module10 = require("@luauforge/bundled/hNH")
local eventStreamConstants = module10.EventStreamConstants
local authMsgShown = module10.Events.authMsgShown
local authFormInteraction = module10.Events.authFormInteraction
local getFFlagEnableMultiPageSignupV2Updates = module8.GetFFlagEnableMultiPageSignupV2Updates

local dateHelper = require("@luauforge/bundled/hNI").DateHelper

return function(p2)
	local state, setState = module.useState(nil)

	local state2, setState2 = module.useState(nil)
	local state3, setState3 = module.useState(false)
	local state4, setState4 = module.useState("")

	local activationFrameworkState = module.useContext(fullPageActivationFrameworkContext).activationFrameworkState

	local v5 = if state then dateHelper.MonthsLocalizationKeys[state.Month] or nil else nil

	local v6 = useLocalization({
		monthText = v5,
		dayAffix = dateHelper.DayAffixLocalizationKey,
		yearAffix = dateHelper.YearAffixLocalizationKey,
		birthdayHint = "Authentication.SignUp.Label.SelectYourBirthday",
		birthdayLabel = "Authentication.SignUp.Label.Birthday",
		invalidBirthdayText = "Authentication.SignUp.Label.Error.MinimumAge5",
		nextButtonText = "Authentication.SignUp.Action.NextWord",
		ageText = {
			"Authentication.SignUp.Label.YearsOld",
			yearsOld = not state2 and "" or tostring(state2)
		}
	})

	local v7 = useLocalization({
		fullDateString = {
			"Authentication.SignUp.Label.FullDateString",
			Month = v6.monthText,
			Day = not state and "" or tostring(state.Day),
			Year = not state and "" or tostring(state.Year)
		}
	})

	local v8 = useStyle()
	local v9 = useDesignTokens()

	local v10 = module.useCallback(function(p3, p4, p5)
		if
			(state == nil or state.Month ~= p3 or state.Day ~= p4 or state.Year ~= p5)
			and dateHelper:isValidDate(p3, p4, p5)
		then
			local v11 = birthday.new({ Month = p3, Day = p4, Year = p5 })

			authFormInteraction(
				module9.ctx.multiPageSignup,
				module9.field.updateBirthday,
				module9.state.enterBirthdayComponent
			)

			setState(v11)
			setState2(v11:GetAgeInYears())
		end
	end, { state })

	module.useEffect(function()
		if state == nil then
			setState4(v6.birthdayHint)
			return
		end

		if getFFlagEnableMultiPageSignupV2Updates() then
			setState4(v7.fullDateString .. " " .. v6.ageText)
			return
		end

		setState4((not state and "" or dateHelper:GetFormattedFullString(
			v6.monthText,
			state.Day,
			v6.dayAffix,
			state.Year,
			v6.yearAffix,
			" ",
			robloxLocaleId
		)) .. " " .. v6.ageText)
	end, { v6.monthText, v6.dayAffix, v6.yearAffix, state })

	local v11 = module.useCallback(module6(function(p3)
		if p3 then
			authMsgShown(
				p2.namespace,
				activationFrameworkState.currentState,
				eventStreamConstants.Field.InvalidBirthday
			)
		end
	end, 1), {})

	module.useEffect(function()
		if state2 == nil then
			return
		end

		local v12 = state2 < fIntSignupMinimumAge
		setState3(v12)
		v11(v12)
	end, { state2 })
	local v12 = if state then not state3 or false else false
	local createElement = module.createElement
	local v14 = {
		namespace = p2.namespace,
		titleTextKey = "Authentication.SignUp.Label.BirthdayHeaderB",
		bodyTextKey = "Authentication.SignUp.Description.BirthdayHelp3",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		primaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.NextWord",
			shouldShowButton = true,
			isButtonEnabled = v12,
			onButtonClicked = function()
				return {
					payloadAddendum = {
						[payloadKey.SignupBirthdayTimestampUtc] = birthday.FormatForEndpoint(state),
						[payloadKey.SignupAge] = tostring(state2)
					},
					status = callbackStatus.Success
				}
			end
		},
		shouldExpandMiddleContent = true,
		subFooterContent = module.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					Padding = UDim.new(0, v9.Size.Size_100)
				}),
				DisclaimerText = module.createElement(titleAndParagraph, {
					LayoutOrder = 1,
					textXAlignment = Enum.TextXAlignment.Left,
					paragraphTextKeys = { "Authentication.SignUp.Description.ClickNextAgreeToTerms" },
					paragraphTextArgs = { {} }
				}),
				DisclaimerLinks = module.createElement(disclaimerLinks, {
					ctx = p2.namespace,
					state = activationFrameworkState.currentState,
					LayoutOrder = 2
				})
			}
		),
		navigation = p2.navigation
	}

	local createElement2 = module.createElement
	local v16 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }
	local v17 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v9.Size.Size_100)
		}),
		BirthdayPicker = module.createElement(birthdayPicker, {
			LayoutOrder = 1,
			skipUpdateOnMount = false,
			minAgeAllowed = fIntSignupMinimumAge,
			updateBirthday = v10,
			shouldExpandTapTarget = true,
			tapTargetExpansionSize = 200
		}),
		ErrorSpacing = module.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v9.Size.Size_200)
		}),
		ErrorTextLabel = 0
	}
	local v18

	if getFFlagEnableSignupFoundationText() then
		v18 = module.createElement(text, {
			LayoutOrder = 3,
			Text = not state3 and "" or v6.invalidBirthdayText,
			textStyle = {
				Color3 = v8.Theme.Alert.Color,
				Transparency = v8.Theme.Alert.Transparency
			},
			tag = "text-body-small text-align-x-center size-full-0 auto-y",
			TextWrapped = true
		})
	else
		v18 = module.createElement(styledTextLabel, {
			layoutOrder = 3,
			text = not state3 and "" or v6.invalidBirthdayText,
			fontStyle = v8.Font.BodySmall,
			colorStyle = v8.Theme.Alert,
			automaticSize = Enum.AutomaticSize.XY,
			textWrapped = true
		})
	end

	v17.ErrorTextLabel = v18
	return createElement(activationFrameworkWrapper, v14, {
		Content = createElement2("Frame", v16, v17),
		SelectedBirthdayText = module.createElement(module7.Text, {
			Text = state4,
			tag = "text-label-medium text-align-x-center size-full-0 auto-y position-bottom-center anchor-bottom-center"
		})
	})
end
