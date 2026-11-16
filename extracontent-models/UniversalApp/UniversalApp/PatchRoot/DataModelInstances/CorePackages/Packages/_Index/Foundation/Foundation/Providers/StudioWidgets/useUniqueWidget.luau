local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local StudioUri = require(Foundation.Utility.Plugin.StudioUri)
local usePlugin = require(Foundation.Providers.Plugin.usePlugin)
local useWidgetRef = require(script.Parent.useWidgetRef)
local useWidgetsContext = require(script.Parent.useWidgetsContext)

local function useUniqueWidget(p)
	local v = usePlugin()

	if v == nil then
		error("useUniqueWidget must be used within a Plugin context")
	end

	local v2 = useWidgetsContext()
	local v3 = React.useMemo(function()
		return StudioUri.wrap(v:GetUri())
	end, { v })

	local ref = React.useRef(nil)

	if ref.current == nil then
		if p and p.id then
			ref.current = p.id
		else
			ref.current = v2.nextId()
		end
	end

	local uri = React.useMemo(function()
		return StudioUri.join(v3, { Category = "Actions", ItemId = ref.current })
	end, { v3, ref.current })

	return {
		ref = useWidgetRef(uri, p and p.forwardRef),
		uri = uri
	}
end

return useUniqueWidget
