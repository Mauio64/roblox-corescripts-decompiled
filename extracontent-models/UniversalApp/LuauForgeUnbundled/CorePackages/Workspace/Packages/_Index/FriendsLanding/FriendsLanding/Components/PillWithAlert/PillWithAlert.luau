local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local roact = dependencies.Roact
local t = dependencies.t
local textService = dependencies.TextService
local uiBlox = dependencies.UIBlox
local foundation = dependencies.Foundation
local radius = foundation.Enums.Radius
local skeleton = foundation.Skeleton

local iconSize = uiBlox.App.ImageSet.Enum.IconSize
local getIconSize = uiBlox.App.ImageSet.getIconSize
local withStyle = uiBlox.Core.Style.withStyle
local validateImage = uiBlox.Core.ImageSet.Validator.validateImage
local controlState = uiBlox.Core.Control.Enum.ControlState
local interactable = uiBlox.Core.Control.Interactable
local badge = uiBlox.App.Indicator.Badge
local badgeStates = uiBlox.App.Indicator.Enum.BadgeStates

local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel

local function fn(p2, controlState2, p3)
	local v5 = p2[controlState2] or p2[controlState.Default]

	local v6 = { Color = p3.Theme[v5].Color, Transparency = p3.Theme[v5].Transparency }

	if controlState2 == controlState.Disabled or controlState2 == controlState.Pressed then
		v6.Transparency = 0.5 * v6.Transparency + 0.5
	end

	return v6
end

local extended = roact.PureComponent:extend("Pill")

extended.validateProps = t.strictInterface({
	text = t.optional(t.string),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	icon = t.union(t.string, validateImage),
	onActivated = t.callback
})

function extended:init()
	self.state = { controlState = controlState.Initialize }

	function self.onStateChanged(p2, p3)
		self:setState({ controlState = p3 })
	end
end

function extended.render(data)
	return withStyle(function(p2)
		local font = p2.Font

		local isSelected = data.props.isSelected
		local isDisabled = data.props.isDisabled
		local isLoading = data.props.isLoading
		local icon = data.props.icon
		local text = data.props.text
		local onActivated = data.props.onActivated

		local v5 = {
			[controlState.Default] = isSelected and "SystemPrimaryContent" or "IconDefault",
			[controlState.Hover] = isSelected and "SystemPrimaryContent" or "IconEmphasis"
		}

		local v6 = {
			[controlState.Default] = isSelected and "SystemPrimaryContent" or "TextDefault",
			[controlState.Hover] = isSelected and "SystemPrimaryContent" or "TextEmphasis"
		}

		local v7 = {
			[controlState.Default] = isSelected and "SystemPrimaryDefault" or "BackgroundUIDefault",
			[controlState.Hover] = isSelected and "SystemPrimaryOnHover" or "BackgroundUIDefault"
		}

		local v8 = fn(v5, data.state.controlState, p2)
		local v9 = fn(v6, data.state.controlState, p2)
		local v10 = fn(v7, data.state.controlState, p2)

		local iconSize2 = getIconSize(iconSize.Small)
		local v11 = font.CaptionHeader.RelativeSize * font.BaseSize
		local x = textService:GetTextSize(text, v11, font.CaptionHeader.Font, Vector2.new(10000, 10000)).X

		local v12 = x + 24
		local v13 = 240 - (32 + iconSize2 + 12)

		if isLoading then
			return nil
		end

		local createElement = roact.createElement
		local onActivatedsByActivated = {
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.new(0, v12 + 8 + iconSize2 + 12, 0, 28),
			BackgroundColor3 = v10.Color,
			BackgroundTransparency = v10.Transparency,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			isDisabled = isDisabled
		}

		local activated = roact.Event.Activated

		if isLoading or not onActivated then
			onActivated = nil
		end

		onActivatedsByActivated[activated] = onActivated
		onActivatedsByActivated.onStateChanged = data.onStateChanged
		local children = {
			UIListLayout = roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Content = 0,
			UICorner = 0,
			UISizeConstraint = 0
		}

		local createElement2 = roact.createElement
		local v16 = {
			Size = UDim2.new(0, x + 8 + iconSize2 + 12, 1, 0),
			ClipsDescendants = true,
			BackgroundTransparency = 1
		}

		local children2 = {
			UIListLayout = roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Icon = roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(iconSize2, iconSize2),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Image = icon,
				ImageColor3 = v8.Color,
				ImageTransparency = v8.Transparency
			}),
			TextArea = 0,
			BadgeFrame = 0,
			UISizeConstraint = 0
		}
		local v17

		if string.len(text) > 0 then
			v17 = roact.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(x, v11),
					LayoutOrder = 3,
					BackgroundTransparency = 1
				},
				{
					PillText = roact.createElement(styledTextLabel, {
						text = text,
						fontStyle = font.CaptionHeader,
						colorStyle = v9,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						size = UDim2.fromOffset(v13, v11),
						[roact.Ref] = data.PillText
					}),
					roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v13, 28)
					})
				}
			)
		else
			v17 = false
		end

		children2.TextArea = v17

		children2.BadgeFrame = roact.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(12, 12),
				LayoutOrder = 4,
				BackgroundTransparency = 1
			},
			{
				Badge = roact.createElement(badge, { value = badgeStates.isEmpty })
			}
		)

		children2.UISizeConstraint = roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(216, 28)
		})
		children.Content = createElement2("Frame", v16, children2)

		children.UICorner = roact.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})

		children.UISizeConstraint = roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(240, 28)
		})
		return createElement(interactable, onActivatedsByActivated, children)
			or roact.createElement(skeleton, {
				Size = UDim2.new(0, v12 + 4 + iconSize2, 0, 28),
				radius = radius.Circle
			})
	end)
end

return extended
