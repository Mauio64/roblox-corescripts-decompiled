local Parent = script:FindFirstAncestor("DataHydration").Parent
local createEffect = require(Parent.Signals).createEffect

require(script.Parent.types)

local function onTerminal(p1, p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)?) -- line: 15
	-- upvalues: createEffect (copy)
	local u7 = nil

	u7 = createEffect(function(p4) -- line: 21
		-- upvalues: p1 (copy), p2 (copy), p3 (copy), u7 (ref)
		local v9 = p1(p4)

		if v9.status == "pending" then
			return
		end

		if v9.status == "succeeded" and p2 then
			p2(v9.result)
		elseif v9.status == "failed" and p3 then
			p3(v9.error or "request failed", v9.errorCode)
		end

		if u7 then
			u7()
		end
	end)
end

return onTerminal
