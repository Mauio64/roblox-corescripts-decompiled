local function waitForEvents() -- line: 6
	task.defer(coroutine.running())
	coroutine.yield()
end

return waitForEvents
