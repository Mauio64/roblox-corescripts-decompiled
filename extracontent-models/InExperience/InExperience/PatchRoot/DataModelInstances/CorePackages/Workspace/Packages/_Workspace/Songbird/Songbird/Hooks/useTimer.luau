local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local useEffect = require(Songbird.Parent.React).useEffect

local function useTimer(n1: number, p1: ((...any) -> ...any), t1: {[any]: any}?) -- line: 8
	-- upvalues: useEffect (copy), Cryo (copy)
	useEffect(function() -- line: 9
		-- upvalues: n1 (copy), p1 (copy)
		local u8 = true

		task.spawn(function() -- line: 12
			-- upvalues: u8 (ref), n1 (copy), p1 (copy)
			while u8 do
				task.wait(n1)

				if not u8 then
					return
				end

				p1()
			end
		end)

		return function() -- line: 24
			-- upvalues: u8 (ref)
			u8 = false
		end
	end, Cryo.Dictionary.join({
		n1,
		p1
	}, t1 or {}))
end

return useTimer
