local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local useForwardRef = require(script.Parent.useForwardRef)

local function usePropertiesBase(p, callback, flag: boolean, ...)
	local joined = Array.concat({}, ...)
	return useForwardRef(p, (React.useCallback(function(instance)
		local function onPropChange() -- 2 equivalent calls inferred from this helper
			callback(table.unpack(Array.map(joined, function(p2)
				return instance[p2]
			end)))
		end
		local thread = nil
		local function fn()
			if not thread then
				thread = task.defer(function()
					thread = nil
					onPropChange() -- inferred equivalent call
				end)
			end
		end
		local mapped = Array.map(joined, function(propertyName)
			local propertyChangedSignal = instance:GetPropertyChangedSignal(propertyName)
			local v = if flag then fn else onPropChange
			return propertyChangedSignal:Connect(v)
		end)
		onPropChange() -- inferred equivalent call
		return function()
			for _, connection in mapped do
				connection:Disconnect()
			end

			if thread then
				task.cancel(thread)
			end
		end
	end, { callback, table.concat(joined, ",") })))
end

return usePropertiesBase
