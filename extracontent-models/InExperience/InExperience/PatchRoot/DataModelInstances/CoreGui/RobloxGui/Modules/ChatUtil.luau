return {
	Signal = function()
		local bindableEvent = Instance.new("BindableEvent")

		local v = nil
		local v2 = nil
		return {
			fire = function(_, ...)
				v = { ... }
				v2 = select("#", ...)
				bindableEvent:Fire()
			end,
			connect = function(self, callback)
				if not callback then
					error("connect(nil)", 2)
				end

				return bindableEvent.Event:connect(function()
					callback(unpack(v, 1, v2))
				end)
			end,
			wait = function(self)
				bindableEvent.Event:wait()
				assert(v, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
				return unpack(v, 1, v2)
			end
		}
	end
}
