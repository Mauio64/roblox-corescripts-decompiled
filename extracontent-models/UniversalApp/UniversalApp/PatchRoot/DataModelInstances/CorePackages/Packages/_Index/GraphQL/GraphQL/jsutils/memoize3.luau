local parent = script.Parent.Parent.Parent
require(parent.LuauPolyfill)

local v = {}

local function replaceNil(p) -- 4 equivalent calls inferred from this helper
	return if p == nil then v else p
end

local function newWeakMap() -- 3 equivalent calls inferred from this helper
	return (setmetatable({}, { __mode = "kv" }))
end

return {
	memoize3 = function(callback)
		local v2 = nil

		return function(p, p2, p3)
			local v3 = replaceNil(p) -- inferred equivalent call
			local v4 = replaceNil(p2) -- inferred equivalent call
			local v5 = replaceNil(p3) -- inferred equivalent call

			if not v2 then
				v2 = newWeakMap() -- inferred equivalent call
			end

			local v6 = v2[v3]
			local v7 = nil

			if v6 then
				v7 = v6[v4]

				if v7 then
					local v8 = v7[v5]

					if v8 ~= nil then
						return if v8 ~= v then v8 else nil
					end
				end
			else
				v6 = newWeakMap() -- inferred equivalent call
				v2[v3] = v6
			end

			if not v7 then
				v7 = newWeakMap() -- inferred equivalent call
				v6[v4] = v7
			end

			local v8 = callback(p, p2, p3)
			v7[v5] = replaceNil(v8) -- inferred equivalent call
			return v8
		end
	end
}
