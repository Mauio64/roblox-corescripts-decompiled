local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local initializeProfileAnalytics = require(CorePackages.Workspace.Packages.ProfilePlatform.initializeProfileAnalytics)
local EventNames = require(CorePackages.Workspace.Packages.ProfilePlatform.EventNames)
local SocialStopwatch = require(CorePackages.Workspace.Packages.SocialStopwatch)
local v10 = initializeProfileAnalytics()

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: ArgCheck (copy), SocialStopwatch (copy), v10 (copy), EventNames (copy), SocialLuaAnalytics (copy), SetCentralOverlay (copy), OverlayType (copy)
	return function(p1) -- line: 29
		-- upvalues: ArgCheck (copy), t1 (copy), SocialStopwatch (copy), v10 (copy), EventNames (copy), SocialLuaAnalytics (copy), SetCentralOverlay (copy), OverlayType (copy)
		ArgCheck.isType(t1.user, "table", "props.user passed down to OpenCentralOverlayForPeopleList")
		ArgCheck.isType(t1.positionIndex, "number", "props.positionIndex passed down to OpenCentralOverlayForPeopleList")
		ArgCheck.isType(t1.onOpen, "function", "props.onOpen passed down to OpenCentralOverlayForPeopleList")
		ArgCheck.isType(t1.onClose, "function", "props.onClose passed down to OpenCentralOverlayForPeopleList")
		ArgCheck.isType(t1.anchorSpaceSize, "Vector2", "props.anchorSpaceSize passed down to OpenCentralOverlayForPeopleList")
		ArgCheck.isType(t1.anchorSpacePosition, "Vector2", "props.anchorSpacePosition passed down to OpenCentralOverlayForPeopleList")
		ArgCheck.isType(t1.absolutePosition, "number", "props.absolutePosition passed down to OpenCentralOverlayForPeopleList")
		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.JoinGameCardOpened);
		((if not t1.mockProfileAnalytics_dev then v10 else t1.mockProfileAnalytics_dev)).fireAnalyticsEvent(EventNames.ProfileInExperienceUserLoadingStage, {
			statValue = 0,
			status = SocialLuaAnalytics.Analytics.Enums.LoadingStages.Started
		})
		p1:dispatch(SetCentralOverlay(OverlayType.PeopleList, t1))
	end
end
