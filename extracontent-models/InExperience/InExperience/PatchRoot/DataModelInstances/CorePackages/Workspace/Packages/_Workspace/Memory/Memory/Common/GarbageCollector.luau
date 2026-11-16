local GarbageCollector = {}
function trigger()
	return collectgarbage("collect")
end

function GarbageCollector.collect()
	pcall(trigger)
	pcall(trigger)
	task.wait()
end

return GarbageCollector
