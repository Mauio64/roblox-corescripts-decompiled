local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/deferred/fya")
local module2 = require("@luauforge/deferred/hGS")
local module3 = require("@luauforge/bundled/fox")
local module4 = require("@luauforge/deferred/hGU")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local useProperty = require("@luauforge/bundled/frw").useProperty

local fFlagLuaAppResponsiveEnginePreferredInput = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppResponsiveEnginePreferredInput
local module6 = require("@luauforge/deferred/hHv")

local fFlagEnableMorePageExitButtonSupport = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMorePageExitButtonSupport

local fFlagEnableMorePageDirectionalLayoutRolloutFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMorePageDirectionalLayoutRolloutFix
local defineFastFlag = game:DefineFastFlag("MorePageExitButtonNotAllowed", false)

local fFlagLuaAppEnableMorePageProfileLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableMorePageProfileLink

local sources = nil
local v5 = nil
local fn

if fFlagLuaAppEnableMorePageProfileLink then
	sources = require("@luauforge/bundled/dYV").Analytics.Enums.Sources
	v5 = require("@luauforge/bundled/hEC")

	fn = function()
		return React.createElement(v5, { source = sources.MorePageSelfWidget })
	end
else
	fn = nil
end

local useNavBarPlacement = if module6 then require("@luauforge/bundled/dHu").useNavBarPlacement else nil

return function()
	local backgroundDefault = useStyle().Theme.BackgroundDefault
	local v6 = useBreakpointXOrLarger(Responsive.Keys.Medium)
	local v7 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)

	local v8 = module2()
	local v9 = React.useMemo(function()
		return Dash.reduce(v8, function(list, p2)
			if p2.type == module.SectionType.Navigation then
				return { Dash.append(list[1], p2.contents), list[2] }
			end

			if p2.type == module.SectionType.Action then
				return { list[1], Dash.append(list[2], p2.contents) }
			end

			return list
		end, { {}, {} })
	end, { v8 })

	local v10 = false
	local v11

	if fFlagEnableMorePageDirectionalLayoutRolloutFix then
		v11 = useAppPolicy(function(p2)
			return p2.getMoreGridDirectionalLayoutPreferred()
		end)
	else
		local v12 = useProperty(UserInputService, "TouchEnabled")
		local v13 = useProperty(UserInputService, "KeyboardEnabled")
		local v14 = useProperty(UserInputService, "MouseEnabled")

		if fFlagLuaAppResponsiveEnginePreferredInput then
			v11 = Responsive.usePreferredInput() == Responsive.Input.Directional and not (v12 or v13 or v14)
		else
			v11 = Responsive.usePreferredInput() == Responsive.Input.Directional
		end
	end

	if fFlagEnableMorePageExitButtonSupport then
		v10 = useAppPolicy(function(p2)
			return p2.getMorePageExitButtonEnabled()
		end) and not defineFastFlag
	end

	local v12 = if module6 then useNavBarPlacement() else nil

	local v13 = nil
	local v14

	if fFlagLuaAppEnableMorePageProfileLink then
		local v15 = useAppPolicy(function(p2)
			return p2.useGridPageLayout()
		end)

		local v16 = useBreakpointXOrLarger(Responsive.Keys.Large)

		if v15 then
			v14 = { fn, module3.BuyRobuxButton, module3.NotificationsButton }
			v13 = not v16
		else
			v14 = { module3.BuyRobuxButton, module3.NotificationsButton }
		end
	else
		v14 = { module3.BuyRobuxButton, module3.NotificationsButton }
	end

	local v15, v16 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()

	local createElement = React.createElement
	local v18 = {
		ref = v16,
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundDefault.Color,
		BackgroundTransparency = backgroundDefault.Transparency
	}

	local v20 = if not v11 then React.createElement(module3.Container, {
		leftItem = module3.BackButton,
		rightItems = v14,
		forceCompactMode = v13
	}) else nil
	return createElement("Frame", v18, {
		TopBarMorePage = v20,
		MorePageContent = React.createElement(module4, {
			defaultFocusRef = v15,
			isWideView = v6,
			isDirectional = v11,
			isExitButtonSupported = v10,
			itemTable = v9,
			topBarHeight = v11 and 0 or v7,
			navBarPlacement = v12
		})
	})
end
