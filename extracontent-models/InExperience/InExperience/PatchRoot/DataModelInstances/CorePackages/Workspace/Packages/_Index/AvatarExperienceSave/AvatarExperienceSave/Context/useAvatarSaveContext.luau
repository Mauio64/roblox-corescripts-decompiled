local parent = script:FindFirstAncestor("AvatarExperienceSave").Parent

local React = require(parent.React)
local AvatarSaveContext = require(script.Parent.AvatarSaveContext)

local function useAvatarSaveContext()
	local v = React.useContext(AvatarSaveContext)
	assert(
		v,
		"useAvatarSaveContext returned nil, usually this means the AvatarSaveContextProvider is not present in the tree"
	)

	return v
end

return useAvatarSaveContext
