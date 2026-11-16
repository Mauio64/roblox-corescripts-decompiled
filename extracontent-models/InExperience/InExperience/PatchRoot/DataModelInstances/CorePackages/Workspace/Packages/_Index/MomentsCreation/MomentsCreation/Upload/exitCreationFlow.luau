local function exitCreationFlow(callback)
	if callback then
		callback()
	end
end

return exitCreationFlow
