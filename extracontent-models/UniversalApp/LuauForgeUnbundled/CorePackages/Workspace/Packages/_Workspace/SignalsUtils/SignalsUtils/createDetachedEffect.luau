local createEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/SignalsUtils/Signals").createEffect

local function createDetachedEffect(callback)
	local flag = false
	local v5 = nil

	local function disposeEffect()
		if not flag then
			flag = true

			if v5 ~= nil then
				v5:Fire()
			end
		end
	end

	local effect = createEffect(function(p2)
		callback(p2, disposeEffect)
	end)

	if flag then
		effect()
	else
		local bindableEvent = Instance.new("BindableEvent")
		v5 = bindableEvent
		bindableEvent.Event:Once(function()
			bindableEvent:Destroy()
			v5 = nil
			effect()
		end)
	end
end

return createDetachedEffect
