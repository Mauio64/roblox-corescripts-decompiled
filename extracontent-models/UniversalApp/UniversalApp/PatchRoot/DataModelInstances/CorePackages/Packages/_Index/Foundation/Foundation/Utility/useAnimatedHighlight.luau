local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.Otter)

local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local useTokens = require(Foundation.Providers.Style.useTokens)
local Wrappers = require(Foundation.Utility.Wrappers)
local Connection = Wrappers.Connection
local Instance = Wrappers.Instance
local Signal = Wrappers.Signal

local function useAnimatedHighlight(p1, p2, t1: {[any]: any}, ...) -- line: 19
	-- upvalues: useTokens (copy), React (copy), ReactOtter (copy), Signal (copy), Instance (copy), Connection (copy)
	local v14 = useTokens()
	local v15 = React.useMemo(function() -- line: 26
		-- upvalues: v14 (copy)
		return {
			easingStyle = v14.Ease.StandardOut,
			duration = v14.Time.Time_200
		}
	end, { v14 })
	local v16 = React.useRef(p1)
	local v17, v18 = ReactOtter.useAnimatedBinding(0)
	local v19, v20 = ReactOtter.useAnimatedBinding(0)
	local v21, v22 = React.useBinding(0)
	local v23 = React.useCallback(function(p3, b1: boolean?) -- line: 39
		-- upvalues: p2 (copy), v20 (copy), ReactOtter (copy), v18 (copy), v15 (copy), v22 (copy)
		if p3.current and p2.current then
			local v26 = p3.current.AbsolutePosition.X - p2.current.AbsolutePosition.X
			local AbsoluteSizeX = p3.current.AbsoluteSize.X

			if b1 then
				v20((ReactOtter.instant(AbsoluteSizeX)))
				v18((ReactOtter.instant(v26)))
			else
				v18(ReactOtter.ease(v26, v15))
				v20(ReactOtter.ease(AbsoluteSizeX, v15))
			end

			v22(p3.current.AbsoluteSize.Y)
		end
	end, {
		v15,
		p1
	})

	React.useEffect(function() -- line: 59
		-- upvalues: p1 (copy), t1 (copy), v16 (copy), v23 (copy), p2 (copy), Signal (copy), Instance (copy), Connection (copy)
		if p1 then
			local v28 = t1[p1]
			local v29 = p1 == v16.current

			local function animateHighlight() -- line: 63
				-- upvalues: v28 (copy), v23 (copy), v29 (copy)
				if v28 then
					v23(v28, v29)
				end
			end

			if v28 and v28.current and p2.current then
				local v31 = Signal.Connect(Instance.GetPropertyChangedSignal(v28.current, "AbsoluteSize"), animateHighlight)
				local v32 = Signal.Connect(Instance.GetPropertyChangedSignal(v28.current, "AbsolutePosition"), animateHighlight)
				local v33 = Signal.Connect(Instance.GetPropertyChangedSignal(p2.current, "AbsoluteSize"), animateHighlight)

				return function() -- line: 83
					-- upvalues: Connection (copy), v31 (copy), v32 (copy), v33 (copy)
					Connection.Disconnect(v31)
					Connection.Disconnect(v32)
					Connection.Disconnect(v33)
				end
			end
		end

		return function() -- line: 91
		end
	end, { p1 })
	React.useEffect(function() -- line: 94
		-- upvalues: p1 (copy), t1 (copy), p2 (copy), v23 (copy), v16 (copy)
		if p1 then
			local v34 = t1[p1]

			if v34 and v34.current and p2.current then
				v23(v34, p1 == v16.current)
			end

			v16.current = p1
		end
	end, {
		p1,
		...
	})

	return {
		activeItemHeight = v21,
		highlightPosition = v17,
		highlightWidth = v19
	}
end

return useAnimatedHighlight
