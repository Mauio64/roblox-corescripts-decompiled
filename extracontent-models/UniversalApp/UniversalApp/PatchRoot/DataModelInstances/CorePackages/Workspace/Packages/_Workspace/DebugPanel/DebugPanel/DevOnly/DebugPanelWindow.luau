local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("DebugPanel").Parent
local Dash = require(Parent.Dash)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local uDim2 = UDim2.new(0, 16, 0, 80)

local function useDragInput(p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 64
	-- upvalues: React (copy), UserInputService (copy)
	local v17 = React.useRef(p1)
	local v18 = React.useRef(p2)

	v17.current = p1
	v18.current = p2

	return React.useCallback(function(_, p4) -- line: 73
		-- upvalues: v17 (copy), UserInputService (copy), v18 (copy)
		if p4.UserInputType ~= Enum.UserInputType.MouseButton1 and p4.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local p4Position = p4.Position
		local v43 = v17.current()
		local connection = nil
		local connection2 = UserInputService.InputChanged:Connect(function(input) -- line: 86
			-- upvalues: v18 (copy), p4Position (copy), v43 (copy)
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			v18.current(input.Position - p4Position + v43)
		end)

		connection = p4.Changed:Connect(function(property: string) -- line: 96
			-- upvalues: p4 (copy), connection2 (ref), connection (ref)
			if property == "UserInputState" and p4.UserInputState == Enum.UserInputState.End then
				if connection2 then
					connection2:Disconnect()
				end

				if connection then
					connection:Disconnect()
				end
			end
		end)
	end, {})
end
local function DebugPanelWindow(t1: {[any]: any}) -- line: 109
	-- upvalues: useTokens (copy), React (copy), uDim2 (copy), useDragInput (copy), View (copy), FoundationText (copy), Foundation (copy), Icon (copy), IconName (copy), IconSize (copy), Dash (copy)
	local v20 = useTokens()
	local v21, v22 = React.useBinding(t1.initialPosition or uDim2)
	local v23, v24 = React.useBinding(t1.width or 280)
	local v25, v26 = React.useBinding(400)
	local v27, v28 = React.useState(t1.defaultCollapsed == true)
	local v29, v30 = React.useState(false)
	local Surface_100 = v20.Color.Surface.Surface_100
	local Surface_200 = v20.Color.Surface.Surface_200
	local Surface_300 = v20.Color.Surface.Surface_300
	local Surface_0 = v20.Color.Surface.Surface_0
	local Small = v20.Padding.Small
	local v36 = React.useCallback(function() -- line: 124
		-- upvalues: v28 (copy)
		v28(function(p5) -- line: 125
			return not p5
		end)
	end, {})
	local v37 = useDragInput(function() -- line: 130
		-- upvalues: v21 (copy)
		local v46 = v21:getValue()

		return (Vector3.new(v46.X.Offset, v46.Y.Offset, 0))
	end, function(vector3: Vector3) -- line: 133
		-- upvalues: v21 (copy), v22 (copy)
		local v48 = v21:getValue()

		v22(UDim2.new(v48.X.Scale, vector3.X, v48.Y.Scale, vector3.Y))
	end)
	local v38 = useDragInput(function() -- line: 138
		-- upvalues: v23 (copy), v25 (copy)
		return (Vector3.new(v23:getValue(), v25:getValue(), 0))
	end, function(vector3: Vector3) -- line: 140
		-- upvalues: v24 (copy), v26 (copy)
		v24((math.max(200, vector3.X)))
		v26((math.max(100, vector3.Y)))
	end)
	local v39 = React.joinBindings({
		v23,
		v25
	}):map(function(p6) -- line: 145
		-- upvalues: v27 (copy), Small (copy)
		if v27 then
			return UDim2.new(0, p6[1], 0, 22 + Small * 2)
		end

		return UDim2.new(0, p6[1], 0, p6[2])
	end)

	return React.createElement("ScreenGui", {
		DisplayOrder = 10000,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		Name = t1.screenGuiName or "DevDebugPanel",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Panel = React.createElement(View, {
			ClipsDescendants = true,
			Position = v21,
			Size = v39,
			backgroundStyle = {
				Transparency = 0.05,
				Color3 = Surface_100.Color3
			},
			cornerRadius = UDim.new(0, v20.Radius.Medium),
			stroke = {
				Color = Surface_0.Color3,
				Thickness = v20.Stroke.Standard
			},
			padding = Small
		}, {
			Header = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundColor3 = Surface_200.Color3,
				BackgroundTransparency = not v29 and 1 or 0.4,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Active = true,
				[React.Event.InputBegan] = v37,
				[React.Event.MouseEnter] = function() -- line: 180
					-- upvalues: v30 (copy)
					v30(true)
				end,
				[React.Event.MouseLeave] = function() -- line: 183
					-- upvalues: v30 (copy)
					v30(false)
				end
			}, {
				HeaderPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v20.Padding.XXSmall)
				}),
				TitleLabel = React.createElement(FoundationText, {
					tag = "text-label-small content-emphasis",
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, -26, 1, 0),
					Text = t1.title
				}),
				CollapseButton = React.createElement(View, {
					ClipsDescendants = true,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 22, 0, 22),
					backgroundStyle = {
						Transparency = 0,
						Color3 = Surface_300.Color3
					},
					cornerRadius = UDim.new(0, v20.Radius.Small),
					onActivated = v36,
					stateLayer = {
						mode = Foundation.Enums.StateLayerMode.Inverse
					}
				}, {
					CollapseIcon = React.createElement(Icon, {
						tag = "content-emphasis",
						name = if not v27 then IconName.MinusSmall else IconName.PlusSmall,
						size = IconSize.Small,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					})
				})
			}),
			Body = React.createElement("ScrollingFrame", {
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Visible = not v27,
				Position = UDim2.new(0, 0, 0, 22 + Small),
				Size = UDim2.new(1, 0, 1, -(22 + Small)),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = v20.Radius.Small,
				ScrollBarImageColor3 = v20.Color.Surface.Surface_300.Color3,
				BackgroundColor3 = v20.Color.Surface.Surface_0.Color3,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}, Dash.join({
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v20.Radius.Small)
				}),
				BodyPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v20.Padding.Small),
					PaddingBottom = UDim.new(0, v20.Padding.Small),
					PaddingLeft = UDim.new(0, v20.Padding.Small),
					PaddingRight = UDim.new(0, v20.Padding.Small)
				}),
				Layout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, Small),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				})
			}, t1.children)),
			ResizeHandle = React.createElement("TextButton", {
				Visible = not v27,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, Small, 1, Small),
				Size = UDim2.new(0, 16, 0, 16),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				[React.Event.InputBegan] = v38
			}, {
				ResizeIcon = React.createElement(Icon, {
					tag = "content-emphasis",
					Rotation = -45,
					name = IconName.ChevronSmallDown,
					size = IconSize.Medium,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})
			})
		})
	})
end

return DebugPanelWindow
