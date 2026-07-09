local t1 = {}

function trigger() -- line: 3
	return collectgarbage("collect")
end
function t1.collect() -- line: 8
	pcall(trigger)
	pcall(trigger)
	task.wait()
end

return t1
