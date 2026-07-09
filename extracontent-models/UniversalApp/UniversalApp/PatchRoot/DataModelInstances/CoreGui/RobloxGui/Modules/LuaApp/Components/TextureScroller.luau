local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local v8 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagMigrateRoactUtilsToReactUtils()
local v9 = Roact.PureComponent:extend("TextureScroller")

function v9.init(p1) -- line: 17
	-- upvalues: Roact (copy), v8 (copy)
	p1.lerpValue = 0
	p1.imageRef = Roact.createRef()

	function p1.renderSteppedCallback(p2) -- line: 21
		-- upvalues: p1 (copy), v8 (copy)
		local imageScrollCycleTime = p1.props.imageScrollCycleTime
		local imagePositionStart = p1.props.imagePositionStart
		local imagePositionEnd = p1.props.imagePositionEnd
		local n1 = 0

		if imageScrollCycleTime ~= 0 then
			n1 = p2 / imageScrollCycleTime
		end

		p1.lerpValue = (p1.lerpValue + n1) % 1

		if not v8 or p1.imageRef.current then
			p1.imageRef.current.Position = imagePositionStart:lerp(imagePositionEnd, p1.lerpValue)
		end
	end
end
function v9.render(p3) -- line: 37
	-- upvalues: ArgCheck (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy), ExternalEventConnection (copy), RunService (copy)
	ArgCheck.isType(p3.props.Image, "string", "self.props.Image")
	ArgCheck.isType(p3.props.imageScrollCycleTime, "number", "self.props.imageScrollCycleTime")
	ArgCheck.isType(p3.props.imagePositionStart, "UDim2", "self.props.imagePositionStart")
	ArgCheck.isType(p3.props.imagePositionEnd, "UDim2", "self.props.imagePositionEnd")

	local propsSize = p3.props.Size
	local propsPosition = p3.props.Position
	local propsAnchorPoint = p3.props.AnchorPoint
	local propsLayoutOrder = p3.props.LayoutOrder
	local propsImage = p3.props.Image
	local imageSize = p3.props.imageSize
	local propsImageTransparency = p3.props.ImageTransparency
	local imageAnchorPoint = p3.props.imageAnchorPoint
	local imagePositionStart = p3.props.imagePositionStart

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = propsSize,
		Position = propsPosition,
		AnchorPoint = propsAnchorPoint,
		LayoutOrder = propsLayoutOrder
	}, {
		Roact.createElement(DEPRECATED_ImageSetLabel, {
			Size = imageSize,
			Position = imagePositionStart,
			AnchorPoint = imageAnchorPoint,
			BackgroundTransparency = 1,
			Image = propsImage,
			ImageTransparency = propsImageTransparency,
			[Roact.Ref] = p3.imageRef
		}),
		renderStepped = Roact.createElement(ExternalEventConnection, {
			event = RunService.renderStepped,
			callback = p3.renderSteppedCallback
		})
	})
end

return v9
