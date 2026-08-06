local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.Otter)

local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)

require(Foundation.Enums.PaginationSize)

local useTokens = require(Foundation.Providers.Style.useTokens)
local Wrappers = require(Foundation.Utility.Wrappers)
local Connection = Wrappers.Connection
local Instance = Wrappers.Instance
local Signal = Wrappers.Signal

require(script.Parent.paginationSlotsUtils)

local function usePaginationAnimatedHighlight(s1: string?, p1, t1: {[any]: any}, p2, t2: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), ReactOtter (copy), React (copy), Signal (copy), Instance (copy), Connection (copy)
	local Time_100 = useTokens().Time.Time_100
	local v17, v18 = ReactOtter.useAnimatedBinding(0)
	local v19, v20 = ReactOtter.useAnimatedBinding(0)
	local v21, v22 = React.useBinding(0)
	local v23, v24 = React.useBinding(false)
	local v25 = React.useRef(s1)
	local v26 = React.useRef(false)
	local v27 = React.useRef(false)
	local v28 = React.useRef(nil)
	local v29 = React.useRef(nil)

	local function resetTransitionState(b1: boolean) -- line: 59
		-- upvalues: v28 (copy), v26 (copy), v27 (copy)
		if v28.current then
			task.cancel(v28.current)
			v28.current = nil
		end

		v26.current = false

		if b1 then
			v27.current = false
		end
	end

	local v31 = React.useCallback(function() -- line: 70
		-- upvalues: v28 (copy), v26 (copy), Time_100 (copy), v27 (copy), v29 (copy)
		if v28.current then
			task.cancel(v28.current)
		end

		v26.current = true
		v28.current = task.delay(Time_100, function() -- line: 76
			-- upvalues: v28 (copy), v26 (copy), v27 (copy), v29 (copy)
			v28.current = nil
			v26.current = false

			if v27.current then
				v27.current = false

				local current = v29.current

				if current then
					current()
				end
			end
		end)
	end, { Time_100 })
	local v32 = React.useCallback(function(p3, b2: boolean?) -- line: 90
		-- upvalues: p1 (copy), v24 (copy), v26 (copy), v27 (copy), v20 (copy), ReactOtter (copy), v18 (copy), v31 (copy), Time_100 (copy), v22 (copy)
		if p3.current and p1.current then
			local v37 = p3.current.AbsolutePosition.X - p1.current.AbsolutePosition.X
			local AbsoluteSizeX = p3.current.AbsoluteSize.X
			local AbsoluteSizeY = p3.current.AbsoluteSize.Y

			if AbsoluteSizeX <= 0 or AbsoluteSizeY <= 0 then
				v24(false)

				return false
			end

			if b2 and v26.current then
				v27.current = true

				return false
			end

			if b2 then
				v20(ReactOtter.instant(AbsoluteSizeX))
				v18(ReactOtter.instant(v37))
			else
				v27.current = false
				v31()

				local t3 = {
					easingStyle = Enum.EasingStyle.Linear,
					duration = Time_100
				}

				v18(ReactOtter.ease(v37, t3))
				v20(ReactOtter.ease(AbsoluteSizeX, t3))
			end

			v22(AbsoluteSizeY)
			v24(true)

			return true
		end

		v24(false)

		return false
	end, {
		Time_100,
		p1,
		v31
	})
	local v33 = React.useCallback(function() -- line: 138
		-- upvalues: s1 (copy), t1 (copy), v32 (copy)
		if s1 then
			local v41 = t1[s1]

			if v41 then
				v32(v41, true)
			end
		end
	end, {
		s1,
		t1,
		v32
	})

	React.useLayoutEffect(function() -- line: 148
		-- upvalues: s1 (copy), t1 (copy), v25 (copy), v28 (copy), v26 (copy), v27 (copy), p1 (copy), v32 (copy), v24 (copy)
		if s1 then
			local v42 = t1[s1]
			local v43 = s1 == v25.current

			if not v43 then
				if v28.current then
					task.cancel(v28.current)
					v28.current = nil
				end

				v26.current = false
				v27.current = false
			end

			if v42 and v42.current and p1.current then
				v32(v42, v43)
			else
				v24(false)
			end

			v25.current = s1

			return
		end

		v24(false)
		v25.current = nil
	end, {
		s1,
		t1,
		v32,
		p2,
		t2
	})
	React.useEffect(function() -- line: 171
		-- upvalues: s1 (copy), t1 (copy), p1 (copy), Signal (copy), Instance (copy), v33 (copy), Connection (copy)
		if s1 then
			local v44 = t1[s1]

			if v44 and v44.current and p1.current then
				local v45 = Signal.Connect(Instance.GetPropertyChangedSignal(v44.current, "AbsoluteSize"), v33)
				local v46 = Signal.Connect(Instance.GetPropertyChangedSignal(v44.current, "AbsolutePosition"), v33)
				local v47 = Signal.Connect(Instance.GetPropertyChangedSignal(p1.current, "AbsoluteSize"), v33)
				local v48 = Signal.Connect(Instance.GetPropertyChangedSignal(p1.current, "AbsolutePosition"), v33)

				return function() -- line: 193
					-- upvalues: Connection (copy), v45 (copy), v46 (copy), v47 (copy), v48 (copy)
					Connection.Disconnect(v45)
					Connection.Disconnect(v46)
					Connection.Disconnect(v47)
					Connection.Disconnect(v48)
				end
			end
		end

		return function() -- line: 202
		end
	end, {
		s1,
		t1,
		v33
	})
	React.useEffect(function() -- line: 206
		-- upvalues: v29 (copy), v33 (copy)
		v29.current = v33
	end, { v33 })
	React.useEffect(function() -- line: 210
		-- upvalues: v28 (copy)
		return function() -- line: 211
			-- upvalues: v28 (copy)
			if v28.current then
				task.cancel(v28.current)
				v28.current = nil
			end
		end
	end, {})

	return {
		activeItemHeight = v21,
		highlightPosition = v17,
		highlightWidth = v19,
		isVisible = v23,
		updateHighlight = v32
	}
end

return usePaginationAnimatedHighlight
