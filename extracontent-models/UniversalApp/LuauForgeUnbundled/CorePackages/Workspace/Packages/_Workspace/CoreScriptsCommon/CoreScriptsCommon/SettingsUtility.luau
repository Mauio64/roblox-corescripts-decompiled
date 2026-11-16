return {
	CreateSignal = function()
		local bindableEvent = Instance.new("BindableEvent")

		local v5 = nil
		local v6 = nil
		return {
			fire = function(p2, ...)
				v5 = { ... }
				v6 = select("#", ...)
				bindableEvent:Fire()
			end,
			connect = function(p2, callback)
				if not callback then
					error("connect(nil)", 2)
				end

				return bindableEvent.Event:Connect(function()
					callback(unpack(v5, 1, v6))
				end)
			end
		}
	end
}
