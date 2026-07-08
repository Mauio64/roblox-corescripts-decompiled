local function schedulePrefetchDelay(n1: number, p1: ((...any) -> ...any)) -- line: 4
	local function guardedCallback() -- line: 5
		-- upvalues: p1 (copy)
		if not game:IsLoaded() then
			return
		end

		p1()
	end

	task.delay(n1, guardedCallback)
end

return schedulePrefetchDelay
