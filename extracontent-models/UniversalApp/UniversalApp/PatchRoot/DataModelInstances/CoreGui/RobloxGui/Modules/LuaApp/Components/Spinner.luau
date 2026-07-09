local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local v11 = Roact.PureComponent:extend("Spinner")

v11.defaultProps = {
	spinSpeed = 540,
	Size = UDim2.new(0, 20, 0, 20)
}

function v11.init(p1) -- line: 25
	function p1.renderSteppedCallback(p2) -- line: 26
		-- upvalues: p1 (copy)
		local isSpinning = p1.props.isSpinning
		local spinSpeed = p1.props.spinSpeed

		if isSpinning and p1.ref.current then
			p1.ref.current.Rotation = p1.ref.current.Rotation + spinSpeed * p2
		end
	end
end
function v11.render(p3) -- line: 36
	-- upvalues: Roact (copy), withStyle (copy), ImageSetLabel (copy), Images (copy), ExternalEventConnection (copy), RunService (copy)
	local propsSize = p3.props.Size
	local propsPosition = p3.props.Position
	local propsAnchorPoint = p3.props.AnchorPoint
	local propsImageColor3 = p3.props.ImageColor3
	local propsImageTransparency = p3.props.ImageTransparency
	local isSpinning = p3.props.isSpinning

	p3.ref = p3.props.forwardRef or (p3.ref or Roact.createRef())

	return withStyle(function(p4) -- line: 48
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

return Roact.forwardRef(function(p5, p6) -- line: 67
	-- upvalues: Roact (copy), v11 (copy), Cryo (copy)
	return Roact.createElement(v11, Cryo.Dictionary.join(p5, {
		forwardRef = p6
	}))
end)
