local TweenService = game:GetService("TweenService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(Parent.ExpChatShared)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local PresetCooldownContext = require(script.Parent.PresetCooldownContext)
local v7 = ExpChatShared.Flags.FIntPresetChatCooldownLuaMs / 1000

local function PresetMessageButton(t1: {[any]: any}) -- line: 21
	-- upvalues: Foundation (copy), React (copy), PresetCooldownContext (copy), v7 (copy), TweenService (copy)
	local v10 = Foundation.Hooks.useTokens()
	local Circle = v10.Radius.Circle
	local v12 = React.useContext(PresetCooldownContext)
	local v13 = v12 ~= nil and v12.isCooldownActive
	local v14 = if v12 == nil then nil else v12.endsAt
	local v15 = React.useCallback(function() -- line: 28
		-- upvalues: t1 (copy)
		t1.onActivated(t1.presetId)
	end, {
		t1.onActivated,
		t1.presetId
	})
	local v16, v17 = React.useState(nil)
	local v18 = React.useRef(nil)
	local v19 = React.useCallback(function(p1) -- line: 35
		-- upvalues: v16 (copy), v17 (copy)
		if v16 == nil and (p1 and p1.AbsoluteSize.X > 0) then
			v17(p1.AbsoluteSize)
		end
	end, { v16 })

	React.useEffect(function() -- line: 41
		-- upvalues: v14 (copy), v16 (copy), v18 (copy), v7 (copy), TweenService (copy)
		if v14 == nil or v16 == nil then
			return
		end

		local current = v18.current

		if current == nil then
			return
		end

		local v22 = v14 - os.clock()

		if v22 <= 0 then
			return
		end

		local v23 = math.clamp(v22 / v7, 0, 1)

		current.Size = UDim2.fromOffset(v16.X * v23, v16.Y)

		local tween = TweenService:Create(current, TweenInfo.new(v22, Enum.EasingStyle.Linear), {
			Size = UDim2.fromOffset(0, v16.Y)
		})

		tween:Play()

		return function() -- line: 59
			-- upvalues: tween (copy)
			tween:Cancel()
			tween:Destroy()
		end
	end, {
		v14,
		v16
	})

	return React.createElement(Foundation.View, {
		tag = "size-0-800 auto-x radius-circle clip",
		onAbsoluteSizeChanged = v19,
		LayoutOrder = t1.layoutOrder or 0,
		backgroundStyle = v10.Color.ActionStandard.Background,
		onActivated = v15,
		isDisabled = v13,
		cursor = {
			radius = UDim.new(0, Circle),
			offset = math.floor(v10.Stroke.Thicker) * 2,
			borderWidth = math.floor(v10.Stroke.Thicker)
		},
		ref = t1.buttonRef
	}, {
		CooldownClipFrame = if not v13 or (v14 == nil or v16 == nil) then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			ZIndex = 1,
			ref = v18,
			Size = UDim2.fromOffset(v16.X, v16.Y)
		}, {
			CooldownOverlay = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, v16.X, 1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v10.Color.Shift.Shift_400.Color3,
				BackgroundTransparency = v10.Color.Shift.Shift_400.Transparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, Circle)
				})
			})
		}),
		Text = React.createElement(Foundation.Text, {
			tag = "size-0-full auto-x text-label-medium",
			ZIndex = 2,
			Text = t1.text,
			textStyle = v10.Color.ActionStandard.Foreground,
			padding = {
				left = UDim.new(0, v10.Padding.Medium),
				right = UDim.new(0, v10.Padding.Medium)
			}
		})
	})
end

return React.memo(PresetMessageButton)
