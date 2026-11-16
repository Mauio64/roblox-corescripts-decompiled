local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)
local t = require(parent.t)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local ReactUtils = require(parent.ReactUtils)
local EventConnection = ReactUtils.EventConnection

local ImageSetComponent = require(parent.UIBlox.Core.ImageSet.ImageSetComponent)
local Images = require(parent.UIBlox.App.ImageSet.Images)
local withStyle = require(parent.UIBlox.Core.Style.withStyle)

local divideTransparency = require(parent.UIBlox.Utility.divideTransparency)

local extended = Roact.PureComponent:extend("SliderTextInput")
extended.validateProps = t.strictInterface({
	position = t.optional(t.union(t.UDim2, t.table)),
	anchorPoint = t.optional(t.Vector2),
	value = t.number,
	min = t.number,
	max = t.number,
	disabled = t.optional(t.boolean),
	stepInterval = t.numberPositive,
	onValueChanged = t.callback,
	layoutOrder = t.optional(t.integer)
})

extended.defaultProps = { disabled = false }

function extended:init()
	self.textBoxRef = Roact.createRef()
end

function extended.render(p)
	return withStyle(function(p2)
		local v = p.props.disabled and 2 or 1
		local textTransparency = divideTransparency(p2.Theme.TextDefault.Transparency, v)

		local imageTransparency = divideTransparency(p2.Theme.Divider.Transparency, v)

		local imageTransparency2 = divideTransparency(p2.Theme.BackgroundUIContrast.Transparency, v)

		return Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			Image = Images["component_assets/circle_16"],
			ImageColor3 = p2.Theme.BackgroundUIContrast.Color,
			ImageTransparency = imageTransparency2,
			Position = p.props.position,
			AnchorPoint = p.props.anchorPoint,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.fromOffset(56, 36),
			SliceCenter = Rect.new(8, 8, 8, 8),
			LayoutOrder = p.props.layoutOrder
		}, {
			Border = Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Image = Images["component_assets/circle_17_stroke_1"],
				ImageColor3 = p2.Theme.Divider.Color,
				ImageTransparency = imageTransparency,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.fromScale(1, 1),
				SliceCenter = Rect.new(8, 8, 8, 8)
			}),
			TextBox = Roact.createElement("TextBox", {
				[Roact.Ref] = p.textBoxRef,
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				FontFace = normalizeFontFace(p2.Font.Body.Font),
				TextSize = p2.Font.Body.RelativeSize * p2.Font.BaseSize,
				TextColor3 = p2.Theme.TextDefault.Color,
				TextTransparency = textTransparency,
				Size = UDim2.fromScale(1, 1),
				Text = tostring(p.props.value),
				TextScaled = true,
				TextEditable = not p.props.disabled,
				ZIndex = 2,
				[Roact.Event.Focused] = p.props.disabled and function(object)
					object:ReleaseFocus()
				end or nil,
				[Roact.Event.FocusLost] = function(p3, _)
					local text = tonumber(p3.Text)

					if text == nil then
						p3.Text = tostring(p.props.value)
						return
					end

					local v2 = math.clamp(
						math.floor(text / p.props.stepInterval + 0.5) * p.props.stepInterval,
						p.props.min,
						p.props.max
					)

					p.props.onValueChanged(v2)
				end
			}, {
				TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
					MinTextSize = p2.Font.Body.RelativeMinSize * p2.Font.BaseSize,
					MaxTextSize = p2.Font.Body.RelativeSize * p2.Font.BaseSize
				})
			}),
			UserInputConnection = not p.props.disabled and Roact.createElement(EventConnection, {
				event = UserInputService.InputBegan,
				callback = function(p3, _)
					if not (p3.UserInputType == Enum.UserInputType.Keyboard and UserInputService:GetFocusedTextBox() == p.textBoxRef.current) then
						return
					end

					local v2 = p3.KeyCode == Enum.KeyCode.Up and 1 or p3.KeyCode == Enum.KeyCode.Down and -1 or 0

					if
						UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
						or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
					then
						v2 *= 10
					end

					if v2 ~= 0 then
						local v3 = math.clamp(
							math.floor((p.props.value + p.props.stepInterval * v2) / p.props.stepInterval + 0.5) * p.props.stepInterval,
							p.props.min,
							p.props.max
						)

						if v3 ~= p.props.value then
							p.props.onValueChanged(v3)
						end
					end
				end
			})
		})
	end)
end

function extended.didMount(p)
	pcall(function()
		p.textBoxRef.current.TextInputType = Enum.TextInputType.Number
	end)
end

return extended
