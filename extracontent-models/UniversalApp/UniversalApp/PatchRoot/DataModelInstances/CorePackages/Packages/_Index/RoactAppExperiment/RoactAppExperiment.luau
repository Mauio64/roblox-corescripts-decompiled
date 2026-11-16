local RunService = game:GetService("RunService")
local IXPService = game:GetService("IXPService")

local Roact = require(script.Parent.Roact)
local t = require(script.Parent.t)
local Cryo = require(script.Parent.Cryo)
local Symbol = require(script.Symbol)

local ExperimentContext = require(script.ExperimentContext)
local named = Symbol.named("IxpServiceProp")

local function connect(p: string, p2: string, p3: string, p4: string, p5: string)
	assert(t.string(p))
	assert(t.string(p2))
	assert(t.string(p3))
	assert(t.string(p4))
	assert(t.string(p5))

	return function(list, callback, flag: boolean?)
		local v = flag == nil or flag

		local traceback = debug.traceback()
		assert(type(list) == "table", "connect expects layerNames to be a list of layers")
		assert(type(callback) == "function", "connect expects mapLayersToProps to be a function")

		return function(p6)
			if p6 == nil then
				local v2 = string.format(
					"connect returns a function that must be passed a component.\n Check the connection at:\n %s",
					traceback
				)

				error(v2, 2)
			end

			local formatted = ("AppExperiment(%s)"):format((tostring(p6)))
			local extended = Roact.PureComponent:extend(formatted)

			function extended:init()
				self.onLoadingStatusChangeConnection = nil
				self.state = {
					layerToVariables = {},
					layerLoadingStatus = Enum.IXPLoadingStatus.None
				}

				function self.updateStateLayerData(layerLoadingStatus)
					local v2 = self.props[named]

					if v2 ~= nil then
						local layerToVariables = {}

						for _, item in ipairs(list) do
							layerToVariables[item] = v2[p3](v2, item)
						end

						self:setState({
							layerToVariables = layerToVariables,
							layerLoadingStatus = layerLoadingStatus
						})
					end
				end

				function self.logAllLayersExposure(p7)
					local v2 = self.props[named]

					if v2 ~= nil and p7 == Enum.IXPLoadingStatus.Initialized and v then
						for _, item in ipairs(list) do
							if v2[p5](v2, item) == Enum.IXPLoadingStatus.Initialized then
								v2[p4](v2, item)
							end
						end
					end
				end

				local v2 = self.props[named]

				if v2 ~= nil then
					local v3 = v2[p2](v2)
					self.updateStateLayerData(v3)
				end
			end

			function extended.render(p7)
				local joined = Cryo.Dictionary.join(p7.props, { [named] = Cryo.None })

				local v2 = callback(p7.state.layerToVariables, joined)
				local joined2 = Cryo.Dictionary.join(joined, v2)
				return Roact.createElement(p6, joined2)
			end

			function extended:didMount()
				local v2 = self.props[named]

				if v2 ~= nil then
					self.onLoadingStatusChangeConnection = v2[p]:Connect(function(_)
						local v3 = v2[p2](v2)

						if self.state.layerLoadingStatus ~= v3 then
							self.updateStateLayerData(v3, p3)
							self.logAllLayersExposure(v3)
						end
					end)

					local v3 = v2[p2](v2)

					if self.state.layerLoadingStatus ~= v3 then
						self.updateStateLayerData(v3, p3)
					end

					self.logAllLayersExposure(v3)
				end
			end

			function extended.willUnmount(p7)
				if p7.onLoadingStatusChangeConnection ~= nil then
					p7.onLoadingStatusChangeConnection:Disconnect()
				end
			end

			return function(p7)
				return Roact.createElement(ExperimentContext.Consumer, {
					render = function(p8)
						assert(p7[named] == nil, "Symbol 'IxpServiceProp' should never exist in the incoming props.")

						local joined = Cryo.Dictionary.join(p7, { [named] = p8 })

						return Roact.createElement(extended, joined)
					end
				})
			end
		end
	end
end

local connectBrowserTrackerLayer = connect(
	"OnBrowserTrackerLayerLoadingStatusChanged",
	"GetBrowserTrackerLayerLoadingStatus",
	"GetBrowserTrackerLayerVariables",
	"LogBrowserTrackerLayerExposure",
	"GetBrowserTrackerStatusForLayer"
)

local connectUserLayer = connect(
	"OnUserLayerLoadingStatusChanged",
	"GetUserLayerLoadingStatus",
	"GetUserLayerVariables",
	"LogUserLayerExposure",
	"GetUserStatusForLayer"
)
local RoactAppExperiment = {}
RoactAppExperiment.Provider = ExperimentContext.Provider
RoactAppExperiment.Consumer = ExperimentContext.Consumer
RoactAppExperiment.Context = ExperimentContext

function RoactAppExperiment.registerUserLayers(items)
	assert(t.table(items))

	if IXPService ~= nil then
		if RunService:IsStudio() then
			IXPService:ClearUserLayers()
		end

		local v = {}

		for _, item in pairs(items) do
			table.insert(v, item)
		end

		IXPService:RegisterUserLayers(v)
	end
end

function RoactAppExperiment.initializeUserLayers(p: number)
	if IXPService ~= nil then
		IXPService:InitializeUserLayers(p)
	end
end

function RoactAppExperiment.clearUserLayers()
	if IXPService ~= nil then
		IXPService:ClearUserLayers()
	end
end

RoactAppExperiment.useBrowserTrackerExperiment = require(script.useBrowserTrackerExperiment)
RoactAppExperiment.useUserExperiment = require(script.useUserExperiment)
RoactAppExperiment.useIXPService = require(script.useIXPService)
RoactAppExperiment.connectBrowserTrackerLayer = connectBrowserTrackerLayer
RoactAppExperiment.connectUserLayer = connectUserLayer
RoactAppExperiment.MockIXPService = require(script.MockIXPService)
return RoactAppExperiment
