local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SearchPage = require(Modules.LuaApp.Components.Search.SearchPage)
local TenFootUiSearch = require(Modules.LuaApp.Components.Search.TenFootUi.TenFootUiSearch)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function AdaptiveSearchPage(p1) -- line: 13
	-- upvalues: useUiModeInfo (copy), UiMode (copy), React (copy), FFlagEnableLeftNavOnConsole (copy), TenFootUiSearch (copy), SearchPage (copy)
	local v11 = useUiModeInfo().uiMode == UiMode.TenFoot

	return React.createElement(if not v11 or FFlagEnableLeftNavOnConsole then SearchPage else TenFootUiSearch, p1)
end

return AdaptiveSearchPage
