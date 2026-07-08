local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local function isFullWidth(n1: number) -- line: 53
	return n1 < 540
end
local function getAnchorPoint(vector2: Vector2) -- line: 57
	if vector2.X < 540 then
		return Vector2.new(0.5, 1)
	end

	return Vector2.new(0, 0)
end
local function getSize(vector2: Vector2, n2: number, n3: number) -- line: 65
	if vector2.X < 540 then
		return UDim2.new(0, vector2.X, 0, n3)
	end

	return UDim2.new(0, n2, 0, vector2.Y)
end
local function getPosition(vector2: Vector2, n4: number) -- line: 73
	if vector2.X < 540 then
		return UDim2.new(0.5, 0, 1, 0)
	end

	return UDim2.new(1, -n4, 0, 0)
end
local function SideModal(t2: {[any]: any}) -- line: 81
	-- upvalues: useTokens (copy), React (copy), getAnchorPoint (copy), getSize (copy), getPosition (copy), ReactOtter (copy), t1 (copy), View (copy), IconButton (copy), IconSize (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), FillBehavior (copy)
	local v28 = useTokens()
	local v29, v30 = React.useState(getAnchorPoint(t2.screenSize))
	local v31, v32 = React.useState(getSize(t2.screenSize, t2.width, t2.height))
	local v33, v34 = React.useState(getPosition(t2.screenSize, t2.width))
	local v35, v36 = React.useState(true)
	local v37, v38 = React.useState(false)
	local v39 = React.useMemo(function() -- line: 90
		-- upvalues: t2 (copy)
		if t2.footerContent then
			return (t2.footerContent())
		end

		return nil
	end, { t2.footerContent })
	local v40 = not v39 and 0 or 35
	local v41, v42 = ReactOtter.useAnimatedBinding(1, function() -- line: 95
		-- upvalues: v35 (copy), v37 (copy), t2 (copy)
		if not v35 then
			if v37 then
				if t2.buttonProps then
					t2.buttonProps.onActivated()

					return
				end
			elseif t2.onAbandon then
				t2.onAbandon()
			end
		end
	end)
	local v43 = React.useMemo(function() -- line: 110
		-- upvalues: v35 (copy)
		if v35 then
			return 0
		end

		return 1
	end, { v35 })

	React.useEffect(function() -- line: 114
		-- upvalues: t2 (copy), v36 (copy)
		if t2.closeWithAnimation then
			v36(false)
		end
	end, { t2.closeWithAnimation })
	React.useEffect(function() -- line: 120
		-- upvalues: v42 (copy), ReactOtter (copy), v43 (copy), t1 (copy)
		v42(ReactOtter.spring(v43, t1))
	end, { v43 })
	React.useEffect(function() -- line: 124
		-- upvalues: v30 (copy), getAnchorPoint (copy), t2 (copy), v32 (copy), getSize (copy), v34 (copy), getPosition (copy)
		v30(getAnchorPoint(t2.screenSize))
		v32(getSize(t2.screenSize, t2.width, t2.height))
		v34(getPosition(t2.screenSize, t2.width))
	end, { t2.screenSize })

	local v44 = React.useCallback(function() -- line: 130
		-- upvalues: v36 (copy)
		v36(false)
	end, { v36 })
	local v45 = React.useCallback(function() -- line: 134
		-- upvalues: t2 (copy), v38 (copy), v36 (copy)
		if t2.buttonProps and (t2.buttonProps.validateState and not t2.buttonProps.validateState()) then
			return
		end

		v38(true)
		v36(false)
	end, {
		v36,
		v38,
		t2.buttonProps
	})

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v41:map(function(n5: number) -- line: 148
			return n5 + 0.3
		end),
		BackgroundColor3 = Color3.fromHex("#000000"),
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[React.Event.Activated] = v44
	}, {
		SideModalContainer = React.createElement(View, {
			tag = "size-full",
			AnchorPoint = Vector2.new(1, 0),
			Position = v41:map(function(n6: number) -- line: 160
				-- upvalues: t2 (copy)
				if t2.screenSize.X < 540 then
					return (UDim2.new(1, 0, 0, t2.height * n6))
				end

				return (UDim2.new(1, t2.width * n6, 0, 0))
			end)
		}, {
			SideModal = React.createElement(View, {
				tag = "bg-surface-300 radius-medium col",
				AnchorPoint = v29,
				Position = v33,
				Size = v31
			}, {
				IconRow = React.createElement(View, {
					tag = "padding-left-medium",
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 32)
				}, {
					IconButton = React.createElement(IconButton, {
						icon = "icons/navigation/pushBack",
						tag = "anchor-center-left position-center-left",
						size = IconSize.Medium,
						onActivated = v44
					})
				}),
				TitleRow = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 32)
				}, {
					Title = React.createElement(FoundationText, {
						TextWrapped = true,
						tag = "auto-xy",
						fontStyle = v28.Typography.TitleLarge,
						textStyle = v28.Color.Content.Emphasis,
						Text = t2.title,
						Size = UDim2.new(1, 0, 0, 32)
					})
				}),
				Content = React.createElement(View, {
					ClipsDescendants = true,
					tag = "padding-x-medium",
					LayoutOrder = 2,
					Size = if not t2.buttonProps then UDim2.new(1, 0, 1, -84 - v40) else UDim2.new(1, 0, 1, -116 - v40)
				}, {
					MiddleContent = React.createElement(View, {
						tag = "size-full"
					}, t2.children)
				}),
				ButtonRow = t2.buttonProps and React.createElement(View, {
					tag = "padding-x-medium padding-bottom-medium",
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 32)
				}, {
					Button = React.createElement(Button, {
						isDisabled = false,
						text = t2.buttonProps.text,
						variant = ButtonVariant.Emphasis,
						onActivated = v45,
						size = ButtonSize.Small,
						fillBehavior = FillBehavior.Fill
					})
				}),
				BottomFrame = if not t2.footerContent then nil else React.createElement(View, {
					tag = "padding-x-medium padding-bottom-medium",
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 32),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					FooterContent = v39
				})
			})
		})
	})
end

return SideModal
