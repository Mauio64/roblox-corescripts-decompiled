local parent = script.Parent.Parent
local parent2 = parent.Parent

local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local UserInputService = game:GetService("UserInputService")

local Otter = require(parent2.Otter)
local React = require(parent2.React)
local ReactUtils = require(parent2.ReactUtils)
local Responsive = require(parent2.Responsive)
local RoactUtils = require(parent2.RoactUtils)
local SocialCommon = require(parent2.SocialCommon)

local useAnalytics = require(parent.Analytics.useAnalytics)
local useBinding = React.useBinding
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useEventConnection = ReactUtils.useEventConnection
local useIsHovered = SocialCommon.Hooks.useIsHovered
local useIsTouchDown = SocialCommon.Hooks.useIsTouchDown
local useLastInput = Responsive.useLastInput

local EventNames = require(parent.Analytics.EventNames)
local getClosestItemToCenter = require(parent.Utils.getClosestItemToCenter)

local SharedFlags = require(parent2.SharedFlags)
local FFlagUseMediaPlayerInCarousel = SharedFlags.FFlagUseMediaPlayerInCarousel

local v = { dampingRatio = 1, frequency = 4 }

local function isWithinEpsilon(p: number, p2: number, p3: number): boolean -- 3 equivalent calls inferred from this helper
	return math.abs(p - p2) < p3
end

