local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/React")

local AvatarSaveContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")
local useAvatarSaveContextProviderValue = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/useAvatarSaveContextProviderValue")

local function AvatarSaveContextProvider(p2)
	local v5 = useAvatarSaveContextProviderValue()
	return React.createElement(AvatarSaveContext.Provider, { value = v5 }, p2.children)
end

return AvatarSaveContextProvider
