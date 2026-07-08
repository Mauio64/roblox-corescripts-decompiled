local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)
local usePlugin = require(Foundation.Providers.Plugin.usePlugin)
local useWidgetRef = require(script.Parent.useWidgetRef)
local useWidgetsContext = require(script.Parent.useWidgetsContext)

local function useUniqueWidget(t1: {[any]: any}?) -- line: 16
	-- upvalues: usePlugin (copy), useWidgetsContext (copy), React (copy), StudioUri (copy), useWidgetRef (copy)
	local v10 = usePlugin()

	if v10 == nil then
		error("useUniqueWidget must be used within a Plugin context")
	end

	local v11 = useWidgetsContext()
	local v12 = React.useMemo(function() -- line: 23
		-- upvalues: StudioUri (copy), v10 (copy)
		return StudioUri.wrap(v10:GetUri())
	end, { v10 })
	local v13 = React.useRef(nil)

	if v13.current == nil then
		if t1 and t1.id then
			v13.current = t1.id
		else
			v13.current = v11.nextId()
		end
	end

	local v14 = React.useMemo(function() -- line: 36
		-- upvalues: StudioUri (copy), v12 (copy), v13 (copy)
		return StudioUri.join(v12, {
			Category = "Actions",
			ItemId = v13.current
		})
	end, {
		v12,
		v13.current
	})

	return {
		ref = useWidgetRef(v14, t1 and t1.forwardRef),
		uri = v14
	}
end

return useUniqueWidget
