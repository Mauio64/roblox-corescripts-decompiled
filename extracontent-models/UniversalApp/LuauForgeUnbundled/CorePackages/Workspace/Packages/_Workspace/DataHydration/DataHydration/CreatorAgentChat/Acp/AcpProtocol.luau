local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/model")

local defineFastString = game:DefineFastString("MyStatsExperienceStatsPath", "/my-stats-service/v1")

return {
	acpUrl = function()
		return urlBase.APIS .. defineFastString
	end,
	ACP_PATH = defineFastString,
	ProtocolVersion = 2,
	Methods = {
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
	},
	Notifications = { SessionUpdate = "session/update" },
	ErrorCodes = {
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
	},
	AskTool = { Name = "ask_tool" },
	CapRtnNamespace = "AssistantPlugin",
	extractSessionNewProject = function(p2)
		if typeof(p2) ~= "table" then
			return nil
		end

		local roblox = p2._meta and p2._meta._roblox

		if
			typeof(roblox) == "table"
			and typeof(roblox.universeId) == "number"
			and typeof(roblox.placeId) == "number"
		then
			return roblox
		end

		return nil
	end,
	buildSessionNewWireParams = function(data)
		local v5 = {
			universeId = data.project.universeId,
			placeId = data.project.placeId
		}

		if data.experiment ~= nil then
			v5.experiment = data.experiment
		end

		if fFlagBuildExperienceModelPickerData and data.model ~= nil then
			v5.model = data.model
		end

		if data.application ~= nil then
			v5.application = data.application
		end

		if data.chatOpenId ~= nil then
			v5.chatOpenId = data.chatOpenId
		end

		return {
			cwd = data.cwd,
			mcpServers = data.mcpServers,
			_meta = { _roblox = v5 }
		}
	end,
	buildSessionPromptWireParams = function(data)
		local sessionPromptWireParams = {
			sessionId = data.sessionId,
			prompt = data.prompt
		}

		if fFlagBuildExperienceModelPickerData and (data.model ~= nil or data.experiment ~= nil) then
			local v5 = data.meta == nil and {} or table.clone(data.meta)
			local v6 = v5._roblox == nil and {} or table.clone(v5._roblox)

			if data.model ~= nil then
				v6.model = data.model
			end

			if data.experiment ~= nil then
				v6.experiment = data.experiment
			end

			v5._roblox = v6
			sessionPromptWireParams._meta = v5
			return sessionPromptWireParams
		elseif data.experiment == nil then
			if data.meta ~= nil then
				sessionPromptWireParams._meta = data.meta
			end

			return sessionPromptWireParams
		else
			local v5 = {}

			if data.meta ~= nil and data.meta._roblox ~= nil then
				for k, v6 in data.meta._roblox do
					v5[k] = v6
				end
			end

			v5.experiment = data.experiment
			sessionPromptWireParams._meta = { _roblox = v5 }
			return sessionPromptWireParams
		end
	end
}
