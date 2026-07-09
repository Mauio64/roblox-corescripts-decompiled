local LandingPage = script:FindFirstAncestor("LandingPage")
local LandingPageParent = LandingPage.Parent
local React = require(LandingPageParent.React)
local Foundation = require(LandingPageParent.Foundation)
local AccountCarouselAvatar = require(LandingPage.Components.AccountCarouselAvatar)
local ScrollIndicatorComponent = require(LandingPage.Components.ScrollIndicatorComponent)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local v9 = game:DefineFastFlag("EnableAccountCarouselPatch", false)
local v10 = game:DefineFastInt("AccountCarouselTweenDurationOnScroll", 100)
local AuthAnalytics = require(LandingPageParent.AuthAnalytics)
local GetFFlagEnableAccountCarouselEvents = require(LandingPageParent.SharedFlags).GetFFlagEnableAccountCarouselEvents
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local AccountCarouselAvatarScaleFactor = require(LandingPage.Constants.LandingPageConstants).Common.AccountCarouselAvatarScaleFactor
local v16 = game:DefineFastFlag("EnableAccountCarouselDefaultCenter", false)

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), AccountCarouselAvatarScaleFactor (copy), v16 (copy), v10 (copy), TweenService (copy), v9 (copy), UserInputService (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), AccountCarouselAvatar (copy), Foundation (copy), ScrollIndicatorComponent (copy)
	local v18, v19 = React.useState(1)
	local v20, v21 = React.useState(0)
	local v22, v23 = React.useState(0)
	local v24, v25 = React.useState(0)
	local v26 = React.useRef({})
	local v27 = React.useRef(nil)
	local t2 = {}
	local v29, v30 = React.useState(false)

	local function scrollToCenter(n1: number, p1) -- line: 44
		-- upvalues: v29 (copy), v30 (copy), v26 (copy), t1 (copy), AccountCarouselAvatarScaleFactor (copy), v16 (copy), v10 (copy), TweenService (copy)
		if v29 then
			return
		end

		v30(true)

		local v41 = v26.current[n1]

		if v41 and v41.AbsolutePosition and p1.AbsolutePosition then
			local v42 = t1.avatarSize.X.Offset * AccountCarouselAvatarScaleFactor
			local v43 = v41.AbsolutePosition.X + v42 / 2
			local v44 = p1.AbsolutePosition.X + p1.AbsoluteSize.X / 2
			local v45 = if not v16 or v44 ~= 0 then v43 - v44 + p1.CanvasPosition.X else 0
			local tweenInfo = TweenInfo.new(v10 / 1000)
			local tween = TweenService:Create(p1, tweenInfo, {
				CanvasPosition = Vector2.new(v45, 0)
			})

			tween:Play()
			tween.Completed:Connect(function() -- line: 65
				-- upvalues: v30 (copy)
				v30(false)
			end)
		end
	end

	local v32 = React.useRef(v18)

	React.useEffect(function() -- line: 83
		-- upvalues: v32 (copy), v18 (copy)
		v32.current = v18
	end, { v18 })

	local v33, v34 = React.useState(nil)

	React.useEffect(function() -- line: 88
		-- upvalues: v9 (copy), v27 (copy), t1 (copy), v29 (copy), v19 (copy), scrollToCenter (copy), v33 (copy), UserInputService (copy), v32 (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), v34 (copy)
		if v9 and (v27.current and #t1.accounts >= 1) then
			local current = v27.current

			if not v9 or not v29 then
				v19(1)
				t1.setSelectedAvatarIndex(1)
				scrollToCenter(1, current)
			end
		end

		if v33 then
			v33:Disconnect()
		end

		local connection = UserInputService.TouchSwipe:Connect(function(p2) -- line: 98
			-- upvalues: t1 (copy), v27 (copy), v32 (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), v9 (copy), v29 (copy), v19 (copy), scrollToCenter (copy)
			if #t1.accounts <= 1 then
				return
			end

			if v27.current and p2 == Enum.SwipeDirection.Left then
				local v60 = math.clamp(v32.current + 1, 1, #t1.accounts)

				if GetFFlagEnableAccountCarouselEvents() then
					authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreen, EventStreamConstants.Button.AccountPickerSwipeLeft, tostring(v32.current) .. ";" .. tostring(v60))
				end

				local current = v27.current

				if v9 and v29 then
					return
				end

				v19(v60)
				t1.setSelectedAvatarIndex(v60)
				scrollToCenter(v60, current)

				return
			end

			if v27.current and p2 == Enum.SwipeDirection.Right then
				local v62 = math.clamp(v32.current - 1, 1, #t1.accounts)

				if GetFFlagEnableAccountCarouselEvents() then
					authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreen, EventStreamConstants.Button.AccountPickerSwipeRight, tostring(v32.current) .. ";" .. tostring(v62))
				end

				local current = v27.current

				if v9 and v29 then
					return
				end

				v19(v62)
				t1.setSelectedAvatarIndex(v62)
				scrollToCenter(v62, current)
			end
		end)

		v34(connection)

		return function() -- line: 125
			-- upvalues: v33 (copy)
			if v33 then
				v33:Disconnect()
			end
		end
	end, {
		v32,
		t1.accounts,
		v27
	})
	React.useEffect(function() -- line: 132
		-- upvalues: v27 (copy)
		if v27.current then
			v27.current.ScrollingEnabled = false
		end
	end, { v27 })

	local v35 = React.useCallback(function(p3) -- line: 139
		-- upvalues: v26 (copy)
		table.insert(v26.current, p3)
	end, {})

	for i, v in ipairs(t1.accounts) do
		t2[i] = React.createElement(AccountCarouselAvatar, {
			avatarSize = t1.avatarSize,
			ref = v35,
			accountInfo = v,
			isHighlighted = i == v18,
			setAvatarElementHeightForParent = function(n2: number) -- line: 37
				-- upvalues: v24 (copy), v25 (copy)
				if n2 ~= v24 then
					v25(n2)
				end
			end,
			onActivated = function() -- line: 150
				-- upvalues: v27 (copy), i (copy), v18 (copy), v9 (copy), v29 (copy), v19 (copy), t1 (copy), scrollToCenter (copy)
				if v27.current and i ~= v18 then
					local v53 = i
					local current = v27.current

					if v9 and v29 then
						return
					end

					v19(v53)
					t1.setSelectedAvatarIndex(v53)
					scrollToCenter(v53, current)
				end
			end
		})
	end

	React.useLayoutEffect(function() -- line: 158
		-- upvalues: t1 (copy), AccountCarouselAvatarScaleFactor (copy), v22 (copy), v20 (copy), v21 (copy)
		local v55 = t1.avatarSize.X.Offset * AccountCarouselAvatarScaleFactor
		local v56 = (v22 - v55) / 2

		if v56 ~= v20 then
			v21(v56)
		end
	end, { v22 })

	return React.createElement(Foundation.View, {
		tag = "col grow size-full-0 align-y-bottom",
		LayoutOrder = t1.LayoutOrder
	}, {
		ScrollView = React.createElement(Foundation.ScrollView, {
			tag = "row gap-none no-wrap",
			LayoutOrder = 1,
			scrollingFrameRef = v27,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
			},
			onAbsoluteWindowSizeChanged = function(p4) -- line: 181
				-- upvalues: v22 (copy), v23 (copy)
				local AbsoluteSizeX = p4.AbsoluteSize.X

				if AbsoluteSizeX ~= v22 then
					v23(AbsoluteSizeX)
				end
			end,
			Size = UDim2.new(1, 0, 0, v24)
		}, { React.createElement(Foundation.View, {
			tag = "row align-y-center gap-none no-wrap auto-xy"
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v20),
				PaddingRight = UDim.new(0, v20)
			}),
			AvatarElements = React.createElement(React.Fragment, {}, t2)
		}) }),
		ScrollIndicators = React.createElement(ScrollIndicatorComponent, {
			LayoutOrder = 2,
			totalAvatars = #t1.accounts,
			highlightedIndex = v18
		})
	})
end
