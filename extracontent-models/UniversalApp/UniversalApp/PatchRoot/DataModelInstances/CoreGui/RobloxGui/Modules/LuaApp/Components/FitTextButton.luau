local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(Modules.Common.Roact)
local Immutable = require(Modules.Common.Immutable)
local Text = require(Modules.Common.Text)
local FitChildren = require(Modules.LuaApp.FitChildren)
local v8 = Roact.PureComponent:extend("FitTextButton")

v8.defaultProps = {
	fitAxis = FitChildren.FitAxis.Height
}

function v8.init(p1) -- line: 17
	-- upvalues: Roact (copy), FitChildren (copy), Text (copy)
	p1.ref = p1.props.forwardRef or Roact.createRef()

	function p1.resize(p2) -- line: 22
		-- upvalues: p1 (copy), FitChildren (copy), Text (copy)
		local fitAxis = p1.props.fitAxis

		if fitAxis == FitChildren.FitAxis.Width or fitAxis == FitChildren.FitAxis.Both then
			local uDim = UDim.new(0, Text.GetTextWidth(p2.Text, p2.Font, p2.TextSize))
			local v19 = fitAxis == FitChildren.FitAxis.Both and UDim.new(0, p2.TextSize) or p2.Size.Height

			p2.Size = UDim2.new(uDim, v19)

			return
		end

		local uDim = UDim.new(0, Text.GetTextHeight(p2.Text, p2.Font, p2.TextSize, p2.AbsoluteSize.X))

		p2.Size = UDim2.new(p2.Size.Width, uDim)
	end
end
function v8.render(p3) -- line: 41
	-- upvalues: FitChildren (copy), Immutable (copy), Roact (copy)
	local v11 = p3.props.fitAxis or FitChildren.FitAxis.Height
	local v12 = Immutable.RemoveFromDictionary(p3.props, "fitAxis", "forwardRef")

	return Roact.createElement("TextButton", Immutable.JoinDictionaries(v12, {
		[Roact.Ref] = p3.ref,
		[Roact.Change.Text] = p3.resize,
		[Roact.Change.TextSize] = p3.resize,
		[Roact.Change.AbsoluteSize] = v11 == FitChildren.FitAxis.Height and p3.resize or nil
	}))
end
function v8.didMount(p4) -- line: 56
	p4.resize(p4.ref.current)
end

return Roact.forwardRef(function(p5, p6) -- line: 60
	-- upvalues: Roact (copy), v8 (copy), Cryo (copy)
	return Roact.createElement(v8, Cryo.Dictionary.join(p5, {
		forwardRef = p6
	}))
end)
