local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local parent = script.Parent.Parent

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local GetDefaultQualityLevel = AppCommonLib.GetDefaultQualityLevel
local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

return function()
	SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
		confirmed = Constants.AnalyticsConfirmedName
	})

	GuiService.SelectedCoreObject = nil

	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()

	game:Shutdown()
	local settings = settings()
	settings.Rendering.QualityLevel = GetDefaultQualityLevel()
end