local function createController(ref, ref2, callback)
	local renderSteppedConnection = nil
	local flag = false
	local v2 = nil
	local isNavigationLocked = false
	local v3 = 0
	local wasTouched = false

	local function getWasTouched()
		return wasTouched
	end

	local function resetTouchState() -- 1 equivalent call inferred from this helper
		flag = false
		wasTouched = false
	end

	local function getIsNavigationLocked()
		return isNavigationLocked
	end

	local function setIsNavigationLocked(flag2: boolean) -- 1 equivalent call inferred from this helper
		if flag2 == true then
			resetTouchState() -- inferred equivalent call
		end

		isNavigationLocked = flag2
	end

	local function resetMotor(x: number, callback2, fn)
		if v2 then
			v2:destroy()
			v2 = nil
		end

		local singleMotor = Otter.createSingleMotor(x)
		v2 = singleMotor
		singleMotor:onStep(function(p)
			if v2 ~= singleMotor then
				singleMotor:destroy()
			elseif flag then
				singleMotor:destroy()
				v2 = nil
			else
				if isWithinEpsilon(p, v3, 0.5) then -- inferred equivalent call
					p = v3
				end

				if callback2 and callback2(x, p) then
					return
				end

				if ref.current then
					ref.current.CanvasPosition = Vector2.new(p, 0)
				end
			end
		end)

		if fn then
			singleMotor:onComplete(fn)
		end

		singleMotor:start()
	end
	local function setGoal(vector2: Vector2, p: number, flag2: boolean) -- 3 equivalent calls inferred from this helper
		if not v2 then
			return
		end

		assert(v2 ~= nil, "setGoal called before resetMotor")

		v3 = vector2.X * (p - 1)

		if flag2 then
			v2:setGoal(Otter.instant(v3))
		else
			v2:setGoal(Otter.spring(v3, v))
		end
	end

	local function handleDeleteTransition(callback2, callback3, vector2: Vector2, p: number, flag2: boolean, callback4)
		local current = ref.current
		local current2 = ref2.current

		if not (current and current2) then
			return
		end

		assert(current ~= nil, "carousel should exist")
		assert(current2 ~= nil, "selectedItem should exist")

		local scrollingEnabled = current.ScrollingEnabled
		current.ScrollingEnabled = false
		setIsNavigationLocked(true) -- inferred equivalent call

		local function handleDeleteNextImageMovement()
			local function onStep(p2: number, p3: number): boolean
				local v4 = math.abs(p2 - p3)
				local v5 = math.round(vector2.X - v4)
				current2.Size = UDim2.fromOffset(v5, vector2.Y)

				return p == 1
			end

			resetMotor(current.CanvasPosition.X, onStep, function()
				callback4()
				current2.Visible = false
				callback2(1)
				isNavigationLocked = false

				current.ScrollingEnabled = scrollingEnabled
			end)

			setGoal(vector2, p - 1, flag2 or UserGameSettings.ReducedMotion)
		end

		local function handleDeleteImagesFadeIn()
			if not callback3 then
				return
			end

			assert(callback3 ~= nil, "setPostDeletionItemBinding should exist")
			resetMotor(current.CanvasPosition.X, function(_, _: number): boolean
				return p == 1
			end, function()
				callback4()
				current2.Visible = false
				local singleMotor = Otter.createSingleMotor(0)
				singleMotor:onStep(function(p2)
					callback2(p2)
					callback3(1)
				end)
				singleMotor:onComplete(function()
					isNavigationLocked = false

					current.ScrollingEnabled = scrollingEnabled
				end)
				singleMotor:setGoal(Otter.spring(1, { frequency = 2 }))
			end)

			setGoal(vector2, p - 1, true) -- inferred equivalent call
		end

		local function handleDeleteNextImageFadeOut()
			if not callback3 then
				return
			end

			assert(callback3 ~= nil, "setPostDeletionItemBinding should exist")
			local singleMotor = Otter.createSingleMotor(1)
			singleMotor:onStep(callback3)
			singleMotor:onComplete(handleDeleteImagesFadeIn)
			singleMotor:setGoal(Otter.spring(0, { frequency = 6 }))
		end

		local singleMotor = Otter.createSingleMotor(1)
		singleMotor:onStep(callback2)
		local frequency

		if UserGameSettings.ReducedMotion then
			singleMotor:onComplete(handleDeleteNextImageFadeOut)
			frequency = 6
		else
			singleMotor:onComplete(handleDeleteNextImageMovement)
			frequency = 4
		end

		singleMotor:setGoal(Otter.spring(0, { frequency = frequency }))
	end

	local function handleInertialMove(vector2: Vector2, p: number)
		local current = ref.current

		if flag or not current then
			return
		end

		assert(current ~= nil, "carousel should not be nil")

		local v4 = -current:GetSampledInertialVelocity().X
		current:ClearInertialScrolling()

		local closestItemToCenter, v5 = getClosestItemToCenter(vector2, current)

		if math.abs(v4) < 60 and closestItemToCenter == p then
			if v5 > 0.5 then
				local x = current.CanvasPosition.X

				if v2 then
					v2:destroy()
					v2 = nil
				end

				local singleMotor = Otter.createSingleMotor(x)
				v2 = singleMotor
				local v6 = nil
				singleMotor:onStep(function(p2)
					if v2 ~= singleMotor then
						singleMotor:destroy()
					elseif flag then
						singleMotor:destroy()
						v2 = nil
					else
						if isWithinEpsilon(p2, v3, 0.5) then -- inferred equivalent call
							p2 = v3
						end

						if v6 and v6(x, p2) then
							return
						end

						if ref.current then
							ref.current.CanvasPosition = Vector2.new(p2, 0)
						end
					end
				end)

				singleMotor:start()
				setGoal(vector2, p, false) -- inferred equivalent call
			end
		else
			if renderSteppedConnection then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			renderSteppedConnection = RunService.RenderStepped:Connect(function(dt)
				local current2 = ref.current

				if current2 and not flag then
					assert(current2 ~= nil, "carousel should not be nil")

					local closestItemToCenter2, v6 = getClosestItemToCenter(vector2, current2)

					if math.abs(v4) < 60 then
						assert(renderSteppedConnection ~= nil, "handleInertialMoveConn should exist")
						renderSteppedConnection:Disconnect()
						renderSteppedConnection = nil

						if closestItemToCenter2 ~= p then
							callback(closestItemToCenter2)

							return
						end

						local x = current2.CanvasPosition.X

						if v2 then
							v2:destroy()
							v2 = nil
						end

						local singleMotor = Otter.createSingleMotor(x)
						v2 = singleMotor
						local v7 = nil
						singleMotor:onStep(function(p2)
							if v2 ~= singleMotor then
								singleMotor:destroy()
							elseif flag then
								singleMotor:destroy()
								v2 = nil
							else
								if isWithinEpsilon(p2, v3, 0.5) then -- inferred equivalent call
									p2 = v3
								end

								if v7 and v7(x, p2) then
									return
								end

								if ref.current then
									ref.current.CanvasPosition = Vector2.new(p2, 0)
								end
							end
						end)

						singleMotor:start()
						setGoal(vector2, p, false) -- inferred equivalent call
					else
						current2.CanvasPosition += Vector2.new(v4 * dt, 0)

						local v7 = math.max(v6 / (vector2.X / 2) * 1.25, 0.85)

						local v8 = math.abs(v4) < 120 and 0.7 or v7 * 0.95

						v4 *= v8 ^ (dt / (1 / 60))
					end
				else
					assert(renderSteppedConnection ~= nil, "handleInertialMoveConn should exist")
					renderSteppedConnection:Disconnect()
					renderSteppedConnection = nil
				end
			end)
		end
	end

	local function onInputBegan(_, p)
		if isNavigationLocked then
			return
		end

		if p.UserInputType == Enum.UserInputType.Touch then
			flag = true
			wasTouched = true
		end
	end

	local controller = {
		carouselRef = ref,
		getWasTouched = getWasTouched,
		getIsNavigationLocked = getIsNavigationLocked,
		handleDeleteTransition = handleDeleteTransition,
		handleInertialMove = handleInertialMove,
		onInputBegan = onInputBegan,
		resetMotor = resetMotor,
		resetTouchState = resetTouchState,
		setGoal = setGoal,
		setIsNavigationLocked = setIsNavigationLocked
	}

	controller.resetMotor(0)

	return controller
