local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local Roact = require(ParentParent.Roact)
local ok, result = pcall(function() -- line: 8
	return game:GetEngineFeature("TextBoundsRoundUp")
end)
local u6 = ok and result
local TextService = game:GetService("TextService")

local function getTextHeight(p1, p2, p3, p4) -- line: 16
	-- upvalues: u6 (ref), TextService (copy)
	if u6 then
		return TextService:GetTextSize(p1, p2, p3, Vector2.new(p4, 10000)).Y
	end

	return TextService:GetTextSize(p1, p2, p3, Vector2.new(p4, 10000)).Y + 2
end
local function getTextWidth(p5, p6, p7) -- line: 24
	-- upvalues: u6 (ref), TextService (copy)
	if u6 then
		return TextService:GetTextSize(p5, p6, p7, Vector2.new(10000, 10000)).X
	end

	return TextService:GetTextSize(p5, p6, p7, Vector2.new(10000, 10000)).X + 2
end

local t1 = {
	FitToText = {}
}
local v11 = Roact.PureComponent:extend("FitTextLabel")

v11.defaultProps = {
	Text = "Label",
	TextSize = 12,
	TextWrapped = true,
	maximumWidth = 1e999,
	Font = Enum.Font.SourceSans
}

function v11.init(p8) -- line: 47
	-- upvalues: Roact (copy)
	if Roact.Ref == "ref" then
		p8.frameRef = p8.props.forwardedRef or Roact.createRef()
	else
		p8.frameRef = p8.props[Roact.Ref] or Roact.createRef()
	end

	function p8.onResize() -- line: 54
		-- upvalues: p8 (copy)
		if not p8.frameRef.current then
			return
		end

		p8.frameRef.current.Size = p8:__getSize(p8.frameRef.current)
	end
end
function v11.render(p9) -- line: 63
	-- upvalues: Roact (copy)
	local v22 = not p9.props.onActivated and "TextLabel" or "TextButton"

	return Roact.createElement(v22, p9:__getFilteredProps())
end
function v11.didMount(p10) -- line: 68
	p10.onResize()
end
function v11.didUpdate(p11) -- line: 72
	p11.onResize()
end
function v11.__getFilteredProps(p12) -- line: 76
	-- upvalues: Cryo (copy), Roact (copy)
	local t2 = {
		width = Cryo.None,
		maximumWidth = Cryo.None,
		onActivated = Cryo.None,
		forwardedRef = Cryo.None,
		Size = UDim2.new(p12.props.width, UDim.new(0, 0)),
		[Roact.Ref] = p12.frameRef,
		[Roact.Children] = Cryo.Dictionary.join(p12.props[Roact.Children] or {}, {
			sizeConstraint = p12.props.maximumWidth < 1e999 and Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(p12.props.maximumWidth, 1e999)
			})
		}),
		[Roact.Event.Activated] = p12.props.onActivated,
		[Roact.Change.AbsoluteSize] = function(p13) -- line: 97
			-- upvalues: p12 (copy), Roact (copy)
			if p12.props[Roact.Change.AbsoluteSize] then
				p12.props[Roact.Change.AbsoluteSize](p13)
			end

			p12.onResize()
		end
	}

	return Cryo.Dictionary.join(p12.props, t2)
end
function v11.__getSize(p14, p15) -- line: 108
	-- upvalues: t1 (copy), getTextWidth (copy), getTextHeight (copy)
	local maximumWidth = p14.props.maximumWidth
	local width = p14.props.width

	if width == t1.FitToText then
		local v31 = getTextWidth(p14.props.Text, p14.props.TextSize, p14.props.Font)

		width = UDim.new(0, (math.min(v31, maximumWidth)))
	end

	local v32 = math.max(maximumWidth < 1e999 and maximumWidth or 0, p15.AbsoluteSize.X)
	local v33 = getTextHeight(p14.props.Text, p14.props.TextSize, p14.props.Font, v32)

	return UDim2.new(width, UDim.new(0, v33))
end

local v12 = if Roact.Ref ~= "ref" then v11 else Roact.forwardRef(function(p16, p17) -- line: 129
	-- upvalues: Roact (copy), v11 (copy), Cryo (copy)
	return Roact.createElement(v11, Cryo.Dictionary.join(p16, {
		forwardedRef = p17
	}))
end)

v12.Width = t1

return v12
