local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Signals")

local marqueeEligibility = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/marqueeEligibility")
local scrollPause = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/scrollPause")
local tileVisibility = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/tileVisibility")

local function drawsOnTop(guiObject): boolean
	if not (guiObject:IsA("GuiObject") and guiObject.Visible) then
		return false
	end

	if guiObject.BackgroundTransparency < 0.95 then
		return true
	end

	if not (guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton")) then
		return false
	end

	return guiObject.Image ~= "" and guiObject.ImageTransparency < 0.95
end

local function isCoveredAt(current, callback, p2, p3): boolean
	for k, v5 in callback(p2, p3) do
		if v5 == current or v5:IsDescendantOf(current) then
			return false
		end

		if not current:IsDescendantOf(v5) and drawsOnTop(v5) then
			return true
		end
	end

	return false
end

local function indexOfTileId(list, p2)
	for i, item in ipairs(list) do
		if item.id == p2 then
			return i
		end
	end

	return nil
end

local function lastLocationFor(tiles, p2)
	for i, item in ipairs(tiles) do
		if item.id == p2 then
			local presence = item.presence
			local lastLocation = if presence ~= nil then presence.lastLocation else nil

			if lastLocation == nil or lastLocation == "" then
				return nil
			end

			return lastLocation
		end
	end

	return nil
end

return {
	useMarqueeActiveTiles = function(p2, current, p3, p4, p5)
		local state, setState = React.useState({})
		local state2, setState2 = React.useState(false)
		local ref = React.useRef(scrollPause.initialState())

		local ref2 = React.useRef({})

		if current.loopsRemainingStore ~= nil then
			ref2.current = current.loopsRemainingStore.getLoopsRemaining(false)
		end

		local ref3 = React.useRef(nil)

		local ref4 = React.useRef(nil)
		local state3, setState3 = React.useState(0)
		local ref5 = React.useRef(0)
		local ref6 = React.useRef(current)
		ref6.current = current

		local ref7 = React.useRef(function() end)

		local ref8 = React.useRef(0)

		local function loopsRemainingMap()
			local loopsRemainingStore = ref6.current.loopsRemainingStore

			if loopsRemainingStore == nil then
				return ref2.current
			end

			return loopsRemainingStore.getLoopsRemaining(false)
		end

		local function publishIndex(current2)
			if ref4.current == current2 then
				return
			end

			ref4.current = current2

			if current2 == nil then
				setState({})
			else
				setState({ [current2] = true })
			end
		end

		local v5 = React.useCallback(function(p6)
			local current2 = ref6.current

			if current2.idleSequenceEnabled ~= true then
				return
			end

			local tiles = current2.tiles or {}
			local v6 = lastLocationFor(tiles, p6)

			if v6 == nil then
				return
			end

			local recordFinishedLoop = marqueeEligibility.recordFinishedLoop
			local loopsRemainingStore = ref6.current.loopsRemainingStore
			local v7 = if loopsRemainingStore == nil then ref2.current else loopsRemainingStore.getLoopsRemaining(false)

			recordFinishedLoop(v7, p6, v6)

			local v8 = {
				direction = current2.direction or Enum.TextDirection.LeftToRight,
				reducedMotion = current2.reducedMotion == true,
				interacting = false,
				loopsRemaining = 0,
				canvasX = 0,
				containerWidth = 0,
				tileWidth = 0,
				gap = 0
			}
			local loopsRemainingStore2 = ref6.current.loopsRemainingStore
			local v9 = if loopsRemainingStore2 == nil then ref2.current else loopsRemainingStore2.getLoopsRemaining(false)

			v8.loopsRemaining = v9
			v8.canvasX = ref.current.canvasX or 0
			v8.containerWidth = current2.containerWidth
			v8.tileWidth = current2.tileWidth
			v8.gap = current2.columnGap

			local v10 = marqueeEligibility.resolveActiveTileId(tiles, v8, p6)

			if v10 ~= p6 then
				v10 = marqueeEligibility.nextEligibleAfter(tiles, p6, v8)
			end

			ref3.current = v10
			local v12

			if v10 ~= nil then
				for i, tile in ipairs(tiles) do
					if tile.id == v10 then
						v12 = i
						break
					end
				end
			end

			publishIndex(v12)

			if v10 == nil then
				return
			end

			local v13 = lastLocationFor(tiles, v10)

			if v13 == nil then
				return
			end

			local loopsRemainingStore3 = ref6.current.loopsRemainingStore
			local v15 = (if loopsRemainingStore3 == nil then ref2.current else loopsRemainingStore3.getLoopsRemaining(false))[marqueeEligibility.loopKey(v10, v13)]

			if v15 ~= nil and v15 < marqueeEligibility.DEFAULT_LOOPS then
				ref5.current += 1
				setState3(ref5.current)
			end
		end, {})

		local function tileById(list, p6)
			for i, item in ipairs(list) do
				if item.id == p6 then
					return item
				end
			end

			return nil
		end

		local v6 = React.useCallback(function(current2)
			local current3 = ref6.current

			if current3.manualMarqueeEnabled ~= true or current3.reducedMotion == true then
				return
			end

			local tiles = current3.tiles or {}
			local v7 = nil

			for i, tile in ipairs(tiles) do
				if tile.id == current2 then
					v7 = tile
					break
				end
			end

			if v7 == nil or not marqueeEligibility.isHoverEligible(v7) then
				return
			end

			ref3.current = current2
			local v10 = nil

			for i, tile in ipairs(tiles) do
				if tile.id == current2 then
					v10 = i
					break
				end
			end

			publishIndex(v10)

			ref5.current += 1
			setState3(ref5.current)
		end, {})

		local v7 = React.useCallback(function(p6)
			if not (ref6.current.manualMarqueeEnabled == true and ref3.current == p6) then
				return
			end

			ref3.current = nil

			if ref4.current == nil then
				return
			end

			ref4.current = nil

			setState({})
		end, {})

		local ref9 = React.useRef({})

		React.useEffect(function()
			local current2 = p2.current

			if current2 == nil then
				return
			end

			local v8 = p3 or RunService.Heartbeat
			local v9 = p4 or UserInputService
			local v10 = p5 or function(p6, p7)
				local basePlayerGui = current2:FindFirstAncestorWhichIsA("BasePlayerGui")

				if basePlayerGui == nil then
					return {}
				end

				return basePlayerGui:GetGuiObjectsAtPosition(p6, p7)
			end

			local connection = nil
			local current3 = ref9.current
			local v11 = {
				current = next(current3) ~= nil
			}

			local apply

			local function stopHeartbeat()
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end

			local function scrollRange(data)
				return math.max(
					data.CanvasSize.Y.Offset + data.CanvasSize.Y.Scale * data.AbsoluteSize.Y,
					data.AbsoluteCanvasSize.Y
				) - data.AbsoluteSize.Y
			end

			local function verticalPage()
				local parent = current2.Parent
				local v12 = nil
				local v13 = 0

				while parent ~= nil do
					if parent:IsA("ScrollingFrame") then
						local v14 = math.max(
							parent.CanvasSize.Y.Offset + parent.CanvasSize.Y.Scale * parent.AbsoluteSize.Y,
							parent.AbsoluteCanvasSize.Y
						) - parent.AbsoluteSize.Y

						if v13 < v14 then
							v13 = v14
							v12 = parent
						end
					end

					parent = parent.Parent
				end

				return v12
			end

			local function verticalCanvasY()
				local v12 = verticalPage()

				if v12 == nil then
					return nil
				end

				return v12.CanvasPosition.Y
			end

			local function rowIsVerticallyEligible(): boolean
				local v12 = verticalPage()

				if v12 == nil then
					return true
				end

				local y = current2.AbsolutePosition.Y
				local y2 = current2.AbsoluteSize.Y
				local y3 = v12.AbsolutePosition.Y
				local y4 = v12.AbsoluteSize.Y

				if not tileVisibility.isAtLeast70PercentVerticallyVisible(y, y2, y3, y4) then
					return false
				end

				local v13 = current2.AbsolutePosition.X + current2.AbsoluteSize.X / 2
				local count = 0

				for i = 1, 20 do
					local v14 = y + (i - 0.5) * y2 / 20
					local v15 = y3 <= v14 and v14 <= y3 + y4

					if not v15 or isCoveredAt(current2, v10, v13, v14) then
						continue
					end

					count += 1
				end

				return count / 20 >= tileVisibility.MIN_VISIBLE_FRACTION
			end

			local function publish(canvasX, p6)
				local current4 = ref6.current

				if current4.manualMarqueeEnabled == true then
					local tiles = current4.tiles or {}
					local current5 = ref3.current
					local v12

					if current5 ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == current5 then
								v12 = tile
								break
							end
						end
					end

					if v12 == nil or current4.reducedMotion == true then
						ref3.current = nil

						if ref4.current == nil then
							return
						end

						ref4.current = nil

						setState({})
					elseif marqueeEligibility.isHoverEligible(v12) then
						local v14 = nil

						for i, tile in ipairs(tiles) do
							if tile.id == current5 then
								v14 = i
								break
							end
						end

						publishIndex(v14)
					else
						ref3.current = nil

						if ref4.current == nil then
							return
						end

						ref4.current = nil

						setState({})
					end
				elseif current4.idleSequenceEnabled == true then
					local tiles = current4.tiles or {}
					local v12 = {
						direction = current4.direction or Enum.TextDirection.LeftToRight,
						reducedMotion = current4.reducedMotion == true,
						interacting = false,
						loopsRemaining = 0,
						canvasX = 0,
						containerWidth = 0,
						tileWidth = 0,
						gap = 0
					}
					local loopsRemainingStore = ref6.current.loopsRemainingStore
					local v13 = if loopsRemainingStore == nil then ref2.current else loopsRemainingStore.getLoopsRemaining(false)

					v12.loopsRemaining = v13
					v12.canvasX = canvasX
					v12.containerWidth = current4.containerWidth
					v12.tileWidth = current4.tileWidth
					v12.gap = current4.columnGap
					local v14

					if p6 then
						v14 = marqueeEligibility.resolveActiveTileId(tiles, v12, ref3.current)
					else
						v14 = marqueeEligibility.leadingEligible(tiles, v12)
					end

					ref3.current = v14
					local v15

					if v14 ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == v14 then
								v15 = i
								break
							end
						end
					end

					publishIndex(v15)
				else
					ref3.current = nil

					if ref4.current == nil then
						return
					end

					ref4.current = nil

					setState({})
				end
			end

			local function startHeartbeat()
				if connection then
					return
				end

				connection = v8:Connect(function(p6)
					local canvasX = ref.current.canvasX

					if canvasX == nil then
						return
					end

					ref8.current = math.max(0, ref8.current - math.max(p6, 0))
					apply(canvasX, p6)
				end)
			end

			apply = function(p6, p7, p8, p9)
				local current4 = ref.current
				local advance = scrollPause.advance
				local current5 = v11.current
				local v12 = verticalPage()

				local v13 = if v12 ~= nil then v12.CanvasPosition.Y else nil

				local v14 = advance(current4, p6, p7, current5, v13)
				ref.current = v14

				if v14.interacting then
					setState2(true)
					startHeartbeat()
				elseif rowIsVerticallyEligible() then
					ref8.current = 0

					if connection then
						connection:Disconnect()
						connection = nil
					end

					if current4.interacting or p8 or ref4.current == nil then
						setState2(false)
						publish(p6, p9 == true and not current4.interacting)
					end
				else
					setState2(false)
					ref3.current = nil

					if ref4.current ~= nil then
						ref4.current = nil

						setState({})
					end

					if ref8.current > 0 then
						startHeartbeat()
					elseif connection then
						connection:Disconnect()
						connection = nil
					end
				end
			end

			local function onInputBegan(p6)
				if not scrollPause.isPointerHold(p6.UserInputType) then
					return
				end

				local v12 = verticalPage()
				local absolutePosition = if v12 == nil then current2.AbsolutePosition else v12.AbsolutePosition
				local v13 = if v12 == nil then current2.AbsoluteSize else v12.AbsoluteSize

				if not scrollPause.pointerIsInside(
					absolutePosition,
					v13,
					Vector2.new(p6.Position.X, p6.Position.Y)
				) then
					return
				end

				current3[p6] = true
				v11.current = true
				apply(current2.CanvasPosition.X, 0)
			end

			local function releaseHold(p6)
				if p6 == nil then
					table.clear(current3)
				elseif current3[p6] == nil then
					return
				else
					current3[p6] = nil
				end

				v11.current = next(current3) ~= nil
				apply(current2.CanvasPosition.X, 0)
			end

			local function onCanvasPositionChanged()
				apply(current2.CanvasPosition.X, 0)
			end

			function ref7.current()
				ref8.current = 1
				apply(current2.CanvasPosition.X, 0, true)
			end
			local current4 = ref6.current

			if current4.idleSequenceEnabled == true then
				local reconcilePresence = marqueeEligibility.reconcilePresence
				local loopsRemainingStore = ref6.current.loopsRemainingStore
				local v12 = if loopsRemainingStore == nil then ref2.current else loopsRemainingStore.getLoopsRemaining(false)

				reconcilePresence(v12, current4.tiles or {})
			end

			apply(current2.CanvasPosition.X, 0, true, true)

			if ref.current.interacting then
				startHeartbeat()
			end

			local v12 = nil
			local canvasPositionChangedConnection = nil
			local connections = {}

			local function bindVerticalScroller()
				local v13 = verticalPage()

				if v13 == v12 then
					return
				end

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
					canvasPositionChangedConnection = nil
				end

				v12 = v13

				if v13 ~= nil then
					canvasPositionChangedConnection = v13:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
				end
			end

			local v13 = verticalPage()

			if v13 ~= v12 then
				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
					canvasPositionChangedConnection = nil
				end

				v12 = v13

				if v13 ~= nil then
					canvasPositionChangedConnection = v13:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
				end
			end

			local parent = current2.Parent

			while parent ~= nil do
				if parent:IsA("ScrollingFrame") then
					table.insert(
						connections,
						parent:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
							local v14 = v12
							local v15 = verticalPage()

							if v15 ~= v12 then
								if canvasPositionChangedConnection then
									canvasPositionChangedConnection:Disconnect()
									canvasPositionChangedConnection = nil
								end

								v12 = v15

								if v15 ~= nil then
									canvasPositionChangedConnection = v15:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
								end
							end

							if v12 ~= v14 then
								apply(current2.CanvasPosition.X, 0)
							end
						end)
					)
				end

				parent = parent.Parent
			end

			local canvasPositionChangedConnection2 = current2:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
			local inputBeganConnection = v9.InputBegan:Connect(onInputBegan)
			local inputEndedConnection = v9.InputEnded:Connect(function(input)
				if input == nil then
					table.clear(current3)
				elseif current3[input] == nil then
					return
				else
					current3[input] = nil
				end

				v11.current = next(current3) ~= nil
				apply(current2.CanvasPosition.X, 0)
			end)
			local windowFocusReleasedConnection

			if v9.WindowFocusReleased then
				windowFocusReleasedConnection = v9.WindowFocusReleased:Connect(function()
					table.clear(current3)

					v11.current = next(current3) ~= nil
					apply(current2.CanvasPosition.X, 0)
				end)
			else
				windowFocusReleasedConnection = nil
			end

			return function()
				function ref7.current() end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				canvasPositionChangedConnection2:Disconnect()

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
				end

				for k, connection2 in connections do
					connection2:Disconnect()
				end

				inputBeganConnection:Disconnect()
				inputEndedConnection:Disconnect()

				if windowFocusReleasedConnection then
					windowFocusReleasedConnection:Disconnect()
				end
			end
		end, {
			p2,
			p3,
			p4,
			p5,
			current.tileCount,
			current.containerWidth,
			current.tileWidth,
			current.columnGap,
			current.tiles,
			current.direction,
			current.reducedMotion,
			current.idleSequenceEnabled,
			current.manualMarqueeEnabled,
			current.loopsRemainingStore
		})

		React.useEffect(function()
			local loopsRemainingStore = current.loopsRemainingStore
			local getHomeFocusVersion = if loopsRemainingStore ~= nil then loopsRemainingStore.getHomeFocusVersion else nil

			if getHomeFocusVersion == nil then
				return
			end

			local v8 = nil
			return Signals.createEffect(function(p6)
				local homeFocusVersion = getHomeFocusVersion(p6)

				if v8 == homeFocusVersion then
					return
				end

				local v9 = v8 == nil
				v8 = homeFocusVersion

				if v9 then
					return
				end

				ref7.current()
			end)
		end, { current.loopsRemainingStore })

		return {
			activeByIndex = state,
			isPaused = state2,
			loopsRemainingRef = ref2,
			onMarqueeFinished = v5,
			onManualMarqueeStart = v6,
			onManualMarqueeEnd = v7,
			marqueeRunId = state3
		}
	end
}
