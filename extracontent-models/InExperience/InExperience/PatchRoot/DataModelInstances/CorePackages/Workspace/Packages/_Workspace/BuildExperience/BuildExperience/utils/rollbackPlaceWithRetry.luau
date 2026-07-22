local Parent = script:FindFirstAncestor("BuildExperience").Parent
local HttpService = game:GetService("HttpService")
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local PlaceVersionHistory = require(Parent.DataHydration.PlaceVersionHistory)
local Promise = require(Parent.Promise)
local v6 = game:DefineFastInt("BuildExperienceRollbackPlaceMaxRetries", 2)
local v7 = game:DefineFastInt("BuildExperienceRollbackPlaceRetryDelayMs", 1000)
local debug = CreatorAgentChat.debug

local function formatDebugValue(p1) -- line: 27
	-- upvalues: HttpService (copy)
	if typeof(p1) == "table" then
		local ok, result = pcall(function() -- line: 29
			-- upvalues: HttpService (copy), p1 (copy)
			return HttpService:JSONEncode(p1)
		end)

		if ok then
			return result
		end
	end

	return (tostring(p1))
end
local function hasVersionNote(p2) -- line: 39
	return p2.title ~= nil or p2.description ~= nil
end
local function debugMessage(t1: {[any]: any}, s1: string) -- line: 43
	return `{ t1.debugSource or "rollback" } { s1 }`
end
local function copyVersionNoteAfterRollback(p3, n1: number, n2: number, p4, t2: {[any]: any}, p5) -- line: 47
	-- upvalues: Promise (copy), debug (copy), HttpService (copy)
	if t2.note == nil then
		return Promise.resolve()
	end

	if p4.newVersionNumber == nil then
		debug.log("info", `{ t2.debugSource or "rollback" } note copy skipped`, {
			reason = "newVersionNumber_nil",
			placeId = n1,
			restoredVersion = n2
		})

		return Promise.resolve()
	end

	if p5 == nil then
		debug.log("info", `{ t2.debugSource or "rollback" } note copy skipped`, {
			reason = "source_notes_not_found",
			placeId = n1,
			restoredVersion = n2,
			newVersion = p4.newVersionNumber
		})

		return Promise.resolve()
	end

	if p5.title == nil and p5.description == nil then
		debug.log("info", `{ t2.debugSource or "rollback" } note copy skipped`, {
			reason = "source_notes_empty",
			placeId = n1,
			restoredVersion = n2,
			newVersion = p4.newVersionNumber
		})

		return Promise.resolve()
	end

	local str = tostring(p4.newVersionNumber)

	return p3.addVersionNote(n1, str, p5):catch(function(p6) -- line: 89
		-- upvalues: debug (copy), t2 (copy), n1 (copy), n2 (copy), str (copy), p5 (copy), HttpService (copy)
		local log = debug.log
		local v44 = `{ t2.debugSource or "rollback" } note copy failed`
		local t3 = {
			placeId = n1,
			restoredVersion = n2,
			newVersion = str,
			titleLength = if p5.title ~= nil then #p5.title else nil,
			descriptionLength = if p5.description ~= nil then #p5.description else nil
		}
		local g48 = nil
		local result = nil

		if typeof(p6) == "table" then
			local ok

			ok, result = pcall(function() -- line: 29
				-- upvalues: HttpService (copy), p6 (copy)
				return HttpService:JSONEncode(p6)
			end)

			if ok then
				g48 = true
			end
		end

		if not g48 then
			result = tostring(p6)
		end

		g48 = false
		t3.error = result
		t3.rawError = p6
		log("warn", v44, t3)

		return nil
	end)
end
local function waitForRetry(n3: number, n4: number) -- line: 103
	-- upvalues: Promise (copy)
	if n4 == 0 then
		return Promise.resolve()
	end

	return Promise.new(function(resolve) -- line: 108
		-- upvalues: n4 (copy), n3 (copy)
		task.delay(n4 * n3 / 1000, resolve)
	end)
end
local function rollbackPlaceWithRetry(n5: number, n6: number, t4: {[any]: any}?) -- line: 113
	-- upvalues: v6 (copy), v7 (copy), PlaceVersionHistory (copy), Promise (copy), copyVersionNoteAfterRollback (copy)
	local v33 = t4 or {}
	local v34 = if v33.retries == nil then v6 else v33.retries
	local v35 = if v33.retryDelayMs == nil then v7 else v33.retryDelayMs
	local v36 = v33.published ~= nil and v33.published
	local v37 = PlaceVersionHistory.getPlaceVersionHistoryStore()

	local function rollbackWithRetry(n7: number, p7) -- line: 128
		-- upvalues: v37 (copy), n5 (copy), n6 (copy), v36 (copy), v34 (copy), Promise (copy), v35 (copy), rollbackWithRetry (copy)
		local v52 = if p7 == nil then nil else p7.description

		return v37.rollbackPlace(n5, n6, v52, v36):catch(function(p8) -- line: 130
			-- upvalues: n7 (copy), v34 (copy), Promise (copy), v35 (copy), rollbackWithRetry (copy), p7 (copy)
			if n7 >= v34 then
				return Promise.reject(p8)
			end

			local v58 = n7 + 1
			local v59 = v35

			return ((if v59 ~= 0 then Promise.new(function(resolve) -- line: 108
				-- upvalues: v59 (copy), v58 (copy)
				task.delay(v59 * v58 / 1000, resolve)
			end) else Promise.resolve())):andThen(function() -- line: 136
				-- upvalues: rollbackWithRetry (copy), v58 (copy), p7 (copy)
				return rollbackWithRetry(v58, p7)
			end)
		end)
	end

	local note = v33.note
	local v40 = if note == nil then nil else note.description
	local n8 = 0

	return v37.rollbackPlace(n5, n6, v40, v36):catch(function(p9) -- line: 130
		-- upvalues: n8 (copy), v34 (copy), Promise (copy), v35 (copy), rollbackWithRetry (copy), note (copy)
		if n8 >= v34 then
			return Promise.reject(p9)
		end

		local v54 = n8 + 1
		local v55 = v35

		return ((if v55 ~= 0 then Promise.new(function(resolve) -- line: 108
			-- upvalues: v55 (copy), v54 (copy)
			task.delay(v55 * v54 / 1000, resolve)
		end) else Promise.resolve())):andThen(function() -- line: 136
			-- upvalues: rollbackWithRetry (copy), v54 (copy), note (copy)
			return rollbackWithRetry(v54, note)
		end)
	end):andThen(function(p10) -- line: 143
		-- upvalues: copyVersionNoteAfterRollback (copy), v37 (copy), n5 (copy), n6 (copy), v33 (copy), note (copy)
		return copyVersionNoteAfterRollback(v37, n5, n6, p10, v33, note):andThen(function() -- line: 145
			-- upvalues: p10 (copy)
			return p10
		end)
	end)
end

return rollbackPlaceWithRetry
