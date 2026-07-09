local MultiPageSignup = script:FindFirstAncestor("MultiPageSignup")
local MultiPageSignupParent = MultiPageSignup.Parent
local RobloxLocaleId = game:GetService("LocalizationService").RobloxLocaleId
local React = require(MultiPageSignupParent.React)
local UserActivationFramework = require(MultiPageSignupParent.UserActivationFramework)
local AuthCommon = require(MultiPageSignupParent.AuthCommon)
local AuthSignup = require(MultiPageSignupParent.AuthSignup)
local UIBlox = require(MultiPageSignupParent.UIBlox)
local debounce = require(MultiPageSignup.Utils.debounce)
local Birthday = AuthCommon.Models.Birthday
local BirthdayPicker = AuthSignup.Components.BirthdayPicker
local FullPageActivationFrameworkContext = UserActivationFramework.Context.FullPageActivationFrameworkContext
local ActivationFrameworkWrapper = UserActivationFramework.Components.ActivationFrameworkWrapper
local CallbackStatus = UserActivationFramework.Enums.CallbackStatus
local PayloadKey = UserActivationFramework.Enums.PayloadKey
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLocalization = require(MultiPageSignupParent.Localization).Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require(MultiPageSignupParent.Style).useDesignTokens
local TitleAndParagraph = AuthCommon.Components.TitleAndParagraph
local DisclaimerLinks = AuthCommon.Components.DisclaimerLinks
local GetFFlagEnableSignupFoundationText = require(MultiPageSignupParent.SharedFlags).GetFFlagEnableSignupFoundationText
local Foundation = require(MultiPageSignupParent.Foundation)
local FoundationText = Foundation.Text
local SharedFlags = require(MultiPageSignupParent.SharedFlags)
local FIntSignupMinimumAge = SharedFlags.FIntSignupMinimumAge
local MultiPageSignupConstants = require(MultiPageSignup.Analytics.MultiPageSignupConstants)
local AuthAnalytics = require(MultiPageSignupParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local GetFFlagEnableMultiPageSignupV2Updates = SharedFlags.GetFFlagEnableMultiPageSignupV2Updates
local DateHelper = require(MultiPageSignupParent.Time).DateHelper

return function(t1: {[any]: any}) -- line: 52
	-- upvalues: React (copy), FullPageActivationFrameworkContext (copy), DateHelper (copy), useLocalization (copy), useStyle (copy), useDesignTokens (copy), Birthday (copy), authFormInteraction (copy), MultiPageSignupConstants (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), RobloxLocaleId (copy), debounce (copy), authMsgShown (copy), EventStreamConstants (copy), FIntSignupMinimumAge (copy), ActivationFrameworkWrapper (copy), PayloadKey (copy), CallbackStatus (copy), TitleAndParagraph (copy), DisclaimerLinks (copy), BirthdayPicker (copy), GetFFlagEnableSignupFoundationText (copy), FoundationText (copy), StyledTextLabel (copy), Foundation (copy)
	local v35, v36 = React.useState(nil)
	local v37, v38 = React.useState(nil)
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useState("")
	local activationFrameworkState = React.useContext(FullPageActivationFrameworkContext).activationFrameworkState
	local v44 = nil

	if v35 then
		v44 = DateHelper.MonthsLocalizationKeys[v35.Month] or nil
	end

	local v45 = useLocalization({
		birthdayHint = "Authentication.SignUp.Label.SelectYourBirthday",
		birthdayLabel = "Authentication.SignUp.Label.Birthday",
		invalidBirthdayText = "Authentication.SignUp.Label.Error.MinimumAge5",
		nextButtonText = "Authentication.SignUp.Action.NextWord",
		monthText = v44,
		dayAffix = DateHelper.DayAffixLocalizationKey,
		yearAffix = DateHelper.YearAffixLocalizationKey,
		ageText = {
			"Authentication.SignUp.Label.YearsOld",
			yearsOld = not v37 and "" or tostring(v37)
		}
	})
	local v46 = useLocalization({
		fullDateString = {
			"Authentication.SignUp.Label.FullDateString",
			Month = v45.monthText,
			Day = not v35 and "" or tostring(v35.Day),
			Year = not v35 and "" or tostring(v35.Year)
		}
	})
	local v47 = useStyle()
	local v48 = useDesignTokens()
	local v49 = React.useCallback(function(n1: number, n2: number, n3: number) -- line: 92
		-- upvalues: v35 (copy), DateHelper (copy), Birthday (copy), authFormInteraction (copy), MultiPageSignupConstants (copy), v36 (copy), v38 (copy)
		if (v35 == nil or (n1 ~= v35.Month or n2 ~= v35.Day or n3 ~= v35.Year)) and DateHelper:isValidDate(n1, n2, n3) then
			local v55 = Birthday.new({
				Month = n1,
				Day = n2,
				Year = n3
			})

			authFormInteraction(MultiPageSignupConstants.ctx.multiPageSignup, MultiPageSignupConstants.field.updateBirthday, MultiPageSignupConstants.state.enterBirthdayComponent)
			v36(v55)
			v38(v55:GetAgeInYears())
		end
	end, { v35 })

	React.useEffect(function() -- line: 112
		-- upvalues: v35 (copy), v42 (copy), v45 (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), v46 (copy), DateHelper (copy), RobloxLocaleId (copy)
		if v35 == nil then
			v42(v45.birthdayHint)

			return
		end

		if GetFFlagEnableMultiPageSignupV2Updates() then
			v42(v46.fullDateString .. " " .. v45.ageText)

			return
		end

		local v56 = not v35 and "" or DateHelper:GetFormattedFullString(v45.monthText, v35.Day, v45.dayAffix, v35.Year, v45.yearAffix, " ", RobloxLocaleId)

		v42(v56 .. " " .. v45.ageText)
	end, {
		v45.monthText,
		v45.dayAffix,
		v45.yearAffix,
		v35
	})

	local v50 = React.useCallback(debounce(function(p1) -- line: 137
		-- upvalues: authMsgShown (copy), t1 (copy), activationFrameworkState (copy), EventStreamConstants (copy)
		if p1 then
			authMsgShown(t1.namespace, activationFrameworkState.currentState, EventStreamConstants.Field.InvalidBirthday)
		end
	end, 1), {})

	React.useEffect(function() -- line: 149
		-- upvalues: v37 (copy), FIntSignupMinimumAge (copy), v40 (copy), v50 (copy)
		if v37 == nil then
			return
		end

		local v58 = v37 < FIntSignupMinimumAge

		v40(v58)
		v50(v58)
	end, { v37 })

	local v51 = not not v35 and (not v39 or false)

	return React.createElement(ActivationFrameworkWrapper, {
		titleTextKey = "Authentication.SignUp.Label.BirthdayHeaderB",
		bodyTextKey = "Authentication.SignUp.Description.BirthdayHelp3",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		shouldExpandMiddleContent = true,
		namespace = t1.namespace,
		primaryButton = {
			buttonTextKey = "Authentication.SignUp.Action.NextWord",
			shouldShowButton = true,
			isButtonEnabled = v51,
			onButtonClicked = function() -- line: 170
				-- upvalues: PayloadKey (copy), Birthday (copy), v35 (copy), v37 (copy), CallbackStatus (copy)
				return {
					payloadAddendum = {
						[PayloadKey.SignupBirthdayTimestampUtc] = Birthday.FormatForEndpoint(v35),
						[PayloadKey.SignupAge] = tostring(v37)
					},
					status = CallbackStatus.Success
				}
			end
		},
		subFooterContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, v48.Size.Size_100)
			}),
			DisclaimerText = React.createElement(TitleAndParagraph, {
				LayoutOrder = 1,
				textXAlignment = Enum.TextXAlignment.Left,
				paragraphTextKeys = { "Authentication.SignUp.Description.ClickNextAgreeToTerms" },
				paragraphTextArgs = {{}}
			}),
			DisclaimerLinks = React.createElement(DisclaimerLinks, {
				LayoutOrder = 2,
				ctx = t1.namespace,
				state = activationFrameworkState.currentState
			})
		}),
		navigation = t1.navigation
	}, {
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v48.Size.Size_100)
			}),
			BirthdayPicker = React.createElement(BirthdayPicker, {
				LayoutOrder = 1,
				skipUpdateOnMount = false,
				shouldExpandTapTarget = true,
				tapTargetExpansionSize = 200,
				minAgeAllowed = FIntSignupMinimumAge,
				updateBirthday = v49
			}),
			ErrorSpacing = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v48.Size.Size_200)
			}),
			ErrorTextLabel = if not GetFFlagEnableSignupFoundationText() then React.createElement(StyledTextLabel, {
				layoutOrder = 3,
				textWrapped = true,
				text = not v39 and "" or v45.invalidBirthdayText,
				fontStyle = v47.Font.BodySmall,
				colorStyle = v47.Theme.Alert,
				automaticSize = Enum.AutomaticSize.XY
			}) else React.createElement(FoundationText, {
				LayoutOrder = 3,
				tag = "text-body-small text-align-x-center size-full-0 auto-y",
				TextWrapped = true,
				Text = not v39 and "" or v45.invalidBirthdayText,
				textStyle = {
					Color3 = v47.Theme.Alert.Color,
					Transparency = v47.Theme.Alert.Transparency
				}
			})
		}),
		SelectedBirthdayText = React.createElement(Foundation.Text, {
			tag = "text-label-medium text-align-x-center size-full-0 auto-y position-bottom-center anchor-bottom-center",
			Text = v41
		})
	})
end
