local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Roact = require(Modules.Common.Roact)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local ShimmerAnimation = require(Modules.LuaApp.Components.ShimmerAnimation)
local t1 = {
	Image = "LuaApp/buttons/buttonFill",
	SliceCenter = Rect.new(8, 8, 9, 9)
}
local t2 = {
	Image = "LuaApp/buttons/buttonStroke",
	SliceCenter = Rect.new(8, 8, 9, 9)
}
local v12 = Roact.PureComponent:extend("RetryButton")

function v12.init(p1) -- line: 42
	p1.state = {
		isRetrying = false,
		isInCooldown = false
	}
	p1._isMounted = false
	p1.cooldownTimer = 0

	function p1.safeSetState(p2) -- line: 51
		-- upvalues: p1 (copy)
		if p1._isMounted then
			p1:setState(p2)
		end
	end
	function p1.onActivated() -- line: 57
		-- upvalues: p1 (copy)
		local onRetry = p1.props.onRetry
		local isRetrying = p1.state.isRetrying
		local isInCooldown = p1.state.isInCooldown

		if not isRetrying and not isInCooldown and onRetry then
			p1.cooldownTimer = 0
			p1.safeSetState({
				isRetrying = true,
				isInCooldown = true
			})
			onRetry():andThen(function() -- line: 70
				-- upvalues: p1 (copy)
				p1.safeSetState({
					isRetrying = false
				})
			end, function() -- line: 74
				-- upvalues: p1 (copy)
				p1.safeSetState({
					isRetrying = false
				})
			end)
		end
	end
	function p1.renderSteppedCallback(p3) -- line: 82
		-- upvalues: p1 (copy)
		if p1.state.isInCooldown then
			p1.cooldownTimer = p1.cooldownTimer + p3

			if p1.cooldownTimer >= 1.5 then
				p1.safeSetState({
					isInCooldown = false
				})
			end
		end
	end
end
function v12.didMount(p4) -- line: 96
	p4._isMounted = true
end
function v12.willUnmount(p5) -- line: 100
	p5._isMounted = false
end
function v12.isDisabled(p6) -- line: 104
	local isRetrying = p6.state.isRetrying
	local isInCooldown = p6.state.isInCooldown

	return isRetrying or isInCooldown
end

local function getCombinedTransparency(p7, p8) -- line: 111
	return 1 - (1 - p7) * (1 - p8)
end

function v12.render(p9) -- line: 115
	-- upvalues: withStyle (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), t1 (copy), DEPRECATED_ImageSetLabel (copy), t2 (copy), ShimmerAnimation (copy), ExternalEventConnection (copy), RunService (copy)
	local propsPosition = p9.props.Position
	local propsAnchorPoint = p9.props.AnchorPoint
	local propsLayoutOrder = p9.props.LayoutOrder
	local v26 = p9:isDisabled()

	return withStyle(function(p10) -- line: 122
		-- upvalues: Roact (copy), DEPRECATED_ImageSetButton (copy), propsPosition (copy), propsAnchorPoint (copy), propsLayoutOrder (copy), t1 (copy), v26 (copy), p9 (copy), DEPRECATED_ImageSetLabel (copy), t2 (copy), ShimmerAnimation (copy), ExternalEventConnection (copy), RunService (copy)
		local createElement = Roact.createElement
		local v34 = DEPRECATED_ImageSetButton
		local t3 = {
			Size = UDim2.new(0, 44, 0, 44),
			Position = propsPosition,
			AnchorPoint = propsAnchorPoint,
			LayoutOrder = propsLayoutOrder,
			BackgroundTransparency = 1,
			Image = t1.Image,
			ImageColor3 = p10.Theme.UIEmphasis.Color
		}
		local UIEmphasisTransparency = p10.Theme.UIEmphasis.Transparency
		local v37 = not v26 and 0 or 0.5

		t3.ImageTransparency = 1 - (1 - UIEmphasisTransparency) * (1 - v37)
		t3.ScaleType = Enum.ScaleType.Slice
		t3.SliceCenter = t1.SliceCenter
		t3[Roact.Event.Activated] = p9.onActivated

		local t4 = {}
		local createElement2 = Roact.createElement
		local v40 = DEPRECATED_ImageSetLabel
		local t5 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Image = t2.Image,
			ImageColor3 = p10.Theme.SecondaryDefault.Color
		}
		local SecondaryDefaultTransparency = p10.Theme.SecondaryDefault.Transparency
		local v43 = not v26 and 0 or 0.5

		t5.ImageTransparency = 1 - (1 - SecondaryDefaultTransparency) * (1 - v43)
		t5.ScaleType = Enum.ScaleType.Slice
		t5.SliceCenter = t2.SliceCenter
		t4.Border = createElement2(v40, t5)

		local createElement3 = Roact.createElement
		local v45 = DEPRECATED_ImageSetLabel
		local t6 = {
			BackgroundTransparency = 1,
			Image = "LuaApp/icons/common_refresh",
			Size = UDim2.new(0, 36, 0, 36),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ImageColor3 = p10.Theme.IconEmphasis.Color
		}
		local IconEmphasisTransparency = p10.Theme.IconEmphasis.Transparency
		local v48 = not v26 and 0 or 0.5

		t6.ImageTransparency = 1 - (1 - IconEmphasisTransparency) * (1 - v48)
		t4.Spinner = createElement3(v45, t6)
		t4.Shimmer = v26 and Roact.createElement(ShimmerAnimation, {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1)
		})
		t4.renderStepped = Roact.createElement(ExternalEventConnection, {
			event = RunService.renderStepped,
			callback = p9.renderSteppedCallback
		})

		return createElement(v34, t3, t4)
	end)
end

return v12
