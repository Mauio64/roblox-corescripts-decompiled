local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ParentParent = script.Parent.Parent

return {
	projects = {
		RobloxGui.Modules.LuaApp.DeepLinks["jest.config"],
		require(ParentParent.Dev.DeepLink)["jest.config"]
	}
}
