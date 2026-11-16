local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Flags = require(Foundation.Utility.Flags)
require(Foundation.Utility.Plugin.StudioUri)
local usePlugin = require(Foundation.Providers.Plugin.usePlugin)
local useWidgetsContext = require(Foundation.Providers.StudioWidgets.useWidgetsContext)

local PanelsContext = require(script.Parent.PanelsContext)
local PopoverManager = require(script.Parent.Managers.PopoverManager)

require(script.Parent.Types)

local function PanelsProvider(p)
	local v = usePlugin()

	if v == nil then
		error("PanelsProvider must be used within a plugin context")
	end

	local v2

	if Flags.FoundationPopoverPluginAnchorRefresh then
		v2 = useWidgetsContext()
	else
		v2 = nil
	end

	local v3 = React.useMemo(function()
		return PopoverManager.new(v, p.uriScope)
	end, { v, p.uriScope })

	React.useEffect(function()
		local thread = task.spawn(function()
			v3:prewarmPoolAsync(2)
		end)

		return function()
			if thread then
				task.cancel(thread)
			end

			v3:destroy()
		end
	end, { v3 })

	local registerPopoverAsync = React.useCallback(
		function(targetWidgetUri, data, callback, p2: number?, p3: string?, flag: boolean?)
			if Flags.FoundationPopoverPluginAnchorRefresh then
				v2.refreshAsync(targetWidgetUri)
			end

			local v4 = {
				targetWidgetUri = targetWidgetUri,
				targetAnchorPoint = data.targetAnchorPoint,
				subjectAnchorPoint = data.subjectAnchorPoint,
				offset = data.offset
			}

			if not Flags.FoundationPopoverPluginFocusable then
				flag = nil
			end

			local v5 = v3:openAtAsync(v4, callback, p2, p3, flag)

			return v5, function()
				v5.close()
			end
		end,
		{ v3, v2 }
	)

	local v4 = React.useMemo(function()
		return { registerPopoverAsync = registerPopoverAsync }
	end, { registerPopoverAsync })

	return React.createElement(PanelsContext.Provider, { value = v4 }, p.children)
end

return PanelsProvider
