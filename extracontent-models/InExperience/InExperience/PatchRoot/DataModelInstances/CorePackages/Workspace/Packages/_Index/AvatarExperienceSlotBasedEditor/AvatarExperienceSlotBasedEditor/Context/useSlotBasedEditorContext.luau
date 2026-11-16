local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local SlotBasedEditorContext = require(script.Parent.SlotBasedEditorContext)

local function useSlotBasedEditorContext()
	return (React.useContext(SlotBasedEditorContext))
end

return useSlotBasedEditorContext
