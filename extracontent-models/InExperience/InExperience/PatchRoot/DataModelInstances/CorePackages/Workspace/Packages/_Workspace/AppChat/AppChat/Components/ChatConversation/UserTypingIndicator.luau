local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Otter = require(parent.Otter)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local UIBlox2 = require(parent.UIBlox)
local Images = UIBlox2.App.ImageSet.Images
local ImageSetLabel = UIBlox2.Core.ImageSet.ImageSetLabel
local MessageCharacterLimit = require(script.Parent.MessageCharacterLimit)

local extended = Roact.PureComponent:extend("UserTypingIndicator")

local v = { dampingRatio = 1.5, frequency = 1.6 }

extended.defaultProps = {
	AnchorPoint = Vector2.new(0, 0),
	LayoutOrder = 1,
	Position = UDim2.new(0, 0, 0, 0),
	ZIndex = 1,
	usersTyping = {},
	oneUserTyping = "PLACEHOLDER {DISPLAY_NAME} is typing...",
	twoUsersTyping = "PLACEHOLDER {DISPLAY_NAME_1} and {DISPLAY_NAME_2} are typing...",
	severalUsersTyping = "PLACEHOLDER Several users are typing...",
	maxCharacterLength = MessageCharacterLimit,
	height = 40
}

function extended:init()
	function self.getDisplayText()
		if not self.props.usersTyping then
			return ""
		end

		if #self.props.usersTyping == 1 then
			return self.props.oneUserTyping
		end

		if #self.props.usersTyping == 2 then
			return self.props.twoUsersTyping
		end

		if #self.props.usersTyping > 2 then
			return self.props.severalUsersTyping
		end

		return ""
	end

	local binding, v2 = Roact.createBinding(1)

	self.motor = Otter.createSingleMotor(1)
	self.motor:start()

	self.motor:onStep(v2)
	self.animationProgress = binding

	function self.updateAnimationGoal()
		local v3 = #self.props.usersTyping > 0 and 0 or 1
		self.motor:setGoal(Otter.spring(v3, v))
	end

	self.updateAnimationGoal()
end

function extended.didUpdate(p, p2, _)
	if #p2.usersTyping ~= #p.props.usersTyping then
		p.updateAnimationGoal()
	end
end

function extended.render(data)
	return withStyle(function(props)
		local font = props.Font
		local textSize = font.BaseSize * font.Footer.RelativeSize

		return Roact.createElement("Frame", {
			AnchorPoint = data.props.AnchorPoint,
			BackgroundTransparency = 1,
			LayoutOrder = data.props.LayoutOrder,
			Position = data.props.Position,
			Size = UDim2.new(1, 0, 0, data.props.height),
			ZIndex = data.props.ZIndex
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
				Size = UDim2.new(0.9, 0, 1, 0),
				BackgroundColor3 = props.Theme.NavigationBar.Color,
				BorderColor3 = props.Theme.Divider.Color,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Image = Images["component_assets/circle_17"],
				ImageColor3 = props.Theme.BackgroundUIDefault.Color,
				ImageTransparency = data.animationProgress:map(function(p)
					return p
				end),
				Position = data.animationProgress:map(function(p)
					return UDim2.new(0, 0, p, 0)
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
					Text = data.getDisplayText(),
					TextSize = textSize,
					FontFace = normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font),
					TextColor3 = props.Theme.TextMuted.Color,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					BackgroundTransparency = 1,
					TextTransparency = data.animationProgress:map(function(p)
						return p
					end)
				})
			})
		})
	end)
end

function extended.willUnmount(p)
	if p.motor then
		p.motor:destroy()
	end
end

return extended
