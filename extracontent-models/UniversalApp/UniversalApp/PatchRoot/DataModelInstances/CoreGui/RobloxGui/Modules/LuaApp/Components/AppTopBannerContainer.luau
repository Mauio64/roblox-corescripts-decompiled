local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AppTopBanner = require(CorePackages.Workspace.Packages.AppTopBanner).AppTopBanner
local AppTopBannerType = require(CorePackages.Workspace.Packages.AppTopBanner).Enums.AppTopBannerType
local DisableAppTopBanner = require(CorePackages.Workspace.Packages.AppTopBanner).Actions.DisableAppTopBanner
local Modules = CoreGui.RobloxGui.Modules
local usePageNavigationOptions = require(Modules.LuaApp.Hooks.usePageNavigationOptions)
local GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport)
local t1 = {
	[AppTopBannerType.None] = nil,
	[AppTopBannerType.ActiveSquad] = require(CorePackages.Workspace.Packages.Squads.SquadTopBanner)
}

local function AppTopBannerContainer(t2: {[any]: any}) -- line: 26
	-- upvalues: useDispatch (copy), useSelector (copy), usePageNavigationOptions (copy), React (copy), DisableAppTopBanner (copy), ReactRoblox (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), AppTopBanner (copy), t1 (copy), CoreGui (copy)
	local v16 = useDispatch()
	local v17 = useSelector(function(p1) -- line: 28
		return p1.TopBar.statusBarHeight
	end)
	local v18 = useSelector(function(p2) -- line: 32
		return p2.GlobalGuiInset
	end)
	local v19 = usePageNavigationOptions()

	React.useEffect(function() -- line: 37
		-- upvalues: v19 (copy), v16 (copy), DisableAppTopBanner (copy)
		local v22 = not not v19 and (not not v19.rootPageOptions and v19.rootPageOptions.disableAppTopBanner == true)
		local v23 = not not v19 and v19.disableAppTopBanner == true

		v16(DisableAppTopBanner(v22 or v23))
	end, { v19 })

	return ReactRoblox.createPortal({
		AppTopBannerScreen = React.createElement("ScreenGui", {
			Enabled = true,
			DisplayOrder = t2.displayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = if not GetFFlagLuaAppFixStudioNotchSupport() then nil else Enum.ScreenInsets.None
		}, {
			AppTopBannerContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, not GetFFlagLuaAppFixStudioNotchSupport() and 0 or -v18.left, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, not GetFFlagLuaAppFixStudioNotchSupport() and 0 or v18.left, 0, if not GetFFlagLuaAppFixStudioNotchSupport() then -v18.top else 0)
			}, {
				AppTopBanner = React.createElement(AppTopBanner, {
					contentMaps = t1,
					deviceStatusBarHeight = v17
				})
			})
		})
	}, CoreGui)
end

return React.memo(AppTopBannerContainer)
