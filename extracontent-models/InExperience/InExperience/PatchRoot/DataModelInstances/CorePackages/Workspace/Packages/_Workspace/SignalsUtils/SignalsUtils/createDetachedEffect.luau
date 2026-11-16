local parent = script.Parent.Parent
local Signals = require(parent.Signals)
local createEffect = Signals.createEffect

local function createDetachedEffect(callback)
	local flag = false
	local v = nil

	local function disposeEffect()
		if not flag then
			flag = true

			if v ~= nil then
				v:Fire()
			end
		end
	end

	local effect = createEffect(function(p)
		callback(p, disposeEffect)
	end)

	if flag then
		effect()
	else
		local bindableEvent = Instance.new("BindableEvent")
		v = bindableEvent
		bindableEvent.Event:Once(function()
			bindableEvent:Destroy()
			v = nil
			effect()
		end)
	end
end

return createDetachedEffect
