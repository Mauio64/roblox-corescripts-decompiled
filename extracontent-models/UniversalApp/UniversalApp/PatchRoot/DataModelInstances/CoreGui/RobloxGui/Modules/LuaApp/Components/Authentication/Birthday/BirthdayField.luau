local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local TextInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AgeAndMonthInput = require(Modules.LuaApp.Components.Authentication.Birthday.AgeAndMonthInput)
local MonthAndYearInput = require(Modules.LuaApp.Components.Authentication.Birthday.MonthAndYearInput)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local _ = {
	Age = 1,
	AgeMonth = 2,
	MonthYear = 3
}

local function BirthdayField(t1: {[any]: any}) -- line: 39
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), AuthStatefulRoundCornerBorder (copy), EventStreamConstants (copy), TextInputBoxWithBorder (copy), AgeAndMonthInput (copy), MonthAndYearInput (copy)
	local v17 = useStyle()
	local v18 = useLocalization({
		ageLabel = "Authentication.SignUp.Label.Age",
		helpText = "Authentication.SignUp.Description.BirthdayValuePropC",
		errorMessage = "Authentication.SignUp.Response.InvalidBirthday"
	})
	local v19, v20 = React.useState(AuthStatefulRoundCornerBorder.BorderState.Default)
	local v21, v22 = React.useState(false)

	local function v23() -- line: 59
		-- upvalues: t1 (copy), v20 (copy), AuthStatefulRoundCornerBorder (copy), EventStreamConstants (copy), v22 (copy)
		if not t1.hasBirthdayError and t1.variant == 1 then
			v20(AuthStatefulRoundCornerBorder.BorderState.Focused)
		end

		t1.analytics.reportAgeFocus(EventStreamConstants.Context.SinglePageSignUpScreen)
		v22(true)
	end
	local function v24() -- line: 67
		-- upvalues: t1 (copy), v20 (copy), AuthStatefulRoundCornerBorder (copy), v22 (copy)
		if not t1.hasBirthdayError and t1.variant == 1 then
			v20(AuthStatefulRoundCornerBorder.BorderState.Default)
		end

		v22(false)
	end
	local function v25() -- line: 83
		-- upvalues: t1 (copy), EventStreamConstants (copy)
		t1.analytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.ConfirmBirthdayMonth)
	end

	React.useEffect(function() -- line: 90
		-- upvalues: t1 (copy), v20 (copy), AuthStatefulRoundCornerBorder (copy)
		if t1.hasBirthdayError then
			v20(AuthStatefulRoundCornerBorder.BorderState.Error)

			return
		end

		v20(AuthStatefulRoundCornerBorder.BorderState.Default)
	end, { t1.hasBirthdayError })
	React.useEffect(function() -- line: 98
		-- upvalues: t1 (copy)
		if t1.variant == 1 and (t1.ageTextFieldRef and t1.ageTextFieldRef.current) then
			t1.ageTextFieldRef.current:CaptureFocus()
		end
	end, {
		t1.variant,
		t1.ageTextFieldRef.current
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 4,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, -10)
		}),
		AgeInput = t1.variant == 1 and React.createElement(TextInputBoxWithBorder, {
			textInputListPadding = 6,
			layoutOrder = 3,
			textInputType = Enum.TextInputType.Number,
			textInputHeight = t1.textInputHeight,
			placeholderText = v18.ageLabel,
			labelText = v18.ageLabel,
			borderState = v19,
			onChangeTextCallback = function() -- line: 49
				-- upvalues: t1 (copy)
				if t1.ageTextFieldRef and t1.ageTextFieldRef.current then
					local currentText = t1.ageTextFieldRef.current.Text

					if string.len(currentText) > 2 then
						t1.ageTextFieldRef.current.Text = string.sub(currentText, 1, 2)
					end
				end

				t1.onAgeChange(t1.ageTextFieldRef.current.Text)
			end,
			errorText = t1.hasBirthdayError and v18.errorMessage or "",
			onFocused = v23,
			onFocusLost = v24,
			textBoxRef = t1.ageTextFieldRef
		}),
		AgeAndMonthInput = t1.variant == 2 and React.createElement(AgeAndMonthInput, {
			layoutOrder = 3,
			errorText = t1.hasBirthdayError and v18.errorMessage or "",
			textInputHeight = t1.textInputHeight,
			onAgeAndMonthChange = t1.onAgeAndMonthChange,
			onFocused = v23,
			onFocusLost = v24,
			onMonthInputConfirmed = v25,
			screenSize = t1.screenSize,
			textBoxRef = t1.ageTextFieldRef
		}),
		MonthAndYearInput = t1.variant == 3 and React.createElement(MonthAndYearInput, {
			layoutOrder = 3,
			errorText = t1.hasBirthdayError and v18.errorMessage or "",
			textInputHeight = t1.textInputHeight,
			onMonthAndYearChange = t1.onMonthAndYearChange,
			onFocused = function() -- line: 74
				-- upvalues: t1 (copy), EventStreamConstants (copy), v22 (copy)
				t1.analytics.reportYearFocus(EventStreamConstants.Context.SinglePageSignUpScreen)
				v22(true)
			end,
			onFocusLost = function() -- line: 79
				-- upvalues: v22 (copy)
				v22(false)
			end,
			onMonthInputConfirmed = v25,
			screenSize = t1.screenSize,
			textBoxRef = t1.ageTextFieldRef
		}),
		Padding = t1.hasBirthdayError and React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 5,
			Size = UDim2.new(0, 0, 0, 21)
		}),
		ValueProp = v21 and React.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			ZIndex = 0,
			LayoutOrder = 6,
			Text = v18.helpText,
			Font = v17.Font.CaptionBody.Font,
			TextSize = v17.Font.BaseSize * v17.Font.CaptionBody.RelativeSize,
			TextColor3 = v17.Theme.TextDefault.Color,
			TextTransparency = v17.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	})
end

return (RoactServices.connect({
	analytics = RoactAnalyticsAuthEvents
})(BirthdayField))
