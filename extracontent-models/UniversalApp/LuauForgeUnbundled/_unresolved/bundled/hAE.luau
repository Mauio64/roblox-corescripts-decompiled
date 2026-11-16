local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local timeUnit = require("@luauforge/bundled/fAu").TimeUnit
local dateHelper = require("@luauforge/bundled/fAu").DateHelper

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/fTi")

local defineFastInt = game:DefineFastInt("BirthdateDropDownMinimumAge", 5)

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local birthday = AuthCommon.Models.Birthday
local registerAuditContent = AuthCommon.Components.RegisterAuditContent
local module3 = require("@luauforge/bundled/hAF")

local getFFlagEnableAuditForSso = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSso

local function fn()
	local v5 = module({ titleText = "Authentication.SignUp.Label.Birthday" })

	if v5.titleText then
		return React.createElement(registerAuditContent, {
			translationKey = "Authentication.SignUp.Label.Birthday",
			translatedSourceString = v5.titleText
		})
	end

	return nil
end

return function(props)
	local state, setState = React.useState(nil)
	local signUpView = useDesignTokens().LuaApps.SignUpView
	local v5 = React.useMemo(function()
		return {
			textCaptionHeaderSize = signUpView.textCaptionHeaderSize,
			textBodySize = signUpView.textBodySize,
			dropdownHeight = signUpView.dropdownHeight,
			dropdownHorizontalPadding = signUpView.dropdownHorizontalPadding,
			dropdownVerticalPadding = signUpView.dropdownVerticalPadding,
			dateDropdownWidth = signUpView.dateDropdownWidth
		}
	end, { signUpView })
	local v6 = useSelector(function(p2)
		return p2.ScreenSize or Vector2.new(1920, 1080)
	end)

	local v7 = React.useCallback(function(p2)
		local v8 = p2[timeUnit.Years]
		local v9 = p2[timeUnit.Months]
		local v10 = p2[timeUnit.Days]

		if v8 ~= 0 and v9 ~= 0 and v10 ~= 0 then
			local v11 = birthday.new({ Year = v8, Month = v9, Day = v10 })
			local v12

			if dateHelper:isValidDate(v9, v10, v8) then
				v12 = true

				if dateHelper:isFutureDate(v9, v10, v8) then
					v12 = false
				elseif v11:GetAgeInYears() < defineFastInt then
					v12 = false
				end
			else
				v12 = false
			end

			setState(v12)
			props.onBirthdaySelected(v11, v12)
		end
	end, { props.onBirthdaySelected })

	local v8 = math.min(v6.Y, 480)

	local currentDate = dateHelper:getCurrentDate()
	local v9 = currentDate[timeUnit.Years] - defineFastInt
	local v10 = currentDate[timeUnit.Years] - 100

	local v11 = {
		size = UDim2.new(0.75, 0, 1, 0),
		titleKey = "Authentication.SignUp.Label.Birthday",
		errorTextKey = state == false and "Authentication.SignUp.Response.InvalidBirthday" or nil,
		maxYear = v9,
		minYear = v10,
		onDateSelected = v7,
		horizontalInnerPadding = UDim.new(0, 18),
		fixedListHeight = v8,
		alignment = props.alignment,
		layoutOrder = props.layoutOrder,
		designTokens = v5
	}

	if not getFFlagEnableAuditForSso() then
		return React.createElement(module3, v11)
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v13 = {
		DateDropdownSelector = React.createElement(module3, v11),
		RegisterTitleAuditContent = 0
	}
	local v14 = if registerAuditContent and props.enableAuditContentCapture then React.createElement(fn) else nil
	v13.RegisterTitleAuditContent = v14
	return createElement(fragment, nil, v13)
end
