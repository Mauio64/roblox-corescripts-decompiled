local v5 = {}
function LUAUFORGE_MODULE_GLOBALS_adX_trigger()
	return collectgarbage("collect")
end

function v5.collect()
	pcall(LUAUFORGE_MODULE_GLOBALS_adX_trigger)
	pcall(LUAUFORGE_MODULE_GLOBALS_adX_trigger)
	task.wait()
end

return v5
