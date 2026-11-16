local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Otter")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local MessageCharacterLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageCharacterLimit")

local extended = Roact.PureComponent:extend("UserTypingIndicator")

local v5 = { dampingRatio = 1.5, frequency = 1.6 }

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

	local binding, v6 = Roact.createBinding(1)

	self.motor = Otter.createSingleMotor(1)
	self.motor:start()

	self.motor:onStep(v6)
	self.animationProgress = binding

	function self.updateAnimationGoal()
		local v7 = #self.props.usersTyping > 0 and 0 or 1
		self.motor:setGoal(Otter.spring(v7, v5))
	end

	self.updateAnimationGoal()
end

function extended.didUpdate(p2, p3, p4)
	if #p3.usersTyping ~= #p2.props.usersTyping then
		p2.updateAnimationGoal()
	end
end

function extended.render(data)
	return withStyle(function(props)
		local font = props.Font
		local font2 = font.Footer.Font
		local v6 = font.BaseSize * font.Footer.RelativeSize

		local createElement = Roact.createElement
		local v8 = {
			AnchorPoint = data.props.AnchorPoint,
			BackgroundTransparency = 1,
			LayoutOrder = data.props.LayoutOrder,
			Position = data.props.Position,
			Size = UDim2.new(1, 0, 0, data.props.height),
			ZIndex = data.props.ZIndex
		}
		local v9 = {
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
			ImageContainer = 0
		}

		local createElement2 = Roact.createElement
		local v11 = {
			Size = UDim2.new(0.9, 0, 1, 0),
			BackgroundColor3 = props.Theme.NavigationBar.Color,
			BorderColor3 = props.Theme.Divider.Color,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			Image = images["component_assets/circle_17"],
			ImageColor3 = props.Theme.BackgroundUIDefault.Color,
			ImageTransparency = data.animationProgress:map(function(p2)
				return p2
			end),
			Position = data.animationProgress:map(function(p2)
				return UDim2.new(0, 0, p2, 0)
			end)
		}

		local v12 = {
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
			TextLabel = 0
		}

		local createElement3 = Roact.createElement
		local v14 = {
			Text = data.getDisplayText(),
			TextSize = v6,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			BackgroundTransparency = 1,
			TextTransparency = 0
		}

		if foundationFontFaceMigration then
			font2 = nil
		end

		v14.Font = font2

		local v15 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font) else nil
		v14.FontFace = v15

		v14.TextColor3 = props.Theme.TextMuted.Color
		v14.TextXAlignment = Enum.TextXAlignment.Left
		v14.TextYAlignment = Enum.TextYAlignment.Center

		v14.TextTransparency = data.animationProgress:map(function(p2)
			return p2
		end)
		v12.TextLabel = createElement3("TextLabel", v14)
		v9.ImageContainer = createElement2(imageSetLabel, v11, v12)
		return createElement("Frame", v8, v9)
	end)
end

function extended.willUnmount(p2)
	if p2.motor then
		p2.motor:destroy()
	end
end

return extended
