local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local getCurrentExperienceProject = require(script.Parent.getCurrentExperienceProject)
local getDefaultTemplatePlaceId = require(script.Parent.getDefaultTemplatePlaceId)
local debug = CreatorAgentChat.debug

local function awaitRequestHandle(p1, n1: number) -- line: 34
	while p1(false).status == "pending" do
		if n1 <= os.clock() then
			return p1(false)
		end

		task.wait()
	end

	return p1(false)
end
local function runSyncRpc(s1: string, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?) -- line: 44
	-- upvalues: awaitRequestHandle (copy)
	local elapsed = os.clock()
	local v19 = p2()
	local v20 = awaitRequestHandle(v19.state, os.clock() + 30)
	local v21 = math.floor((os.clock() - elapsed) * 1000)

	if v20.status == "succeeded" then
		local s2 = "succeeded"

		if p3 then
			s2 = p3(v20.result)
		end

		return {
			status = "ok",
			method = s1,
			detail = s2,
			elapsedMs = v21
		}
	end

	if v20.status == "pending" then
		return {
			status = "fail",
			detail = "timed out (still pending)",
			method = s1,
			elapsedMs = v21
		}
	end

	return {
		status = "fail",
		method = s1,
		detail = v20.error or "failed",
		elapsedMs = v21
	}
end
local function skipResult(s3: string, s4: string) -- line: 82
	return {
		status = "skip",
		elapsedMs = nil,
		method = s3,
		detail = s4
	}
end
local function formatResultLine(t1: {[any]: any}) -- line: 91
	local v26 = if t1.status ~= "ok" then t1.status ~= "skip" and "FAIL" or "SKIP" else "OK"
	local v27 = not t1.elapsedMs and "" or ` ({ t1.elapsedMs }ms)`

	return `[{ v26 }] { t1.method }{ v27 } — { t1.detail }`
end
local function buildSummary(s5: string, t2: {[any]: any}) -- line: 97
	local t3 = {
		"CAS API smoke test",
		s5,
		""
	}

	for _, v32 in t2 do
		local v33 = if v32.status ~= "ok" then v32.status ~= "skip" and "FAIL" or "SKIP" else "OK"
		local v34 = not v32.elapsedMs and "" or ` ({ v32.elapsedMs }ms)`

		table.insert(t3, `[{ v33 }] { v32.method }{ v34 } — { v32.detail }`)
	end

	local n2 = 0
	local n3 = 0
	local n4 = 0

	for _, v39 in t2 do
		if v39.status == "ok" then
			n2 += 1
		elseif v39.status == "skip" then
			n4 += 1
		else
			n3 += 1
		end
	end

	table.insert(t3, "")
	table.insert(t3, `Summary: { n2 } ok, { n3 } fail, { n4 } skip`)

	return table.concat(t3, "\n")
end
local function runSessionPromptSmoke(p4, s6: string?, n5: number?) -- line: 125
	if s6 == nil then
		return {
			method = "session/prompt",
			status = "skip",
			detail = "requires session/new to succeed first",
			elapsedMs = nil
		}
	end

	local elapsed = os.clock()
	local t4 = {
		prompt = "smoke test",
		sessionId = s6
	}

	if n5 ~= nil then
		t4._meta = {
			_roblox = {
				providerConfig = {
					universeId = n5
				}
			}
		}
	end

	local v45 = p4.sessionPrompt(t4)
	local v46 = os.clock() + 30

	while v45.state(false).status == "queued" do
		if v46 <= os.clock() then
			local v47 = math.floor((os.clock() - elapsed) * 1000)

			return {
				method = "session/prompt",
				status = "fail",
				detail = "timed out waiting for POST ack (still queued)",
				elapsedMs = v47
			}
		end

		task.wait()
	end

	while not v45.state(false).isDone do
		if v46 <= os.clock() then
			local v48 = math.floor((os.clock() - elapsed) * 1000)

			return {
				method = "session/prompt",
				status = "fail",
				detail = "timed out waiting for CAP completion",
				elapsedMs = v48
			}
		end

		task.wait()
	end

	local v49 = math.floor((os.clock() - elapsed) * 1000)
	local v50 = v45.state(false)

	if v50.status == "failed" then
		return {
			method = "session/prompt",
			status = "fail",
			detail = v50.error or "POST failed",
			elapsedMs = v49
		}
	end

	local v51 = not v50.isDone and "POST accepted (202); CAP stream not completed in window" or `CAP completed ({ v50.status }, stopReason={ v50.stopReason or "?" })`

	return {
		method = "session/prompt",
		status = "ok",
		detail = v51,
		elapsedMs = v49
	}
