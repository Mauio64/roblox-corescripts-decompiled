local ScriptProfilerService = game:GetService("ScriptProfilerService")

local ProfilerDataParser = {}
ProfilerDataParser.__index = ProfilerDataParser

function ProfilerDataParser.new(p: string)
	local self = setmetatable({ _data = nil }, ProfilerDataParser)

	local success, result = pcall(function()
		return ScriptProfilerService:DeserializeJSON(p)
	end)

	if success then
		self._data = result
		return self
	end

	warn("[ProfilerDataParser] Failed to deserialize JSON:", result)

	return self
end

function ProfilerDataParser:getFunctionById(p: number)
	if self._data then
		return self._data.Functions[p]
	end

	return nil
end

function ProfilerDataParser:getNodeById(p: number)
	local data = self._data

	if data then
		return data.Nodes[p]
	end

	return nil
end

function ProfilerDataParser:getSessionDuration()
	local data = self._data

	if not data then
		return nil
	end

	local sessionStartTime = data.SessionStartTime
	local sessionEndTime = data.SessionEndTime

	if sessionStartTime and sessionEndTime then
		return sessionEndTime - sessionStartTime
	end

	return nil
end

function ProfilerDataParser:getTotalFunctions()
	if self._data then
		return #self._data.Functions
	end

	return 0
end

function ProfilerDataParser:getTotalNodes()
	local data = self._data

	if data then
		return #data.Nodes
	end

	return 0
end

function ProfilerDataParser.parsePackageName(value: string?)
	if not value or value == "" then
		return "Unknown"
	end

	local v = string.match(value, "^CorePackages%.Packages%._Index%.([^%.%-]+)")

	if v then
		return v
	end

	local v2 = string.match(value, "^CorePackages%.Workspace%.Packages%._Workspace%.([^%.]+)")

	if v2 then
		return v2
	end

	if string.match(value, "^CoreGui%.RobloxGui") then
		return value:match("^CoreGui%.RobloxGui%.(.*)")
	end

	if not string.match(value, "^Players%.") then
		return "Unknown"
	end

	if string.match(value, "CameraModule") then
		return "CameraModule"
	end

	if string.match(value, "ControlModule") then
		return "ControlModule"
	end

	return "Players"
end

function ProfilerDataParser:getPackageStatistics()
	if not self._data then
		return {}
	end

	local result = {}

	for _, category in self._data.Categories do
		for _, child in self._data.Nodes[category.NodeId].Children do
			local node = self._data.Nodes[child]

			for k, _ in node.Children do
				local v = tonumber(k)

				if not v then
					break
				end

				local v2 = self._data.Functions[v]

				if v2 then
					local packageName = ProfilerDataParser.parsePackageName(v2.Source)

					if packageName then
						if not result[packageName] then
							result[packageName] = { count = 0, totalDuration = 0 }
						end

						result[packageName].count += 1
						result[packageName].totalDuration += node.TotalDuration
					end
				end

				break
			end
		end
	end

	return result
end

return ProfilerDataParser
