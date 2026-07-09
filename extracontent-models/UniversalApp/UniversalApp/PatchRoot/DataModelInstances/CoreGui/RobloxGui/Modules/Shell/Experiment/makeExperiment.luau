local IXPService = game:GetService("IXPService")

local function makeExperiment(s1: string, s2: string, s3: string, s4: string, s5: string) -- line: 23
	-- upvalues: IXPService (copy)
	for _, v9 in {
		s1,
		s2,
		s3,
		s4,
		s5
	} do
		if not IXPService[v9] then
			error("makeExperiment factory expects configured members to exist on IXPService. Member " .. v9 .. " not found")
		end
	end

	return function(p1, t1: {[any]: any}, p2: ((...any) -> ...any), b1: boolean?) -- line: 44
		-- upvalues: IXPService (copy), s3 (copy), s5 (copy), s4 (copy), s2 (copy), s1 (copy)
		if b1 == nil then
			b1 = true
		end

		assert(type(t1) == "table", "makeExperiment expects layerNames to be a list of layers")
		assert(type(p2) == "function", "makeExperiment expects mapLayers to be a function")

		local function updateStateLayerData(s6: string) -- line: 57
			-- upvalues: t1 (copy), IXPService (copy), s3 (copy), p2 (copy)
			local t2 = {}

			for _, v in ipairs(t1) do
				t2[v] = IXPService[s3](IXPService, v)
			end

			p2({
				layerToVariables = t2,
				layerLoadingStatus = s6
			})
		end
		local function logAllLayersExposure() -- line: 69
			-- upvalues: t1 (copy), IXPService (copy), s5 (copy), s4 (copy)
			for _, v in ipairs(t1) do
				if IXPService[s5](IXPService, v) == Enum.IXPLoadingStatus.Initialized then
					IXPService[s4](IXPService, v)
				end
			end
		end

		updateStateLayerData((IXPService[s2](IXPService)))

		local connection = IXPService[s1]:Connect(function() -- line: 81
			-- upvalues: IXPService (copy), s2 (copy), updateStateLayerData (copy), b1 (ref), logAllLayersExposure (copy)
			local v24 = IXPService[s2](IXPService)

			updateStateLayerData(v24)

			if b1 and v24 == Enum.IXPLoadingStatus.Initialized then
				logAllLayersExposure()
			end
		end)

		p1.Destroying:Once(function() -- line: 95
			-- upvalues: connection (copy)
			connection:Disconnect()
		end)

		return connection
	end
end

return makeExperiment
