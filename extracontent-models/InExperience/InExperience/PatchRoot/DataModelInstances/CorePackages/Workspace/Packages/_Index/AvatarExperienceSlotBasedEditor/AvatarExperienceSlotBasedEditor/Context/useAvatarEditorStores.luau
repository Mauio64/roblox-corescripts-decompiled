local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local AvatarEditorStores = require(script.Parent.AvatarEditorStores)
local createAvatarEditorStores = require(script.Parent.Parent.Stores.createAvatarEditorStores)

local function useAvatarEditorStores()
	local v = React.useContext(AvatarEditorStores)

	if v then
		return v
	end

	warn("useAvatarEditorStores was used without an AvatarEditorStores context provider. Providing a temporary default value instead.")

	return createAvatarEditorStores()
end

return useAvatarEditorStores
