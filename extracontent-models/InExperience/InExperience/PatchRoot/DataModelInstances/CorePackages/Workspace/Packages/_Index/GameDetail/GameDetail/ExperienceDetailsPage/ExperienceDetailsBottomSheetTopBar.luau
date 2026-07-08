local Parent = script:FindFirstAncestor("GameDetail").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function ExperienceDetailsBottomSheetTopBar(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), RoactNavigation (copy), Foundation (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy)
	local tokens = t1.tokens
	local navigation = t1.navigation
	local v13, v14 = React.useBinding(0)
	local v15, v16 = React.useBinding(false)
	local v17 = tokens.Padding.Small + tokens.Size.Size_100

	React.useEffect(function() -- line: 39
		-- upvalues: t1 (copy), v14 (copy), v17 (copy)
		local current = t1.sheetContentRef.current

		if not current then
			v14(0)

			return
		end

		local function updateTopBarState() -- line: 46
			-- upvalues: current (copy), t1 (copy), v17 (copy), v14 (copy)
			local v25 = 1 - math.clamp((math.ceil(current.AbsolutePosition.Y) + t1.deviceInsets.top - t1.topBarHeight - v17) / math.max(t1.fullH - t1.briefH, 1), 0, 1)

			v14(v25)
		end

		local v20 = 1 - math.clamp((math.ceil(current.AbsolutePosition.Y) + t1.deviceInsets.top - t1.topBarHeight - v17) / math.max(t1.fullH - t1.briefH, 1), 0, 1)

		v14(v20)

		local connection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateTopBarState)

		return function() -- line: 60
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		t1.overlayFrame,
		t1.deviceInsets.top,
		t1.topBarHeight,
		v17,
		t1.fullH,
		t1.briefH
	})
	React.useEffect(function() -- line: 67
		-- upvalues: v16 (copy), navigation (copy), RoactNavigation (copy)
		v16(navigation.isFocused())

		local v22 = navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 70
			-- upvalues: v16 (copy)
			v16(true)
		end)
		local v23 = navigation.addListener(RoactNavigation.Events.WillBlur, function() -- line: 74
			-- upvalues: v16 (copy)
			v16(false)
		end)

		return function() -- line: 78
			-- upvalues: v22 (copy), v23 (copy)
			v22.remove()
			v23.remove()
		end
	end, { navigation })

	return React.createElement("ScreenGui", {
		DisplayOrder = 1,
		IgnoreGuiInset = true,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ScreenInsets = Enum.ScreenInsets.None,
		Enabled = v15
	}, {
		TopBarCanvasGroup = React.createElement("CanvasGroup", {
			Active = false,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = 2,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, t1.topBarHeight),
			BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
			GroupTransparency = if not t1.shouldMountAsFullView then v13:map(function(p1) -- line: 100
				return 1 - p1
			end) else 0,
			BorderColor3 = tokens.Color.Common.Shimmer.Color3
		}, {
			TopBarOverlay = React.createElement(Foundation.View, {
				tag = "row align-y-center size-full",
				padding = {
					top = UDim.new(0, t1.deviceInsets.top),
					left = UDim.new(0, tokens.Padding.Large)
				}
			}, {
				TopBarButton = React.createElement(IconButton, {
					isCircular = true,
					icon = if not t1.shouldMountAsFullView then IconName.X else IconName.ChevronLargeLeft,
					variant = ButtonVariant.Utility,
					size = ButtonSize.Medium,
					onActivated = if not t1.shouldMountAsFullView then t1.onClose else t1.onBack
				})
			})
		})
	})
end

return ExperienceDetailsBottomSheetTopBar
