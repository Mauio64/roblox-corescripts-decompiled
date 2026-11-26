local function forwardErrorToScriptContext(message)
	task.spawn(function()
		error(message, 0)
	end)
end

return forwardErrorToScriptContext
