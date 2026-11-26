local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/React")
local AvatarSaveContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")

local function useAvatarSaveContext()
	local v5 = React.useContext(AvatarSaveContext)
	assert(
		v5,
		"useAvatarSaveContext returned nil, usually this means the AvatarSaveContextProvider is not present in the tree"
	)

	return v5
end

return useAvatarSaveContext
