local Parent = script:FindFirstAncestor("DataHydration").Parent
local UrlBase = require(Parent.UrlBuilder).UrlBase
local v3 = game:DefineFastString("MyStatsExperienceStatsPath", "/my-stats-service/v1")
local t1 = {
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
	SessionSaveAndPublish = "_roblox/session/save_and_publish"
}
local t2 = {
	Name = "ask_tool"
}
local t3 = {
	SessionUpdate = "session/update"
}
local t4 = {
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
	Gone = -32005
}

return {
	ProtocolVersion = 2,
	CapRtnNamespace = "AssistantPlugin",
	acpUrl = function() -- line: 13
		-- upvalues: UrlBase (copy), v3 (copy)
		return UrlBase.APIS .. v3
	end,
	ACP_PATH = v3,
	Methods = t1,
	Notifications = t3,
	ErrorCodes = t4,
	AskTool = t2,
	extractSessionNewProject = function(p1) -- line: 53
		if typeof(p1) ~= "table" then
			return nil
		end

		local v9 = p1._meta and p1._meta._roblox

		if typeof(v9) == "table" and typeof(v9.universeId) == "number" and typeof(v9.placeId) == "number" then
			return v9
		end

		return nil
	end,
	buildSessionNewWireParams = function(t5: {[any]: any}) -- line: 64
		local t6 = {
			universeId = t5.project.universeId,
			placeId = t5.project.placeId
		}

		if t5.experiment ~= nil then
			t6.experiment = t5.experiment
		end

		return {
			cwd = t5.cwd,
			mcpServers = t5.mcpServers,
			_meta = {
				_roblox = t6
			}
		}
	end
}
