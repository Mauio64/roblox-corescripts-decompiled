local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

local Promise = require(parent.Promise)

local Observable = require(script.Parent.Observable)
local observable = Observable.Observable
return {
	asyncMap = function(object, callback, callback2)
		return observable.new(function(data)
			local v = nil

			local nextNode = data.next
			local err = data.error
			local complete = data.complete
			local v2 = 0
			local v3 = false

			local v4 = { andThen = 0 }

			function v4:andThen(callback3)
				return Promise.new(function(callback4)
					return callback4(callback3())
				end)
			end

			local function makeCallback(callback3, callback4) -- 2 equivalent calls inferred from this helper
				if Boolean.toJSBoolean(callback3) then
					return function(_, p)
						v2 += 1
						local function both()
							return callback3(p)
						end

						v4 = v4:andThen(function()
							return Promise.delay(0)
						end):andThen(both, both):andThen(function(p2)
							v2 -= 1

							if Boolean.toJSBoolean(nextNode) then
								nextNode(data, p2)
							end

							if Boolean.toJSBoolean(v3) then
								v.complete()
							end
						end, function(message)
							v2 -= 1
							error(message)
						end):catch(function(p2)
							if Boolean.toJSBoolean(err) then
								return err(data, p2)
							end
						end)
					end
				end

				return function(_, p)
					if Boolean.toJSBoolean(callback4) then
						callback4(data, p)
					end
				end
			end

			v = {
				next = makeCallback(callback, nextNode), -- inferred equivalent call
				error = makeCallback(callback2, err), -- inferred equivalent call
				complete = function()
					v3 = true

					if not Boolean.toJSBoolean(v2) and Boolean.toJSBoolean(complete) then
						complete(data)
					end
				end
			}

			local v5 = object:subscribe(v)
			return function()
				return v5:unsubscribe()
			end
		end)
	end
}
