local RunService = game:GetService("RunService")
local IXPService = game:GetService("IXPService")
local Roact = require(script.Parent.Roact)
local t = require(script.Parent.t)
local Cryo = require(script.Parent.Cryo)
local Symbol = require(script.Symbol)
local ExperimentContext = require(script.ExperimentContext)
local v8 = Symbol.named("IxpServiceProp")

local function connect(s1: string, s2: string, s3: string, s4: string, s5: string) -- line: 79
	-- upvalues: t (copy), Roact (copy), v8 (copy), Cryo (copy), ExperimentContext (copy)
	assert(t.string(s1))
	assert(t.string(s2))
	assert(t.string(s3))
	assert(t.string(s4))
	assert(t.string(s5))

	return function(p1, p2, b1: boolean?) -- line: 95
		-- upvalues: Roact (copy), v8 (copy), s3 (copy), s5 (copy), s4 (copy), s2 (copy), Cryo (copy), s1 (copy), ExperimentContext (copy)
		if b1 == nil then
			b1 = true
		end

		local trace = debug.traceback()

		assert(type(p1) == "table", "connect expects layerNames to be a list of layers")
		assert(type(p2) == "function", "connect expects mapLayersToProps to be a function")

		return function(p3) -- line: 104
			-- upvalues: trace (copy), Roact (copy), v8 (copy), p1 (copy), s3 (copy), b1 (ref), s5 (copy), s4 (copy), s2 (copy), Cryo (copy), p2 (copy), s1 (copy), ExperimentContext (copy)
			if p3 == nil then
				local v28 = string.format("connect returns a function that must be passed a component.\n Check the connection at:\n %s", trace)

				error(v28, 2)
			end

			local v29 = ("AppExperiment(%s)"):format((tostring(p3)))
			local v30 = Roact.PureComponent:extend(v29)

			function v30.init(p4) -- line: 117
				-- upvalues: v8 (copy), p1 (copy), s3 (copy), b1 (ref), s5 (copy), s4 (copy), s2 (copy)
				p4.onLoadingStatusChangeConnection = nil
				p4.state = {
					layerToVariables = {},
					layerLoadingStatus = Enum.IXPLoadingStatus.None
				}

				function p4.updateStateLayerData(p5) -- line: 124
					-- upvalues: p4 (copy), v8 (copy), p1 (copy), s3 (copy)
					local v44 = p4.props[v8]

					if v44 ~= nil then
						local t1 = {}

						for _, v in ipairs(p1) do
							t1[v] = v44[s3](v44, v)
						end

						p4:setState({
							layerToVariables = t1,
							layerLoadingStatus = p5
						})
					end
				end
				function p4.logAllLayersExposure(p6) -- line: 140
					-- upvalues: p4 (copy), v8 (copy), b1 (ref), p1 (copy), s5 (copy), s4 (copy)
					local v49 = p4.props[v8]

					if v49 ~= nil and (p6 == Enum.IXPLoadingStatus.Initialized and b1) then
						for _, v in ipairs(p1) do
							if v49[s5](v49, v) == Enum.IXPLoadingStatus.Initialized then
								v49[s4](v49, v)
							end
						end
					end
				end

				local v32 = p4.props[v8]

				if v32 ~= nil then
					local v33 = v32[s2](v32)

					p4.updateStateLayerData(v33)
				end
			end
			function v30.render(p7) -- line: 163
				-- upvalues: Cryo (copy), v8 (copy), p2 (copy), Roact (copy), p3 (copy)
				local v35 = Cryo.Dictionary.join(p7.props, {
					[v8] = Cryo.None
				})
				local v36 = p2(p7.state.layerToVariables, v35)
				local v37 = Cryo.Dictionary.join(v35, v36)

				return Roact.createElement(p3, v37)
			end
			function v30.didMount(p8) -- line: 172
				-- upvalues: v8 (copy), s1 (copy), s2 (copy), s3 (copy)
				local v39 = p8.props[v8]

				if v39 ~= nil then
					p8.onLoadingStatusChangeConnection = v39[s1]:Connect(function(_) -- line: 177
						-- upvalues: v39 (copy), s2 (copy), p8 (copy), s3 (copy)
						local v53 = v39[s2](v39)

						if v53 ~= p8.state.layerLoadingStatus then
							p8.updateStateLayerData(v53, s3)
							p8.logAllLayersExposure(v53)
						end
					end)

					local v40 = v39[s2](v39)

					if v40 ~= p8.state.layerLoadingStatus then
						p8.updateStateLayerData(v40, s3)
					end

					p8.logAllLayersExposure(v40)
				end
			end
			function v30.willUnmount(p10) -- line: 200
				if p10.onLoadingStatusChangeConnection ~= nil then
					p10.onLoadingStatusChangeConnection:Disconnect()
				end
			end

			return function(p11) -- line: 206
				-- upvalues: Roact (copy), ExperimentContext (copy), v8 (copy), Cryo (copy), v30 (copy)
				return Roact.createElement(ExperimentContext.Consumer, {
					render = function(p12) -- line: 208
						-- upvalues: p11 (copy), v8 (copy), Cryo (copy), Roact (copy), v30 (copy)
						assert(p11[v8] == nil, "Symbol 'IxpServiceProp' should never exist in the incoming props.")

						local v55 = Cryo.Dictionary.join(p11, {
							[v8] = p12
						})

						return Roact.createElement(v30, v55)
					end
				})
			end
		end
	end
end

local v10 = connect("OnBrowserTrackerLayerLoadingStatusChanged", "GetBrowserTrackerLayerLoadingStatus", "GetBrowserTrackerLayerVariables", "LogBrowserTrackerLayerExposure", "GetBrowserTrackerStatusForLayer")
local v11 = connect("OnUserLayerLoadingStatusChanged", "GetUserLayerLoadingStatus", "GetUserLayerVariables", "LogUserLayerExposure", "GetUserStatusForLayer")

return {
	Provider = ExperimentContext.Provider,
	Consumer = ExperimentContext.Consumer,
	Context = ExperimentContext,
	registerUserLayers = function(t2: {[any]: any}) -- line: 31
		-- upvalues: t (copy), IXPService (copy), RunService (copy)
		assert(t.table(t2))

		if IXPService ~= nil then
			if RunService:IsStudio() then
				IXPService:ClearUserLayers()
			end

			local t3 = {}

			for _, v in pairs(t2) do
				table.insert(t3, v)
			end

			IXPService:RegisterUserLayers(t3)
		end
	end,
	initializeUserLayers = function(n1: number) -- line: 54
		-- upvalues: IXPService (copy)
		if IXPService ~= nil then
			IXPService:InitializeUserLayers(n1)
		end
	end,
	clearUserLayers = function() -- line: 66
		-- upvalues: IXPService (copy)
		if IXPService ~= nil then
			IXPService:ClearUserLayers()
		end
	end,
	useBrowserTrackerExperiment = require(script.useBrowserTrackerExperiment),
	useUserExperiment = require(script.useUserExperiment),
	useIXPService = require(script.useIXPService),
	connectBrowserTrackerLayer = v10,
	connectUserLayer = v11,
	MockIXPService = require(script.MockIXPService)
}