end
local function runCreatorAgentSmokeTest(p5, n6: number?, n7: number?) -- line: 199
	-- upvalues: CreatorAgentChat (copy), getCurrentExperienceProject (copy), getDefaultTemplatePlaceId (copy), debug (copy), runSyncRpc (copy), runSessionPromptSmoke (copy), buildSummary (copy)
	local v55 = CreatorAgentChat.resolveCreatorAgentAcp()
	local t5 = {}
	local v57 = getCurrentExperienceProject()
	local v58 = n6 or v57.universeId
	local v59 = n7 or (v57.placeId or getDefaultTemplatePlaceId())

	debug.log("info", "CAS smoke test starting", {
		acpUrl = v55.url,
		universeId = v58,
		placeId = v59
	})

	local sessionId = nil

	table.insert(t5, (runSyncRpc("initialize", function() -- line: 218
		-- upvalues: p5 (copy)
		return p5.initialize({
			protocolVersion = 2
		})
	end, function(p6) -- line: 220
		if typeof(p6) == "table" and typeof(p6.agentInfo) == "table" then
			return `agent={ p6.agentInfo.name or "?" } v{ p6.agentInfo.version or "?" }`
		end

		return "succeeded"
	end)))

	local v61 = if v58 ~= nil then runSyncRpc("session/new", function() -- line: 230
		-- upvalues: p5 (copy), v58 (copy), v59 (copy)
		return p5.sessionNew({
			project = {
				universeId = v58,
				placeId = v59
			}
		})
	end, function(p7) -- line: 237
		-- upvalues: sessionId (ref)
		if typeof(p7) ~= "table" or (typeof(p7.sessionId) ~= "string" or p7.sessionId == "") then
			return "succeeded but missing sessionId"
		end

		sessionId = p7.sessionId

		return `sessionId={ sessionId }`
	end) else {
		method = "session/new",
		status = "skip",
		detail = "requires universeId (game.GameId is 0 or not in an experience)",
		elapsedMs = nil
	}

	if v61.status == "ok" and sessionId == nil then
		v61 = {
			method = "session/new",
			status = "fail",
			detail = "succeeded but missing sessionId in result",
			elapsedMs = v61.elapsedMs
		}
	elseif v61.status == "fail" then
		v61.detail = debug.rpcFailureMessage("session/new", {
			status = "failed",
			error = v61.detail
		})
	end

	table.insert(t5, v61)
	table.insert(t5, (runSyncRpc("session/list", function() -- line: 260
		-- upvalues: p5 (copy)
		return p5.sessionList()
	end, function(p8) -- line: 262
		return `{ #(if typeof(p8) ~= "table" or not p8.sessions then {} else p8.sessions) } session(s)`
	end)))

	if sessionId == nil then
		table.insert(t5, {
			method = "session/load",
			status = "skip",
			detail = "requires session/new",
			elapsedMs = nil
		})
		table.insert(t5, {
			method = "_roblox/session/update_info",
			status = "skip",
			detail = "requires session/new",
			elapsedMs = nil
		})
		table.insert(t5, {
			method = "session/cancel",
			status = "skip",
			detail = "requires session/new",
			elapsedMs = nil
		})
		table.insert(t5, {
			method = "_roblox/session/delete",
			status = "skip",
			detail = "requires session/new",
			elapsedMs = nil
		})
		table.insert(t5, {
			method = "session/prompt",
			status = "skip",
			detail = "requires session/new to succeed first",
			elapsedMs = nil
		})
	else
		table.insert(t5, (runSyncRpc("session/load", function() -- line: 275
			-- upvalues: p5 (copy), sessionId (ref)
			return p5.sessionLoad(sessionId)
		end)))
		table.insert(t5, (runSyncRpc("_roblox/session/update_info", function() -- line: 280
			-- upvalues: p5 (copy), sessionId (ref)
			return p5.sessionUpdateInfo(sessionId, "BuildExperience smoke test")
		end)))
		table.insert(t5, (runSessionPromptSmoke(p5, sessionId, v58)))
		table.insert(t5, (runSyncRpc("session/cancel", function() -- line: 287
			-- upvalues: p5 (copy), sessionId (ref)
			return p5.sessionCancel(sessionId)
		end)))
		table.insert(t5, (runSyncRpc("_roblox/session/delete", function() -- line: 292
			-- upvalues: p5 (copy), sessionId (ref)
			return p5.sessionDelete(sessionId)
		end)))
	end

	local v62 = buildSummary(v55.url, t5)

	debug.log("info", "CAS smoke test complete", {
		results = t5,
		summary = v62
	})

	return {
		acpUrl = v55.url,
		results = t5,
		summary = v62
	}
end

return runCreatorAgentSmokeTest
