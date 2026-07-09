local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.InterventionShared)["jest.config"],
		require(ParentParent.InAppIntervention)["jest.config"],
		require(ParentParent.NotApprovedPage)["jest.config"],
		require(ParentParent.UniversalFeatureRestrictions)["jest.config"],
		game.CoreGui.RobloxGui.Modules.LuaApp.Models.UserModerationApi["jest.config"],
		game.CoreGui.RobloxGui.Modules.LuaApp.Components.Moderation["jest.config"]
	}
}
