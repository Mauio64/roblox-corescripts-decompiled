local function forwardErrorToScriptContext(message: string)
	task.spawn(function()
		error(message, 0)
	end)
end

return forwardErrorToScriptContext
