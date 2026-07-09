local Parent = script:FindFirstAncestor("PeekView").Parent
local Cryo = require(Parent.Cryo)
local Roact = require(Parent.Roact)
local Immutable = require(Parent.AppCommonLib).Immutable
local Symbol = require(Parent.AppCommonLib).Symbol
local t1 = {
	FitAxis = {
		Width = Symbol.named("Width"),
		Height = Symbol.named("Height"),
		Both = Symbol.named("Both")
	}
}

function t1.wrap(p1) -- line: 23
	-- upvalues: Roact (copy), t1 (copy), Immutable (copy), Cryo (copy)
	local v8 = Roact.PureComponent:extend(("FitChildren(%s)"):format((tostring(p1))))

	function v8.disconnectSignals(p2) -- line: 26
		for _, v in ipairs(p2.signals) do
			v:Disconnect()
		end
	end
	function v8.resize(p3) -- line: 32
		-- upvalues: t1 (copy)
		local u13 = p3.props.fitFields or if not p3.props.fitAxis then {
			Size = t1.FitAxis.Both
		} else {
			Size = p3.props.fitAxis
		}

		p3:disconnectSignals()
		p3.signals = {}

		local current = p3.ref.current

		if current == nil then
			return
		end

		local UIGridStyleLayout = current:FindFirstChildWhichIsA("UIGridStyleLayout")

		if UIGridStyleLayout then
			local function update() -- line: 59
				-- upvalues: UIGridStyleLayout (copy), p3 (copy), u13 (ref)
				local AbsoluteContentSize = UIGridStyleLayout.AbsoluteContentSize

				p3:applyFit(u13, AbsoluteContentSize.x, AbsoluteContentSize.y)
			end

			local connection = UIGridStyleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)

			table.insert(p3.signals, connection)

			local AbsoluteContentSize = UIGridStyleLayout.AbsoluteContentSize

			p3:applyFit(u13, AbsoluteContentSize.x, AbsoluteContentSize.y)
		else
			p3:resizeFromChildren(u13)

			local children = current:GetChildren()

			for _, v in ipairs(children) do
				if v:IsA("GuiBase2d") then
					local connection = v:GetPropertyChangedSignal("Size"):Connect(function() -- line: 73
						-- upvalues: p3 (copy), u13 (ref)
						p3:resizeFromChildren(u13)
					end)

					table.insert(p3.signals, connection)

					local connection2 = v:GetPropertyChangedSignal("Position"):Connect(function() -- line: 77
						-- upvalues: p3 (copy), u13 (ref)
						p3:resizeFromChildren(u13)
					end)

					table.insert(p3.signals, connection2)
				end
			end
		end
	end
	function v8.resizeFromChildren(p4, p5) -- line: 86
		local current = p4.ref.current

		if current == nil then
			return
		end

		local AbsolutePosition = current.AbsolutePosition
		local children = current:GetChildren()
		local n1 = 0
		local n2 = 0

		for _, v in ipairs(children) do
			if v:IsA("GuiBase2d") then
				local AbsoluteSize = v.AbsoluteSize
				local AbsolutePosition2 = v.AbsolutePosition

				n1 = math.max(n1, AbsolutePosition2.x - AbsolutePosition.x + AbsoluteSize.x)
				n2 = math.max(n2, AbsolutePosition2.y - AbsolutePosition.y + AbsoluteSize.y)
			end
		end

		p4:applyFit(p5, n1, n2)
	end
	function v8.applyFit(p6, p7, p8, p9) -- line: 108
		-- upvalues: t1 (copy)
		local current = p6.ref.current

		if current == nil then
			return
		end

		local UIPadding = current:FindFirstChildOfClass("UIPadding")
		local v41 = p6.props.Size or UDim2.new(0, 0, 0, 0)
		local Width = t1.FitAxis.Width
		local FitAxisHeight = t1.FitAxis.Height

		local function calculateAxis(p10, p11, p12, p13, p14, p15) -- line: 119
			-- upvalues: t1 (copy), UIPadding (copy)
			if p10 == p11 or p10 == t1.FitAxis.Both then
				local n3 = 0

				if UIPadding then
					local v68 = UIPadding[p14].Scale + UIPadding[p15].Scale
					local v69 = UIPadding[p14].Offset + UIPadding[p15].Offset

					if v68 == 1 then
						error("Can not apply FitChildren to a component with 100% padding width")

						return n3, nil
					end

					return n3, (p12 + v69) / (1 - v68)
				end

				return n3, p12
			end

			return p13.Scale, p13.Offset
		end

		for k, v in pairs(p7) do
			local v47, v48 = calculateAxis(v, Width, p8, v41.X, "PaddingLeft", "PaddingRight")
			local v49, v50 = calculateAxis(v, FitAxisHeight, p9, v41.Y, "PaddingTop", "PaddingBottom")

			current[k] = UDim2.new(v47, v48, v49, v50)
		end
	end
	function v8.init(p16) -- line: 150
		-- upvalues: v8 (copy), Roact (copy)
		p16.signals = {}

		local forwardRef = p16.props.forwardRef

		assert(type(forwardRef) ~= "function", ("%s does not support function ref forwarding"):format((tostring(v8))))
		p16.ref = forwardRef or Roact.createRef()
	end
	function v8.render(p17) -- line: 164
		-- upvalues: Immutable (copy), Roact (copy), p1 (copy)
		local v54 = Immutable.RemoveFromDictionary(p17.props, "fitAxis", "fitFields", "forwardRef")

		v54[Roact.Ref] = p17.ref

		return Roact.createElement(p1, v54)
	end
	function v8.didMount(p18) -- line: 171
		p18:resize()
	end
	function v8.didUpdate(p19) -- line: 175
		p19:resize()
	end
	function v8.willUnmount(p20) -- line: 179
		p20:disconnectSignals()
	end

	return Roact.forwardRef(function(p21, p22) -- line: 183
		-- upvalues: Roact (copy), v8 (copy), Cryo (copy)
		return Roact.createElement(v8, Cryo.Dictionary.join(p21, {
			forwardRef = p22
		}))
	end)
end

t1.FitFrame = t1.wrap("Frame")
t1.FitScrollingFrame = t1.wrap("ScrollingFrame")
t1.FitTextButton = t1.wrap("TextButton")

return t1
