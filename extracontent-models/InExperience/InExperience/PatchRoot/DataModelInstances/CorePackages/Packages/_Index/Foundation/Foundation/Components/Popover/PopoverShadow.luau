local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function PopoverShadow(t1: {[any]: any}) -- line: 22
	-- upvalues: useTokens (copy), React (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy)
	local v11 = useTokens()

	return React.createElement(Image, {
		AnchorPoint = t1.AnchorPoint,
		Image = SHADOW_IMAGE,
		Size = t1.contentSize:map(function(uDim2: UDim2) -- line: 28
			-- upvalues: SHADOW_SIZE (copy)
			return uDim2 + UDim2.fromOffset(SHADOW_SIZE, SHADOW_SIZE)
		end),
		Position = t1.position,
		ZIndex = t1.ZIndex,
		slice = {
			center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
		},
		imageStyle = v11.Color.Extended.Black.Black_20,
		testId = t1.testId
	})
end

return PopoverShadow
