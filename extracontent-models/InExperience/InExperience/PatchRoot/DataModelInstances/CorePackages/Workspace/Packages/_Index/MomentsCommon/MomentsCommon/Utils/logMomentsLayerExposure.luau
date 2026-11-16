local function logMomentsLayerExposure(p: string, object)
	if p == "" then
		return
	end

	if object == nil then
		if not game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			return
		end

		object = game:GetService("IXPService")
	end

	pcall(function()
		object:LogFlagLinkedUserLayerExposure(p)
	end)
end

return logMomentsLayerExposure
