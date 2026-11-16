local Immutable = require(script.Parent.Parent.Immutable)

local AppendRecentDumpPath = require(script.Parent.Parent.Actions.AppendRecentDumpPath)
local SetRCCProfilerState = require(script.Parent.Parent.Actions.SetRCCProfilerState)

return function(p, data)
	local selected = p or {
		waitingForRecording = false,
		lastFileOutputLocation = "",
		recentDumpPaths = {}
	}

	if data.type == SetRCCProfilerState.name then
		local v = {
			waitingForRecording = data.waitingForRecording,
			lastFileOutputLocation = data.lastFileOutputLocation,
			recentDumpPaths = selected.recentDumpPaths
		}

		return (Immutable.JoinDictionaries(selected, v))
	end

	if data.type ~= AppendRecentDumpPath.name then
		return selected
	end

	local v = {
		waitingForRecording = selected.waitingForRecording,
		lastFileOutputLocation = selected.lastFileOutputLocation,
		recentDumpPaths = Immutable.Append(selected.recentDumpPaths, data.dumpPath)
	}

	return (Immutable.JoinDictionaries(selected, v))
end
