local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)
local useContext = React.useContext

local PluginContext = require(script.Parent.PluginContext)
local isPluginElevated = require(script.Parent.isPluginElevated)

local function usePlugin()
	local v = useContext(PluginContext)

	if v and v ~= React.None then
		return v, isPluginElevated(v)
	end

	return nil, false
end

return usePlugin
