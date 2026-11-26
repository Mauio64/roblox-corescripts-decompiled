local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.LuauPolyfill)

local function useDebouncedWrite(current)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current.identity)
	ref2.current = current.identity
	local state, setState = React.useState(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(true)
	local ref6 = React.useRef(0)
	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(nil)
	local ref9 = React.useRef(nil)

	local function isStillCurrent(p2)
		return ref5.current and p2.identity == ref2.current
	end

	local function readPendingValue()
		local current2 = ref3.current

		if current2 == nil or current2.identity ~= ref2.current then
			return nil
		end

		return current2.value
	end

	local v5 = React.useCallback(function()
		if ref7.current ~= nil then
			task.cancel(ref7.current)
			ref7.current = nil
		end

		if ref8.current ~= nil then
			task.cancel(ref8.current)
			ref8.current = nil
		end
	end, {})

	local v6 = React.useCallback(function(p2)
		setState(function(p3)
			if p3 == nil or p3.identity ~= p2 then
				return p3
			end

			return nil
		end)
	end, {})

	local v7 = React.useCallback(function()
		v5()
		local current2 = ref3.current
		ref3.current = nil
		ref6.current = 0

		if not (current2 ~= nil and current2.value ~= current2.getServerValue()) then
			return
		end

		local v8 = current2.write(current2.value)

		if v8 ~= nil then
			v8:andThen(function() end, function() end)
		end
	end, {})

	local v8 = React.useCallback(function()
		v5()
		ref7.current = task.delay(ref.current.debounceMs / 1000, function()
			ref7.current = nil
			local current2 = ref9.current

			if current2 ~= nil then
				current2()
			end
		end)
	end, {})

	ref9.current = React.useCallback(function()
		if ref4.current then
			return
		end

		local current2 = ref3.current

		if current2 == nil then
			return
		end

		if not ref5.current or current2.identity ~= ref2.current then
			v7()
		elseif current2.value == current2.getServerValue() then
			ref3.current = nil
			ref6.current = 0
			v6(current2.identity)
		else
			if ref6.current == 0 and ref.current.onWriteStart ~= nil then
				ref.current.onWriteStart(current2.value)
			end

			ref4.current = true
			local value = current2.value
			local v9 = current2.write(current2.value)

			if v9 == nil then
				ref4.current = false
				ref3.current = nil
				ref6.current = 0
				v6(current2.identity)
			else
				local function finish(p2)
					local current3 = ref3.current
					local v10 = not (current3 == nil) and current3.identity == current2.identity

					local v11 = not (current3 == nil or not v10) and current3.value ~= value

					if ref5.current and current2.identity == ref2.current then
						if v11 then
							ref6.current = 0
							v8()
						elseif p2 then
							ref3.current = nil
							v6(current2.identity)
							local onCommitted = ref.current.onCommitted

							if onCommitted ~= nil then
								onCommitted(value)
							end
						else
							local current4 = ref.current

							if (current4.maxRetries or 0) > ref6.current then
								ref6.current += 1
								local retryBaseMs = current4.retryBaseMs or 1000
								local retryCapMs = current4.retryCapMs or 8000
								local v14 = math.min(retryBaseMs * 2 ^ (ref6.current - 1), retryCapMs)

								if ref8.current ~= nil then
									task.cancel(ref8.current)
								end

								ref8.current = task.delay(v14 / 1000, function()
									ref8.current = nil
									local current5 = ref9.current

									if current5 ~= nil then
										current5()
									end
								end)
							else
								ref6.current = 0
								ref3.current = nil
								v6(current2.identity)
								local onGiveUp = current4.onGiveUp

								if onGiveUp ~= nil then
									onGiveUp(value)
								end
							end
						end
					elseif v11 then
						v7()
					elseif v10 then
						ref3.current = nil
					end
				end

				v9:andThen(function()
					ref4.current = false
					ref6.current = 0
					local current3 = ref3.current
					local v10 = not (current3 == nil) and current3.identity == current2.identity

					local v11 = not (current3 == nil or not v10) and current3.value ~= value

					if ref5.current and current2.identity == ref2.current then
						if v11 then
							ref6.current = 0
							v8()
						else
							ref3.current = nil
							v6(current2.identity)
							local onCommitted = ref.current.onCommitted

							if onCommitted ~= nil then
								onCommitted(value)
							end
						end
					elseif v11 then
						v7()
					elseif v10 then
						ref3.current = nil
					end
				end, function()
					ref4.current = false
					finish(false)
				end)
			end
		end
	end, {})

	local v9 = React.useCallback(function(p2)
		local current2 = ref.current

		if current2.enabled == false then
			return
		end

		local identity = current2.identity
		local current3 = ref3.current

		if current3 ~= nil and current3.identity ~= identity then
			v7()
		end

		ref3.current = {
			identity = identity,
			value = p2,
			getServerValue = current2.getServerValue,
			write = current2.write
		}

		ref6.current = 0

		if ref8.current ~= nil then
			task.cancel(ref8.current)
			ref8.current = nil
		end

		setState(function(p3)
			if p3 == nil or p3.identity ~= identity or p3.value ~= p2 then
				return { identity = identity, value = p2 }
			end

			return p3
		end)

		if not ref4.current then
			v8()
		end
	end, {})

	local v10 = React.useCallback(function(callback)
		if ref.current.enabled == false then
			return
		end

		local current2 = ref3.current
		local v12 = if current2 ~= nil and current2.identity == ref2.current then current2.value else nil

		v9(callback(v12))
	end, {})

	React.useEffect(function()
		ref5.current = true
		return function()
			ref5.current = false
		end
	end, {})

	React.useEffect(function()
		return function()
			v5()
			ref6.current = 0
			setState(nil)

			if not ref4.current then
				v7()
			end
		end
	end, { current.identity })

	return {
		displayValue = if current.enabled ~= false and state ~= nil and state.identity == current.identity then state.value else nil,
		setValue = v9,
		updateValue = v10
	}
end

return useDebouncedWrite
