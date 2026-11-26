local fFlagLuaAppDefaultHttpRetry = require("@luauforge/bundled/hZu").FFlagLuaAppDefaultHttpRetry
local BugReporterService

if game:GetEngineFeature("BugReporterProtocol") then
	BugReporterService = game:GetService("BugReporterService")
end

local GuiService = game:GetService("GuiService")
local LogReporterService = game:GetService("LogReporterService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SafetyService = game:GetService("SafetyService")
local UserInputService = game:GetService("UserInputService")
local VoiceChatService = game:GetService("VoiceChatService")

local module = require("@luauforge/bundled/hZv")
local systemInfoProtocol = require("@luauforge/bundled/hZg").SystemInfoProtocol
local module2 = require("@luauforge/bundled/hZw")
local module3 = require("@luauforge/bundled/hZx")

local function getPlaceId()
	return game.PlaceId
end

local config = module2.config
local v5 = {
	requestFunction = module2.requestFunctions.RequestInternal,
	maxRetryCount = 0
}
local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("BugReportingHttpRetryCount", 4) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

return {
	bugReporterService = BugReporterService,
	guiService = GuiService,
	loggingProtocol = module.default,
	logReporterService = LogReporterService,
	runService = RunService,
	safetyService = SafetyService,
	userInputService = UserInputService,
	voiceChatService = VoiceChatService,
	systemInfoProtocol = systemInfoProtocol.default,
	localPlayer = Players.LocalPlayer,
	getPlaceId = getPlaceId,
	networking = v7,
	makeLogger = module3
}
