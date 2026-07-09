local ParentParent = script.Parent.Parent
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")

return {
	projects = {
		require(RobloxGui.Modules.AbuseReportMenu)["jest.config"],
		require(ParentParent.InGameAssetReporting)["jest.config"]
	}
}
