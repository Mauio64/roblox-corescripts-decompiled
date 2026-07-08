local Immutable = require(script.Parent.Parent.Immutable)
local AppendRecentDumpPath = require(script.Parent.Parent.Actions.AppendRecentDumpPath)
local SetRCCProfilerState = require(script.Parent.Parent.Actions.SetRCCProfilerState)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 12
	-- upvalues: SetRCCProfilerState (copy), Immutable (copy), AppendRecentDumpPath (copy)
	local v6 = t1 or {
		waitingForRecording = false,
		lastFileOutputLocation = "",
		recentDumpPaths = {}
	}

	if t2.type == SetRCCProfilerState.name then
		local t3 = {
			waitingForRecording = t2.waitingForRecording,
			lastFileOutputLocation = t2.lastFileOutputLocation,
			recentDumpPaths = v6.recentDumpPaths
		}

		return (Immutable.JoinDictionaries(v6, t3))
	end

	if t2.type == AppendRecentDumpPath.name then
		local t4 = {
			waitingForRecording = v6.waitingForRecording,
			lastFileOutputLocation = v6.lastFileOutputLocation,
			recentDumpPaths = Immutable.Append(v6.recentDumpPaths, t2.dumpPath)
		}

		return (Immutable.JoinDictionaries(v6, t4))
	end

	return v6
end
