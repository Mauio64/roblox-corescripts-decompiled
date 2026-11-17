local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local v

if Flags.FoundationPluginShadowSize then
	v = Constants.PLUGIN_SHADOW_SIZE
else
	v = Constants.SHADOW_SIZE
end

local function PopoverShadow(props)
	local v2 = useTokens()

	if not Flags.FoundationPluginShadowSize then
		return (React.createElement(Image, {
			AnchorPoint = props.AnchorPoint,
			Image = SHADOW_IMAGE,
			Size = props.contentSize:map(function(udim: UDim2)
				return udim + UDim2.fromOffset(v, v)
			end),
			Position = props.position,
			ZIndex = props.ZIndex,
			slice = {
				center = Rect.new(v, v, v + 1, v + 1)
			},
			imageStyle = v2.Color.Extended.Black.Black_20,
			testId = props.testId
		}))
	end

	local createElement = React.createElement

	local v3 = {
		Size = props.contentSize:map(function(udim: UDim2)
			return udim + UDim2.fromOffset(v, v)
		end),
		Position = props.position,
		ZIndex = props.ZIndex,
		Transparency = 1,
		tag = 0,
		testId = 0
	}

	local radiusTagSet = { [props.radiusTag] = true }
	v3.tag = radiusTagSet

	v3.testId = props.testId
	return (createElement(View, v3, React.createElement("UIShadow", {
		Offset = UDim2.fromOffset(0, 2),
		Transparency = 0.92,
		BlurRadius = UDim.new(0, 4),
		Color = v2.Color.Extended.Black.Black_100.Color3,
		ZIndex = -1,
		Spread = UDim2.fromOffset(-1, -1)
	})))
end

return PopoverShadow
