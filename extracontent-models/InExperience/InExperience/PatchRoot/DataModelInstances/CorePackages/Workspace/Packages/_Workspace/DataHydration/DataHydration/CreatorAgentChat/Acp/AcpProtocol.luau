local parent = script:FindFirstAncestor("DataHydration").Parent

local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
require(script.Parent.Parent.Types.model)

local defineFastString = game:DefineFastString("MyStatsExperienceStatsPath", "/my-stats-service/v1")
local AcpProtocol = {}

function AcpProtocol.acpUrl()
	return UrlBase.APIS .. defineFastString
end

AcpProtocol.ACP_PATH = defineFastString
AcpProtocol.ProtocolVersion = 2
AcpProtocol.Methods = {
	Initialize = "initialize",
	SessionNew = "session/new",
	SessionList = "session/list",
	SessionLoad = "session/load",
	SessionPrompt = "session/prompt",
	SessionCancel = "session/cancel",
	SessionFindByUniverse = "_roblox/session/find_by_universe",
	SessionDelete = "_roblox/session/delete",
	SessionUpdateInfo = "_roblox/session/update_info",
	SessionReadTasks = "_roblox/session/read_tasks",
	SessionSaveAndPublish = "_roblox/session/save_and_publish",
	AdCampaignEligibility = "_roblox/ad_campaign/eligibility",
	AdCampaignCheckFunds = "_roblox/ad_campaign/check_funds",
	AdCampaignCreate = "_roblox/ad_campaign/create",
	AdCampaignToolCallStatus = "_roblox/ad_campaign/tool_call_status"
}

AcpProtocol.Notifications = { SessionUpdate = "session/update" }

AcpProtocol.ErrorCodes = {
	ParseError = -32700,
	InvalidRequest = -32600,
	MethodNotFound = -32601,
	InvalidParams = -32602,
	InternalError = -32603,
	Unauthorized = -32000,
	Forbidden = -32001,
	NotFound = -32002,
	Conflict = -32003,
	UpstreamUnavailable = -32004,
	Gone = -32005,
	OutOfCredits = -32006,
	PayloadTooLarge = -32007,
	InsufficientFunds = -32008,
	MissingThumbnail = -32009
}
AcpProtocol.AskTool = { Name = "ask_tool" }
AcpProtocol.CapRtnNamespace = "AssistantPlugin"

function AcpProtocol.extractSessionNewProject(p)
	if typeof(p) ~= "table" then
		return nil
	end

	local roblox = p._meta and p._meta._roblox

	if typeof(roblox) == "table" and typeof(roblox.universeId) == "number" and typeof(roblox.placeId) == "number" then
		return roblox
	end

	return nil
end

function AcpProtocol.buildSessionNewWireParams(data)
	local roblox = { universeId = data.project.universeId, placeId = data.project.placeId }

	if data.experiment ~= nil then
		roblox.experiment = data.experiment
	end

	if FFlagBuildExperienceModelPickerData and data.model ~= nil then
		roblox.model = data.model
	end

	if data.application ~= nil then
		roblox.application = data.application
	end

	if data.chatOpenId ~= nil then
		roblox.chatOpenId = data.chatOpenId
	end

	return {
		cwd = data.cwd,
		mcpServers = data.mcpServers,
		_meta = { _roblox = roblox }
	}
end

function AcpProtocol.buildSessionPromptWireParams(data)
	local sessionPromptWireParams = { sessionId = data.sessionId, prompt = data.prompt }

	if FFlagBuildExperienceModelPickerData and (data.model ~= nil or data.experiment ~= nil) then
		local meta = data.meta == nil and {} or table.clone(data.meta)
		local roblox = meta._roblox == nil and {} or table.clone(meta._roblox)

		if data.model ~= nil then
			roblox.model = data.model
		end

		if data.experiment ~= nil then
			roblox.experiment = data.experiment
		end

		meta._roblox = roblox
		sessionPromptWireParams._meta = meta
		return sessionPromptWireParams
	elseif data.experiment == nil then
		if data.meta ~= nil then
			sessionPromptWireParams._meta = data.meta
		end

		return sessionPromptWireParams
	else
		local roblox = {}

		if data.meta ~= nil and data.meta._roblox ~= nil then
			for k, v in data.meta._roblox do
				roblox[k] = v
			end
		end

		roblox.experiment = data.experiment
		sessionPromptWireParams._meta = { _roblox = roblox }
		return sessionPromptWireParams
	end
end

return AcpProtocol
