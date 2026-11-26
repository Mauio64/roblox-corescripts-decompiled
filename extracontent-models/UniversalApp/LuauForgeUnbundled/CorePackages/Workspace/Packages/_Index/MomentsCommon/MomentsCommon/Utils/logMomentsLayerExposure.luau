local function logMomentsLayerExposure(p2, object)
	if p2 == "" then
		return
	end

	if object == nil then
		if not game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			return
		end

		object = game:GetService("IXPService")
	end

	pcall(function()
		object:LogFlagLinkedUserLayerExposure(p2)
	end)
end

return logMomentsLayerExposure
