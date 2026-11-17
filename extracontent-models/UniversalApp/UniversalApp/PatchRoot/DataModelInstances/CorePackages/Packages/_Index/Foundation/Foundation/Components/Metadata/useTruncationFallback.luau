local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Services = require(Foundation.Utility.Wrappers.Services)
require(Foundation.Components.Types)
local getTextBoundsAsync = require(Foundation.Utility.getTextBoundsAsync)
local normalizeFontFace = require(Foundation.Utility.normalizeFontFace)
local RunService = Services.RunService

local v = {}

local function useTruncationFallback(p: string, p2: number, p3)
	local state, setState = React.useState({ key = p, level = 0 })
	local v2 = state.key ~= p and 0 or state.level
	local v3 = math.max(p2 - 1, 0)
	local formatted = `{p3.Font}|{p3.FontSize}`
	local minWidth = v[formatted] or 0
	local ref = React.useRef({})
	local ref2 = React.useRef({})

	React.useEffect(function()
		return function()
			for _, connection in ref.current do
				connection:Disconnect()
			end

			table.clear(ref.current)
			table.clear(ref2.current)
		end
	end, { p })

	local current = React.useCallback(function(p4: number, p5: number, flag: boolean)
		local v4 = not flag and p5 <= minWidth + 1
		local level = v2

		if p4 == v2 and v2 < v3 and v4 then
			level = v2 + 1
		elseif p4 == v2 - 1 and minWidth + 4 < p5 then
			level = v2 - 1
		end

		if v2 < level and v[formatted] == nil then
			local fontFace = normalizeFontFace(p3.Font)
			local v5

			if typeof(fontFace) == "Font" then
				v5 = getTextBoundsAsync("…", fontFace, p3.FontSize or 0)
			end

			if v5 and v5.X > 0 then
				v[formatted] = math.ceil(v5.X)
			end
		end

		if level ~= v2 then
			setState({ key = p, level = level })
		end
	end, { p, v2, v3, minWidth, formatted, p3 })

	local ref3 = React.useRef(current)
	ref3.current = current

	local onSizeChanged = React.useCallback(function(p4: number, data)
		ref2.current[p4] = data

		if ref.current[p4] then
			return
		end

		local count = 0
		local function check()
			count += 1
			local x = data.AbsoluteSize.X
			local x2 = data.TextBounds.X

			if x + 1 < x2 and count < 10 then
				ref.current[p4] = RunService.Heartbeat:Once(check)
				return
			end

			ref.current[p4] = nil
			ref3.current(p4, x, data.TextFits)
		end
		ref.current[p4] = RunService.Heartbeat:Once(check)
	end, {})

	React.useEffect(function()
		for _, v4 in { v2 - 1, v2 } do
			local v5 = ref2.current[v4]

			if v5 and v5.Parent then
				onSizeChanged(v4, v5)
			end
		end
	end, { v2, p, minWidth, onSizeChanged })

	return {
		minWidth = minWidth,
		getShrinkRatio = React.useCallback(function(p4: number)
			if p4 <= v2 then
				return 1000 ^ (v2 - p4)
			end

			return nil
		end, { v2 }),
		isPinned = React.useCallback(function(p4: number): boolean
			return p4 < v2
		end, { v2 }),
		isDeciding = React.useCallback(function(p4: number): boolean
			return p4 == v2 or p4 == v2 - 1
		end, { v2 }),
		onSizeChanged = onSizeChanged
	}
end

return useTruncationFallback
