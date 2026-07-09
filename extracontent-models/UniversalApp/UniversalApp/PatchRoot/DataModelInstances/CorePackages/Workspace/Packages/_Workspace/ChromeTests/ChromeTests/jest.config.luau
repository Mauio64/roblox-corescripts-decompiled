local ParentParent = script.Parent.Parent
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")

return {
	projects = {
		require(ParentParent.Chrome)["jest.config"],
		require(ParentParent.PeopleReactView)["jest.config"],
		require(ParentParent.PeopleService)["jest.config"],
		RobloxGui.Modules.Chrome["jest.config"]
	}
}
