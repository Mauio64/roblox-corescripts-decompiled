return {
	CreateSignal = function() -- line: 2
		local t1 = {}
		local BindableEvent = Instance.new("BindableEvent")
		local t2 = nil
		local u4 = nil

		function t1.fire(_, ...) -- line: 10
			-- upvalues: t2 (ref), u4 (ref), BindableEvent (copy)
			t2 = { ... }
			u4 = select("#", ...)
			BindableEvent:Fire()
		end
		function t1.connect(_, p3) -- line: 16
			-- upvalues: BindableEvent (copy), t2 (ref), u4 (ref)
			if not p3 then
				error("connect(nil)", 2)
			end

			return BindableEvent.Event:Connect(function() -- line: 20
				-- upvalues: p3 (copy), t2 (ref), u4 (ref)
				p3(unpack(t2, 1, u4))
			end)
		end

		return t1
	end
}
