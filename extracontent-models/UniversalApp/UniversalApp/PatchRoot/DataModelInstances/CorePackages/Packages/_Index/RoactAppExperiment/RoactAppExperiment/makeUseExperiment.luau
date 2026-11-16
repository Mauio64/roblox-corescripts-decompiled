local RoactAppExperiment = script:FindFirstAncestor("RoactAppExperiment")

local React = require(RoactAppExperiment.Parent.React)
local usePrevious = require(script.Parent.usePrevious)
local useIXPService = require(RoactAppExperiment.useIXPService)

local function getLayerNamesKey(list) -- 1 equivalent call inferred from this helper
	local layerNamesKey = ""

	for i, item in ipairs(list) do
		if i > 1 then
			layerNamesKey ..= ","
		end

		layerNamesKey ..= item
	end

	return layerNamesKey
end

local function makeUseExperiment(p, p2, p3, p4, p5)
	return function(list, callback, flag: boolean?)
		local v = flag == nil or flag

		local v2 = useIXPService()

		assert(type(list) == "table", "useExperiment expects layerNames to be a list of layers")
		assert(type(callback) == "function", "useExperiment expects mapLayers to be a function")

		local function getNewLayerToVariables()
			local newLayerToVariables = {}

			for _, item in ipairs(list) do
				newLayerToVariables[item] = v2[p3](v2, item)

				if not newLayerToVariables[item] or next(newLayerToVariables[item]) then
					continue
				end

				newLayerToVariables[item] = nil
			end

			return newLayerToVariables
		end

		local function getLoadingStatus() -- 1 equivalent call inferred from this helper
			return v2[p2](v2)
		end

		local state, setState = React.useState(getNewLayerToVariables)
		local state2, setState2 = React.useState(getLoadingStatus)
		local layerNamesKey = getLayerNamesKey(list) -- inferred equivalent call
		React.useEffect(function()
			if v2 == nil then
				return function() end
			end

			local function updateStateLayerData() -- 2 equivalent calls inferred from this helper
				local loadingStatus = getLoadingStatus() -- inferred equivalent call
				local newLayerToVariables = getNewLayerToVariables()

				setState(function(items)
					local v3 = not next(items)

					if not next(newLayerToVariables) == v3 then
						return items
					end

					return newLayerToVariables
				end)

				setState2(loadingStatus)
			end

			local connection = v2[p]:Connect(function(_)
				updateStateLayerData() -- inferred equivalent call
			end)
			updateStateLayerData() -- inferred equivalent call
			return function()
				if connection ~= nil then
					connection:Disconnect()
				end
			end
		end, { v2, layerNamesKey })

		local v3 = usePrevious(state2) or Enum.IXPLoadingStatus.None

		React.useEffect(function()
			if
				v
				and v2 ~= nil
				and state2 == Enum.IXPLoadingStatus.Initialized
				and v3 ~= Enum.IXPLoadingStatus.Initialized
			then
				for _, item in ipairs(list) do
					if v2[p5](v2, item) == Enum.IXPLoadingStatus.Initialized then
						v2[p4](v2, item)
					end
				end
			end
		end, { v2, layerNamesKey, v, state2, v3 })

		return callback(state)
	end
end

return makeUseExperiment
