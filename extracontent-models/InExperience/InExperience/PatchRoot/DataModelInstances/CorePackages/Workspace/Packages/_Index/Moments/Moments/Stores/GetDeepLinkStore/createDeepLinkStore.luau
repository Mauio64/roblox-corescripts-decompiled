local Parent = script:FindFirstAncestor("Moments").Parent
local createSignal = require(Parent.Signals).createSignal

local function createDeepLinkStore() -- line: 23
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal(nil)
	local v6, v7 = createSignal(nil)

	return {
		getDeepLinkedMomentId = v4,
		getDeepLinkedMomentTargetIdType = v6,
		setDeepLinkedMomentId = function(s1: string?) -- line: 34
			-- upvalues: v5 (copy), v7 (copy)
			v5(s1)
			v7(if s1 == nil then nil else nil)
		end,
		setDeepLinkedMoment = function(s2: string?, s3: string?) -- line: 29
			-- upvalues: v5 (copy), v7 (copy)
			v5(s2)
			v7(if s2 == nil then nil else s3)
		end,
		consumeDeepLinkedMoment = function() -- line: 38
			-- upvalues: v4 (copy), v6 (copy), v5 (copy), v7 (copy)
			local v11 = v4(false)
			local v12 = v6(false)

			v5(nil)
			v7(nil)

			if v11 == nil then
				return nil
			end

			return {
				targetId = v11,
				targetIdType = v12
			}
		end,
		consumeDeepLinkedMomentId = function() -- line: 51
			-- upvalues: v4 (copy), v6 (copy), v5 (copy), v7 (copy)
			local v13 = v4(false)
			local v14 = v6(false)

			v5(nil)
			v7(nil)

			local v15 = if v13 ~= nil then {
				targetId = v13,
				targetIdType = v14
			} else nil

			if v15 ~= nil then
				return v15.targetId
			end

			return nil
		end
	}
end

return createDeepLinkStore
