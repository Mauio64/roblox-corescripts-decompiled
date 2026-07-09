local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local VRSettings = require(Modules.LuaApp.Components.More.VRSettings)
local SettingsPage = require(Modules.LuaApp.Components.More.AccountSettings.SettingsPage)

local function MoreSettingsPageSelector(p1) -- line: 8
	-- upvalues: useIsSpatial (copy), React (copy), VRSettings (copy), SettingsPage (copy)
	if useIsSpatial() then
		return React.createElement(VRSettings, p1)
	end

	return React.createElement(SettingsPage, p1)
end

return MoreSettingsPageSelector
