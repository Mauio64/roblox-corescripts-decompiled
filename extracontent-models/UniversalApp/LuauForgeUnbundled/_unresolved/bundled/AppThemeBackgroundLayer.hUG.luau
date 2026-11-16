local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/eeu")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module2 = require("@luauforge/bundled/hUH")
local module3 = require("@luauforge/bundled/hUE")

local module4 = require("@luauforge/bundled/hUI")

local v5 = if module4 then require("@luauforge/bundled/hUJ") else nil

local function AppThemeBackgroundLayer(props)
	local v6 = module2()
	local v7 = useDesignTokens()

	local v8 = if props.isVR == nil then isVRAppBuild() else props.isVR
	local v9

	if v6 == nil then
		v9 = false
	else
		v9 = not v8

		if v9 then
			v9 = not (props.currentPage == nil) and module3[props.currentPage] == true
		end
	end

	local clipRight

	if module4 then
		local v10 = v5()
		v9 = v9 and not v10.isHidden
		clipRight = v10.clipRight
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local themeBackgroundLayer = module.ThemeBackgroundLayer

	if not v9 then
		v6 = nil
	end

	local v11 = {
		Layer = createElement2(
			themeBackgroundLayer,
			{
				image = v6,
				baseColor = v7.LuaApps.App.Page.BackgroundColor,
				overscan = 200,
				clipRight = clipRight
			},
			props.children
		),
		DeviceInsetBackground = 0
	}
	local v13 = if not v9 then props.deviceInsetBackground else nil
	v11.DeviceInsetBackground = v13
	return createElement(fragment, nil, v11)
end

return AppThemeBackgroundLayer
