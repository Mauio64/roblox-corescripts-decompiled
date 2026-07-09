local Parent = script:FindFirstAncestor("AvatarExperienceSave").Parent
local React = require(Parent.React)
local AvatarSaveContext = require(script.Parent.AvatarSaveContext)

local function useAvatarSaveContext() -- line: 7
	-- upvalues: React (copy), AvatarSaveContext (copy)
	local v5 = React.useContext(AvatarSaveContext)

	assert(v5, "useAvatarSaveContext returned nil, usually this means the AvatarSaveContextProvider is not present in the tree")

	return v5
end

return useAvatarSaveContext
