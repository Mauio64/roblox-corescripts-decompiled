local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/ViewportUtils/Display")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ViewportUtils/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ViewportUtils/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ViewportUtils/SignalsReact")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ViewportUtils/SharedFlags")

local intersectBounds = require("@game/CorePackages/Workspace/Packages/_Index/ViewportUtils/ViewportUtils/intersectBounds")
local useClipAncestorBounds = require("@game/CorePackages/Workspace/Packages/_Index/ViewportUtils/ViewportUtils/useClipAncestorBounds")

local defineFastFlag = game:DefineFastFlag("LuaAppFixFrameBoundsImpressions", false)

local fIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold = SharedFlags.FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
local defineFastFlag2 = game:DefineFastFlag("LuaAppThrottleViewportBoundsScreenSize", false)
local fIntLuaAppViewportBoundsScreenSizeThreshold = SharedFlags.FIntLuaAppViewportBoundsScreenSizeThreshold

local fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local fFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local defineFastFlag3 = game:DefineFastFlag("LuaAppUseViewportBoundsInsetFix", false)
local fFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions

local function boundsEqual(p2, p3): boolean
	return p2.min == p3.min and p2.max == p3.max
end

local function screenSizeBoundsEqual(p2, p3): boolean
	local v5 = fIntLuaAppViewportBoundsScreenSizeThreshold
	return math.abs(p2.max.X - p3.max.X) < v5
		and math.abs(p2.max.Y - p3.max.Y) < v5
		and p2.min.X == p3.min.X
		and p2.min.Y == p3.min.Y
end

local v5 = { min = Vector2.zero, max = Vector2.zero }

local function calculateClampedViewportBounds(absolutePosition, absoluteSize, p2)
	local v6 = absolutePosition or Vector2.zero
	local v7 = v6 + (absoluteSize or Vector2.zero)

	local v8 = math.max(p2.min.X, v6.X)
	local v9 = math.min(p2.max.X, v7.X)
	local v10 = math.max(p2.min.Y, v6.Y)
	local v11 = math.min(p2.max.Y, v7.Y)

	if defineFastFlag and (v9 <= v8 or v11 <= v10) then
		return v5
	end

	return { min = Vector2.new(v8, v10), max = Vector2.new(v9, v11) }
end

