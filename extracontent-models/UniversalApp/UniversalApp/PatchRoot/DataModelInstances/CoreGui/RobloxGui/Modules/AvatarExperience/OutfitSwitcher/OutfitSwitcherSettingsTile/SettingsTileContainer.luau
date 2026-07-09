local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local SettingsTile = require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherSettingsTile.SettingsTile)
local useSettingsTileProps = require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherSettingsTile.useSettingsTileProps)

local function SettingsTileContainer(p1, p2) -- line: 11
	-- upvalues: useSettingsTileProps (copy), React (copy), SettingsTile (copy), Dash (copy)
	local v10 = useSettingsTileProps(p1, p2)

	return React.createElement(SettingsTile, Dash.assign(v10, {
		ref = p2
	}))
end

return React.forwardRef(SettingsTileContainer)
