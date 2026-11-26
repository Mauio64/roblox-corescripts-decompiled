local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local SlotBasedEditorContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Context/SlotBasedEditorContext")

local function useSlotBasedEditorContext()
	return (React.useContext(SlotBasedEditorContext))
end

return useSlotBasedEditorContext
