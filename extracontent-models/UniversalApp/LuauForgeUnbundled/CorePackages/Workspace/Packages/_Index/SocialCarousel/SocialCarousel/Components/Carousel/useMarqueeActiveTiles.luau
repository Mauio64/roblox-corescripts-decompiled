local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Signals")

local marqueeEligibility = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/marqueeEligibility")
local scrollPause = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/scrollPause")
local tileVisibility = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/tileVisibility")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums")

local function defaultPointerPosition()
	return UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
end

local function tileIdUnderPointer(p2, callback)
	for i, parent in ipairs(callback(p2.X, p2.Y)) do
		while parent ~= nil do
			local attribute = parent:GetAttribute(Enums.MarqueeFriendIdAttribute)

			if typeof(attribute) == "string" then
				return attribute
			end

			parent = parent.Parent
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
	useMarqueeActiveTiles = function(p2, current, p3, p4, p5, callback)
		local v5

		if not (current.restoredTileId == nil or current.tiles == nil) then
			local tiles = current.tiles
			local restoredTileId = current.restoredTileId

			for i, tile in ipairs(tiles) do
				if tile.id == restoredTileId then
					v5 = i
					break
				end
			end
		end

		local state, setState = React.useState(v5 == nil and {} or { [v5] = true })

		local state2, setState2 = React.useState(v5 ~= nil)
		local ref = React.useRef(scrollPause.initialState())

		local ref2 = React.useRef({})

		if current.loopsRemainingStore ~= nil then
			ref2.current = current.loopsRemainingStore.getLoopsRemaining(false)
		end

		local ref3 = React.useRef(current.restoredTileId)

		local ref4 = React.useRef(v5)
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

		local function refUserId(p6)
			if p6 == nil then
				return nil
			end

			return p6.current
		end

		local function joinCardUserId(data)
			if data.joinPopoverUserId ~= nil then
				return data.joinPopoverUserId
			end

			local joinSheetUserIdRef = data.joinSheetUserIdRef
			local current2 = if joinSheetUserIdRef ~= nil then joinSheetUserIdRef.current else nil

			if current2 ~= nil then
				return current2
			end

			local joinPopoverUserIdRef = data.joinPopoverUserIdRef

			if joinPopoverUserIdRef == nil then
				return nil
			end

			return joinPopoverUserIdRef.current
		end

		local function joinCardIsOpen(data): boolean
			if data.homeBlurredOrJoinCardOpen == true then
				return true
			end

			local v6

			if data.joinPopoverUserId == nil then
				local joinSheetUserIdRef = data.joinSheetUserIdRef

				if joinSheetUserIdRef ~= nil then
					v6 = joinSheetUserIdRef.current
				end

				if v6 == nil then
					local joinPopoverUserIdRef = data.joinPopoverUserIdRef
					v6 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
				end
			else
				v6 = data.joinPopoverUserId
			end

			return v6 ~= nil
		end

		local function cardHoldsTile(data, p6): boolean
			local v6

			if data.homeBlurredOrJoinCardOpen == true then
				v6 = true
			else
				local v7

				if data.joinPopoverUserId == nil then
					local joinSheetUserIdRef = data.joinSheetUserIdRef

					if joinSheetUserIdRef ~= nil then
						v7 = joinSheetUserIdRef.current
					end

					if v7 == nil then
						local joinPopoverUserIdRef = data.joinPopoverUserIdRef
						v7 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
					end
				else
					v7 = data.joinPopoverUserId
				end

				v6 = v7 ~= nil
			end

			if not v6 then
				return false
			end

			local v7

			if data.joinPopoverUserId == nil then
				local joinSheetUserIdRef = data.joinSheetUserIdRef

				if joinSheetUserIdRef ~= nil then
					v7 = joinSheetUserIdRef.current
				end

				if v7 == nil then
					local joinPopoverUserIdRef = data.joinPopoverUserIdRef
					v7 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
				end
			else
				v7 = data.joinPopoverUserId
			end

			return v7 == nil or v7 == p6
		end

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

		local function clearActiveTile()
			ref3.current = nil

			if ref4.current == nil then
				return
			end

			ref4.current = nil

			setState({})
		end

		local v6 = React.useCallback(function(p6)
			ref10.current = false
			local current2 = ref6.current

			if current2.idleSequenceEnabled ~= true then
				return
			end

			local tiles = current2.tiles or {}
			local v7 = lastLocationFor(tiles, p6)

			if v7 == nil then
				return
			end

			local recordFinishedLoop = marqueeEligibility.recordFinishedLoop
			local loopsRemainingStore = ref6.current.loopsRemainingStore
			local v8 = if loopsRemainingStore == nil then ref2.current else loopsRemainingStore.getLoopsRemaining(false)

			recordFinishedLoop(v8, p6, v7)

			local v9 = {
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
			local v10 = if loopsRemainingStore2 == nil then ref2.current else loopsRemainingStore2.getLoopsRemaining(false)

			v9.loopsRemaining = v10
			v9.canvasX = ref.current.canvasX or 0
			v9.containerWidth = current2.containerWidth
			v9.tileWidth = current2.tileWidth
			v9.gap = current2.columnGap

			local v11 = marqueeEligibility.resolveActiveTileId(tiles, v9, p6)

			if v11 ~= p6 then
				v11 = marqueeEligibility.nextEligibleAfter(tiles, p6, v9)
			end

			ref3.current = v11
			local v13

			if v11 ~= nil then
				for i, tile in ipairs(tiles) do
					if tile.id == v11 then
						v13 = i
						break
					end
				end
			end

			publishIndex(v13)

			if v11 == nil then
				return
			end

			local v14 = lastLocationFor(tiles, v11)

			if v14 == nil then
				return
			end

			local loopsRemainingStore3 = ref6.current.loopsRemainingStore
			local v16 = (if loopsRemainingStore3 == nil then ref2.current else loopsRemainingStore3.getLoopsRemaining(false))[marqueeEligibility.loopKey(v11, v14)]

			if v16 ~= nil and v16 < marqueeEligibility.DEFAULT_LOOPS then
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

		local v7 = React.useCallback(function(current2)
			local current3 = ref6.current

			if current3.manualMarqueeEnabled ~= true or current3.reducedMotion == true then
				return
			end

			local tiles = current3.tiles or {}
			local v8 = nil

			for i, tile in ipairs(tiles) do
				if tile.id == current2 then
					v8 = tile
					break
				end
			end

			if v8 == nil or not marqueeEligibility.isHoverEligible(v8) then
				return
			end

			ref11.current = nil

			if ref3.current == current2 and ref4.current ~= nil then
				return
			end

			ref3.current = current2
			local v11 = nil

			for i, tile in ipairs(tiles) do
				if tile.id == current2 then
					v11 = i
					break
				end
			end

			publishIndex(v11)

			ref5.current += 1
			setState3(ref5.current)
		end, {})

		local v8 = React.useCallback(function(current2)
			local current3 = ref6.current
			local v9

			if current3.homeBlurredOrJoinCardOpen == true then
				v9 = true
			else
				local v10

				if current3.joinPopoverUserId == nil then
					local joinSheetUserIdRef = current3.joinSheetUserIdRef

					if joinSheetUserIdRef ~= nil then
						v10 = joinSheetUserIdRef.current
					end

					if v10 == nil then
						local joinPopoverUserIdRef = current3.joinPopoverUserIdRef
						v10 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
					end
				else
					v10 = current3.joinPopoverUserId
				end

				v9 = v10 ~= nil
			end

			if v9 then
				if ref3.current == current2 then
					ref11.current = current2
				end
			else
				if not (current3.manualMarqueeEnabled == true and ref3.current == current2) then
					return
				end

				ref3.current = nil

				if ref4.current == nil then
					return
				end

				ref4.current = nil

				setState({})
			end
		end, {})

		local ref13 = React.useRef({})

		React.useEffect(function()
			if current.marqueeEnabled == false then
				return
			end

			local current2 = p2.current

			if current2 == nil then
				return
			end

			local v9 = p3 or RunService.Heartbeat
			local v10 = p4 or UserInputService
			local v11 = p5 or function(p6, p7)
				local basePlayerGui = current2:FindFirstAncestorWhichIsA("BasePlayerGui")

				if basePlayerGui == nil then
					return {}
				end

				return basePlayerGui:GetGuiObjectsAtPosition(p6, p7)
			end

			local connection = nil
			local current3 = ref13.current
			local v12 = {
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
				local v13 = nil
				local v14 = 0

				while parent ~= nil do
					if parent:IsA("ScrollingFrame") then
						local v15 = math.max(
							parent.CanvasSize.Y.Offset + parent.CanvasSize.Y.Scale * parent.AbsoluteSize.Y,
							parent.AbsoluteCanvasSize.Y
						) - parent.AbsoluteSize.Y

						if v14 < v15 then
							v14 = v15
							v13 = parent
						end
					end

					parent = parent.Parent
				end

				return v13
			end

			local function verticalCanvasY()
				local v13 = verticalPage()

				if v13 == nil then
					return nil
				end

				return v13.CanvasPosition.Y
			end

			local function rowIsInsidePage()
				local v13 = verticalPage()

				if v13 == nil then
					return true
				end

				return tileVisibility.isAtLeast70PercentVerticallyVisible(
					current2.AbsolutePosition.Y,
					current2.AbsoluteSize.Y,
					v13.AbsolutePosition.Y,
					v13.AbsoluteSize.Y
				)
			end

			local function rowIsVerticallyEligible(): boolean
				local v13 = verticalPage()

				if
					v13 ~= nil
					and not tileVisibility.isAtLeast70PercentVerticallyVisible(
						current2.AbsolutePosition.Y,
						current2.AbsoluteSize.Y,
						v13.AbsolutePosition.Y,
						v13.AbsoluteSize.Y
					)
				then
					return false
				end

				local v14 = verticalPage()

				if v14 == nil then
					return true
				end

				local y = current2.AbsolutePosition.Y
				local y2 = current2.AbsoluteSize.Y
				local y3 = v14.AbsolutePosition.Y
				local y4 = v14.AbsoluteSize.Y

				local v15 = current2.AbsolutePosition.X + current2.AbsoluteSize.X / 2
				local count = 0

				for i = 1, 20 do
					local v16 = y + (i - 0.5) * y2 / 20
					local v17 = y3 <= v16 and v16 <= y3 + y4

					if not v17 or isCoveredAt(current2, v11, v15, v16) then
						continue
					end

					count += 1
				end

				return count / 20 >= tileVisibility.MIN_VISIBLE_FRACTION
			end

			local function publish(canvasX, p6)
				local current4 = ref6.current
				local v13

				if current4.homeBlurredOrJoinCardOpen == true then
					v13 = true
				else
					local v14

					if current4.joinPopoverUserId == nil then
						local joinSheetUserIdRef = current4.joinSheetUserIdRef

						if joinSheetUserIdRef ~= nil then
							v14 = joinSheetUserIdRef.current
						end

						if v14 == nil then
							local joinPopoverUserIdRef = current4.joinPopoverUserIdRef
							v14 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
						end
					else
						v14 = current4.joinPopoverUserId
					end

					v13 = v14 ~= nil
				end

				local v14 = ref12.current and not v13
				ref12.current = v13
				local restoredTileId = current4.restoredTileId

				if ref10.current and restoredTileId ~= nil then
					local tiles = current4.tiles or {}
					local v15 = nil

					for i, tile in ipairs(tiles) do
						if tile.id == restoredTileId then
							v15 = tile
							break
						end
					end

					local v17

					if v15 ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == restoredTileId then
								v17 = i
								break
							end
						end
					end

					if v17 == nil or not marqueeEligibility.isHoverEligible(v15) then
						ref10.current = false
					else
						ref3.current = restoredTileId

						if current4.homeBlurredOrJoinCardOpen == true then
							setState2(true)
						end

						publishIndex(v17)
						return
					end
				end

				if current4.manualMarqueeEnabled == true then
					if v14 then
						ref11.current = nil

						if current4.isDesktop == true then
							local v15

							if callback == nil then
								v15 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
							else
								v15 = callback()
							end

							local v16 = tileIdUnderPointer(v15, v11)

							if v16 == nil then
								ref3.current = nil

								if ref4.current == nil then
									return
								end

								ref4.current = nil

								setState({})
							else
								v7(v16)

								if ref3.current ~= v16 then
									ref3.current = nil

									if ref4.current == nil then
										return
									end

									ref4.current = nil

									setState({})
								end
							end

							return
						end
					end

					local tiles = current4.tiles or {}
					local current5 = ref3.current
					local v15

					if current5 ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == current5 then
								v15 = tile
								break
							end
						end
					end

					if v15 == nil or current4.reducedMotion == true then
						ref3.current = nil

						if ref4.current == nil then
							return
						end

						ref4.current = nil

						setState({})
					elseif marqueeEligibility.isHoverEligible(v15) then
						local v17 = nil

						for i, tile in ipairs(tiles) do
							if tile.id == current5 then
								v17 = i
								break
							end
						end

						publishIndex(v17)
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
					local v15 = {
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
					local v16 = if loopsRemainingStore == nil then ref2.current else loopsRemainingStore.getLoopsRemaining(false)

					v15.loopsRemaining = v16
					v15.canvasX = canvasX
					v15.containerWidth = current4.containerWidth
					v15.tileWidth = current4.tileWidth
					v15.gap = current4.columnGap
					local v17

					if p6 then
						v17 = marqueeEligibility.resolveActiveTileId(tiles, v15, ref3.current)
					else
						v17 = marqueeEligibility.leadingEligible(tiles, v15)
					end

					ref3.current = v17
					local v18

					if v17 ~= nil then
						for i, tile in ipairs(tiles) do
							if tile.id == v17 then
								v18 = i
								break
							end
						end
					end

					publishIndex(v18)
				else
					local current5 = ref3.current

					if current5 ~= nil then
						local v15

						if current4.homeBlurredOrJoinCardOpen == true then
							v15 = true
						else
							local v16

							if current4.joinPopoverUserId == nil then
								local joinSheetUserIdRef = current4.joinSheetUserIdRef

								if joinSheetUserIdRef ~= nil then
									v16 = joinSheetUserIdRef.current
								end

								if v16 == nil then
									local joinPopoverUserIdRef = current4.joinPopoverUserIdRef
									v16 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
								end
							else
								v16 = current4.joinPopoverUserId
							end

							v15 = v16 ~= nil
						end

						local v16

						if v15 then
							local v17

							if current4.joinPopoverUserId == nil then
								local joinSheetUserIdRef = current4.joinSheetUserIdRef

								if joinSheetUserIdRef ~= nil then
									v17 = joinSheetUserIdRef.current
								end

								if v17 == nil then
									local joinPopoverUserIdRef = current4.joinPopoverUserIdRef
									v17 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
								end
							else
								v17 = current4.joinPopoverUserId
							end

							v16 = v17 == nil or v17 == current5
						else
							v16 = false
						end

						if v16 then
							local tiles = current4.tiles or {}
							local v17 = nil

							for i, tile in ipairs(tiles) do
								if tile.id == current5 then
									v17 = i
									break
								end
							end

							if v17 ~= nil then
								publishIndex(v17)
								return
							end
						end
					end

					ref11.current = nil
					setState2(false)
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

				connection = v9:Connect(function(p6)
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
				local current5 = v12.current
				local v13 = verticalPage()

				local v14 = if v13 ~= nil then v13.CanvasPosition.Y else nil

				local v15 = advance(current4, p6, p7, current5, v14)
				ref.current = v15

				if v15.interacting then
					setState2(true)
					startHeartbeat()
				elseif rowIsVerticallyEligible() then
					local v16 = ref9.current
					ref9.current = false
					ref8.current = 0

					if connection then
						connection:Disconnect()
						connection = nil
					end

					if current4.interacting or p8 or ref4.current == nil or v16 then
						if current4.interacting then
							ref10.current = false
						end

						setState2(false)

						if p9 == true or v16 then
							v16 = not current4.interacting
						end

						publish(p6, v16)
					end
				else
					local current6 = ref3.current

					if current6 == nil then
						ref9.current = false
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
					else
						local current7 = ref6.current
						local v16

						if current7.homeBlurredOrJoinCardOpen == true then
							v16 = true
						else
							local v17

							if current7.joinPopoverUserId == nil then
								local joinSheetUserIdRef = current7.joinSheetUserIdRef

								if joinSheetUserIdRef ~= nil then
									v17 = joinSheetUserIdRef.current
								end

								if v17 == nil then
									local joinPopoverUserIdRef = current7.joinPopoverUserIdRef
									v17 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
								end
							else
								v17 = current7.joinPopoverUserId
							end

							v16 = v17 ~= nil
						end

						local v17

						if v16 then
							local v18

							if current7.joinPopoverUserId == nil then
								local joinSheetUserIdRef = current7.joinSheetUserIdRef

								if joinSheetUserIdRef ~= nil then
									v18 = joinSheetUserIdRef.current
								end

								if v18 == nil then
									local joinPopoverUserIdRef = current7.joinPopoverUserIdRef
									v18 = if joinPopoverUserIdRef ~= nil then joinPopoverUserIdRef.current else nil
								end
							else
								v18 = current7.joinPopoverUserId
							end

							v17 = v18 == nil or v18 == current6
						else
							v17 = false
						end

						if v17 or ref8.current > 0 then
							ref9.current = true
							setState2(true)
							local tiles = ref6.current.tiles or {}
							local v19 = nil

							for i, tile in ipairs(tiles) do
								if tile.id == current6 then
									v19 = i
									break
								end
							end

							publishIndex(v19)

							if ref8.current > 0 then
								startHeartbeat()
							elseif connection then
								connection:Disconnect()
								connection = nil
							end
						else
							ref9.current = false
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
				end
			end

			local function onInputBegan(p6)
				if not scrollPause.isPointerHold(p6.UserInputType) then
					return
				end

				local v13 = verticalPage()
				local absolutePosition = if v13 == nil then current2.AbsolutePosition else v13.AbsolutePosition
				local v14 = if v13 == nil then current2.AbsoluteSize else v13.AbsoluteSize

				if not scrollPause.pointerIsInside(
					absolutePosition,
					v14,
					Vector2.new(p6.Position.X, p6.Position.Y)
				) then
					return
				end

				current3[p6] = true
				v12.current = true
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

				v12.current = next(current3) ~= nil
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
				local v13 = if loopsRemainingStore == nil then ref2.current else loopsRemainingStore.getLoopsRemaining(false)

				reconcilePresence(v13, current4.tiles or {})
			end

			apply(current2.CanvasPosition.X, 0, true, true)

			if ref.current.interacting then
				startHeartbeat()
			end

			local v13 = nil
			local canvasPositionChangedConnection = nil
			local connections = {}

			local function bindVerticalScroller()
				local v14 = verticalPage()

				if v14 == v13 then
					return
				end

				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
					canvasPositionChangedConnection = nil
				end

				v13 = v14

				if v14 ~= nil then
					canvasPositionChangedConnection = v14:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
				end
			end

			local v14 = verticalPage()

			if v14 ~= v13 then
				if canvasPositionChangedConnection then
					canvasPositionChangedConnection:Disconnect()
					canvasPositionChangedConnection = nil
				end

				v13 = v14

				if v14 ~= nil then
					canvasPositionChangedConnection = v14:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
				end
			end

			local parent = current2.Parent

			while parent ~= nil do
				if parent:IsA("ScrollingFrame") then
					table.insert(
						connections,
						parent:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
							local v15 = v13
							local v16 = verticalPage()

							if v16 ~= v13 then
								if canvasPositionChangedConnection then
									canvasPositionChangedConnection:Disconnect()
									canvasPositionChangedConnection = nil
								end

								v13 = v16

								if v16 ~= nil then
									canvasPositionChangedConnection = v16:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
								end
							end

							if v13 ~= v15 then
								apply(current2.CanvasPosition.X, 0)
							end
						end)
					)
				end

				parent = parent.Parent
			end

			local canvasPositionChangedConnection2 = current2:GetPropertyChangedSignal("CanvasPosition"):Connect(onCanvasPositionChanged)
			local inputBeganConnection = v10.InputBegan:Connect(onInputBegan)
			local inputEndedConnection = v10.InputEnded:Connect(function(input)
				if input == nil then
					table.clear(current3)
				elseif current3[input] == nil then
					return
				else
					current3[input] = nil
				end

				v12.current = next(current3) ~= nil
				apply(current2.CanvasPosition.X, 0)
			end)
			local windowFocusReleasedConnection

			if v10.WindowFocusReleased then
				windowFocusReleasedConnection = v10.WindowFocusReleased:Connect(function()
					table.clear(current3)

					v12.current = next(current3) ~= nil
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
			current.joinPopoverUserId,
			current.loopsRemainingStore,
			current.marqueeEnabled
		})

		React.useEffect(function()
			if current.marqueeEnabled == false then
				return
			end

			local loopsRemainingStore = current.loopsRemainingStore
			local getHomeFocusVersion = if loopsRemainingStore ~= nil then loopsRemainingStore.getHomeFocusVersion else nil

			if getHomeFocusVersion == nil then
				return
			end

			local v9 = nil
			return Signals.createEffect(function(p6)
				local homeFocusVersion = getHomeFocusVersion(p6)

				if v9 == homeFocusVersion then
					return
				end

				local v10 = v9 == nil
				v9 = homeFocusVersion

				if v10 then
					return
				end

				ref7.current()
			end)
		end, { current.loopsRemainingStore, current.marqueeEnabled })

		return {
			activeByIndex = state,
			isPaused = state2,
			loopsRemainingRef = ref2,
			onMarqueeFinished = v6,
			onManualMarqueeStart = v7,
			onManualMarqueeEnd = v8,
			marqueeRunId = state3
		}
	end
}
