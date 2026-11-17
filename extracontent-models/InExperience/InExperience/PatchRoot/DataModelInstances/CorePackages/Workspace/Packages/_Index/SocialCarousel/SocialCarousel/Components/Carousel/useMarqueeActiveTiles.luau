local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

local marqueeEligibility = require(script.Parent.marqueeEligibility)
local scrollPause = require(script.Parent.scrollPause)
local tileVisibility = require(script.Parent.tileVisibility)
local Enums = require(SocialCarousel.Common.Enums)

local function defaultPointerPosition() -- 1 equivalent call inferred from this helper
	return UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
end

local function tileIdUnderPointer(vector2: Vector2, callback)
	for _, parent2 in ipairs(callback(vector2.X, vector2.Y)) do
		while parent2 ~= nil do
			local attribute = parent2:GetAttribute(Enums.MarqueeFriendIdAttribute)

			if typeof(attribute) == "string" then
				return attribute
			end

			parent2 = parent2.Parent
		end
	end

	return nil
end

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

local function indexOfTileId(tiles, current: string) -- 4 equivalent calls inferred from this helper
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
	useMarqueeActiveTiles = function(p, current, p2, p3, callback, callback2)
		local v

		if not (current.restoredTileId == nil or current.tiles == nil) then
			local tiles = current.tiles
			local restoredTileId = current.restoredTileId

			for i, tile in ipairs(tiles) do
				if tile.id == restoredTileId then
					v = i
					break
				end
			end
		end

		local state, setState = React.useState(v == nil and {} or { [v] = true })

		local state2, setState2 = React.useState(v ~= nil)
		local ref = React.useRef(scrollPause.initialState())

		local ref2 = React.useRef({})

		if current.loopsRemainingStore ~= nil then
			ref2.current = current.loopsRemainingStore.getLoopsRemaining(false)
		end

		local ref3 = React.useRef(current.restoredTileId)

		local ref4 = React.useRef(v)
		local state3, setState3 = React.useState(0)
		local ref5 = React.useRef(0)
		local ref6 = React.useRef(current)
		ref6.current = current

		local ref7 = React.useRef(function() end)

		local ref8 = React.useRef(current.restoredTileId == nil and 0 or 1)

		local ref9 = React.useRef(current.restoredTileId ~= nil)

		local ref10 = React.useRef(current.restoredTileId ~= nil)

		local ref11 = React.useRef(nil)

		local ref12 = React.useRef(false)

		local function refUserId(p4) -- 2 equivalent calls inferred from this helper
			return if p4 ~= nil then p4.current else nil
		end

		local function joinCardUserId(data) -- 1 equivalent call inferred from this helper
			if data.joinPopoverUserId ~= nil then
				return data.joinPopoverUserId
			end

			local selected = refUserId(data.joinSheetUserIdRef) -- inferred equivalent call

			if selected ~= nil then
				return selected
			end

			return refUserId(data.joinPopoverUserIdRef) -- inferred equivalent call
		end

		local function joinCardIsOpen(data): boolean -- 3 equivalent calls inferred from this helper
			return data.homeBlurredOrJoinCardOpen == true or joinCardUserId(data) ~= nil -- inferred equivalent call
		end

		local function cardHoldsTile(current2, current3: string): boolean -- 2 equivalent calls inferred from this helper
			if not joinCardIsOpen(current2) then -- inferred equivalent call
				return false
			end

			local v2

			if current2.joinPopoverUserId == nil then
				local joinSheetUserIdRef = current2.joinSheetUserIdRef

				if joinSheetUserIdRef ~= nil then
					v2 = joinSheetUserIdRef.current
				end

				if v2 == nil then
					local joinPopoverUserIdRef = current2.joinPopoverUserIdRef

					if joinPopoverUserIdRef == nil then
						v2 = nil
					else
						v2 = joinPopoverUserIdRef.current
					end
				end
			else
				v2 = current2.joinPopoverUserId
			end

			return v2 == nil or v2 == current3
		end

		local function loopsRemainingMap() -- 5 equivalent calls inferred from this helper
			local loopsRemainingStore = ref6.current.loopsRemainingStore

			if loopsRemainingStore == nil then
				return ref2.current
			end

			return loopsRemainingStore.getLoopsRemaining(false)
		end

		local function publishIndex(current2: number?) -- 1 equivalent call inferred from this helper
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

		local function clearActiveTile() -- 8 equivalent calls inferred from this helper
			ref3.current = nil
			publishIndex(nil) -- inferred equivalent call
		end

		local onMarqueeFinished = React.useCallback(function(p4: string)
			ref10.current = false
			local current2 = ref6.current

			if current2.idleSequenceEnabled ~= true then
				return
			end

			local tiles = current2.tiles or {}
			local v2 = lastLocationFor(tiles, p4)

			if v2 == nil then
				return
			end

			marqueeEligibility.recordFinishedLoop(loopsRemainingMap(), p4, v2) -- inferred equivalent call

			local v3 = {
				direction = current2.direction or Enum.TextDirection.LeftToRight,
				reducedMotion = current2.reducedMotion == true,
				interacting = false,
				loopsRemaining = loopsRemainingMap(), -- inferred equivalent call
				canvasX = ref.current.canvasX or 0,
				containerWidth = current2.containerWidth,
				tileWidth = current2.tileWidth,
				gap = current2.columnGap
			}

			local current3 = marqueeEligibility.resolveActiveTileId(tiles, v3, p4)

			if current3 ~= p4 then
				current3 = marqueeEligibility.nextEligibleAfter(tiles, p4, v3)
			end

			ref3.current = current3
			local v4

			if current3 ~= nil then
				for i, tile in ipairs(tiles) do
					if tile.id == current3 then
						v4 = i
						break
					end
				end
			end

			publishIndex(v4)

			if current3 == nil then
				return
			end

			local v5 = lastLocationFor(tiles, current3)

			if v5 == nil then
				return
			end

			local v6 = loopsRemainingMap()[marqueeEligibility.loopKey(current3, v5)] -- inferred equivalent call

			if v6 ~= nil and v6 < marqueeEligibility.DEFAULT_LOOPS then
				ref5.current += 1
				setState3(ref5.current)
			end
		end, {})

		local function tileById(tiles, p4: string) -- 2 equivalent calls inferred from this helper
			for _, item in ipairs(tiles) do
				if item.id == p4 then
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

			ref11.current = nil

			if ref3.current == current2 and ref4.current ~= nil then
				return
			end

			ref3.current = current2
			publishIndex(indexOfTileId(tiles, current2)) -- inferred equivalent call

			ref5.current += 1
			setState3(ref5.current)
		end, {})

		local onManualMarqueeEnd = React.useCallback(function(current2: string)
			local current3 = ref6.current

			if joinCardIsOpen(current3) then -- inferred equivalent call
				if ref3.current == current2 then
					ref11.current = current2
				end
			else
				if not (current3.manualMarqueeEnabled == true and ref3.current == current2) then
					return
				end

				clearActiveTile() -- inferred equivalent call
			end
		end, {})

		local ref13 = React.useRef({})

		React.useEffect(function()
			if current.marqueeEnabled == false then
				return
			end

			local current2 = p.current

			if current2 == nil then
				return
			end

			local v2 = p2 or RunService.Heartbeat
			local v3 = p3 or UserInputService
			local v4 = callback or function(p4: number, p5: number)
				local basePlayerGui = current2:FindFirstAncestorWhichIsA("BasePlayerGui")

				if basePlayerGui == nil then
					return {}
				end

				return basePlayerGui:GetGuiObjectsAtPosition(p4, p5)
			end

			local connection = nil
			local current3 = ref13.current
			local v5 = {
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
				local v6 = nil
				local v7 = 0

				while parent2 ~= nil do
					if parent2:IsA("ScrollingFrame") then
						local v8 = scrollRange(parent2) -- inferred equivalent call

						if v7 < v8 then
							v7 = v8
							v6 = parent2
						end
					end

					parent2 = parent2.Parent
				end

				return v6
			end

			local function verticalCanvasY() -- 1 equivalent call inferred from this helper
				local v6 = verticalPage()

				if v6 == nil then
					return nil
				end

				return v6.CanvasPosition.Y
			end

			local function rowIsInsidePage() -- 1 equivalent call inferred from this helper
				local v6 = verticalPage()

				if v6 == nil then
					return true
				end

				return tileVisibility.isAtLeast70PercentVerticallyVisible(
					current2.AbsolutePosition.Y,
					current2.AbsoluteSize.Y,
					v6.AbsolutePosition.Y,
					v6.AbsoluteSize.Y
				)
			end

			local function rowIsVerticallyEligible(): boolean
				if not rowIsInsidePage() then -- inferred equivalent call
					return false
				end

				local v6 = verticalPage()

				if v6 == nil then
					return true
				end

				local y = current2.AbsolutePosition.Y
				local y2 = current2.AbsoluteSize.Y
				local y3 = v6.AbsolutePosition.Y
				local y4 = v6.AbsoluteSize.Y

				local v7 = current2.AbsolutePosition.X + current2.AbsoluteSize.X / 2
				local count = 0

				for i = 1, 20 do
					local v8 = y + (i - 0.5) * y2 / 20
					local v9

					if y3 <= v8 then
						v9 = v8 <= y3 + y4
					else
						v9 = false
					end

					if not v9 or isCoveredAt(current2, v4, v7, v8) then
						continue
					end

					count += 1
				end

				return count / 20 >= tileVisibility.MIN_VISIBLE_FRACTION
			end

			local function publish(canvasX: number, flag: boolean?)
				local current4 = ref6.current
				local current6 = joinCardIsOpen(current4) -- inferred equivalent call
				local v6 = ref12.current and not current6
				ref12.current = current6
				local restoredTileId = current4.restoredTileId

				if ref10.current and restoredTileId ~= nil then
					local tiles = current4.tiles or {}
					local item = tileById(tiles, restoredTileId) -- inferred equivalent call
					local v7

					if item ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == restoredTileId then
								v7 = i
								break
							end
						end
					end

					if v7 == nil or not marqueeEligibility.isHoverEligible(item) then
						ref10.current = false
					else
						ref3.current = restoredTileId

						if current4.homeBlurredOrJoinCardOpen == true then
							setState2(true)
						end

						publishIndex(v7)
						return
					end
				end

				if current4.manualMarqueeEnabled == true then
					if v6 then
						ref11.current = nil

						if current4.isDesktop == true then
							local v7

							if callback2 == nil then
								v7 = defaultPointerPosition() -- inferred equivalent call
							else
								v7 = callback2()
							end

							local v8 = tileIdUnderPointer(v7, v4)

							if v8 == nil then
								clearActiveTile() -- inferred equivalent call
							else
								onManualMarqueeStart(v8)

								if ref3.current ~= v8 then
									clearActiveTile() -- inferred equivalent call
								end
							end

							return
						end
					end

					local tiles = current4.tiles or {}
					local current5 = ref3.current
					local v7

					if current5 ~= nil then
						for _, tile in ipairs(tiles) do
							if tile.id == current5 then
								v7 = tile
								break
							end
						end
					end

					if v7 == nil or current4.reducedMotion == true then
						clearActiveTile() -- inferred equivalent call
					elseif marqueeEligibility.isHoverEligible(v7) then
						publishIndex(indexOfTileId(tiles, current5)) -- inferred equivalent call
					else
						clearActiveTile() -- inferred equivalent call
					end
				elseif current4.idleSequenceEnabled == true then
					local tiles = current4.tiles or {}
					local v7 = {
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
						current5 = marqueeEligibility.resolveActiveTileId(tiles, v7, ref3.current)
					else
						current5 = marqueeEligibility.leadingEligible(tiles, v7)
					end

					ref3.current = current5
					local v8

					if current5 ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == current5 then
								v8 = i
								break
							end
						end
					end

					publishIndex(v8)
				else
					local current5 = ref3.current

					if current5 ~= nil and cardHoldsTile(current4, current5) then -- inferred equivalent call
						local current7 = indexOfTileId(current4.tiles or {}, current5) -- inferred equivalent call

						if current7 ~= nil then
							publishIndex(current7)
							return
						end
					end

					ref11.current = nil
					setState2(false)
					clearActiveTile() -- inferred equivalent call
				end
			end

			local function startHeartbeat()
				if connection then
					return
				end

				connection = v2:Connect(function(p4: number)
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
				local current5 = scrollPause.advance(current4, canvasX, p4, v5.current, verticalCanvasY()) -- inferred equivalent call
				ref.current = current5

				if current5.interacting then
					setState2(true)
					startHeartbeat()
				elseif rowIsVerticallyEligible() then
					local v6 = ref9.current
					ref9.current = false
					ref8.current = 0
					stopHeartbeat() -- inferred equivalent call

					if current4.interacting or flag or ref4.current == nil or v6 then
						if current4.interacting then
							ref10.current = false
						end

						setState2(false)

						if flag2 == true or v6 then
							v6 = not current4.interacting
						end

						publish(canvasX, v6)
					end
				else
					local current6 = ref3.current

					if current6 == nil then
						ref9.current = false
						setState2(false)
						clearActiveTile() -- inferred equivalent call
					elseif cardHoldsTile(ref6.current, current6) or ref8.current > 0 then -- inferred equivalent call
						ref9.current = true
						setState2(true)
						publishIndex(indexOfTileId(ref6.current.tiles or {}, current6)) -- inferred equivalent call
					else
						ref9.current = false
						setState2(false)
						clearActiveTile() -- inferred equivalent call
					end

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

				local v6 = verticalPage()
				local absolutePosition

				if v6 == nil then
					absolutePosition = current2.AbsolutePosition
				else
					absolutePosition = v6.AbsolutePosition
				end

				local v7

				if v6 == nil then
					v7 = current2.AbsoluteSize
				else
					v7 = v6.AbsoluteSize
				end

				if not scrollPause.pointerIsInside(absolutePosition, v7, Vector2.new(p4.Position.X, p4.Position.Y)) then
					return
				end

				current3[p4] = true
				v5.current = true
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

				v5.current = next(current3) ~= nil
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

			local v6 = nil
			local canvasPositionChangedConnection = nil
			local connections = {}

			local function bindVerticalScroller() -- 2 equivalent calls inferred from this helper
				local v7 = verticalPage()

				if v7 == v6 then
					return
				end

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
					canvasPositionChangedConnection = nil
				end

				v6 = v7

				if v7 ~= nil then
					canvasPositionChangedConnection = v7:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
				end
			end

			bindVerticalScroller() -- inferred equivalent call
			local parent2 = current2.Parent

			while parent2 ~= nil do
				if parent2:IsA("ScrollingFrame") then
					table.insert(connections, parent2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
						local v7 = v6
						bindVerticalScroller() -- inferred equivalent call

						if v6 ~= v7 then
							apply(current2.CanvasPosition.X, 0)
						end
					end))
				end

				parent2 = parent2.Parent
			end

			local canvasPositionChangedConnection2 = current2:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
			local inputBeganConnection = v3.InputBegan:Connect(onInputBegan)
			local inputEndedConnection = v3.InputEnded:Connect(function(input)
				if input == nil then
					table.clear(current3)
				elseif current3[input] == nil then
					return
				else
					current3[input] = nil
				end

				v5.current = next(current3) ~= nil
				apply(current2.CanvasPosition.X, 0)
			end)
			local windowFocusReleasedConnection

			if v3.WindowFocusReleased then
				windowFocusReleasedConnection = v3.WindowFocusReleased:Connect(function()
					table.clear(current3)

					v5.current = next(current3) ~= nil
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
			callback2,
			current.tileCount,
			current.containerWidth,
			current.tileWidth,
			current.columnGap,
			current.tiles,
			current.direction,
			current.reducedMotion,
			current.idleSequenceEnabled,
			current.manualMarqueeEnabled,
			current.joinPopoverUserId,
			current.loopsRemainingStore,
			current.marqueeEnabled
		})

		React.useEffect(function()
			if current.marqueeEnabled == false then
				return
			end

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

			local v2 = nil
			return Signals.createEffect(function(p4)
				local homeFocusVersion = getHomeFocusVersion(p4)

				if v2 == homeFocusVersion then
					return
				end

				local v3 = v2 == nil
				v2 = homeFocusVersion

				if v3 then
					return
				end

				ref7.current()
			end)
		end, { current.loopsRemainingStore, current.marqueeEnabled })

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
