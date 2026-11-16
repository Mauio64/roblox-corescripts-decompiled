local parent = script:FindFirstAncestor("ViewportUtils").Parent
local Display = require(parent.Display)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)

local intersectBounds = require(script.Parent.intersectBounds)
local useClipAncestorBounds = require(script.Parent.useClipAncestorBounds)

local defineFastFlag = game:DefineFastFlag("LuaAppFixFrameBoundsImpressions", false)

local FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold = SharedFlags.FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
local defineFastFlag2 = game:DefineFastFlag("LuaAppThrottleViewportBoundsScreenSize", false)
local FIntLuaAppViewportBoundsScreenSizeThreshold = SharedFlags.FIntLuaAppViewportBoundsScreenSizeThreshold

local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local defineFastFlag3 = game:DefineFastFlag("LuaAppUseViewportBoundsInsetFix", false)
local FFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions

local function boundsEqual(p, p2): boolean -- 1 equivalent call inferred from this helper
	return p.min == p2.min and p.max == p2.max
end

local function screenSizeBoundsEqual(p, p2): boolean
	local v = FIntLuaAppViewportBoundsScreenSizeThreshold
	return math.abs(p.max.X - p2.max.X) < v
		and math.abs(p.max.Y - p2.max.Y) < v
		and p.min.X == p2.min.X
		and p.min.Y == p2.min.Y
end

local v = { min = Vector2.zero, max = Vector2.zero }

local function calculateClampedViewportBounds(absolutePosition: Vector2?, absoluteSize: Vector2?, p)
	local v2 = absolutePosition or Vector2.zero
	local v3 = v2 + (absoluteSize or Vector2.zero)

	local v4 = math.max(p.min.X, v2.X)
	local v5 = math.min(p.max.X, v3.X)
	local v6 = math.max(p.min.Y, v2.Y)
	local v7 = math.min(p.max.Y, v3.Y)

	if defineFastFlag and (v5 <= v4 or v7 <= v6) then
		return v
	end

	return { min = Vector2.new(v4, v6), max = Vector2.new(v5, v7) }
end

