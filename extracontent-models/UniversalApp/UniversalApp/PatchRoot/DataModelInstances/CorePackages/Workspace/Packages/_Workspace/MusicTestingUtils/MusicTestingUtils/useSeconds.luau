local MusicTestingUtils = script:FindFirstAncestor("MusicTestingUtils")
local React = require(MusicTestingUtils.Parent.React)
local useState = React.useState
local useEffect = React.useEffect

local function useSeconds() -- line: 7
	-- upvalues: useState (copy), useEffect (copy)
	local v6, v7 = useState(0)

	useEffect(function() -- line: 10
		-- upvalues: v7 (copy)
		local u8 = true

		task.spawn(function() -- line: 13
			-- upvalues: u8 (ref), v7 (copy)
			while u8 do
				task.wait(1)
				v7(function(p1) -- line: 17
					return p1 + 1
				end)
			end
		end)

		return function() -- line: 23
			-- upvalues: u8 (ref)
			u8 = false
		end
	end, {})

	return v6
end

return useSeconds
