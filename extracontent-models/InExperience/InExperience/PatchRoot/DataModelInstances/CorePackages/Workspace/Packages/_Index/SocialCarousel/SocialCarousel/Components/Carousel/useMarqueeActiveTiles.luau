local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

local marqueeEligibility = require(script.Parent.marqueeEligibility)
local scrollPause = require(script.Parent.scrollPause)
local tileVisibility = require(script.Parent.tileVisibility)

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

local function isCoveredAt(current, callback, p: number, p2: number): boolean
	for _, v in callback(p, p2) do
		if v == current or v:IsDescendantOf(current) then
			return false
		end

		if not current:IsDescendantOf(v) and drawsOnTop(v) then
			return true
		end
	end

	return false
end

local function indexOfTileId(tiles, current: string) -- 2 equivalent calls inferred from this helper
	for i, item in ipairs(tiles) do
		if item.id == current then
			return i
		end
	end

	return nil
end

local function lastLocationFor(tiles, p: string)
	for _, item in ipairs(tiles) do
		if item.id == p then
			local presence = item.presence
			local lastLocation

			if presence ~= nil then
				lastLocation = presence.lastLocation
			end

			if lastLocation == nil or lastLocation == "" then
				return nil
			end

			return lastLocation
		end
	end

	return nil
end

