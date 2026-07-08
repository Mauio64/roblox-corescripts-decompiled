local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local withStyle = require(Parent.UIBlox).Style.withStyle
local Otter = require(Parent.Otter)
local UIBlox = require(Parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v8 = Roact.PureComponent:extend("UserTypingIndicator")
local t1 = {
	dampingRatio = 1.5,
	frequency = 1.6
}

v8.defaultProps = {
	LayoutOrder = 1,
	ZIndex = 1,
	oneUserTyping = "PLACEHOLDER {DISPLAY_NAME} is typing...",
	twoUsersTyping = "PLACEHOLDER {DISPLAY_NAME_1} and {DISPLAY_NAME_2} are typing...",
	severalUsersTyping = "PLACEHOLDER Several users are typing...",
	maxCharacterLength = 160,
	height = 40,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0),
	usersTyping = {}
}

function v8.init(p1) -- line: 32
	-- upvalues: Roact (copy), Otter (copy), t1 (copy)
	function p1.getDisplayText() -- line: 33
		-- upvalues: p1 (copy)
		if p1.props.usersTyping then
			if #p1.props.usersTyping == 1 then
				return p1.props.oneUserTyping
			end

			if #p1.props.usersTyping == 2 then
				return p1.props.twoUsersTyping
			end

			if #p1.props.usersTyping > 2 then
				return p1.props.severalUsersTyping
			end
		end

		return ""
	end

	local v11, v12 = Roact.createBinding(1)

	p1.motor = Otter.createSingleMotor(1)
	p1.motor:start()
	p1.motor:onStep(v12)
	p1.animationProgress = v11

	function p1.updateAnimationGoal() -- line: 54
		-- upvalues: p1 (copy), Otter (copy), t1 (copy)
		local v18 = not (#p1.props.usersTyping > 0) and 1 or 0

		p1.motor:setGoal(Otter.spring(v18, t1))
	end

	p1.updateAnimationGoal()
end
function v8.didUpdate(p2, p3, _) -- line: 62
	if #p3.usersTyping ~= #p2.props.usersTyping then
		p2.updateAnimationGoal()
	end
end
function v8.render(p5) -- line: 68
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), Images (copy)
	return withStyle(function(p6) -- line: 69
		-- upvalues: Roact (copy), p5 (copy), ImageSetLabel (copy), Images (copy)
		local p6Font = p6.Font
		local FooterFont = p6Font.Footer.Font
		local v22 = p6Font.BaseSize * p6Font.Footer.RelativeSize

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = p5.props.AnchorPoint,
			LayoutOrder = p5.props.LayoutOrder,
			Position = p5.props.Position,
			Size = UDim2.new(1, 0, 0, p5.props.height),
			ZIndex = p5.props.ZIndex
		}, {
			Layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4)
			}),
			ImageContainer = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0.9, 0, 1, 0),
				BackgroundColor3 = p6.Theme.NavigationBar.Color,
				BorderColor3 = p6.Theme.Divider.Color,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Image = Images["component_assets/circle_17"],
				ImageColor3 = p6.Theme.BackgroundUIDefault.Color,
				ImageTransparency = p5.animationProgress:map(function(p7) -- line: 104
					return p7
				end),
				Position = p5.animationProgress:map(function(p8) -- line: 107
					return UDim2.new(0, 0, p8, 0)
				end)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 4),
					PaddingBottom = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 12)
				}),
				TextLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = p5.getDisplayText(),
					TextSize = v22,
					Font = FooterFont,
					TextColor3 = p6.Theme.TextMuted.Color,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextTransparency = p5.animationProgress:map(function(p9) -- line: 133
						return p9
					end)
				})
			})
		})
	end)
end
function v8.willUnmount(p10) -- line: 142
	if p10.motor then
		p10.motor:destroy()
	end
end

return v8
