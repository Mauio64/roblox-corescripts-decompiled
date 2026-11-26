local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local AvatarEditorStores = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Context/AvatarEditorStores")
local createAvatarEditorStores = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createAvatarEditorStores")

local function useAvatarEditorStores()
	local v5 = React.useContext(AvatarEditorStores)

	if v5 then
		return v5
	end

	warn("useAvatarEditorStores was used without an AvatarEditorStores context provider. Providing a temporary default value instead.")

	return createAvatarEditorStores()
end

return useAvatarEditorStores
