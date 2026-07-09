local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local AvatarEditorStores = require(script.Parent.AvatarEditorStores)
local createAvatarEditorStores = require(script.Parent.Parent.Stores.createAvatarEditorStores)

local function useAvatarEditorStores() -- line: 12
	-- upvalues: React (copy), AvatarEditorStores (copy), createAvatarEditorStores (copy)
	local v6 = React.useContext(AvatarEditorStores)

	if not v6 then
		warn("useAvatarEditorStores was used without an AvatarEditorStores context provider. Providing a temporary default value instead.")
		v6 = createAvatarEditorStores()
	end

	return v6
end

return useAvatarEditorStores
