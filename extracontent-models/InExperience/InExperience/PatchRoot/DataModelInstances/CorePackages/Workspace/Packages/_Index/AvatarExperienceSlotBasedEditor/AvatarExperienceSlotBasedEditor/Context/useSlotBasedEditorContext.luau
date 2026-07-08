local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local SlotBasedEditorContext = require(script.Parent.SlotBasedEditorContext)

local function useSlotBasedEditorContext() -- line: 13
	-- upvalues: React (copy), SlotBasedEditorContext (copy)
	return (React.useContext(SlotBasedEditorContext))
end

return useSlotBasedEditorContext
