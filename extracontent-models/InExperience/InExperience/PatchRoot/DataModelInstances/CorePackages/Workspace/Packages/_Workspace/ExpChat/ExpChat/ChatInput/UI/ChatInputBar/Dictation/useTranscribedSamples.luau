local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

local function useTranscribedSamples() -- line: 26
	-- upvalues: React (copy)
	local v4, v5 = React.useBinding({})
	local v6 = React.useRef(nil)

	return {
		binding = v4,
		begin = function(n1: number) -- line: 32
			-- upvalues: v6 (copy)
			v6.current = v6.current or n1
		end,
		commit = function(n2: number) -- line: 38
			-- upvalues: v6 (copy), v4 (copy), v5 (copy)
			local current = v6.current

			v6.current = nil

			if current == nil or n2 < current then
				return
			end

			local v10 = table.clone(v4:getValue())

			table.insert(v10, {
				startIdx = current,
				endIdx = n2
			})
			v5(v10)
		end,
		reset = function() -- line: 49
			-- upvalues: v6 (copy), v5 (copy)
			v6.current = nil
			v5({})
		end
	}
end

return useTranscribedSamples
