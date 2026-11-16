local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
require(ViewRecyclerReact.Parent.ViewRecycler)

local React = require(ViewRecyclerReact.Parent.React)
local RecyclingRoot = require(ViewRecyclerReact.ReactAdapter.Private.RecyclingRoot)
local RecyclingScopeContext = require(ViewRecyclerReact.ReactAdapter.Private.RecyclingScopeContext)

local createElement = React.createElement

local PoolObserver
local withPoolObserver

if FFlagViewRecyclerReact08 then
	PoolObserver = function(p): nil
		local observePool = p.observePool
		local diagnostics = p.diagnostics
		React.useLayoutEffect(function()
			if diagnostics == nil then
				return nil
			end

			return observePool(diagnostics)
		end, { observePool, diagnostics })
		return nil
	end

	withPoolObserver = function(observePool, diagnostics, p)
		return createElement(
			React.Fragment,
			nil,
			createElement(PoolObserver, { observePool = observePool, diagnostics = diagnostics }),
			createElement(React.Fragment, nil, p)
		)
	end
else
	withPoolObserver = nil
end

local function createRecyclingScope(p)
	local createPortal

	if p == nil then
		createPortal = nil
	else
		createPortal = p.createPortal
	end

	local createdRecyclingScope = FFlagViewRecyclerReact08 and function(props)
		assert(createPortal ~= nil, "RecyclingScope requires a configured portal renderer")
		local _, setState = React.useState(0)
		local ref = React.useRef(0)
		local ref2 = React.useRef(false)
		local ref3 = React.useRef(false)
		local v = React.useState(function()
			return RecyclingRoot.new(function()
				if not ref2.current then
					setState(function(p2)
						return p2 + 1
					end)
				end
			end, props.maxPoolSize)
		end)

		local function destroyRootIfReady()
			if ref2.current and ref.current == 0 and not ref3.current then
				ref3.current = true
				v.destroy()
			end
		end

		local v2 = React.useState(function()
			return table.freeze({
				getScope = v.getScope,
				observePool = v.observePool,
				registerConsumer = function()
					assert(not ref3.current, "RecyclingScope: cannot register after destruction")
					ref2.current = false
					ref.current += 1
					local v2 = true
					return function()
						if not v2 then
							return
						end

						v2 = false
						ref.current -= 1
						task.defer(destroyRootIfReady)
					end
				end
			})
		end)

		React.useLayoutEffect(function()
			v.setMaxPoolSize(props.maxPoolSize)
		end, { v, props.maxPoolSize })

		React.useEffect(function()
			ref2.current = false
			return function()
				ref2.current = true
				task.defer(destroyRootIfReady)
			end
		end, { v })

		local v3 = {
			Consumers = withPoolObserver(v.observePool, props.diagnostics, props.children)
		}

		for k, v4 in v.getPortalChildren(createPortal) do
			v3[k] = v4
		end

		return createElement(RecyclingScopeContext.Provider, { value = v2 }, v3)
	end or nil

	local function RecyclingScope(props)
		local v = nil
		local v2 = nil
		local ref = nil
		local ref2 = nil
		local ref3 = nil
		local root = nil
		local destroyRootIfReady
		local registerConsumer = nil
		local v3 = nil

		if FFlagViewRecyclerReact08 then
			v = React.useContext(RecyclingScopeContext)

			if v == nil then
				return createElement(createdRecyclingScope, props)
			end
		else
			assert(createPortal ~= nil, "RecyclingScope requires a configured portal renderer")
			local _, setState = React.useState(0)
			v2 = setState
			ref = React.useRef(0)
			ref2 = React.useRef(false)
			ref3 = React.useRef(false)
			root = React.useState(function()
				return RecyclingRoot.new(function()
					if not ref2.current then
						v2(function(p2)
							return p2 + 1
						end)
					end
				end)
			end)

			destroyRootIfReady = function()
				if ref2.current and ref.current == 0 and not ref3.current then
					ref3.current = true
					root.destroy()
				end
			end

			registerConsumer = React.useState(function()
				return function()
					assert(not ref3.current, "RecyclingScope: cannot register after destruction")
					ref2.current = false
					ref.current += 1
					local v4 = true
					return function()
						if not v4 then
							return
						end

						v4 = false
						ref.current -= 1
						task.defer(destroyRootIfReady)
					end
				end
			end)

			local v4 = React.useMemo(function()
				return {
					root = root,
					listOptions = {
						maxPoolSize = props.maxPoolSize,
						diagnostics = props.diagnostics
					},
					registerConsumer = registerConsumer
				}
			end, { props.maxPoolSize, props.diagnostics, registerConsumer, root })

			React.useEffect(function()
				ref2.current = false
				return function()
					ref2.current = true
					task.defer(destroyRootIfReady)
				end
			end, { root })

			v3 = {
				Consumers = createElement(RecyclingScopeContext.Provider, { value = v4 }, props.children)
			}

			for k, v5 in root.getPortalChildren(createPortal) do
				v3[k] = v5
			end
		end

		local v4

		if FFlagViewRecyclerReact08 then
			v4 = withPoolObserver
		else
			v4 = createElement
		end

		local v5

		if FFlagViewRecyclerReact08 then
			v5 = v.observePool
		else
			v5 = React.Fragment
		end

		local diagnostics

		if FFlagViewRecyclerReact08 then
			diagnostics = props.diagnostics
		end

		if FFlagViewRecyclerReact08 then
			v3 = props.children
		end

		return v4(v5, diagnostics, v3)
	end

	return RecyclingScope
end

return { create = createRecyclingScope }
