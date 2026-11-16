local parent = script.Parent.Parent.Parent.Parent

local GroupService = game:GetService("GroupService")
local GuiService = game:GetService("GuiService")

local React = require(parent.React)

return React.createContext({ groupService = GroupService, guiService = GuiService })
