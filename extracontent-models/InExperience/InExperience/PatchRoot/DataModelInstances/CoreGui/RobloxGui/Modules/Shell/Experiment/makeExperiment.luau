local IXPService = game:GetService("IXPService")

local function makeExperiment(p: string, p2: string, p3: string, p4: string, p5: string)
	for _, v in { p, p2, p3, p4, p5 } do
		if not IXPService[v] then
			error("makeExperiment factory expects configured members to exist on IXPService. Member " .. v .. " not found")
		end
	end

	return function(instance, list, callback, flag: boolean?)
		local v = flag == nil or flag

		assert(type(list) == "table", "makeExperiment expects layerNames to be a list of layers")
		assert(type(callback) == "function", "makeExperiment expects mapLayers to be a function")

		local function updateStateLayerData(layerLoadingStatus: string)
			local layerToVariables = {}

			for _, item in ipairs(list) do
				layerToVariables[item] = IXPService[p3](IXPService, item)
			end

			callback({
				layerToVariables = layerToVariables,
				layerLoadingStatus = layerLoadingStatus
			})
		end

		local function logAllLayersExposure()
			for _, item in ipairs(list) do
				if IXPService[p5](IXPService, item) == Enum.IXPLoadingStatus.Initialized then
					IXPService[p4](IXPService, item)
				end
			end
		end

		updateStateLayerData(IXPService[p2](IXPService))

		local connection = IXPService[p]:Connect(function()
			local layerLoadingStatus = IXPService[p2](IXPService)
			updateStateLayerData(layerLoadingStatus)

			if v and layerLoadingStatus == Enum.IXPLoadingStatus.Initialized then
				logAllLayersExposure()
			end
		end)

		instance.Destroying:Once(function()
			connection:Disconnect()
		end)

		return connection
	end
end

return makeExperiment
