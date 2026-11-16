local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local getCurrentExperienceProject = require(script.Parent.getCurrentExperienceProject)
local getDefaultTemplatePlaceId = require(script.Parent.getDefaultTemplatePlaceId)

local Debug = CreatorAgentChat.debug

local function awaitRequestHandle(state, p: number)
	while state(false).status == "pending" do
		if p <= os.clock() then
			return state(false)
		end

		task.wait()
	end

	return state(false)
end

local function runSyncRpc(method: string, fn, callback)
	local lastTime = os.clock()
	local v = awaitRequestHandle(fn().state, os.clock() + 30)
	local elapsedMs = math.floor((os.clock() - lastTime) * 1000)

	if v.status == "succeeded" then
		return {
			method = method,
			status = "ok",
			detail = not callback and "succeeded" or callback(v.result),
			elapsedMs = elapsedMs
		}
	end

	if v.status == "pending" then
		return {
			method = method,
			status = "fail",
			detail = "timed out (still pending)",
			elapsedMs = elapsedMs
		}
	end

	return {
		method = method,
		status = "fail",
		detail = v.error or "failed",
		elapsedMs = elapsedMs
	}
end

local function skipResult(method: string, detail: string) -- 7 equivalent calls inferred from this helper
	return { method = method, status = "skip", detail = detail, elapsedMs = nil }
end

local function formatResultLine(item) -- 1 equivalent call inferred from this helper
	local v = item.status == "ok" and "OK" or item.status == "skip" and "SKIP" or "FAIL"
	local v2 = not item.elapsedMs and "" or ` ({item.elapsedMs}ms)`
	return `[{v}] {item.method}{v2} — {item.detail}`
end

local function buildSummary(url: string, items)
	local v = { "CAS API smoke test", url, "" }

	for _, item in items do
		table.insert(v, formatResultLine(item)) -- inferred equivalent call
	end

	local count = 0
	local count2 = 0
	local count3 = 0

	for _, item in items do
		if item.status == "ok" then
			count3 += 1
		elseif item.status == "skip" then
			count2 += 1
		else
			count += 1
		end
	end

	table.insert(v, "")
	table.insert(v, `Summary: {count3} ok, {count} fail, {count2} skip`)

	return table.concat(v, "\n")
end

local function runSessionPromptSmoke(data, sessionId: string?, universeId: number?)
	if sessionId == nil then
		return skipResult("session/prompt", "requires session/new to succeed first") -- inferred equivalent call
	end

	local lastTime = os.clock()
	local v = { sessionId = sessionId, prompt = "smoke test" }

	if universeId ~= nil then
		v._meta = {
			_roblox = {
				providerConfig = { universeId = universeId }
			}
		}
	end

	local sessionPrompt = data.sessionPrompt(v)
	local v2 = os.clock() + 30

	while sessionPrompt.state(false).status == "queued" do
		if v2 <= os.clock() then
			return {
				method = "session/prompt",
				status = "fail",
				detail = "timed out waiting for POST ack (still queued)",
				elapsedMs = math.floor((os.clock() - lastTime) * 1000)
			}
		end

		task.wait()
	end

	while not sessionPrompt.state(false).isDone do
		if v2 <= os.clock() then
			return {
				method = "session/prompt",
				status = "fail",
				detail = "timed out waiting for CAP completion",
				elapsedMs = math.floor((os.clock() - lastTime) * 1000)
			}
		end

		task.wait()
	end

	local elapsedMs = math.floor((os.clock() - lastTime) * 1000)
	local state = sessionPrompt.state(false)

	if state.status == "failed" then
		return {
			method = "session/prompt",
			status = "fail",
			detail = state.error or "POST failed",
			elapsedMs = elapsedMs
		}
	end

	return {
		method = "session/prompt",
		status = "ok",
		detail = not state.isDone and "POST accepted (202); CAP stream not completed in window" or `CAP completed ({state.status}, stopReason={state.stopReason or "?"})`,
		elapsedMs = elapsedMs
	}
end

local function runCreatorAgentSmokeTest(data, p: number?, p2: number?)
	local creatorAgentAcp = CreatorAgentChat.resolveCreatorAgentAcp()
	local results = {}
	local currentExperienceProject = getCurrentExperienceProject()
	local universeId = p or currentExperienceProject.universeId
	local placeId = p2 or currentExperienceProject.placeId or getDefaultTemplatePlaceId()

	Debug.log("info", "CAS smoke test starting", {
		acpUrl = creatorAgentAcp.url,
		universeId = universeId,
		placeId = placeId
	})

	local sessionId = nil

	table.insert(results, runSyncRpc("initialize", function()
		return data.initialize({ protocolVersion = 2 })
	end, function(p3)
		if typeof(p3) == "table" and typeof(p3.agentInfo) == "table" then
			return `agent={p3.agentInfo.name or "?"} v{p3.agentInfo.version or "?"}`
		end

		return "succeeded"
	end))

	local v = universeId == nil
		and skipResult("session/new", "requires universeId (game.GameId is 0 or not in an experience)") -- inferred equivalent call
		or runSyncRpc("session/new", function()
			return data.sessionNew({
				project = { universeId = universeId, placeId = placeId },
				application = "build"
			})
		end, function(p3)
			if typeof(p3) ~= "table" or typeof(p3.sessionId) ~= "string" or p3.sessionId == "" then
				return "succeeded but missing sessionId"
			end

			sessionId = p3.sessionId
			return `sessionId={sessionId}`
		end)

	if v.status == "ok" and sessionId == nil then
		v = {
			method = "session/new",
			status = "fail",
			detail = "succeeded but missing sessionId in result",
			elapsedMs = v.elapsedMs
		}
	elseif v.status == "fail" then
		v.detail = Debug.rpcFailureMessage("session/new", { status = "failed", error = v.detail })
	end

	table.insert(results, v)

	table.insert(results, runSyncRpc("session/list", function()
		return data.sessionList()
	end, function(p3)
		return `{#((typeof(p3) ~= "table" or not p3.sessions) and {} or p3.sessions)} session(s)`
	end))

	if sessionId == nil then
		table.insert(results, skipResult("session/load", "requires session/new")) -- inferred equivalent call
		table.insert(results, skipResult("_roblox/session/update_info", "requires session/new")) -- inferred equivalent call
		table.insert(results, skipResult("session/cancel", "requires session/new")) -- inferred equivalent call
		table.insert(results, skipResult("_roblox/session/delete", "requires session/new")) -- inferred equivalent call
		table.insert(results, skipResult("session/prompt", "requires session/new to succeed first")) -- inferred equivalent call
	else
		table.insert(results, runSyncRpc("session/load", function()
			return data.sessionLoad(sessionId)
		end))

		table.insert(results, runSyncRpc("_roblox/session/update_info", function()
			return data.sessionUpdateInfo(sessionId, "BuildExperience smoke test")
		end))

		table.insert(results, (runSessionPromptSmoke(data, sessionId, universeId)))

		table.insert(results, runSyncRpc("session/cancel", function()
			return data.sessionCancel(sessionId)
		end))

		table.insert(results, runSyncRpc("_roblox/session/delete", function()
			return data.sessionDelete(sessionId)
		end))
	end

	local summary = buildSummary(creatorAgentAcp.url, results)
	Debug.log("info", "CAS smoke test complete", { results = results, summary = summary })

	return { acpUrl = creatorAgentAcp.url, results = results, summary = summary }
end

return runCreatorAgentSmokeTest
