local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Cryo = require(ParentParentParentParent.Cryo)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local ControllerBarHint = require(script.Parent.ControllerBarHint)
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local ControllerBarHintInternalPadding = require(script.Parent.BarConstants).ControllerBarHintInternalPadding
local DefaultKeyLabelSize = require(ParentParent.Menu.MenuConstants).DefaultKeyLabelSize
local v12 = Roact.PureComponent:extend("ControllerBar")
local v13 = t.strictInterface({
	keyCode = t.enum(Enum.KeyCode),
	text = t.string
})

v12.validateProps = t.strictInterface({
	leftHint = v13,
	rightHints = t.optional(t.map(t.number, v13))
})

function v12.init(p1) -- line: 46
	p1.state = {
		controllerBarWidth = 0,
		hintStringsConcat = nil,
		requiredSpace = nil,
		hintRatios = nil
	}
end
function v12.calculateHintRatios(p2, p3) -- line: 56
	-- upvalues: Cryo (copy), GetTextSize (copy), DefaultKeyLabelSize (copy), ControllerBarHintInternalPadding (copy)
	local n1 = 84
	local s1 = ""
	local t1 = {}
	local n2 = 0
	local v21 = Cryo.List.join({ p2 }, p3 or {})

	for _, v in ipairs(v21) do
		t1[v.text] = GetTextSize(v.text, 17, Enum.Font.ArialBold, Vector2.new(10000, 10000)).X
		n2 += t1[v.text]
		n1 = n1 + DefaultKeyLabelSize + ControllerBarHintInternalPadding
		s1 ..= v.text
	end

	for k, v in pairs(t1) do
		t1[k] = v / n2
	end

	return t1, n1 + math.max(#v21 - 2, 0) * 40, s1
end
function v12.getDerivedStateFromProps(p4) -- line: 92
	-- upvalues: v12 (copy)
	local v27, v28, v29 = v12.calculateHintRatios(p4.leftHint, p4.rightHints)

	return {
		hintRatios = v27,
		requiredSpace = v28,
		hintStringsConcat = v29
	}
end
function v12.calculateHintSize(p5, p6, p7) -- line: 103
	-- upvalues: GetTextSize (copy)
	local v33 = p6 - p5.state.requiredSpace
	local v34 = p7.Header2.RelativeSize * p7.BaseSize
	local v35 = p7.Header2.RelativeMinSize * p7.BaseSize
	local X = GetTextSize(p5.state.hintStringsConcat, v35, p7.Header2.Font, Vector2.new(10000, 10000)).X

	if X <= v33 then
		local X2 = GetTextSize(p5.state.hintStringsConcat, v34, p7.Header2.Font, Vector2.new(10000, 10000)).X
		local v38 = (v34 - v35) / (X2 - X)
		local v39 = v34 - v38 * X2

		return nil, (math.clamp(v33 * v38 + v39, v35, v34))
	end

	local t2 = {}

	for k, v in pairs(p5.state.hintRatios) do
		t2[k] = v * v33
	end

	return t2
end
function v12.render(p8) -- line: 142
	-- upvalues: withStyle (copy), Cryo (copy), Roact (copy), ControllerBarHint (copy)
	return withStyle(function(p9) -- line: 143
		-- upvalues: p8 (copy), Cryo (copy), Roact (copy), ControllerBarHint (copy)
		local Theme = p9.Theme
		local v46, v47 = p8:calculateHintSize(p8.state.controllerBarWidth, p9.Font)

		local function makeHint(p10, p11) -- line: 148
			-- upvalues: Cryo (copy), v47 (copy), v46 (copy), Roact (copy), ControllerBarHint (copy)
			local v52 = Cryo.Dictionary.join(p10, {
				key = "Hint" .. tostring(p11),
				hintTextSize = v47,
				maxWidth = v46 and v46[p10.text] or nil
			})

			return Roact.createElement(ControllerBarHint, v52)
		end

		local v49 = nil

		if p8.props.rightHints then
			v49 = Roact.createFragment(Cryo.List.map(p8.props.rightHints, makeHint))
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = Theme.BackgroundUIContrast.Transparency,
			BackgroundColor3 = Theme.BackgroundUIContrast.Color,
			Size = UDim2.new(1, 0, 0, 72),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			[Roact.Change.AbsoluteSize] = function(p12) -- line: 171
				-- upvalues: p8 (copy)
				p8:setState({
					controllerBarWidth = p12.AbsoluteSize.X
				})
			end,
			[Roact.Event.AncestryChanged] = function(p13) -- line: 176
				-- upvalues: p8 (copy)
				p8:setState({
					controllerBarWidth = p13.AbsoluteSize.X
				})
			end
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			LeftFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.5, 1)
			}, {
				Roact.createElement("UIListLayout", {
					key = "Layout",
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 40)
				}),
				makeHint(p8.props.leftHint, "Left")
			}),
			RightFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.5, 1),
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 40)
				}),
				RightHints = v49
			})
		})
	end)
end

return v12
