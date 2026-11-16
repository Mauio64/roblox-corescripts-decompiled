return {
	CreateSignal = function()
		local bindableEvent = Instance.new("BindableEvent")

		local v = nil
		local v2 = nil
		return {
			fire = function(_, ...)
				v = { ... }
				v2 = select("#", ...)
				bindableEvent:Fire()
			end,
			connect = function(_, callback)
				if not callback then
					error("connect(nil)", 2)
				end

				return bindableEvent.Event:Connect(function()
					callback(unpack(v, 1, v2))
				end)
			end
		}
	end
}
