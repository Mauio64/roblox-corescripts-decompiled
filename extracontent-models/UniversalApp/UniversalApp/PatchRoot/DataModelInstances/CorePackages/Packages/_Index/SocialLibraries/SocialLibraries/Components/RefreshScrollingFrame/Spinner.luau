local RunService = game:GetService("RunService")

local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local t = dependencies.t
local cryo = dependencies.Cryo

local withStyle = uiBlox.Style.withStyle
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel

local ExternalEventConnection = require(script.Parent.ExternalEventConnection)

local extended = roact.PureComponent:extend("Spinner")

extended.defaultProps = { Size = UDim2.new(0, 20, 0, 20), spinSpeed = 540 }

extended.validateProps = t.interface({
	isSpinning = t.optional(t.boolean),
	spinSpeed = t.optional(t.number),
	Size = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.Vector2),
	ImageColor3 = t.optional(t.Color3),
	ImageTransparency = t.optional(t.number),
	forwardRef = t.optional(t.table)
})

function extended:init()
	function self.renderSteppedCallback(p)
		local isSpinning = self.props.isSpinning
		local spinSpeed = self.props.spinSpeed

		if isSpinning and self.ref.current then
			self.ref.current.Rotation = self.ref.current.Rotation + spinSpeed * p
		end
	end
end

function extended:render()
	local size = self.props.Size
	local position = self.props.Position
	local anchorPoint = self.props.AnchorPoint
	local imageColor3 = self.props.ImageColor3
	local imageTransparency = self.props.ImageTransparency
	local isSpinning = self.props.isSpinning

	self.ref = self.props.forwardRef or self.ref or roact.createRef()

	return withStyle(function(p)
		return roact.createElement(imageSetLabel, {
			Size = size,
			Position = position,
			AnchorPoint = anchorPoint,
			BackgroundTransparency = 1,
			Image = images["icons/common/refresh"],
			ImageColor3 = imageColor3 or p.Theme.SystemPrimaryDefault.Color,
			ImageTransparency = imageTransparency or p.Theme.SystemPrimaryDefault.Transparency,
			[roact.Ref] = self.ref
		}, {
			renderStepped = isSpinning and roact.createElement(ExternalEventConnection, {
				event = RunService.renderStepped,
				callback = self.renderSteppedCallback
			})
		})
	end)
end

return roact.forwardRef(function(p, forwardRef)
	return roact.createElement(extended, cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
