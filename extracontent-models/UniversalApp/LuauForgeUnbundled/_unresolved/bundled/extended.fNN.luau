local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/edm")
local module3 = require("@luauforge/bundled/edi")
local module4 = require("@luauforge/bundled/dwL")

local fFlagMigrateRoactUtilsToReactUtils = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagMigrateRoactUtilsToReactUtils()

local extended = module.PureComponent:extend("TextureScroller")

function extended:init()
	self.lerpValue = 0
	self.imageRef = module.createRef()

	function self.renderSteppedCallback(p2)
		local imageScrollCycleTime = self.props.imageScrollCycleTime
		local imagePositionStart = self.props.imagePositionStart
		local imagePositionEnd = self.props.imagePositionEnd

		local v5 = imageScrollCycleTime == 0 and 0 or p2 / imageScrollCycleTime

		self.lerpValue = (self.lerpValue + v5) % 1

		if not fFlagMigrateRoactUtilsToReactUtils or self.imageRef.current then
			self.imageRef.current.Position = imagePositionStart:lerp(imagePositionEnd, self.lerpValue)
		end
	end
end

function extended.render(props)
	module4.isType(props.props.Image, "string", "self.props.Image")
	module4.isType(props.props.imageScrollCycleTime, "number", "self.props.imageScrollCycleTime")
	module4.isType(props.props.imagePositionStart, "UDim2", "self.props.imagePositionStart")
	module4.isType(props.props.imagePositionEnd, "UDim2", "self.props.imagePositionEnd")

	local size = props.props.Size
	local position = props.props.Position
	local anchorPoint = props.props.AnchorPoint
	local layoutOrder = props.props.LayoutOrder

	local image = props.props.Image
	local imageSize = props.props.imageSize
	local imageTransparency = props.props.ImageTransparency
	local imageAnchorPoint = props.props.imageAnchorPoint
	local imagePositionStart = props.props.imagePositionStart

	return module.createElement("Frame", {
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}, {
		module.createElement(module3, {
			Size = imageSize,
			Position = imagePositionStart,
			AnchorPoint = imageAnchorPoint,
			BackgroundTransparency = 1,
			Image = image,
			ImageTransparency = imageTransparency,
			[module.Ref] = props.imageRef
		}),
		renderStepped = module.createElement(module2, {
			event = RunService.renderStepped,
			callback = props.renderSteppedCallback
		})
	})
end

return extended
