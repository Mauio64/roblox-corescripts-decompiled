local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local TimeUnit = require(CorePackages.Workspace.Packages.Time).TimeUnit
local DateHelper = require(CorePackages.Workspace.Packages.Time).DateHelper
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local v9 = game:DefineFastInt("BirthdateDropDownMinimumAge", 5)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local Birthday = AuthCommon.Models.Birthday
local RegisterAuditContent = AuthCommon.Components.RegisterAuditContent
local DateDropdownSelector = require(Modules.LuaApp.Components.Authentication.DateDropdownSelector)
local GetFFlagEnableAuditForSso = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuditForSso

local function v15() -- line: 35
	-- upvalues: useLocalization (copy), React (copy), RegisterAuditContent (copy)
	local v16 = useLocalization({
		titleText = "Authentication.SignUp.Label.Birthday"
	})

	if not v16.titleText then
		return nil
	end

	return React.createElement(RegisterAuditContent, {
		translationKey = "Authentication.SignUp.Label.Birthday",
		translatedSourceString = v16.titleText
	})
end

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), useDesignTokens (copy), useSelector (copy), TimeUnit (copy), Birthday (copy), DateHelper (copy), v9 (copy), GetFFlagEnableAuditForSso (copy), DateDropdownSelector (copy), RegisterAuditContent (copy), v15 (copy)
	local v18, v19 = React.useState(nil)
	local SignUpView = useDesignTokens().LuaApps.SignUpView
	local v21 = React.useMemo(function() -- line: 50
		-- upvalues: SignUpView (copy)
		return {
			textCaptionHeaderSize = SignUpView.textCaptionHeaderSize,
			textBodySize = SignUpView.textBodySize,
			dropdownHeight = SignUpView.dropdownHeight,
			dropdownHorizontalPadding = SignUpView.dropdownHorizontalPadding,
			dropdownVerticalPadding = SignUpView.dropdownVerticalPadding,
			dateDropdownWidth = SignUpView.dateDropdownWidth
		}
	end, { SignUpView })
	local v22 = useSelector(function(p1) -- line: 60
		return p1.ScreenSize or Vector2.new(1920, 1080)
	end)
	local v23 = React.useCallback(function(p2) -- line: 63
		-- upvalues: TimeUnit (copy), Birthday (copy), DateHelper (copy), v9 (copy), v19 (copy), t1 (copy)
		local v31 = p2[TimeUnit.Years]
		local v32 = p2[TimeUnit.Months]
		local v33 = p2[TimeUnit.Days]

		if v31 ~= 0 and (v32 ~= 0 and v33 ~= 0) then
			local v34 = Birthday.new({
				Year = v31,
				Month = v32,
				Day = v33
			})
			local v35 = false

			if DateHelper:isValidDate(v32, v33, v31) then
				v35 = true

				if DateHelper:isFutureDate(v32, v33, v31) then
					v35 = false
				elseif v34:GetAgeInYears() < v9 then
					v35 = false
				end
			end

			v19(v35)
			t1.onBirthdaySelected(v34, v35)
		end
	end, { t1.onBirthdaySelected })
	local v24 = math.min(v22.Y, 480)
	local v25 = DateHelper:getCurrentDate()
	local v26 = v25[TimeUnit.Years] - v9
	local v27 = v25[TimeUnit.Years] - 100
	local t2 = {
		titleKey = "Authentication.SignUp.Label.Birthday",
		size = UDim2.new(0.75, 0, 1, 0),
		errorTextKey = if v18 ~= false then nil else "Authentication.SignUp.Response.InvalidBirthday",
		maxYear = v26,
		minYear = v27,
		onDateSelected = v23,
		horizontalInnerPadding = UDim.new(0, 18),
		fixedListHeight = v24,
		alignment = t1.alignment,
		layoutOrder = t1.layoutOrder,
		designTokens = v21
	}

	if GetFFlagEnableAuditForSso() then
		return React.createElement(React.Fragment, nil, {
			DateDropdownSelector = React.createElement(DateDropdownSelector, t2),
			RegisterTitleAuditContent = if not RegisterAuditContent or not t1.enableAuditContentCapture then nil else React.createElement(v15)
		})
	end

	return React.createElement(DateDropdownSelector, t2)
end
