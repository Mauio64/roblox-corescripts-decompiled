local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useAvatarSwitcherFrameProps = require(Modules.AvatarExperience.AvatarEditor.Components.useAvatarSwitcherFrameProps)
local AvatarSwitcherFrame = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarSwitcherFrame)

local function AvatarSwitcherFrameContainer() -- line: 11
	-- upvalues: useAvatarSwitcherFrameProps (copy), React (copy), AvatarSwitcherFrame (copy)
	local v7 = useAvatarSwitcherFrameProps()

	return React.createElement(AvatarSwitcherFrame, v7)
end

return AvatarSwitcherFrameContainer
