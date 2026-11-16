local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Wrappers = require(Foundation.Utility.Wrappers)
local Signal = Wrappers.Signal
local Connection = Wrappers.Connection

local function findLayerCollector(instance)
	if instance then
		return instance:FindFirstAncestorWhichIsA("LayerCollector")
	end

	return nil
end

local function useLayerCollector(instance)
	local state, setState = React.useState(nil)

	local v = React.useCallback(function()
		setState(findLayerCollector(instance))
	end, { instance })

	React.useEffect(function()
		if not instance then
			return nil
		end

		v()

		local v2 = Signal.Connect(instance.AncestryChanged, v)

		return function()
			Connection.Disconnect(v2)
		end
	end, { instance })

	return state
end

return useLayerCollector
