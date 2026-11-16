local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)

local function useTranscribedSamples()
	local binding, v = React.useBinding({})
	local ref = React.useRef(nil)

	return {
		binding = binding,
		begin = function(p: number)
			ref.current = ref.current or p
		end,
		commit = function(endIdx: number)
			local current = ref.current
			ref.current = nil

			if current == nil or endIdx < current then
				return
			end

			local clone = table.clone(binding:getValue())
			table.insert(clone, { startIdx = current, endIdx = endIdx })
			v(clone)
		end,
		reset = function()
			ref.current = nil
			v({})
		end
	}
end

return useTranscribedSamples
