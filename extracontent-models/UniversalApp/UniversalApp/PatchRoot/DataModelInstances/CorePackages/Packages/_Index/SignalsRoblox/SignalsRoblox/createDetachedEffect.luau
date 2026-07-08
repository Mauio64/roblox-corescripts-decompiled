local ParentParent = script.Parent.Parent
local createEffect = require(ParentParent.Signals).createEffect

local function createDetachedEffect(p1: ((...any) -> ...any)) -- line: 9
	-- upvalues: createEffect (copy)
	local u5 = false
	local u6 = nil

	local function disposeEffect() -- line: 13
		-- upvalues: u5 (ref), u6 (ref)
		if not u5 then
			u5 = true

			if u6 ~= nil then
				u6:Fire()
			end
		end
	end

	local v8 = createEffect(function(p2) -- line: 22
		-- upvalues: p1 (copy), disposeEffect (copy)
		p1(p2, disposeEffect)
	end)

	if u5 then
		v8()
	else
		local BindableEvent = Instance.new("BindableEvent")

		u6 = BindableEvent
		BindableEvent.Event:Once(function() -- line: 31
			-- upvalues: BindableEvent (copy), u6 (ref), v8 (copy)
			BindableEvent:Destroy()
			u6 = nil
			v8()
		end)
	end
end

return createDetachedEffect
