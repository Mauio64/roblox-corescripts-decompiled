local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local PromptInfo = require(script.PromptInfo)
local ScreenSize = require(script.ScreenSize)
local GameName = require(script.GameName)
local AnalyticsInfo = require(script.AnalyticsInfo)
local FFlagAXAvatarTimeoutFlowIE = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE

return (Rodux.combineReducers({
	promptInfo = PromptInfo,
	screenSize = ScreenSize,
	ScreenSize = if not FFlagAXAvatarTimeoutFlowIE then nil else ScreenSize,
	gameName = GameName,
	analyticsInfo = AnalyticsInfo
}))
