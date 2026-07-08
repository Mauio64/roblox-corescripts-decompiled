local Parent = script:FindFirstAncestor("Moments").Parent
local createSignal = require(Parent.Signals).createSignal

local function createDeepLinkStore() -- line: 15
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal(nil)

	return {
		getDeepLinkedMomentId = v4,
		setDeepLinkedMomentId = v5,
		consumeDeepLinkedMomentId = function() -- line: 19
			-- upvalues: v4 (copy), v5 (copy)
			local v6 = v4(false)

			if v6 then
				v5(nil)
			end

			return v6
		end
	}
end

return createDeepLinkStore
