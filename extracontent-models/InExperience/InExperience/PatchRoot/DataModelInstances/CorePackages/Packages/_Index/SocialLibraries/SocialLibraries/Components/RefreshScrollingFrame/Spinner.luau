local RunService = game:GetService("RunService")
local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local Cryo = dependencies.Cryo
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ExternalEventConnection = require(script.Parent.ExternalEventConnection)
local v12 = Roact.PureComponent:extend("Spinner")

v12.defaultProps = {
	spinSpeed = 540,
	Size = UDim2.new(0, 20, 0, 20)
}
v12.validateProps = t.interface({
	isSpinning = t.optional(t.boolean),
	spinSpeed = t.optional(t.number),
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.Vector2),
	ImageColor3 = t.optional(t.Color3),
	ImageTransparency = t.optional(t.number),
	forwardRef = t.optional(t.table)
})

function v12.init(p1) -- line: 37
	function p1.renderSteppedCallback(p2) -- line: 38
		-- upvalues: p1 (copy)
		local isSpinning = p1.props.isSpinning
		local spinSpeed = p1.props.spinSpeed

		if isSpinning and p1.ref.current then
			p1.ref.current.Rotation = p1.ref.current.Rotation + spinSpeed * p2
		end
	end
end
function v12.render(p3) -- line: 48
	-- upvalues: Roact (copy), withStyle (copy), ImageSetLabel (copy), Images (copy), ExternalEventConnection (copy), RunService (copy)
	local propsSize = p3.props.Size
	local propsPosition = p3.props.Position
	local propsAnchorPoint = p3.props.AnchorPoint
	local propsImageColor3 = p3.props.ImageColor3
	local propsImageTransparency = p3.props.ImageTransparency
	local isSpinning = p3.props.isSpinning

	p3.ref = p3.props.forwardRef or (p3.ref or Roact.createRef())

	return withStyle(function(p4) -- line: 60
		-- upvalues: Roact (copy), ImageSetLabel (copy), propsSize (copy), propsPosition (copy), propsAnchorPoint (copy), Images (copy), propsImageColor3 (copy), propsImageTransparency (copy), p3 (copy), isSpinning (copy), ExternalEventConnection (copy), RunService (copy)
		return Roact.createElement(ImageSetLabel, {
			Size = propsSize,
			Position = propsPosition,
			AnchorPoint = propsAnchorPoint,
			BackgroundTransparency = 1,
			Image = Images["icons/common/refresh"],
			ImageColor3 = propsImageColor3 or p4.Theme.SystemPrimaryDefault.Color,
			ImageTransparency = propsImageTransparency or p4.Theme.SystemPrimaryDefault.Transparency,
			[Roact.Ref] = p3.ref
		}, {
			renderStepped = isSpinning and Roact.createElement(ExternalEventConnection, {
				event = RunService.renderStepped,
				callback = p3.renderSteppedCallback
			})
		})
	end)
end

return Roact.forwardRef(function(p5, p6) -- line: 79
	-- upvalues: Roact (copy), v12 (copy), Cryo (copy)
	return Roact.createElement(v12, Cryo.Dictionary.join(p5, {
		forwardRef = p6
	}))
end)