return {
	useMarqueeActiveTiles = function(p, current, p2, p3, callback)
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

		local function loopsRemainingMap() -- 5 equivalent calls inferred from this helper
			local loopsRemainingStore = ref6.current.loopsRemainingStore

			if loopsRemainingStore == nil then
				return ref2.current
			end

			return loopsRemainingStore.getLoopsRemaining(false)
		end

		local function publishIndex(current2: number?) -- 5 equivalent calls inferred from this helper
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

		local onMarqueeFinished = React.useCallback(function(p4: string)
			local current2 = ref6.current

			if current2.idleSequenceEnabled ~= true then
				return
			end

			local tiles = current2.tiles or {}
			local v = lastLocationFor(tiles, p4)

			if v == nil then
				return
			end

			marqueeEligibility.recordFinishedLoop(loopsRemainingMap(), p4, v) -- inferred equivalent call

			local v2 = {
				direction = current2.direction or Enum.TextDirection.LeftToRight,
				reducedMotion = current2.reducedMotion == true,
				interacting = false,
				loopsRemaining = loopsRemainingMap(), -- inferred equivalent call
				canvasX = ref.current.canvasX or 0,
				containerWidth = current2.containerWidth,
				tileWidth = current2.tileWidth,
				gap = current2.columnGap
			}

			local current3 = marqueeEligibility.resolveActiveTileId(tiles, v2, p4)

			if current3 ~= p4 then
				current3 = marqueeEligibility.nextEligibleAfter(tiles, p4, v2)
			end

			ref3.current = current3
			local v3

			if current3 ~= nil then
				for i, tile in ipairs(tiles) do
					if tile.id == current3 then
						v3 = i
						break
					end
				end
			end

			publishIndex(v3)

			if current3 == nil then
				return
			end

			local v4 = lastLocationFor(tiles, current3)

			if v4 == nil then
				return
			end

			local v5 = loopsRemainingMap()[marqueeEligibility.loopKey(current3, v4)] -- inferred equivalent call

			if v5 ~= nil and v5 < marqueeEligibility.DEFAULT_LOOPS then
				ref5.current += 1
				setState3(ref5.current)
			end
		end, {})

		local function tileById(tiles, current2: string) -- 1 equivalent call inferred from this helper
			for _, item in ipairs(tiles) do
				if item.id == current2 then
					return item
				end
			end

			return nil
		end

		local onManualMarqueeStart = React.useCallback(function(current2: string)
			local current3 = ref6.current

			if current3.manualMarqueeEnabled ~= true or current3.reducedMotion == true then
				return
			end

			local tiles = current3.tiles or {}
			local item = tileById(tiles, current2) -- inferred equivalent call

			if item == nil or not marqueeEligibility.isHoverEligible(item) then
				return
			end

			ref3.current = current2
			publishIndex(indexOfTileId(tiles, current2)) -- inferred equivalent call

			ref5.current += 1
			setState3(ref5.current)
		end, {})

		local onManualMarqueeEnd = React.useCallback(function(p4: string)
			if not (ref6.current.manualMarqueeEnabled == true and ref3.current == p4) then
				return
			end

			ref3.current = nil
			publishIndex(nil) -- inferred equivalent call
		end, {})

		local ref9 = React.useRef({})

		React.useEffect(function()
			local current2 = p.current

			if current2 == nil then
				return
			end

			local v = p2 or RunService.Heartbeat
			local v2 = p3 or UserInputService
			local v3 = callback or function(p4: number, p5: number)
				local basePlayerGui = current2:FindFirstAncestorWhichIsA("BasePlayerGui")

				if basePlayerGui == nil then
					return {}
				end

				return basePlayerGui:GetGuiObjectsAtPosition(p4, p5)
			end

			local connection = nil
			local current3 = ref9.current
			local v4 = {
				current = next(current3) ~= nil
			}

			local apply

			local function stopHeartbeat() -- 3 equivalent calls inferred from this helper
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end

			local function scrollRange(parent2) -- 1 equivalent call inferred from this helper
				return math.max(
					parent2.CanvasSize.Y.Offset + parent2.CanvasSize.Y.Scale * parent2.AbsoluteSize.Y,
					parent2.AbsoluteCanvasSize.Y
				) - parent2.AbsoluteSize.Y
			end

			local function verticalPage()
				local parent2 = current2.Parent
				local v5 = nil
				local v6 = 0

				while parent2 ~= nil do
					if parent2:IsA("ScrollingFrame") then
						local v7 = scrollRange(parent2) -- inferred equivalent call

						if v6 < v7 then
							v6 = v7
							v5 = parent2
						end
					end

					parent2 = parent2.Parent
				end

				return v5
			end

			local function verticalCanvasY() -- 1 equivalent call inferred from this helper
				local v5 = verticalPage()

				if v5 == nil then
					return nil
				end

				return v5.CanvasPosition.Y
			end

			local function rowIsVerticallyEligible(): boolean
				local v5 = verticalPage()

				if v5 == nil then
					return true
				end

				local y = current2.AbsolutePosition.Y
				local y2 = current2.AbsoluteSize.Y
				local y3 = v5.AbsolutePosition.Y
				local y4 = v5.AbsoluteSize.Y

				if not tileVisibility.isAtLeast70PercentVerticallyVisible(y, y2, y3, y4) then
					return false
				end

				local v6 = current2.AbsolutePosition.X + current2.AbsoluteSize.X / 2
				local count = 0

				for i = 1, 20 do
					local v7 = y + (i - 0.5) * y2 / 20
					local v8

					if y3 <= v7 then
						v8 = v7 <= y3 + y4
					else
						v8 = false
					end

					if not v8 or isCoveredAt(current2, v3, v6, v7) then
						continue
					end

					count += 1
				end

				return count / 20 >= tileVisibility.MIN_VISIBLE_FRACTION
			end

			local function publish(canvasX: number, flag: boolean?)
				local current4 = ref6.current

				if current4.manualMarqueeEnabled == true then
					local tiles = current4.tiles or {}
					local current5 = ref3.current
					local v5

					if current5 ~= nil then
						for _, tile in ipairs(tiles) do
							if tile.id == current5 then
								v5 = tile
								break
							end
						end
					end

					if v5 == nil or current4.reducedMotion == true then
						ref3.current = nil
						publishIndex(nil) -- inferred equivalent call
					elseif marqueeEligibility.isHoverEligible(v5) then
						publishIndex(indexOfTileId(tiles, current5)) -- inferred equivalent call
					else
						ref3.current = nil
						publishIndex(nil) -- inferred equivalent call
					end
				elseif current4.idleSequenceEnabled == true then
					local tiles = current4.tiles or {}
					local v5 = {
						direction = current4.direction or Enum.TextDirection.LeftToRight,
						reducedMotion = current4.reducedMotion == true,
						interacting = false,
						loopsRemaining = loopsRemainingMap(), -- inferred equivalent call
						canvasX = canvasX,
						containerWidth = current4.containerWidth,
						tileWidth = current4.tileWidth,
						gap = current4.columnGap
					}
					local current5

					if flag then
						current5 = marqueeEligibility.resolveActiveTileId(tiles, v5, ref3.current)
					else
						current5 = marqueeEligibility.leadingEligible(tiles, v5)
					end

					ref3.current = current5
					local v6

					if current5 ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == current5 then
								v6 = i
								break
							end
						end
					end

					publishIndex(v6)
				else
					ref3.current = nil
					publishIndex(nil) -- inferred equivalent call
				end
			end

			local function startHeartbeat()
				if connection then
					return
				end

				connection = v:Connect(function(p4: number)
					local canvasX = ref.current.canvasX

					if canvasX == nil then
						return
					end

					ref8.current = math.max(0, ref8.current - math.max(p4, 0))
					apply(canvasX, p4)
				end)
			end

			apply = function(canvasX: number, p4: number, flag: boolean?, flag2: boolean?)
				local current4 = ref.current
				local current5 = scrollPause.advance(current4, canvasX, p4, v4.current, verticalCanvasY()) -- inferred equivalent call
				ref.current = current5

				if current5.interacting then
					setState2(true)
					startHeartbeat()
				elseif rowIsVerticallyEligible() then
					ref8.current = 0
					stopHeartbeat() -- inferred equivalent call

					if current4.interacting or flag or ref4.current == nil then
						setState2(false)
						publish(canvasX, flag2 == true and not current4.interacting)
					end
				else
					setState2(false)
					ref3.current = nil
					publishIndex(nil) -- inferred equivalent call

					if ref8.current > 0 then
						startHeartbeat()
						return
					end

					stopHeartbeat() -- inferred equivalent call
				end
			end

			local function onInputBegan(p4)
				if not scrollPause.isPointerHold(p4.UserInputType) then
					return
				end

				local v5 = verticalPage()
				local absolutePosition

				if v5 == nil then
					absolutePosition = current2.AbsolutePosition
				else
					absolutePosition = v5.AbsolutePosition
				end

				local v6

				if v5 == nil then
					v6 = current2.AbsoluteSize
				else
					v6 = v5.AbsoluteSize
				end

				if not scrollPause.pointerIsInside(absolutePosition, v6, Vector2.new(p4.Position.X, p4.Position.Y)) then
					return
				end

				current3[p4] = true
				v4.current = true
				apply(current2.CanvasPosition.X, 0)
			end

			local function releaseHold(p4)
				if p4 == nil then
					table.clear(current3)
				elseif current3[p4] == nil then
					return
				else
					current3[p4] = nil
				end

				v4.current = next(current3) ~= nil
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
				marqueeEligibility.reconcilePresence(loopsRemainingMap(), current4.tiles or {}) -- inferred equivalent call
			end

			apply(current2.CanvasPosition.X, 0, true, true)

			if ref.current.interacting then
				startHeartbeat()
			end

			local v5 = nil
			local canvasPositionChangedConnection = nil
			local connections = {}

			local function bindVerticalScroller() -- 2 equivalent calls inferred from this helper
				local v6 = verticalPage()

				if v6 == v5 then
					return
				end

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
					canvasPositionChangedConnection = nil
				end

				v5 = v6

				if v6 ~= nil then
					canvasPositionChangedConnection = v6:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
				end
			end

			bindVerticalScroller() -- inferred equivalent call
			local parent2 = current2.Parent

			while parent2 ~= nil do
				if parent2:IsA("ScrollingFrame") then
					table.insert(connections, parent2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
						local v6 = v5
						bindVerticalScroller() -- inferred equivalent call

						if v5 ~= v6 then
							apply(current2.CanvasPosition.X, 0)
						end
					end))
				end

				parent2 = parent2.Parent
			end

			local canvasPositionChangedConnection2 = current2:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
			local inputBeganConnection = v2.InputBegan:Connect(onInputBegan)
			local inputEndedConnection = v2.InputEnded:Connect(function(input)
				if input == nil then
					table.clear(current3)
				elseif current3[input] == nil then
					return
				else
					current3[input] = nil
				end

				v4.current = next(current3) ~= nil
				apply(current2.CanvasPosition.X, 0)
			end)
			local windowFocusReleasedConnection

			if v2.WindowFocusReleased then
				windowFocusReleasedConnection = v2.WindowFocusReleased:Connect(function()
					table.clear(current3)

					v4.current = next(current3) ~= nil
					apply(current2.CanvasPosition.X, 0)
				end)
			else
				windowFocusReleasedConnection = nil
			end

			return function()
				function ref7.current() end

				stopHeartbeat() -- inferred equivalent call
				canvasPositionChangedConnection2:Disconnect()

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
				end

				for _, connection2 in connections do
					connection2:Disconnect()
				end

				inputBeganConnection:Disconnect()
				inputEndedConnection:Disconnect()

				if windowFocusReleasedConnection then
					windowFocusReleasedConnection:Disconnect()
				end
			end
		end, {
			p,
			p2,
			p3,
			callback,
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
			local getHomeFocusVersion

			if loopsRemainingStore == nil then
				getHomeFocusVersion = nil
			else
				getHomeFocusVersion = loopsRemainingStore.getHomeFocusVersion
			end

			if getHomeFocusVersion == nil then
				return
			end

			local v = nil
			return Signals.createEffect(function(p4)
				local homeFocusVersion = getHomeFocusVersion(p4)

				if v == homeFocusVersion then
					return
				end

				local v2 = v == nil
				v = homeFocusVersion

				if v2 then
					return
				end

				ref7.current()
			end)
		end, { current.loopsRemainingStore })

		return {
			activeByIndex = state,
			isPaused = state2,
			loopsRemainingRef = ref2,
			onMarqueeFinished = onMarqueeFinished,
			onManualMarqueeStart = onManualMarqueeStart,
			onManualMarqueeEnd = onManualMarqueeEnd,
			marqueeRunId = state3
		}
	end
}