return function(p2, p3, p4, value)
	local v6 = fFlagUnifyShortcutBarFixImpressions and (value or 0) or nil
	local v7

	if defineFastFlag2 then
		local function fn()
			return Signals.createComputed(function(p5)
				local displayStore = Display.GetDisplayStore(p5)
				local viewportSize = displayStore.getViewportSize(p5)
				local topBarHeight = displayStore.getTopBarHeight(p5)

				local v8 = if not defineFastFlag3 then displayStore.getGuiInset(p5) else nil
				local v9 = { min = Vector2.new(0, topBarHeight), max = 0 }
				local newVector2 = Vector2.new
				local x = viewportSize.X

				local v10 = if defineFastFlag3 or p3 then viewportSize.Y else viewportSize.Y - v8.bottom
				local vector2 = newVector2(x, v10)

				local v11 = if fFlagUnifyShortcutBarFixImpressions then Vector2.new(0, v6) else Vector2.zero
				v9.max = vector2 - v11
				return v9
			end, screenSizeBoundsEqual)
		end

		local v10 = React.useMemo(fn, { p3, if fFlagUnifyShortcutBarFixImpressions then v6 else nil })

		v7 = SignalsReact.useSignalState(v10)
	else
		local v8 = SignalsReact.useSignalState(function(p5)
			return Display.GetDisplayStore(p5).getViewportSize(p5)
		end)

		local v9 = SignalsReact.useSignalState(function(p5)
			return Display.GetDisplayStore(p5).getTopBarHeight(p5)
		end)
		local v10

		if defineFastFlag3 then
			v10 = nil
		else
			v10 = SignalsReact.useSignalState(function(p5)
				return Display.GetDisplayStore(p5).getGuiInset(p5)
			end)
		end

		local useMemo = React.useMemo
		local function fn()
			local v11 = { min = Vector2.new(0, v9), max = 0 }
			local newVector2 = Vector2.new
			local x = v8.X

			local v12 = if defineFastFlag3 or p3 then v8.Y else v8.Y - v10.bottom
			local vector2 = newVector2(x, v12)

			local v13 = if fFlagUnifyShortcutBarFixImpressions then Vector2.new(0, v6) else Vector2.zero
			v11.max = vector2 - v13
			return v11
		end

		local v12 = if not defineFastFlag3 then v10 else nil
		v7 = useMemo(fn, {
			v9,
			v8,
			v12,
			p3,
			if fFlagUnifyShortcutBarFixImpressions then v6 else nil
		})
	end

	local v8

	if fFlagLuaAppRespectClipAncestorImpressions then
		local v10 = if p4 then p2 else nil
		v8 = useClipAncestorBounds(v10)
	else
		v8 = nil
	end

	local state, setState = React.useState(v5)
	local v9

	if defineFastFlag then
		v9 = React.useCallback(function(p5)
			setState(function(p6)
				local v10 = p5
				local v11 = p6.min == v10.min and p6.max == v10.max

				if v11 then
					return p6
				end

				return p5
			end)
		end, {})
	else
		v9 = setState
	end

	local function fn()
		local connections = {}

		local current = if p2 then p2.current else nil

		if current then
			local absolutePosition = current.AbsolutePosition
			local absoluteSize = current.AbsoluteSize
			local v10 = if defineFastFlag then absolutePosition else nil
			local v11 = if defineFastFlag2 then absoluteSize else nil
			local v13 = if fFlagLuaAppRespectClipAncestorImpressions then intersectBounds({
				min = absolutePosition,
				max = absolutePosition + absoluteSize
			}, v7) else calculateClampedViewportBounds(absolutePosition, absoluteSize, v7)
			v9(v13)

			table.insert(
				connections,
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					absolutePosition = current.AbsolutePosition

					if defineFastFlag then
						local v14 = fIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
						local v15 = absolutePosition - v10

						if math.abs(v15.X) < v14 and math.abs(v15.Y) < v14 then
							return
						end

						v10 = absolutePosition
					end

					local v15 = if fFlagLuaAppRespectClipAncestorImpressions then intersectBounds({
						min = absolutePosition,
						max = absolutePosition + absoluteSize
					}, v7) else calculateClampedViewportBounds(absolutePosition, absoluteSize, v7)
					v9(v15)
				end)
			)

			table.insert(connections, current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				absoluteSize = current.AbsoluteSize

				if defineFastFlag2 then
					local v14 = fIntLuaAppViewportBoundsScreenSizeThreshold
					local v15 = absoluteSize - v11

					if math.abs(v15.X) < v14 and math.abs(v15.Y) < v14 then
						return
					end

					v11 = absoluteSize
				end

				local v15 = if fFlagLuaAppRespectClipAncestorImpressions then intersectBounds({
					min = absolutePosition,
					max = absolutePosition + absoluteSize
				}, v7) else calculateClampedViewportBounds(absolutePosition, absoluteSize, v7)
				v9(v15)
			end))
		else
			v9(v7)
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end

	React.useEffect(fn, { p2, v7, if fFlagLuaAppRespectClipAncestorImpressions then v9 else nil })
	local v13

	if fFlagLuaAppRespectClipAncestorImpressions then
		v13 = React.useMemo(function()
			if v8 then
				return (intersectBounds(state, v8))
			end

			return state
		end, { state, v8 })
	else
		v13 = state
	end

	if not fFlagLuaAppRespectClipAncestorImpressions then
		v13 = state
	end

	return v13, if fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then v7 else nil
end
