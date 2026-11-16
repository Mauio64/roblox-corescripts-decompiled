local function forwardErrorToScriptContext(p, p2: string?)
	task.spawn(function()
		error(tostring(p) .. "\n" .. (not p2 and "" or p2), 0)
	end)
end

return forwardErrorToScriptContext
