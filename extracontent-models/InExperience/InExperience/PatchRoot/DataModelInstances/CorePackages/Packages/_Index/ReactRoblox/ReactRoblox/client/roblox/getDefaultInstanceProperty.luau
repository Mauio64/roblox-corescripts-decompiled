local parent = script.Parent.Parent.Parent.Parent
local Shared = require(parent.Shared)
local named = Shared.Symbol.named("Nil")
local v = {}

local function tryPropertyName(p, p2)
	return p[p2]
end

local function getDefaultInstanceProperty(className, p)
	local v2 = v[className]

	if v2 then
		local v3 = v2[p]

		if v3 == named then
			return true, nil
		end

		if v3 ~= nil then
			return true, v3
		end
	else
		v2 = {}
		v[className] = v2
	end

	local instance = Instance.new(className)
	local success, result = pcall(tryPropertyName, instance, p)

	instance:Destroy()

	if not success then
		return success, result
	end

	if result == nil then
		v2[p] = named
		return success, nil
	end

	v2[p] = result

	return success, result
end

return getDefaultInstanceProperty
