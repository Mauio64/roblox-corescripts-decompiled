local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local appTopBanner = require("@luauforge/bundled/dzW").AppTopBanner
local appTopBannerType = require("@luauforge/bundled/dzW").Enums.AppTopBannerType
local disableAppTopBanner = require("@luauforge/bundled/dzW").Actions.DisableAppTopBanner
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/Responsive").useDeviceInsets

local fFlagFixOverlayTopInsetForDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixOverlayTopInsetForDeviceSafeInsets

local fFlagUseSignalsForAppTopBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAppTopBanner

local getAppTopBannerStore = if fFlagUseSignalsForAppTopBanner then require("@luauforge/bundled/dzW").GetAppTopBannerStore else nil

local module = require("@luauforge/bundled/iaM")

local fFlagLuaAppSupportDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSupportDeviceSafeInsets

local shouldUseDeviceSafeInsets = fFlagFixOverlayTopInsetForDeviceSafeInsets
	and require("@luauforge/bundled/dXA").shouldUseDeviceSafeInsets

local v5 = {
	[appTopBannerType.None] = nil,
	[appTopBannerType.ActiveSquad] = require("@luauforge/bundled/iaO")
}

local function AppTopBannerContainer(p2)
	local v6 = useDispatch()
	local v7 = useSelector(function(p3)
		return p3.TopBar.statusBarHeight
	end)
	local v8

	if fFlagFixOverlayTopInsetForDeviceSafeInsets then
		local v9 = useDeviceInsets()
		v8 = not shouldUseDeviceSafeInsets and 0 or v9.top
	else
		v8 = 0
	end

	local v9 = useSelector(function(p3)
		return p3.GlobalGuiInset
	end)

	local v10 = module()
	React.useEffect(function()
		local v11

		if v10 and v10.rootPageOptions then
			v11 = v10.rootPageOptions.disableAppTopBanner == true
		else
			v11 = false
		end

		local v12 = if v10 then v10.disableAppTopBanner == true else false

		if fFlagUseSignalsForAppTopBanner then
			getAppTopBannerStore(false).disableAppTopBanner(v11 or v12)
		else
			v6(disableAppTopBanner(v11 or v12))
		end
	end, { v10 })

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v13 = {
		Enabled = true,
		DisplayOrder = p2.displayOrder,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ScreenInsets = 0,
		ClipToDeviceSafeArea = 0
	}
	local v14

	if shouldUseDeviceSafeInsets then
		v14 = Enum.ScreenInsets.DeviceSafeInsets
	elseif fFlagLuaAppSupportDeviceSafeInsets then
		v14 = Enum.ScreenInsets.None
	end

	v13.ScreenInsets = v14

	v13.ClipToDeviceSafeArea = if shouldUseDeviceSafeInsets then false else nil

	local createElement2 = React.createElement
	local v18 = {
		Size = UDim2.new(1, not fFlagLuaAppSupportDeviceSafeInsets and 0 or -v9.left, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = 0,
		BackgroundTransparency = 1
	}
	local newUDim2 = UDim2.new

	local v20 = not fFlagLuaAppSupportDeviceSafeInsets and 0 or v9.left
	local v22

	if fFlagLuaAppSupportDeviceSafeInsets then
		v22 = not fFlagFixOverlayTopInsetForDeviceSafeInsets and 0 or -v8
	else
		v22 = -v9.top
	end

	v18.Position = newUDim2(0, v20, 0, v22)
	return createPortal({
		AppTopBannerScreen = createElement("ScreenGui", v13, {
			AppTopBannerContainer = createElement2("Frame", v18, {
				AppTopBanner = React.createElement(appTopBanner, {
					contentMaps = v5,
					deviceStatusBarHeight = v7 + (not fFlagFixOverlayTopInsetForDeviceSafeInsets and 0 or v8)
				})
			})
		})
	}, CoreGui)
end

return React.memo(AppTopBannerContainer)
