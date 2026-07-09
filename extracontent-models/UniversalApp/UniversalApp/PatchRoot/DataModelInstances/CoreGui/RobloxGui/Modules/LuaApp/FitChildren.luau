local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(Modules.Common.Roact)
local Immutable = require(Modules.Common.Immutable)
local Symbol = require(Modules.Common.Symbol)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local t1 = {
	FitAxis = {
		Width = Symbol.named("Width"),
		Height = Symbol.named("Height"),
		Both = Symbol.named("Both")
	}
}

function t1.wrap(p1) -- line: 25
	-- upvalues: Roact (copy), t1 (copy), Immutable (copy), Cryo (copy)
	local v11 = Roact.PureComponent:extend(("FitChildren(%s)"):format((tostring(p1))))

	function v11.disconnectSignals(p2) -- line: 28
		for _, v in ipairs(p2.signals) do
			v:Disconnect()
		end
	end
	function v11.resize(p3) -- line: 34
		-- upvalues: t1 (copy)
		local u16 = p3.props.fitFields or if not p3.props.fitAxis then {
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
			local function update() -- line: 61
				-- upvalues: UIGridStyleLayout (copy), p3 (copy), u16 (ref)
				local AbsoluteContentSize = UIGridStyleLayout.AbsoluteContentSize

				p3:applyFit(u16, AbsoluteContentSize.x, AbsoluteContentSize.y)
			end

			local connection = UIGridStyleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)

			table.insert(p3.signals, connection)

			local AbsoluteContentSize = UIGridStyleLayout.AbsoluteContentSize

			p3:applyFit(u16, AbsoluteContentSize.x, AbsoluteContentSize.y)
		else
			p3:resizeFromChildren(u16)

			local children = current:GetChildren()

			for _, v in ipairs(children) do
				if v:IsA("GuiBase2d") then
					local connection = v:GetPropertyChangedSignal("Size"):Connect(function() -- line: 75
						-- upvalues: p3 (copy), u16 (ref)
						p3:resizeFromChildren(u16)
					end)

					table.insert(p3.signals, connection)

					local connection2 = v:GetPropertyChangedSignal("Position"):Connect(function() -- line: 79
						-- upvalues: p3 (copy), u16 (ref)
						p3:resizeFromChildren(u16)
					end)

					table.insert(p3.signals, connection2)
				end
			end
		end
	end
	function v11.resizeFromChildren(p4, p5) -- line: 88
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
	function v11.applyFit(p6, p7, p8, p9) -- line: 110
		-- upvalues: t1 (copy)
		local current = p6.ref.current

		if current == nil then
			return
		end

		local UIPadding = current:FindFirstChildOfClass("UIPadding")
		local v44 = p6.props.Size or UDim2.new(0, 0, 0, 0)
		local Width = t1.FitAxis.Width
		local FitAxisHeight = t1.FitAxis.Height

		local function calculateAxis(p10, p11, p12, p13, p14, p15) -- line: 121
			-- upvalues: t1 (copy), UIPadding (copy)
			if p10 == p11 or p10 == t1.FitAxis.Both then
				local n3 = 0

				if UIPadding then
					local v71 = UIPadding[p14].Scale + UIPadding[p15].Scale
					local v72 = UIPadding[p14].Offset + UIPadding[p15].Offset

					if v71 == 1 then
						error("Can not apply FitChildren to a component with 100% padding width")

						return n3, nil
					end

					return n3, (p12 + v72) / (1 - v71)
				end

				return n3, p12
			end

			return p13.Scale, p13.Offset
		end

		for k, v in pairs(p7) do
			local v50, v51 = calculateAxis(v, Width, p8, v44.X, "PaddingLeft", "PaddingRight")
			local v52, v53 = calculateAxis(v, FitAxisHeight, p9, v44.Y, "PaddingTop", "PaddingBottom")

			current[k] = UDim2.new(v50, v51, v52, v53)
		end
	end
	function v11.init(p16) -- line: 152
		-- upvalues: Roact (copy)
		p16.signals = {}

		local forwardRef = p16.props.forwardRef

		if type(forwardRef) == "table" then
			p16.ref = forwardRef
		else
			p16.ref = Roact.createRef()
		end

		function p16.setRef(p17) -- line: 164
			-- upvalues: p16 (copy), forwardRef (copy)
			p16.ref.current = p17

			if forwardRef and type(forwardRef) == "function" then
				forwardRef(p17)
			end
		end
	end
	function v11.render(p18) -- line: 172
		-- upvalues: Immutable (copy), Roact (copy), p1 (copy)
		local v57 = Immutable.RemoveFromDictionary(p18.props, "fitAxis", "fitFields", "forwardRef")

		v57[Roact.Ref] = p18.setRef

		return Roact.createElement(p1, v57)
	end
	function v11.didMount(p19) -- line: 179
		p19:resize()
	end
	function v11.didUpdate(p20) -- line: 183
		p20:resize()
	end
	function v11.willUnmount(p21) -- line: 187
		p21:disconnectSignals()
	end

	return Roact.forwardRef(function(p22, p23) -- line: 191
		-- upvalues: Roact (copy), v11 (copy), Cryo (copy)
		return Roact.createElement(v11, Cryo.Dictionary.join(p22, {
			forwardRef = p23
		}))
	end)
end

t1.FitFrame = t1.wrap("Frame")
t1.FitScrollingFrame = t1.wrap("ScrollingFrame")
t1.FitTextButton = t1.wrap("TextButton")
t1.FitImageLabel = t1.wrap(DEPRECATED_ImageSetLabel)
t1.FitImageButton = t1.wrap(DEPRECATED_ImageSetButton)

return t1
