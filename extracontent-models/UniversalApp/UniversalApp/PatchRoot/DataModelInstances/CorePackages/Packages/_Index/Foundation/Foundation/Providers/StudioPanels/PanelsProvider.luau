local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Utility.Plugin.StudioUri)

local usePlugin = require(Foundation.Providers.Plugin.usePlugin)
local PanelsContext = require(script.Parent.PanelsContext)
local PopoverManager = require(script.Parent.Managers.PopoverManager)

require(script.Parent.Types)

local function PanelsProvider(t1: {[any]: any}) -- line: 27
	-- upvalues: usePlugin (copy), React (copy), PopoverManager (copy), Flags (copy), PanelsContext (copy)
	local v10 = usePlugin()

	if v10 == nil then
		error("PanelsProvider must be used within a plugin context")
	end

	local v11 = React.useMemo(function() -- line: 33
		-- upvalues: PopoverManager (copy), v10 (copy), t1 (copy)
		return PopoverManager.new(v10, t1.uriScope)
	end, {
		v10,
		t1.uriScope
	})

	React.useEffect(function() -- line: 37
		-- upvalues: Flags (copy), v11 (copy)
		local thread = nil

		if Flags.FoundationPopoverPluginPrewarmDepthPool then
			thread = task.spawn(function() -- line: 40
				-- upvalues: v11 (copy)
				v11:prewarmPoolAsync(2)
			end)
		end

		return function() -- line: 45
			-- upvalues: thread (ref), v11 (copy)
			if thread then
				task.cancel(thread)
			end

			v11:destroy()
		end
	end, { v11 })

	local t2 = {
		registerPopoverAsync = React.useCallback(function(p1, p2, p3: ((...any) -> ...any), n1: number?, s1: string?) -- line: 55
			-- upvalues: v11 (copy)
			local v19 = v11:openAtAsync({
				targetWidgetUri = p1,
				targetAnchorPoint = p2.targetAnchorPoint,
				subjectAnchorPoint = p2.subjectAnchorPoint,
				offset = p2.offset
			}, p3, n1, s1)

			return v19, function() -- line: 69
				-- upvalues: v19 (copy)
				v19.close()
			end
		end, { v11 })
	}

	return React.createElement(PanelsContext.Provider, {
		value = t2
	}, t1.children)
end

return PanelsProvider
