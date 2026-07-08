local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local EventConnection = require(ParentParent.ReactUtils).EventConnection
local ImageSetComponent = require(ParentParent.UIBlox.Core.ImageSet.ImageSetComponent)
local Images = require(ParentParent.UIBlox.App.ImageSet.Images)
local withStyle = require(ParentParent.UIBlox.Core.Style.withStyle)
local divideTransparency = require(ParentParent.UIBlox.Utility.divideTransparency)
local v10 = Roact.PureComponent:extend("SliderTextInput")

v10.validateProps = t.strictInterface({
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
v10.defaultProps = {
	disabled = false
}

function v10.init(p1) -- line: 37
	-- upvalues: Roact (copy)
	p1.textBoxRef = Roact.createRef()
end
function v10.render(p2) -- line: 41
	-- upvalues: withStyle (copy), divideTransparency (copy), Roact (copy), ImageSetComponent (copy), Images (copy), EventConnection (copy), UserInputService (copy)
	return withStyle(function(p3) -- line: 42
		-- upvalues: p2 (copy), divideTransparency (copy), Roact (copy), ImageSetComponent (copy), Images (copy), EventConnection (copy), UserInputService (copy)
		local v15 = not p2.props.disabled and 1 or 2
		local v16 = divideTransparency(p3.Theme.TextDefault.Transparency, v15)
		local v17 = divideTransparency(p3.Theme.Divider.Transparency, v15)
		local v18 = divideTransparency(p3.Theme.BackgroundUIContrast.Transparency, v15)

		return Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			Image = Images["component_assets/circle_16"],
			ImageColor3 = p3.Theme.BackgroundUIContrast.Color,
			ImageTransparency = v18,
			Position = p2.props.position,
			AnchorPoint = p2.props.anchorPoint,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.fromOffset(56, 36),
			SliceCenter = Rect.new(8, 8, 8, 8),
			LayoutOrder = p2.props.layoutOrder
		}, {
			Border = Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Image = Images["component_assets/circle_17_stroke_1"],
				ImageColor3 = p3.Theme.Divider.Color,
				ImageTransparency = v17,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.fromScale(1, 1),
				SliceCenter = Rect.new(8, 8, 8, 8)
			}),
			TextBox = Roact.createElement("TextBox", {
				[Roact.Ref] = p2.textBoxRef,
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				Font = p3.Font.Body.Font,
				TextSize = p3.Font.Body.RelativeSize * p3.Font.BaseSize,
				TextColor3 = p3.Theme.TextDefault.Color,
				TextTransparency = v16,
				Size = UDim2.fromScale(1, 1),
				Text = tostring(p2.props.value),
				TextScaled = true,
				TextEditable = not p2.props.disabled,
				ZIndex = 2,
				[Roact.Event.Focused] = p2.props.disabled and function(p4) -- line: 86
					p4:ReleaseFocus()
				end or nil,
				[Roact.Event.FocusLost] = function(p5, _) -- line: 89
					-- upvalues: p2 (copy)
					local num = tonumber(p5.Text)

					if num == nil then
						p5.Text = tostring(p2.props.value)

						return
					end

					local v23 = math.clamp(math.floor(num / p2.props.stepInterval + 0.5) * p2.props.stepInterval, p2.props.min, p2.props.max)

					p2.props.onValueChanged(v23)
				end
			}, {
				TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
					MinTextSize = p3.Font.Body.RelativeMinSize * p3.Font.BaseSize,
					MaxTextSize = p3.Font.Body.RelativeSize * p3.Font.BaseSize
				})
			}),
			UserInputConnection = not p2.props.disabled and Roact.createElement(EventConnection, {
				event = UserInputService.InputBegan,
				callback = function(p7, _) -- line: 113
					-- upvalues: UserInputService (copy), p2 (copy)
					if p7.UserInputType ~= Enum.UserInputType.Keyboard then
						return
					end

					if UserInputService:GetFocusedTextBox() ~= p2.textBoxRef.current then
						return
					end

					local n1 = 0

					if p7.KeyCode == Enum.KeyCode.Up then
						n1 = 1
					elseif p7.KeyCode == Enum.KeyCode.Down then
						n1 = -1
					end

					if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
						n1 *= 10
					end

					if n1 ~= 0 then
						local v27 = math.clamp(math.floor((p2.props.value + p2.props.stepInterval * n1) / p2.props.stepInterval + 0.5) * p2.props.stepInterval, p2.props.min, p2.props.max)

						if v27 ~= p2.props.value then
							p2.props.onValueChanged(v27)
						end
					end
				end
			})
		})
	end)
end
function v10.didMount(p9) -- line: 154
	pcall(function() -- line: 157
		-- upvalues: p9 (copy)
		p9.textBoxRef.current.TextInputType = Enum.TextInputType.Number
	end)
end

return v10