end

return function(vector2: Vector2, p: number, callback)
	local v2 = useAnalytics()
	local selectedItemFadeOutBinding, v3 = useBinding(1)

	local postDeletionItemBinding, v4 = useBinding(1)
	local ref = React.useRef(nil)
	local v5, v6, v7 = useIsHovered()
	local v8 = useIsTouchDown()
	local ref2 = React.useRef(nil)
	local v9 = useLastInput()

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = createController(ref, ref2, callback)
	end

	local current = ref3.current
	assert(current ~= nil, "carouselController should exist")

	React.useEffect(function()
		local current2 = ref.current

		if not current2 then
			return
		end

		assert(current2 ~= nil, "carousel should exist")

		local v10 = UserGameSettings.ReducedMotion and true or false

		current.resetMotor(current2.CanvasPosition.X)
		current.setGoal(vector2, p, v10)
	end, { p })

	useEffectOnce(function()
		current.setGoal(vector2, p, true)
	end, p ~= nil)

	React.useEffect(function()
		current.setGoal(vector2, p, true)
	end, { vector2 })

	React.useEffect(function()
		if not v8 and current.getWasTouched() then
			current.resetTouchState()
			current.handleInertialMove(vector2, p)
		end
	end, { v8 })

	local v10 = React.useCallback(function(p2: number)
		local current2 = ref.current

		if not current2 then
			return
		end

		assert(current2 ~= nil, "carousel should exist")

		if current.getIsNavigationLocked() then
			return
		end

		local closestItemToCenter = getClosestItemToCenter(vector2, current2)

		if v5 and p2 > 0 then
			callback(closestItemToCenter - 1)
		elseif v5 and p2 < 0 then
			callback(closestItemToCenter + 1)
		end
	end, { v5, vector2 })

	useEventConnection(UserInputService.PointerAction, v10)

	local v11 = React.useCallback(function(p2)
		if not UserGameSettings.ReducedMotion then
			return
		end

		local current2 = ref.current

		if not current2 then
			return
		end

		assert(current2 ~= nil, "carousel should exist")

		if current.getIsNavigationLocked() then
			return
		end

		local closestItemToCenter = getClosestItemToCenter(vector2, current2)

		if p2 == Enum.SwipeDirection.Left then
			callback(closestItemToCenter + 1)
		elseif p2 == Enum.SwipeDirection.Right then
			callback(closestItemToCenter - 1)
		end
	end, {})

	useEventConnection(UserInputService.TouchSwipe, v11)

	React.useEffect(function()
		ContextActionService:BindCoreAction("CapturesCarouselNavigateShortcutAction", function(_, p2, p3)
			local current2 = ref.current

			if not current2 then
				return
			end

			assert(current2 ~= nil, "carousel should exist")

			if current.getIsNavigationLocked() then
				return
			end

			if p2 == Enum.UserInputState.End then
				v2.fireEvent(EventNames.CapturesCarouselNavigatedByKeyboard)
				local closestItemToCenter = getClosestItemToCenter(vector2, current2)

				if p3.KeyCode == Enum.KeyCode.Left then
					callback(closestItemToCenter - 1)
				elseif p3.KeyCode == Enum.KeyCode.Right then
					callback(closestItemToCenter + 1)
				end
			end
		end, false, Enum.KeyCode.Left, Enum.KeyCode.Right)

		return function()
			ContextActionService:UnbindCoreAction("CapturesCarouselNavigateShortcutAction")
		end
	end, {})

	return {
		carouselInputBegan = React.useCallback(function(p2, p3)
			if current.getIsNavigationLocked() then
				return
			end

			if UserGameSettings.ReducedMotion then
				v6(p2, p3)
				return
			end

			current.onInputBegan(p2, p3)
			v6(p2, p3)
		end, { current.onInputBegan, v6 }),
		carouselInputEnded = React.useCallback(function(p2, p3)
			if FFlagUseMediaPlayerInCarousel and v9 == "Touch" and not current.getWasTouched() then
				current.onInputBegan(p2, p3)
			end

			v7(p2, p3)
		end, { v7 }),
		carouselRef = ref,
		deleteSelectedItem = React.useCallback(function(p2)
			current.handleDeleteTransition(v3, v4, vector2, p, false, p2)
		end, { vector2, p, v3 }),
		postDeletionItemBinding = postDeletionItemBinding,
		selectedItemFadeOutBinding = selectedItemFadeOutBinding,
		selectedItemRef = ref2,
		setIsNavigationLocked = current.setIsNavigationLocked
	}
end
