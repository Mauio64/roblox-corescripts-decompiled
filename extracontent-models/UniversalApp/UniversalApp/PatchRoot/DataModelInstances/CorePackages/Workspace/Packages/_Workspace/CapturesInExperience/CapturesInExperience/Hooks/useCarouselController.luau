local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local UserInputService = game:GetService("UserInputService")
local Otter = require(ParentParentParent.Otter)
local React = require(ParentParentParent.React)
local ReactUtils = require(ParentParentParent.ReactUtils)
local Responsive = require(ParentParentParent.Responsive)
local RoactUtils = require(ParentParentParent.RoactUtils)
local SocialCommon = require(ParentParentParent.SocialCommon)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useBinding = React.useBinding
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useEventConnection = ReactUtils.useEventConnection
local useIsHovered = SocialCommon.Hooks.useIsHovered
local useIsTouchDown = SocialCommon.Hooks.useIsTouchDown
local useLastInput = Responsive.useLastInput
local EventNames = require(ParentParent.Analytics.EventNames)
local getClosestItemToCenter = require(ParentParent.Utils.getClosestItemToCenter)
local FFlagUseMediaPlayerInCarousel = require(ParentParentParent.SharedFlags).FFlagUseMediaPlayerInCarousel
local t1 = {
	dampingRatio = 1,
	frequency = 4
}

local function isWithinEpsilon(n1: number, n2: number, n3: number) -- line: 75
	return n3 > math.abs(n1 - n2)
