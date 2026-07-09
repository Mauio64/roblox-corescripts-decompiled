local ScriptProfilerService = game:GetService("ScriptProfilerService")
local t1 = {}

t1.__index = t1

function t1.new(s1: string) -- line: 52
	-- upvalues: t1 (copy), ScriptProfilerService (copy)
	local v4 = setmetatable({
		_data = nil
	}, t1)
	local ok, result = pcall(function() -- line: 58
		-- upvalues: ScriptProfilerService (copy), s1 (copy)
		return ScriptProfilerService:DeserializeJSON(s1)
	end)

	if ok then
		v4._data = result

		return v4
	end

	warn("[ProfilerDataParser] Failed to deserialize JSON:", result)

	return v4
end
function t1.getFunctionById(t2: {[any]: any}, n1: number) -- line: 72
	if not t2._data then
		return nil
	end

	return t2._data.Functions[n1]
end
function t1.getNodeById(t3: {[any]: any}, n2: number) -- line: 80
	local _data = t3._data

	if not _data then
		return nil
	end

	return _data.Nodes[n2]
end
function t1.getSessionDuration(p1) -- line: 89
	local _data = p1._data

	if not _data then
		return nil
	end

	local SessionStartTime = _data.SessionStartTime
	local SessionEndTime = _data.SessionEndTime

	if SessionStartTime and SessionEndTime then
		return SessionEndTime - SessionStartTime
	end

	return nil
end
function t1.getTotalFunctions(p2) -- line: 103
	if not p2._data then
		return 0
	end

	return #p2._data.Functions
end
function t1.getTotalNodes(p3) -- line: 111
	local _data = p3._data

	if not _data then
		return 0
	end

	return #_data.Nodes
end
function t1.parsePackageName(s2: string?) -- line: 127
	if not s2 or s2 == "" then
		return "Unknown"
	end

	local match = string.match(s2, "^CorePackages%.Packages%._Index%.([^%.%-]+)")

	if match then
		return match
	end

	local match2 = string.match(s2, "^CorePackages%.Workspace%.Packages%._Workspace%.([^%.]+)")

	if match2 then
		return match2
	end

	if string.match(s2, "^CoreGui%.RobloxGui") then
		return s2:match("^CoreGui%.RobloxGui%.(.*)")
	end

	if string.match(s2, "^Players%.") then
		if string.match(s2, "CameraModule") then
			return "CameraModule"
		end

		if string.match(s2, "ControlModule") then
			return "ControlModule"
		end

		return "Players"
	end

	return "Unknown"
end
function t1.getPackageStatistics(p4) -- line: 167
	-- upvalues: t1 (copy)
	if not p4._data then
		return {}
	end

	local t4 = {}

	for _, v25 in p4._data.Categories do
		for _, v27 in p4._data.Nodes[v25.NodeId].Children do
			local v28 = p4._data.Nodes[v27]

			for v29, _ in v28.Children do
				local num = tonumber(v29)

				if not num then
					break
				end

				local v32 = p4._data.Functions[num]

				if not v32 then
					break
				end

				local v33 = t1.parsePackageName(v32.Source)

				if not v33 then
					break
				end

				if not t4[v33] then
					t4[v33] = {
						count = 0,
						totalDuration = 0
					}
				end

				local v34 = t4[v33]

				v34.count = v34.count + 1

				local v35 = t4[v33]

				v35.totalDuration = v35.totalDuration + v28.TotalDuration

				break
			end
		end
	end

	return t4
end

return t1
