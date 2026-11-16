local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local useEffect = React.useEffect
local useRef = React.useRef

local StudioUri = require(Foundation.Utility.Plugin.StudioUri)

local useWidgetsContext = require(script.Parent.useWidgetsContext)

local function useWidgetRef(p, p2)
	local v = useWidgetsContext()
	local v2 = useRef(nil)
	local v3 = p2 or v2

	useEffect(function()
		local current = v3.current

		if not current then
			return
		end

		if not p or typeof(current) ~= "Instance" then
			return nil
		end

		v.register(p, current)
		return function()
			v.deregister(p, current)
		end
	end, { StudioUri.toString(p), v3.current, p, v.register, v.deregister })

	return v3
end

return useWidgetRef
