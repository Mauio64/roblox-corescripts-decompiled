local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local EmoteTile = require(Modules.AvatarExperience.EditEmotes.EmoteTile.EmoteTile)
local useEmoteTileProps = require(Modules.AvatarExperience.EditEmotes.EmoteTile.useEmoteTileProps)

local function EmoteTileContainer(p1, p2) -- line: 10
	-- upvalues: useEmoteTileProps (copy), React (copy), EmoteTile (copy), Dash (copy)
	local v10 = useEmoteTileProps(p1, p2)

	return React.createElement(EmoteTile, Dash.assign(v10, {
		ref = p2
	}))
end

return React.forwardRef(EmoteTileContainer)
