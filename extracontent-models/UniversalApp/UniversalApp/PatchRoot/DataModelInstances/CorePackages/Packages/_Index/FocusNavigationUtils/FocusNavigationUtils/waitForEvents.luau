local function waitForEvents()
	task.defer(coroutine.running())
	coroutine.yield()
end

return waitForEvents
