local Parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(Parent.React)
local Signal = require(Parent.AppCommonLib).Signal

local function useCollectionImpressionsSignal(p1) -- line: 18
	-- upvalues: React (copy), Signal (copy)
	local v6 = React.useRef(nil)

	if v6.current == nil then
		v6.current = Signal.new()
	end

	local current = v6.current

	React.useEffect(function() -- line: 25
		-- upvalues: current (copy), p1 (copy)
		current:fire()

		local u8 = nil

		if p1 then
			u8 = p1:connect(function() -- line: 34
				-- upvalues: current (copy)
				current:fire()
			end)
		end

		return function() -- line: 39
			-- upvalues: u8 (ref)
			if u8 then
				u8:disconnect()
			end
		end
	end, {
		p1,
		current
	})

	return current, (React.useCallback(function() -- line: 46
		-- upvalues: current (copy)
		current:fire()
	end, { current }))
end

return useCollectionImpressionsSignal
