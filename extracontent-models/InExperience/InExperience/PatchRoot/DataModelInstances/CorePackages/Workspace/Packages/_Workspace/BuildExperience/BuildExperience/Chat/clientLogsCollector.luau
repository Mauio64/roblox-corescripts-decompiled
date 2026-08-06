local Parent = script:FindFirstAncestor("BuildExperience").Parent
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local StudioClientLogsTool = require(Parent.DataHydration.CreatorAgentChat).StudioClientLogsTool

game:DefineFastInt("MyStatsExperienceAskForLogsMaxEntries", 100)

local function getDefaultMaxEntriesPerSource() -- line: 20
	return (math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries")))
end

local t1 = {
	[Enum.MessageType.MessageOutput.Value] = "Output",
	[Enum.MessageType.MessageInfo.Value] = "Information",
	[Enum.MessageType.MessageWarning.Value] = "Warning",
	[Enum.MessageType.MessageError.Value] = "Error"
}

local function getMessageTypeValue(p1) -- line: 31
	if typeof(p1) == "EnumItem" then
		return p1.Value
	end

	if typeof(p1) == "number" then
		return p1
	end

	return nil
end
local function getMessageTypeLabel(p2) -- line: 41
	-- upvalues: t1 (copy)
	local v23 = if typeof(p2) ~= "EnumItem" then if typeof(p2) ~= "number" then nil else p2 else p2.Value

	if v23 ~= nil then
		return t1[v23] or tostring(v23)
	end

	if typeof(p2) == "EnumItem" then
		return p2.Name
	end

	if typeof(p2) == "string" and p2 ~= "" then
		return p2
	end

	return nil
end
local function encodeContext(p3) -- line: 55
	-- upvalues: HttpService (copy)
	if typeof(p3) ~= "table" or next(p3) == nil then
		return nil
	end

	return HttpService:JSONEncode(p3)
end
local function pushCapped(t2: {[any]: any}, p4, n1: number) -- line: 63
	if n1 <= 0 then
		return
	end

	table.insert(t2, p4)

	if n1 < #t2 then
		table.remove(t2, 1)
	end
end
local function toLogEntry(p5, p6, p7, p8) -- line: 73
	-- upvalues: t1 (copy), HttpService (copy)
	local v32 = if typeof(p5) ~= "string" then tostring(p5 or "") else p5
	local v33 = if typeof(p7) ~= "number" then nil else p7
	local t3 = {
		message = v32
	}
	local v35 = if typeof(p6) ~= "EnumItem" then if typeof(p6) ~= "number" then nil else p6 else p6.Value

	t3.messageType = if v35 == nil then if typeof(p6) ~= "EnumItem" then if typeof(p6) ~= "string" or p6 == "" then nil else p6 else p6.Name else t1[v35] or tostring(v35)
	t3.messageTypeValue = if typeof(p6) ~= "EnumItem" then if typeof(p6) ~= "number" then nil else p6 else p6.Value
	t3.timestamp = v33
	t3.contextJson = if typeof(p8) == "table" and next(p8) ~= nil then HttpService:JSONEncode(p8) else nil

	return t3
end

local t4 = {}
local connection = nil
local connection2 = nil
local u15 = false
local u16 = math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))

local function collectClientLogs(p9, n2: number?) -- line: 91
	-- upvalues: LogService (copy), toLogEntry (copy)
	local v38 = p9 or LogService
	local v39 = n2 or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))
	local t5 = {}

	for _, v42 in (v38:GetLogHistory()) do
		if typeof(v42) == "table" then
			local v43 = toLogEntry(v42.message, v42.messageType, v42.timestamp, v42.context)

			if not (v39 <= 0) then
				table.insert(t5, v43)

				if v39 < #t5 then
					table.remove(t5, 1)
				end
			end
		end
	end

	return t5
end
local function trimServerLogs(n3: number) -- line: 106
	-- upvalues: t4 (ref)
	while n3 < #t4 do
		table.remove(t4, 1)
	end
end
local function startServerLogCollection(t6: {[any]: any}?) -- line: 127
	-- upvalues: u15 (ref), LogService (copy), u16 (ref), t4 (ref), connection (ref), toLogEntry (copy), connection2 (ref)
	local v47 = t6 or {}

	if (v47.dataModel or game).GameId == 0 then
		return false
	end

	if u15 then
		return true
	end

	local v48 = v47.logService or LogService

	u16 = v47.maxEntriesPerSource or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))

	local v49 = u16

	while v49 < #t4 do
		table.remove(t4, 1)
	end

	connection = v48.ServerMessageOut:Connect(function(p10, p11, p12, p13) -- line: 141
		-- upvalues: t4 (ref), toLogEntry (copy), u16 (ref)
		local v61 = t4
		local v62 = toLogEntry(p10, p11, p12, p13)
		local v63 = u16

		if v63 <= 0 then
			return
		end

		table.insert(v61, v62)

		if v63 < #v61 then
			table.remove(v61, 1)
		end
	end)
	connection2 = v48.ServerContextOut:Connect(function(p14) -- line: 146
		-- upvalues: t4 (ref), toLogEntry (copy), u16 (ref)
		if typeof(p14) ~= "table" or p14._structuredContext == nil then
			return
		end

		local v65 = t4
		local v66 = toLogEntry(p14._message, p14._messageType, p14._timestamp, p14._structuredContext)
		local v67 = u16

		if v67 <= 0 then
			return
		end

		table.insert(v65, v66)

		if v67 < #v65 then
			table.remove(v65, 1)
		end
	end)
	v48:RequestServerOutput()
	u15 = true

	return true
end
local function getCollectedServerLogs(n4: number?) -- line: 163
	-- upvalues: t4 (ref)
	local v51 = n4 or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))
	local t7 = {}

	for i = math.max(1, #t4 - v51 + 1), #t4 do
		table.insert(t7, t4[i])
	end

	return t7
end

return {
	startServerLogCollection = startServerLogCollection,
	stopServerLogCollection = function(b1: boolean?) -- line: 112
		-- upvalues: connection (ref), connection2 (ref), u15 (ref), t4 (ref)
		if connection ~= nil then
			connection:Disconnect()
			connection = nil
		end

		if connection2 ~= nil then
			connection2:Disconnect()
			connection2 = nil
		end

		u15 = false

		if b1 == true then
			t4 = {}
		end
	end,
	collectToolResultContent = function(t8: {[any]: any}?) -- line: 173
		-- upvalues: StudioClientLogsTool (copy), startServerLogCollection (copy), collectClientLogs (copy), getCollectedServerLogs (copy)
		local v55 = t8 or {}

		if (v55.dataModel or game).GameId == 0 then
			return StudioClientLogsTool.formatNotInGameContent()
		end

		local v56 = v55.maxEntriesPerSource or math.max(0, game:GetFastInt("MyStatsExperienceAskForLogsMaxEntries"))

		startServerLogCollection(v55)

		return StudioClientLogsTool.formatLogsContent(collectClientLogs(v55.logService, v56), (getCollectedServerLogs(v56)))
	end
}
