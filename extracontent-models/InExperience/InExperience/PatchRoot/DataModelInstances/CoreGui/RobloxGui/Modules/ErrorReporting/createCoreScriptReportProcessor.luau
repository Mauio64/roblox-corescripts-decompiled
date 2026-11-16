local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function getStaticAttributes()
	return {
		LocalVersion = RunService:GetRobloxVersion(),
		BaseUrl = ContentProvider.BaseUrl,
		PlaceId = game.PlaceId,
		Platform = UserInputService:GetPlatform().Name,
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion()
	}
end

local function createCoreScriptReportProcessor(p)
	local selected = p or getStaticAttributes()

	local function processReport(object)
		object:addAttributes(selected)

		object:addAttributes({
			PlayerCount = #Players:GetPlayers()
		})

		object:addAttributes({
			RobloxChannel = RunService:GetRobloxClientChannel()
		})

		return object
	end

	return processReport, selected
end

return createCoreScriptReportProcessor
