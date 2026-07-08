local Roact = require(script.Parent.Parent.Roact)
local shallowEqual = require(script.Parent.shallowEqual)
local join = require(script.Parent.join)
local StoreContext = require(script.Parent.StoreContext)

local function formatMessage(p1, p2) -- line: 9
	return table.concat(p1, "\n"):format(unpack(p2 or {}))
end
local function noop() -- line: 13
	return nil
end
local function makeStateUpdater(p3) -- line: 26
	-- upvalues: join (copy)
	return function(p4, p5, p6) -- line: 27
		-- upvalues: p3 (copy), join (copy)
		if p6 == nil then
			p6 = p5.mapStateToProps(p3:getState(), p4)
		end

		local v21 = join(p4, p6, p5.mappedStoreDispatch)

		return {
			mappedStoreState = p6,
			propsForChild = v21
		}
	end
end
local function connect(p7, p8) -- line: 50
	-- upvalues: noop (copy), Roact (copy), join (copy), shallowEqual (copy), StoreContext (copy)
	local trace = debug.traceback()

	if p7 ~= nil then
		assert(typeof(p7) == "function", "mapStateToProps must be a function or nil!")
	else
		p7 = noop
	end

	local v17 = typeof(p8)

	if p8 ~= nil then
		assert(v17 == "function" or v17 == "table", "mapDispatchToProps must be a function, table, or nil!")
	else
		p8 = noop
	end

	return function(p9) -- line: 69
		-- upvalues: trace (copy), Roact (copy), p7 (ref), v17 (copy), p8 (ref), join (copy), shallowEqual (copy), StoreContext (copy)
		if p9 == nil then
			local t1 = { trace }
			local v24 = table.concat({
				"connect returns a function that must be passed a component.",
				"Check the connection at:",
				"%s"
			}, "\n"):format(unpack(t1 or {}))

			error(v24, 2)
		end

		local v25 = ("RoduxConnection(%s)"):format((tostring(p9)))
		local v26 = Roact.Component:extend(v25)

		function v26.getDerivedStateFromProps(p10, p11) -- line: 86
			if p11.stateUpdater ~= nil then
				return p11.stateUpdater(p10.innerProps, p11)
			end
		end
		function v26.init(p12, p13) -- line: 92
			-- upvalues: p9 (copy), p7 (ref), v17 (copy), p8 (ref), join (copy)
			p12.store = p13.store

			if p12.store == nil then
				local t2 = { (tostring(p9)) }
				local v33 = table.concat({
					"Cannot initialize Roact-Rodux connection without being a descendent of StoreProvider!",
					"Tried to wrap component %q",
					"Make sure there is a StoreProvider above this component in the tree."
				}, "\n"):format(unpack(t2 or {}))

				error(v33)
			end

			local v34 = p12.store:getState()
			local v35 = p7
			local v36 = v35(v34, p12.props.innerProps)

			if typeof(v36) == "function" then
				v35 = v36
				v36 = v35(v34, p12.props.innerProps)
			end

			if v36 ~= nil and typeof(v36) ~= "table" then
				local t3 = {
					tostring(v36),
					(typeof(v36))
				}
				local v38 = table.concat({
					"mapStateToProps must either return a table, or return another function that returns a table.",
					"Instead, it returned %q, which is of type %s."
				}, "\n"):format(unpack(t3 or {}))

				error(v38)
			end

			local function dispatch(...) -- line: 133
				-- upvalues: p12 (copy)
				return p12.store:dispatch(...)
			end

			local t4 = nil

			if v17 == "table" then
				t4 = {}

				for k, v in pairs(p8) do
					assert(typeof(v) == "function", "mapDispatchToProps must contain function values")
					t4[k] = function(...) -- line: 144
						-- upvalues: dispatch (copy), v (copy)
						dispatch(v(...))
					end
				end
			elseif v17 == "function" then
				t4 = p8(dispatch)
			end

			local store = p12.store

			local function v44(p14, p15, p16) -- line: 27
				-- upvalues: store (copy), join (copy)
				if p16 == nil then
					p16 = p15.mapStateToProps(store:getState(), p14)
				end

				local v56 = join(p14, p16, p15.mappedStoreDispatch)

				return {
					mappedStoreState = p16,
					propsForChild = v56
				}
			end

			p12.state = {
				propsForChild = nil,
				stateUpdater = v44,
				mapStateToProps = v35,
				mappedStoreDispatch = t4
			}

			local v45 = v44(p12.props.innerProps, p12.state, v36)

			for k, v in pairs(v45) do
				p12.state[k] = v
			end
		end
		function v26.didMount(p17) -- line: 179
			-- upvalues: shallowEqual (copy)
			local v49 = p17.store:getState()

			p17:setState(function(p18, p19) -- line: 181
				-- upvalues: v49 (copy), shallowEqual (copy)
				local v60 = p18.mapStateToProps(v49, p19.innerProps)

				if shallowEqual(v60, p18.mappedStoreState) then
					return nil
				end

				return p18.stateUpdater(p19.innerProps, p18, v60)
			end)
			p17.storeChangedConnection = p17.store.changed:connect(function(p20) -- line: 180
				-- upvalues: p17 (copy), shallowEqual (copy)
				p17:setState(function(p21, p22) -- line: 181
					-- upvalues: p20 (copy), shallowEqual (copy)
					local v64 = p21.mapStateToProps(p20, p22.innerProps)

					if shallowEqual(v64, p21.mappedStoreState) then
						return nil
					end

					return p21.stateUpdater(p22.innerProps, p21, v64)
				end)
			end)
		end
		function v26.willUnmount(p23) -- line: 203
			if p23.storeChangedConnection then
				p23.storeChangedConnection:disconnect()
				p23.storeChangedConnection = nil
			end
		end
		function v26.render(p24) -- line: 210
			-- upvalues: Roact (copy), p9 (copy)
			return Roact.createElement(p9, p24.state.propsForChild)
		end

		local v27 = Roact.Component:extend(v25)

		function v27.render(p25) -- line: 216
			-- upvalues: Roact (copy), StoreContext (copy), v26 (copy)
			return Roact.createElement(StoreContext.Consumer, {
				render = function(p26) -- line: 218
					-- upvalues: Roact (copy), v26 (copy), p25 (copy)
					return Roact.createElement(v26, {
						innerProps = p25.props,
						store = p26
					})
				end
			})
		end

		return v27
	end
end

return connect
