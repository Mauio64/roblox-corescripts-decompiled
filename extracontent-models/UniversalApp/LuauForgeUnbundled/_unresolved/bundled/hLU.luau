local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local timeUnit = require("@luauforge/bundled/geM").TimeUnit
local dateHelper = require("@luauforge/bundled/geM").DateHelper

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/gxM")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local defineFastInt = game:DefineFastInt("BirthdateDropDownMinimumAge", 5)

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local birthday = AuthCommon.Models.Birthday
local registerAuditContent = AuthCommon.Components.RegisterAuditContent
local module4 = require("@luauforge/bundled/hLV")

local getFFlagEnableAuditForSso = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSso
local module5 = require("@luauforge/bundled/hLT")

local fFlagEnableMetaSignupMinimumAgePolicy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMetaSignupMinimumAgePolicy

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

local function useMinimumAge()
	local v5 = useAppPolicy(function(p2)
		return p2.getMetaSignupMinimumAge()
	end)

	if v5 == nil then
		return defineFastInt
	end

	return (math.max(v5, defineFastInt))
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
	local v6 = defineFastInt

	if fFlagEnableMetaSignupMinimumAgePolicy and isVRAppBuild() then
		local v7 = useAppPolicy(function(p2)
			return p2.getMetaSignupMinimumAge()
		end)

		v6 = if v7 == nil then defineFastInt else math.max(v7, defineFastInt)
	end

	local v7 = useSelector(function(p2)
		return p2.ScreenSize or Vector2.new(1920, 1080)
	end)
	local v8

	if fFlagEnableMetaSignupMinimumAgePolicy then
		v8 = { props.onBirthdaySelected, v6 }
	else
		v8 = { props.onBirthdaySelected }
	end

	local v9 = React.useCallback(function(p2)
		local v10 = p2[timeUnit.Years]
		local v11 = p2[timeUnit.Months]
		local v12 = p2[timeUnit.Days]

		if v10 ~= 0 and v11 ~= 0 and v12 ~= 0 then
			local v13 = birthday.new({ Year = v10, Month = v11, Day = v12 })
			local v14

			if dateHelper:isValidDate(v11, v12, v10) then
				v14 = true

				if dateHelper:isFutureDate(v11, v12, v10) then
					v14 = false
				elseif v13:GetAgeInYears() < v6 then
					v14 = false
				end
			else
				v14 = false
			end

			setState(v14)
			props.onBirthdaySelected(v13, v14)
		end
	end, v8)

	local v10 = math.min(v7.Y, 480)

	local currentDate = dateHelper:getCurrentDate()
	local v11 = currentDate[timeUnit.Years] - v6
	local v12 = currentDate[timeUnit.Years] - 100

	local v13 = {
		size = UDim2.new(0.75, 0, 1, 0),
		titleKey = "Authentication.SignUp.Label.Birthday",
		errorTextKey = state == false and "Authentication.SignUp.Response.InvalidBirthday" or nil,
		maxYear = v11,
		minYear = v12,
		onDateSelected = v9,
		horizontalInnerPadding = UDim.new(0, 18),
		fixedListHeight = v10,
		alignment = props.alignment,
		layoutOrder = props.layoutOrder,
		designTokens = v5,
		onMenuOpenChange = 0
	}

	local v14 = if module5 then props.onMenuOpenChange else nil
	v13.onMenuOpenChange = v14

	if not getFFlagEnableAuditForSso() then
		return React.createElement(module4, v13)
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v16 = {
		DateDropdownSelector = React.createElement(module4, v13),
		RegisterTitleAuditContent = 0
	}
	local v17 = if registerAuditContent and props.enableAuditContentCapture then React.createElement(fn) else nil
	v16.RegisterTitleAuditContent = v17
	return createElement(fragment, nil, v16)
end