end
local function createController(t2: {[any]: any}, p1, p2) -- line: 79
	-- upvalues: Otter (copy), t1 (copy), UserGameSettings (copy), getClosestItemToCenter (copy), RunService (copy)
	local u32 = nil
	local u33 = false
	local u34 = nil
	local u35 = false
	local n4 = 0
	local u37 = false

	local function resetMotor(n5: number, p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)?) -- line: 111
		-- upvalues: u34 (ref), Otter (copy), u33 (ref), n4 (ref), t2 (copy)
		if u34 then
			u34:destroy()
			u34 = nil
		end

		local v67 = Otter.createSingleMotor(n5)

		u34 = v67
		v67:onStep(function(p5) -- line: 123
			-- upvalues: u34 (ref), v67 (copy), u33 (ref), n4 (ref), p3 (copy), n5 (copy), t2 (copy)
			if u34 ~= v67 then
				v67:destroy()

				return
			end

			if u33 then
				v67:destroy()
				u34 = nil

				return
			end

			local v110 = if not (math.abs(p5 - n4) < 0.5) then p5 else n4

			if p3 and p3(n5, v110) then
				return
			end

			if t2.current then
				t2.current.CanvasPosition = Vector2.new(v110, 0)
			end
		end)

		if p4 then
			v67:onComplete(p4)
		end

		v67:start()
	end
	local function setGoal(vector2: Vector2, n6: number, b1: boolean) -- line: 156
		-- upvalues: u34 (ref), n4 (ref), Otter (copy), t1 (copy)
		if not u34 then
			return
		end

		assert(u34 ~= nil, "setGoal called before resetMotor")
		n4 = vector2.X * (n6 - 1)

		if b1 then
			u34:setGoal(Otter.instant(n4))

			return
		end

		u34:setGoal(Otter.spring(n4, t1))
	end

	local t3 = {
		carouselRef = t2,
		getWasTouched = function() -- line: 91
			-- upvalues: u37 (ref)
			return u37
		end,
		getIsNavigationLocked = function() -- line: 100
			-- upvalues: u35 (ref)
			return u35
		end,
		handleDeleteTransition = function(p6: ((...any) -> ...any), p7: ((...any) -> ...any), vector2: Vector2, n7: number, b2: boolean, p8: ((...any) -> ...any)) -- line: 171
			-- upvalues: t2 (copy), p1 (copy), u33 (ref), u37 (ref), u35 (ref), resetMotor (copy), setGoal (copy), UserGameSettings (copy), Otter (copy), u34 (ref), n4 (ref)
			local current = t2.current
			local current2 = p1.current

			if not current or not current2 then
				return
			end

			assert(current ~= nil, "carousel should exist")
			assert(current2 ~= nil, "selectedItem should exist")

			local ScrollingEnabled = current.ScrollingEnabled

			current.ScrollingEnabled = false
			u33 = false
			u37 = false
			u35 = true

			local function handleDeleteNextImageMovement() -- line: 194
				-- upvalues: vector2 (copy), current2 (copy), n7 (copy), resetMotor (copy), current (copy), p8 (copy), p6 (copy), u35 (ref), ScrollingEnabled (copy), setGoal (copy), b2 (copy), UserGameSettings (copy)
				local function onStep(n8: number, n9: number) -- line: 195
					-- upvalues: vector2 (copy), current2 (copy), n7 (copy)
					local v135 = math.abs(n8 - n9)
					local v136 = math.round(vector2.X - v135)

					current2.Size = UDim2.fromOffset(v136, vector2.Y)

					return n7 == 1
				end

				resetMotor(current.CanvasPosition.X, onStep, function() -- line: 205
					-- upvalues: p8 (copy), current2 (copy), p6 (copy), u35 (ref), current (copy), ScrollingEnabled (copy)
					p8()
					current2.Visible = false
					p6(1)
					u35 = false
					current.ScrollingEnabled = ScrollingEnabled
				end)
				setGoal(vector2, n7 - 1, b2 or UserGameSettings.ReducedMotion)
			end
			local function handleDeleteImagesFadeIn() -- line: 216
				-- upvalues: p7 (copy), n7 (copy), resetMotor (copy), current (copy), p8 (copy), current2 (copy), Otter (copy), p6 (copy), u35 (ref), ScrollingEnabled (copy), vector2 (copy), u34 (ref), n4 (ref)
				if not p7 then
					return
				end

				assert(p7 ~= nil, "setPostDeletionItemBinding should exist")
				resetMotor(current.CanvasPosition.X, function(_, _: number) -- line: 221
					-- upvalues: n7 (copy)
					return n7 == 1
				end, function() -- line: 225
					-- upvalues: p8 (copy), current2 (copy), Otter (copy), p6 (copy), p7 (copy), u35 (ref), current (copy), ScrollingEnabled (copy)
					p8()
					current2.Visible = false

					local v139 = Otter.createSingleMotor(0)

					v139:onStep(function(p10) -- line: 229
						-- upvalues: p6 (copy), p7 (copy)
						p6(p10)
						p7(1)
					end)
					v139:onComplete(function() -- line: 233
						-- upvalues: u35 (ref), current (copy), ScrollingEnabled (copy)
						u35 = false
						current.ScrollingEnabled = ScrollingEnabled
					end)
					v139:setGoal(Otter.spring(1, {
						frequency = 2
					}))
				end)

				local v112 = vector2
				local v113 = n7 - 1

				if not u34 then
					return
				end

				assert(u34 ~= nil, "setGoal called before resetMotor")
				n4 = v112.X * (v113 - 1)
				u34:setGoal(Otter.instant(n4))
			end
			local function handleDeleteNextImageFadeOut() -- line: 243
				-- upvalues: p7 (copy), Otter (copy), handleDeleteImagesFadeIn (copy)
				if not p7 then
					return
				end

				assert(p7 ~= nil, "setPostDeletionItemBinding should exist")

				local v114 = Otter.createSingleMotor(1)

				v114:onStep(p7)
				v114:onComplete(handleDeleteImagesFadeIn)
				v114:setGoal(Otter.spring(0, {
					frequency = 6
				}))
			end

			local v83 = Otter.createSingleMotor(1)

			v83:onStep(p6)

			local n11

			if UserGameSettings.ReducedMotion then
				n11 = 6
				v83:onComplete(handleDeleteNextImageFadeOut)
			else
				n11 = 4
				v83:onComplete(handleDeleteNextImageMovement)
			end

			v83:setGoal(Otter.spring(0, {
				frequency = n11
			}))
		end,
		handleInertialMove = function(vector2: Vector2, n12: number) -- line: 267
			-- upvalues: t2 (copy), u33 (ref), getClosestItemToCenter (copy), u34 (ref), Otter (copy), n4 (ref), t1 (copy), u32 (ref), RunService (copy), p2 (copy)
			local current = t2.current

			if u33 or not current then
				return
			end

			assert(current ~= nil, "carousel should not be nil")

			local u88 = -current:GetSampledInertialVelocity().X

			current:ClearInertialScrolling()

			local v89, v90 = getClosestItemToCenter(vector2, current)

			if math.abs(u88) < 60 and v89 == n12 then
				if v90 > 0.5 then
					local CanvasPositionX = current.CanvasPosition.X

					if u34 then
						u34:destroy()
						u34 = nil
					end

					local v92 = Otter.createSingleMotor(CanvasPositionX)

					u34 = v92

					local v93 = nil

					v92:onStep(function(p11) -- line: 123
						-- upvalues: u34 (ref), v92 (copy), u33 (ref), n4 (ref), v93 (copy), CanvasPositionX (copy), t2 (copy)
						if u34 ~= v92 then
							v92:destroy()

							return
						end

						if u33 then
							v92:destroy()
							u34 = nil

							return
						end

						local v116 = if not (math.abs(p11 - n4) < 0.5) then p11 else n4

						if v93 and v93(CanvasPositionX, v116) then
							return
						end

						if t2.current then
							t2.current.CanvasPosition = Vector2.new(v116, 0)
						end
					end)
					v92:start()

					if u34 then
						assert(u34 ~= nil, "setGoal called before resetMotor")
						n4 = vector2.X * (n12 - 1)
						u34:setGoal(Otter.spring(n4, t1))
					end
				end

				return
			end

			if u32 then
				u32:Disconnect()
				u32 = nil
			end

			u32 = RunService.RenderStepped:Connect(function(dt) -- line: 297
				-- upvalues: t2 (copy), u33 (ref), u32 (ref), getClosestItemToCenter (copy), vector2 (copy), u88 (ref), n12 (copy), u34 (ref), Otter (copy), n4 (ref), t1 (copy), p2 (copy)
				local current3 = t2.current

				if not current3 or u33 then
					assert(u32 ~= nil, "handleInertialMoveConn should exist")
					u32:Disconnect()
					u32 = nil

					return
				end

				assert(current3 ~= nil, "carousel should not be nil")

				local v119, v120 = getClosestItemToCenter(vector2, current3)

				if math.abs(u88) < 60 then
					assert(u32 ~= nil, "handleInertialMoveConn should exist")
					u32:Disconnect()
					u32 = nil

					if v119 == n12 then
						local CanvasPositionX = current3.CanvasPosition.X

						if u34 then
							u34:destroy()
							u34 = nil
						end

						local v122 = Otter.createSingleMotor(CanvasPositionX)

						u34 = v122

						local v123 = nil

						v122:onStep(function(p12) -- line: 123
							-- upvalues: u34 (ref), v122 (copy), u33 (ref), n4 (ref), v123 (copy), CanvasPositionX (copy), t2 (copy)
							if u34 ~= v122 then
								v122:destroy()

								return
							end

							if u33 then
								v122:destroy()
								u34 = nil

								return
							end

							local v141 = if not (math.abs(p12 - n4) < 0.5) then p12 else n4

							if v123 and v123(CanvasPositionX, v141) then
								return
							end

							if t2.current then
								t2.current.CanvasPosition = Vector2.new(v141, 0)
							end
						end)
						v122:start()

						local v124 = vector2
						local v125 = n12

						if not u34 then
							return
						end

						assert(u34 ~= nil, "setGoal called before resetMotor")
						n4 = v124.X * (v125 - 1)
						u34:setGoal(Otter.spring(n4, t1))

						return
					end

					p2(v119)

					return
				end

				current3.CanvasPosition = current3.CanvasPosition + Vector2.new(u88 * dt, 0)

				local v126 = math.max(v120 / (vector2.X / 2) * 1.25, 0.85)
				local v127 = if not (math.abs(u88) < 120) then v126 * 0.95 else 0.7

				u88 *= v127 ^ (dt / 0.016666666666666666)
			end)
		end,
		onInputBegan = function(_, p14) -- line: 343
			-- upvalues: u35 (ref), u33 (ref), u37 (ref)
			if u35 then
				return
			end

			if p14.UserInputType == Enum.UserInputType.Touch then
				u33 = true
				u37 = true
			end
		end,
		resetMotor = resetMotor,
		resetTouchState = function() -- line: 95
			-- upvalues: u33 (ref), u37 (ref)
			u33 = false
			u37 = false
		end,
		setGoal = setGoal,
		setIsNavigationLocked = function(b3: boolean) -- line: 104
			-- upvalues: u33 (ref), u37 (ref), u35 (ref)
			if b3 == true then
				u33 = false
				u37 = false
			end

			u35 = b3
		end
	}

	t3.resetMotor(0)

	return t3
