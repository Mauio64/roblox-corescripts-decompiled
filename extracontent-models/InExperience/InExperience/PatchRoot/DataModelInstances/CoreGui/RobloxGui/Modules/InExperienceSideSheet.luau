local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local TopBar = require(RobloxGui.Modules.TopBar)

return (InExperienceSideSheet.SideSheet.createSideSheet({ VoiceStateContext.Provider }, {
	ChatSelector = ChatSelector
}, TopBar.store))
