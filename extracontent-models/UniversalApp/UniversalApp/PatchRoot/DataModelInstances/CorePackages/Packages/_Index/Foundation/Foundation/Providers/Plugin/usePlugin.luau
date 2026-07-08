local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local useContext = React.useContext
local PluginContext = require(script.Parent.PluginContext)
local isPluginElevated = require(script.Parent.isPluginElevated)

local function usePlugin() -- line: 10
	-- upvalues: useContext (copy), PluginContext (copy), React (copy), isPluginElevated (copy)
	local v7 = useContext(PluginContext)

	if v7 and v7 ~= React.None then
		return v7, isPluginElevated(v7)
	end

	return nil, false
end

return usePlugin
