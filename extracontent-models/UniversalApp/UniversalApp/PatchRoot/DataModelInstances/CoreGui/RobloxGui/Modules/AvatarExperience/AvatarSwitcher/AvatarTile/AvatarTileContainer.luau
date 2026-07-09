local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local AvatarTile = require(Modules.AvatarExperience.AvatarSwitcher.AvatarTile.AvatarTile)
local useAvatarTileProps = require(Modules.AvatarExperience.AvatarSwitcher.AvatarTile.useAvatarTileProps)

local function AvatarTileContainer(p1, p2) -- line: 10
	-- upvalues: useAvatarTileProps (copy), React (copy), AvatarTile (copy), Dash (copy)
	local v10 = useAvatarTileProps(p1, p2)

	return React.createElement(AvatarTile, Dash.assign(v10, {
		ref = p2
	}))
end

return React.forwardRef(AvatarTileContainer)
