local GroupService = game:GetService("GroupService")
local GuiService = game:GetService("GuiService")

return require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React").createContext({
	groupService = GroupService,
	guiService = GuiService
})
