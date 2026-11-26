local function forwardErrorToScriptContext(p2, p3)
	task.spawn(function()
		error(tostring(p2) .. "\n" .. (not p3 and "" or p3), 0)
	end)
end

return forwardErrorToScriptContext
