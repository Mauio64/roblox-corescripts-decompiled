local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local StyleSheet = {}

function StyleSheet.compose(p, p2)
	if p ~= nil and p2 ~= nil then
		return { p, p2 }
	end

	return if p == nil then p2 else p
end

function StyleSheet.create(p)
	if _G.__DEV__ then
		Array.forEach(Object.keys(p), function(p2)
			if p[p2] then
				Object.freeze(p[p2])
			end
		end)
	end

	return p
end

return StyleSheet
