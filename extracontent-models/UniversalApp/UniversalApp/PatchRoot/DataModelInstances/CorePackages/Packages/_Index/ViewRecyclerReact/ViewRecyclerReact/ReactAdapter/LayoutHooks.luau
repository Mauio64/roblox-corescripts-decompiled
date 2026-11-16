local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)
local Layout = ViewRecycler.Layout
local React = require(ViewRecyclerReact.Parent.React)

local function useManagedLayout(fn, p)
	local v = React.useMemo(fn, p)
	React.useEffect(function()
		return function()
			v.destroy()
		end
	end, { v })
	return v
end

local LayoutHooks = {}

function LayoutHooks.useMeasuredLayout(p)
	local v = React.useMemo(function()
		return Layout.measured(p)
	end, {})
	React.useEffect(function()
		return function()
			v.destroy()
		end
	end, { v })
	return v
end

function LayoutHooks.useUniformLayout(data)
	return useManagedLayout(function()
		return Layout.uniform(data)
	end, { data.itemLength, data.spacing, data.paddingBefore, data.paddingAfter })
end

return LayoutHooks