end

return function(vector2: Vector2, n13: number, p15: ((...any) -> ...any)) -- line: 372
	-- upvalues: useAnalytics (copy), useBinding (copy), React (copy), useIsHovered (copy), useIsTouchDown (copy), useLastInput (copy), createController (copy), UserGameSettings (copy), useEffectOnce (copy), getClosestItemToCenter (copy), useEventConnection (copy), UserInputService (copy), ContextActionService (copy), EventNames (copy), FFlagUseMediaPlayerInCarousel (copy)
	local v44 = useAnalytics()
	local v45, v46 = useBinding(1)
	local v47, v48 = useBinding(1)
	local v49 = React.useRef(nil)
	local v50, v51, v52 = useIsHovered()
	local v53 = useIsTouchDown()
	local v54 = React.useRef(nil)
	local v55 = useLastInput()
	local v56 = React.useRef(nil)

	if v56.current == nil then
		v56.current = createController(v49, v54, p15)
	end

	local current = v56.current

	assert(current ~= nil, "carouselController should exist")
	React.useEffect(function() -- line: 392
		-- upvalues: v49 (copy), UserGameSettings (copy), current (copy), vector2 (copy), n13 (copy)
		local current4 = v49.current

		if not current4 then
			return
		end

		assert(current4 ~= nil, "carousel should exist")

		local v97 = false

		if UserGameSettings.ReducedMotion then
			v97 = true
		end

		current.resetMotor(current4.CanvasPosition.X)
		current.setGoal(vector2, n13, v97)
	end, { n13 })
	useEffectOnce(function() -- line: 410
		-- upvalues: current (copy), vector2 (copy), n13 (copy)
		current.setGoal(vector2, n13, true)
	end, n13 ~= nil)
	React.useEffect(function() -- line: 416
		-- upvalues: current (copy), vector2 (copy), n13 (copy)
		current.setGoal(vector2, n13, true)
	end, { vector2 })
	React.useEffect(function() -- line: 421
		-- upvalues: v53 (copy), current (copy), vector2 (copy), n13 (copy)
		if not v53 and current.getWasTouched() then
			current.resetTouchState()
			current.handleInertialMove(vector2, n13)
		end
	end, { v53 })

	local v58 = React.useCallback(function(n14: number) -- line: 428
		-- upvalues: v49 (copy), current (copy), getClosestItemToCenter (copy), vector2 (copy), v50 (copy), p15 (copy)
		local current5 = v49.current

		if not current5 then
			return
		end

		assert(current5 ~= nil, "carousel should exist")

		if current.getIsNavigationLocked() then
			return
		end

		local v100 = getClosestItemToCenter(vector2, current5)

		if v50 and n14 > 0 then
			p15(v100 - 1)

			return
		end

		if v50 and n14 < 0 then
			p15(v100 + 1)
		end
	end, {
		v50,
		vector2
	})

	useEventConnection(UserInputService.PointerAction, v58)

	local v59 = React.useCallback(function(p16) -- line: 449
		-- upvalues: UserGameSettings (copy), v49 (copy), current (copy), getClosestItemToCenter (copy), vector2 (copy), p15 (copy)
		if not UserGameSettings.ReducedMotion then
			return
		end

		local current6 = v49.current

		if not current6 then
			return
		end

		assert(current6 ~= nil, "carousel should exist")

		if current.getIsNavigationLocked() then
			return
		end

		local v103 = getClosestItemToCenter(vector2, current6)

		if p16 == Enum.SwipeDirection.Left then
			p15(v103 + 1)

			return
		end

		if p16 == Enum.SwipeDirection.Right then
			p15(v103 - 1)
		end
	end, {})

	useEventConnection(UserInputService.TouchSwipe, v59)
	React.useEffect(function() -- line: 473
		-- upvalues: ContextActionService (copy), v49 (copy), current (copy), v44 (copy), EventNames (copy), getClosestItemToCenter (copy), vector2 (copy), p15 (copy)
		ContextActionService:BindCoreAction("CapturesCarouselNavigateShortcutAction", function(_, p18, p19) -- line: 474
			-- upvalues: v49 (copy), current (copy), v44 (copy), EventNames (copy), getClosestItemToCenter (copy), vector2 (copy), p15 (copy)
			local current7 = v49.current

			if not current7 then
				return
			end

			assert(current7 ~= nil, "carousel should exist")

			if current.getIsNavigationLocked() then
				return
			end

			if p18 == Enum.UserInputState.End then
				v44.fireEvent(EventNames.CapturesCarouselNavigatedByKeyboard)

				local v132 = getClosestItemToCenter(vector2, current7)

				if p19.KeyCode == Enum.KeyCode.Left then
					p15(v132 - 1)

					return
				end

				if p19.KeyCode == Enum.KeyCode.Right then
					p15(v132 + 1)
				end
			end
		end, false, Enum.KeyCode.Left, Enum.KeyCode.Right)

		return function() -- line: 496
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("CapturesCarouselNavigateShortcutAction")
		end
	end, {})

	local v60 = React.useCallback(function(p20, p21) -- line: 501
		-- upvalues: current (copy), UserGameSettings (copy), v51 (copy)
		if current.getIsNavigationLocked() then
			return
		end

		if UserGameSettings.ReducedMotion then
			v51(p20, p21)

			return
		end

		current.onInputBegan(p20, p21)
		v51(p20, p21)
	end, {
		current.onInputBegan,
		v51
	})
	local v61 = React.useCallback(function(p22, p23) -- line: 515
		-- upvalues: FFlagUseMediaPlayerInCarousel (copy), v55 (copy), current (copy), v52 (copy)
		if FFlagUseMediaPlayerInCarousel and (v55 == "Touch" and not current.getWasTouched()) then
			current.onInputBegan(p22, p23)
		end

		v52(p22, p23)
	end, { v52 })
	local v62 = React.useCallback(function(p24) -- line: 522
		-- upvalues: current (copy), v46 (copy), v48 (copy), vector2 (copy), n13 (copy)
		current.handleDeleteTransition(v46, v48, vector2, n13, false, p24)
	end, {
		vector2,
		n13,
		v46
	})

	return {
		carouselInputBegan = v60,
		carouselInputEnded = v61,
		carouselRef = v49,
		deleteSelectedItem = v62,
		postDeletionItemBinding = v47,
		selectedItemFadeOutBinding = v45,
		selectedItemRef = v54,
		setIsNavigationLocked = current.setIsNavigationLocked
	}
end
