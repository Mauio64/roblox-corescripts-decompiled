local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local ComposedRecyclableView = require(ViewRecyclerReact.ReactAdapter.Private.ComposedRecyclableView)
local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewRegistry = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)
local Signals = require(ViewRecyclerReact.Parent.Signals)
local selectViewType = require(ViewRecyclerReact.ReactAdapter.Private.selectViewType)

local function RecyclableViewSwitch(props)
	local selected = props.selected
	local views = props.views

	if FFlagViewRecyclerReact084 then
		local viewType = React.useMemo(function()
			for k, view in views do
				assert(
					RecyclableViewRegistry.isRegistered(view),
					`RecyclableViewSwitch: views.{k} is not a Recyclable view type`
				)
			end

			return selectViewType(selected, function(p: string?)
				if p == nil then
					return nil
				end

				return views[p]
			end)
		end, { selected, views })

		return React.createElement(ComposedRecyclableView, {
			viewType = viewType,
			itemSignal = props.itemSignal
		})
	end

	if FFlagViewRecyclerReact08 then
		local viewType = React.useMemo(function()
			for k, view in views do
				assert(
					RecyclableViewRegistry.isRegistered(view),
					`RecyclableViewSwitch: views.{k} is not a Recyclable view type`
				)
			end

			return selectViewType(selected, function(p: string?)
				if p == nil then
					return nil
				end

				return views[p]
			end)
		end, { selected, views })

		return React.createElement(ComposedRecyclableView, {
			viewType = viewType,
			itemSignal = props.itemSignal
		})
	end

	local v = React.useMemo(function()
		local result = {}

		for k, view in views do
			assert(
				RecyclableViewRegistry.isRegistered(view),
				`RecyclableViewSwitch: views.{k} is not a Recyclable view type`
			)

			if type(selected) == "function" then
				result[k] = Signals.createComputed(function(p): boolean
					return selected(p) == k
				end)
			else
				result[k] = selected == k
			end
		end

		return result
	end, { selected, views })

	local children = {}

	for k, view in views do
		children[k] = React.createElement(view, { active = v[k], itemSignal = props.itemSignal })
	end

	return React.createElement(React.Fragment, nil, children)
end

return RecyclableViewSwitch
