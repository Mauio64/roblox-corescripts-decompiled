local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local t = dependencies.t
local TextService = dependencies.TextService
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local ControlState = UIBlox.Core.Control.Enum.ControlState
local Interactable = UIBlox.Core.Control.Interactable
local Badge = UIBlox.App.Indicator.Badge
local BadgeStates = UIBlox.App.Indicator.Enum.BadgeStates
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function v20(p1, p2, p3) -- line: 30
	-- upvalues: ControlState (copy)
	local v25 = p1[p2] or p1[ControlState.Default]
	local t1 = {
		Color = p3.Theme[v25].Color,
		Transparency = p3.Theme[v25].Transparency
	}

	if p2 == ControlState.Disabled or p2 == ControlState.Pressed then
		t1.Transparency = 0.5 * t1.Transparency + 0.5
	end

	return t1
end

local v21 = Roact.PureComponent:extend("Pill")

v21.validateProps = t.strictInterface({
	text = t.optional(t.string),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	icon = t.union(t.string, validateImage),
	onActivated = t.callback
})

function v21.init(p4) -- line: 58
	-- upvalues: ControlState (copy)
	p4.state = {
		controlState = ControlState.Initialize
	}

	function p4.onStateChanged(_, p6) -- line: 63
		-- upvalues: p4 (copy)
		p4:setState({
			controlState = p6
		})
	end
end
function v21.render(p7) -- line: 70
	-- upvalues: withStyle (copy), ControlState (copy), v20 (copy), getIconSize (copy), IconSize (copy), TextService (copy), Roact (copy), Interactable (copy), ImageSetLabel (copy), StyledTextLabel (copy), Badge (copy), BadgeStates (copy), Skeleton (copy), EnumsRadius (copy)
	return withStyle(function(p8) -- line: 71
		-- upvalues: p7 (copy), ControlState (copy), v20 (copy), getIconSize (copy), IconSize (copy), TextService (copy), Roact (copy), Interactable (copy), ImageSetLabel (copy), StyledTextLabel (copy), Badge (copy), BadgeStates (copy), Skeleton (copy), EnumsRadius (copy)
		local p8Font = p8.Font
		local isSelected = p7.props.isSelected
		local isDisabled = p7.props.isDisabled
		local isLoading = p7.props.isLoading
		local icon = p7.props.icon
		local text = p7.props.text
		local onActivated = p7.props.onActivated
		local t2 = {
			[ControlState.Default] = not isSelected and "IconDefault" or "SystemPrimaryContent",
			[ControlState.Hover] = not isSelected and "IconEmphasis" or "SystemPrimaryContent"
		}
		local t3 = {
			[ControlState.Default] = not isSelected and "TextDefault" or "SystemPrimaryContent",
			[ControlState.Hover] = not isSelected and "TextEmphasis" or "SystemPrimaryContent"
		}
		local t4 = {
			[ControlState.Default] = not isSelected and "BackgroundUIDefault" or "SystemPrimaryDefault",
			[ControlState.Hover] = not isSelected and "BackgroundUIDefault" or "SystemPrimaryOnHover"
		}
		local v42 = v20(t2, p7.state.controlState, p8)
		local v43 = v20(t3, p7.state.controlState, p8)
		local v44 = v20(t4, p7.state.controlState, p8)
		local v45 = getIconSize(IconSize.Small)
		local v46 = p8Font.CaptionHeader.RelativeSize * p8Font.BaseSize
		local X = TextService:GetTextSize(text, v46, p8Font.CaptionHeader.Font, Vector2.new(10000, 10000)).X
		local v48 = X + 24
		local v49 = 240 - (32 + v45 + 12)

		if isLoading then
			return nil
		end

		return Roact.createElement(Interactable, {
			Size = UDim2.new(0, v48 + 8 + v45 + 12, 0, 28),
			BackgroundColor3 = v44.Color,
			BackgroundTransparency = v44.Transparency,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			isDisabled = isDisabled,
			[Roact.Event.Activated] = not isLoading and onActivated or nil,
			onStateChanged = p7.onStateChanged
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Content = Roact.createElement("Frame", {
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, X + 8 + v45 + 12, 1, 0)
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(v45, v45),
					Image = icon,
					ImageColor3 = v42.Color,
					ImageTransparency = v42.Transparency
				}),
				TextArea = string.len(text) > 0 and Roact.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(X, v46)
				}, {
					PillText = Roact.createElement(StyledTextLabel, {
						text = text,
						fontStyle = p8Font.CaptionHeader,
						colorStyle = v43,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						size = UDim2.fromOffset(v49, v46),
						[Roact.Ref] = p7.PillText
					}),
					Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v49, 28)
					})
				}),
				BadgeFrame = Roact.createElement("Frame", {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(12, 12)
				}, {
					Badge = Roact.createElement(Badge, {
						value = BadgeStates.isEmpty
					})
				}),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(216, 28)
				})
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(240, 28)
			})
		}) or Roact.createElement(Skeleton, {
			Size = UDim2.new(0, v48 + 4 + v45, 0, 28),
			radius = EnumsRadius.Circle
		})
	end)
end

return v21
