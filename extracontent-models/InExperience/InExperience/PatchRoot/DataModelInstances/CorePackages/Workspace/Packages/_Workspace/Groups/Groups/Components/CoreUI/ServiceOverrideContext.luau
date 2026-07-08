local ParentParent = script.Parent.Parent.Parent.Parent
local GroupService = game:GetService("GroupService")
local GuiService = game:GetService("GuiService")

return require(ParentParent.React).createContext({
	groupService = GroupService,
	guiService = GuiService
})
