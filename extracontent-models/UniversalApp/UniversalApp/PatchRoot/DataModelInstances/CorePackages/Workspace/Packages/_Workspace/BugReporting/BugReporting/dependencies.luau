local Parent = script:FindFirstAncestor("BugReporting").Parent
local FFlagLuaAppDefaultHttpRetry = require(Parent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v3 = if not game:GetEngineFeature("BugReporterProtocol") then nil else game:GetService("BugReporterService")
local GuiService = game:GetService("GuiService")
local LogReporterService = game:GetService("LogReporterService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SafetyService = game:GetService("SafetyService")
local UserInputService = game:GetService("UserInputService")
local VoiceChatService = game:GetService("VoiceChatService")
local LoggingProtocol = require(Parent.LoggingProtocol)
local SystemInfoProtocol = require(Parent.SystemInfoProtocol).SystemInfoProtocol
local HttpRequest = require(Parent.HttpRequest)
local makeBugReporterLogger = require(script.Parent.analytics.makeBugReporterLogger)
local v15 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("BugReportingHttpRetryCount", 4)
})

return {
	bugReporterService = v3,
	guiService = GuiService,
	loggingProtocol = LoggingProtocol.default,
	logReporterService = LogReporterService,
	runService = RunService,
	safetyService = SafetyService,
	userInputService = UserInputService,
	voiceChatService = VoiceChatService,
	systemInfoProtocol = SystemInfoProtocol.default,
	localPlayer = Players.LocalPlayer,
	getPlaceId = function() -- line: 21
		return game.PlaceId
	end,
	networking = v15,
	makeLogger = makeBugReporterLogger
}
