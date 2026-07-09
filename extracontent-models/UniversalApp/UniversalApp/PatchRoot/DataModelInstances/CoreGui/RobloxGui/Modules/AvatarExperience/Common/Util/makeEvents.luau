local function makeEvents(p1) -- line: 3
	local t1 = {}
	local t2 = {}
	local t3 = {}

	for _, v7 in p1 do
		local BindableEvent = Instance.new("BindableEvent")

		t1[v7] = BindableEvent.Event
		t2[v7] = function(...) -- line: 11
			-- upvalues: BindableEvent (copy)
			BindableEvent:Fire(...)
		end
		t3[v7] = function() -- line: 14
			-- upvalues: BindableEvent (copy)
			BindableEvent:Destroy()
		end
	end

	return t1, t2, t3
end

return makeEvents
