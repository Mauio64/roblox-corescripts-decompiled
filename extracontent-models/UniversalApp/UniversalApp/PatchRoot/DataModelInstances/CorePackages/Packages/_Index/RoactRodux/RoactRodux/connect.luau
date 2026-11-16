local Roact = require(script.Parent.Parent.Roact)
local shallowEqual = require(script.Parent.shallowEqual)
local join = require(script.Parent.join)
local StoreContext = require(script.Parent.StoreContext)

local function formatMessage(list, options) -- 3 equivalent calls inferred from this helper
	return table.concat(list, "\n"):format(unpack(options or {}))
end

local function noop(): nil
	return nil
end

local function makeStateUpdater(store) -- 1 equivalent call inferred from this helper
	return function(p, p2, mappedStoreState)
		if mappedStoreState == nil then
			mappedStoreState = p2.mapStateToProps(store:getState(), p)
		end

		return {
			mappedStoreState = mappedStoreState,
			propsForChild = join(p, mappedStoreState, p2.mappedStoreDispatch)
		}
	end
end

local function connect(callback, items)
	local traceback = debug.traceback()

	if callback == nil then
		callback = noop
	else
		assert(typeof(callback) == "function", "mapStateToProps must be a function or nil!")
	end

	local typeName = typeof(items)

	if items == nil then
		items = noop
	else
		assert(typeName == "function" or typeName == "table", "mapDispatchToProps must be a function, table, or nil!")
	end

	return function(p)
		if p == nil then
			error(
				formatMessage( -- inferred equivalent call
					{ "connect returns a function that must be passed a component.", "Check the connection at:", "%s" },
					{ traceback }
				),
				2
			)
		end

		local formatted = ("RoduxConnection(%s)"):format((tostring(p)))

		local extended = Roact.Component:extend(formatted)

		function extended.getDerivedStateFromProps(p2, p3)
			if p3.stateUpdater == nil then
				return
			end

			return p3.stateUpdater(p2.innerProps, p3)
		end

		function extended:init(p2)
			self.store = p2.store

			if self.store == nil then
				local v = formatMessage( -- inferred equivalent call
					{
						"Cannot initialize Roact-Rodux connection without being a descendent of StoreProvider!",
						"Tried to wrap component %q",
						"Make sure there is a StoreProvider above this component in the tree."
					},
					{ (tostring(p)) }
				)

				error(v)
			end

			local state = self.store:getState()

			local mapStateToProps = callback
			local v = mapStateToProps(state, self.props.innerProps)

			if typeof(v) == "function" then
				mapStateToProps = v
				v = v(state, self.props.innerProps)
			end

			if v ~= nil and typeof(v) ~= "table" then
				local v2 = formatMessage( -- inferred equivalent call
					{
						"mapStateToProps must either return a table, or return another function that returns a table.",
						"Instead, it returned %q, which is of type %s."
					},
					{ tostring(v), (typeof(v)) }
				)

				error(v2)
			end

			local function dispatch(...)
				return self.store:dispatch(...)
			end

			local mappedStoreDispatch = nil

			if typeName == "table" then
				mappedStoreDispatch = {}

				for k, item in pairs(items) do
					assert(typeof(item) == "function", "mapDispatchToProps must contain function values")

					mappedStoreDispatch[k] = function(...)
						dispatch(item(...))
					end
				end
			elseif typeName == "function" then
				mappedStoreDispatch = items(dispatch)
			end

			local stateUpdater = makeStateUpdater(self.store) -- inferred equivalent call

			self.state = {
				stateUpdater = stateUpdater,
				mapStateToProps = mapStateToProps,
				mappedStoreDispatch = mappedStoreDispatch,
				propsForChild = nil
			}

			local v2 = stateUpdater(self.props.innerProps, self.state, v)

			for k, v3 in pairs(v2) do
				self.state[k] = v3
			end
		end

		function extended:didMount()
			local function fn(p2) -- 1 equivalent call inferred from this helper
				self:setState(function(data, p3)
					local mapStateToProps = data.mapStateToProps(p2, p3.innerProps)

					if shallowEqual(mapStateToProps, data.mappedStoreState) then
						return nil
					end

					return data.stateUpdater(p3.innerProps, data, mapStateToProps)
				end)
			end

			fn(self.store:getState()) -- inferred equivalent call

			self.storeChangedConnection = self.store.changed:connect(fn)
		end

		function extended:willUnmount()
			if self.storeChangedConnection then
				self.storeChangedConnection:disconnect()
				self.storeChangedConnection = nil
			end
		end

		function extended.render(p2)
			return Roact.createElement(p, p2.state.propsForChild)
		end

		local extended2 = Roact.Component:extend(formatted)

		function extended2.render(p2)
			return Roact.createElement(StoreContext.Consumer, {
				render = function(store)
					return Roact.createElement(extended, { innerProps = p2.props, store = store })
				end
			})
		end

		return extended2
	end
end

return connect