return function(p, flag: boolean?, flag2: boolean?, value: number?)
	local v2 = FFlagUnifyShortcutBarFixImpressions and (value or 0) or nil
	local v3

	if defineFastFlag2 then
		local useMemo = React.useMemo
		local function fn()
			return Signals.createComputed(function(p2)
				local displayStore = Display.GetDisplayStore(p2)
				local viewportSize = displayStore.getViewportSize(p2)
				local topBarHeight = displayStore.getTopBarHeight(p2)
				local v4

				if not defineFastFlag3 then
					v4 = displayStore.getGuiInset(p2)
				end

				local v5 = { min = Vector2.new(0, topBarHeight), max = 0 }

				local x = viewportSize.X
				local v6

				if defineFastFlag3 or flag then
					v6 = viewportSize.Y
				else
					v6 = viewportSize.Y - v4.bottom
				end

				local vector2 = Vector2.new(x, v6)
				local v7

				if FFlagUnifyShortcutBarFixImpressions then
					v7 = Vector2.new(0, v2)
				else
					v7 = Vector2.zero
				end

				v5.max = vector2 - v7
				return v5
			end, screenSizeBoundsEqual)
		end

		local v4

		if FFlagUnifyShortcutBarFixImpressions then
			v4 = v2
		end

		local v5 = useMemo(fn, { flag, v4 })

		v3 = SignalsReact.useSignalState(v5)
	else
		local v4 = SignalsReact.useSignalState(function(p2)
			return Display.GetDisplayStore(p2).getViewportSize(p2)
		end)

		local v5 = SignalsReact.useSignalState(function(p2)
			return Display.GetDisplayStore(p2).getTopBarHeight(p2)
		end)
		local v6

		if defineFastFlag3 then
			v6 = nil
		else
			v6 = SignalsReact.useSignalState(function(p2)
				return Display.GetDisplayStore(p2).getGuiInset(p2)
			end)
		end

		local useMemo = React.useMemo
		local function fn()
			local v7 = { min = Vector2.new(0, v5), max = 0 }

			local x = v4.X
			local v8

			if defineFastFlag3 or flag then
				v8 = v4.Y
			else
				v8 = v4.Y - v6.bottom
			end

			local vector2 = Vector2.new(x, v8)
			local v9

			if FFlagUnifyShortcutBarFixImpressions then
				v9 = Vector2.new(0, v2)
			else
				v9 = Vector2.zero
			end

			v7.max = vector2 - v9
			return v7
		end

		local v7

		if not defineFastFlag3 then
			v7 = v6
		end

		local v8

		if FFlagUnifyShortcutBarFixImpressions then
			v8 = v2
		end

		v3 = useMemo(fn, { v5, v4, v7, flag, v8 })
	end

	local v4

	if FFlagLuaAppRespectClipAncestorImpressions then
		local v5

		if flag2 then
			v5 = p
		end

		v4 = useClipAncestorBounds(v5)
	else
		v4 = nil
	end

	local state, setState = React.useState(v)
	local v5

	if defineFastFlag then
		v5 = React.useCallback(function(p2)
			setState(function(p3)
				if boundsEqual(p3, p2) then -- inferred equivalent call
					return p3
				end

				return p2
			end)
		end, {})
	else
		v5 = setState
	end

	local useEffect = React.useEffect
	local function fn()
		local connections = {}
		local current

		if p then
			current = p.current
		else
			current = nil
		end

		if current then
			local absolutePosition = current.AbsolutePosition
			local absoluteSize = current.AbsoluteSize
			local v6

			if defineFastFlag then
				v6 = absolutePosition
			else
				v6 = nil
			end

			local v7

			if defineFastFlag2 then
				v7 = absoluteSize
			else
				v7 = nil
			end

			local v8

			if FFlagLuaAppRespectClipAncestorImpressions then
				v8 = intersectBounds({
					min = absolutePosition,
					max = absolutePosition + absoluteSize
				}, v3)
			else
				v8 = calculateClampedViewportBounds(absolutePosition, absoluteSize, v3)
			end

			v5(v8)

			table.insert(connections, current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				absolutePosition = current.AbsolutePosition

				if defineFastFlag then
					local v9 = FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
					local v10 = absolutePosition - v6

					if math.abs(v10.X) < v9 and math.abs(v10.Y) < v9 then
						return
					end

					v6 = absolutePosition
				end

				local v9

				if FFlagLuaAppRespectClipAncestorImpressions then
					v9 = intersectBounds({
						min = absolutePosition,
						max = absolutePosition + absoluteSize
					}, v3)
				else
					v9 = calculateClampedViewportBounds(absolutePosition, absoluteSize, v3)
				end

				v5(v9)
			end))

			table.insert(connections, current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				absoluteSize = current.AbsoluteSize

				if defineFastFlag2 then
					local v9 = FIntLuaAppViewportBoundsScreenSizeThreshold
					local v10 = absoluteSize - v7

					if math.abs(v10.X) < v9 and math.abs(v10.Y) < v9 then
						return
					end

					v7 = absoluteSize
				end

				local v9

				if FFlagLuaAppRespectClipAncestorImpressions then
					v9 = intersectBounds({
						min = absolutePosition,
						max = absolutePosition + absoluteSize
					}, v3)
				else
					v9 = calculateClampedViewportBounds(absolutePosition, absoluteSize, v3)
				end

				v5(v9)
			end))
		else
			v5(v3)
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end

	local v6

	if FFlagLuaAppRespectClipAncestorImpressions then
		v6 = v5
	end

	useEffect(fn, { p, v3, v6 })
	local v7

	if FFlagLuaAppRespectClipAncestorImpressions then
		v7 = React.useMemo(function()
			if v4 then
				return (intersectBounds(state, v4))
			end

			return state
		end, { state, v4 })
	else
		v7 = state
	end

	if not FFlagLuaAppRespectClipAncestorImpressions then
		v7 = state
	end

	local v8

	if FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		v8 = v3
	end

	return v7, v8
end
