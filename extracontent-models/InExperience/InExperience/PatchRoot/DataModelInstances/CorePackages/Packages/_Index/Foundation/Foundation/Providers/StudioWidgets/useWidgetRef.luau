local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useEffect = React.useEffect
local useRef = React.useRef
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)
local useWidgetsContext = require(script.Parent.useWidgetsContext)

local function useWidgetRef(p1, p2) -- line: 13
	-- upvalues: useWidgetsContext (copy), useRef (copy), StudioUri (copy), useEffect (copy)
	local v11 = useWidgetsContext()
	local v12 = useRef(nil)
	local v13 = p2 or v12
	local v14 = StudioUri.toString(p1)

	useEffect(function() -- line: 20
		-- upvalues: v13 (copy), p1 (copy), v11 (copy)
		local current = v13.current

		if not current then
			return
		end

		if p1 and typeof(current) == "Instance" then
			v11.register(p1, current)

			return function() -- line: 27
				-- upvalues: v11 (copy), p1 (copy), current (copy)
				v11.deregister(p1, current)
			end
		end

		return nil
	end, {
		v14,
		v13.current,
		p1,
		v11.register,
		v11.deregister
	})

	return v13
end

return useWidgetRef
