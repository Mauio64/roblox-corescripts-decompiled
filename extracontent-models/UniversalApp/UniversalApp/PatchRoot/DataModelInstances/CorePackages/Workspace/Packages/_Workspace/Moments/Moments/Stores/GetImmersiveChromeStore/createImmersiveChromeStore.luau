local Parent = script:FindFirstAncestor("Moments").Parent
local createSignal = require(Parent.Signals).createSignal

local function createImmersiveChromeStore() -- line: 37
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal(true)
	local u6 = nil
	local v7, v8 = createSignal(false)

	return {
		getChromeVisible = v4,
		setChromeVisible = function(b1: boolean) -- line: 45
			-- upvalues: v5 (copy)
			v5(b1)
		end,
		revealChrome = function() -- line: 57
			-- upvalues: u6 (ref), v5 (copy)
			if u6 ~= nil then
				u6()

				return
			end

			v5(true)
		end,
		setRevealHandler = function(p1: ((...any) -> ...any)?) -- line: 53
			-- upvalues: u6 (ref)
			u6 = p1
		end,
		getOverlayCovering = v7,
		setOverlayCovering = function(b2: boolean) -- line: 49
			-- upvalues: v8 (copy)
			v8(b2)
		end
	}
end

return createImmersiveChromeStore
