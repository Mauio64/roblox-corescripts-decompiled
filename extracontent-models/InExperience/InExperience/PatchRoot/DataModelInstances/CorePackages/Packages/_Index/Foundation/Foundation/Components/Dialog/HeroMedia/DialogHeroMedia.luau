local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)

require(Foundation.Enums.DialogSize)

local Gradient = require(Foundation.Components.Gradient)
local useDialog = require(script.Parent.Parent.useDialog)
local withDefaults = require(Foundation.Utility.withDefaults)
local useDialogVariants = require(script.Parent.Parent.useDialogVariants).useDialogVariants
local t1 = {
	height = UDim.new(1, 0)
}

local function DialogHeroMedia(t2: {[any]: any}) -- line: 35
	-- upvalues: withDefaults (copy), t1 (copy), useDialog (copy), useDialogVariants (copy), React (copy), View (copy), Constants (copy), Image (copy), Gradient (copy)
	local v14 = withDefaults(t2, t1)
	local v15 = useDialog()
	local v16 = useDialogVariants()

	React.useEffect(function() -- line: 40
		-- upvalues: v15 (copy)
		v15.setHasHeroMedia(true)

		return function() -- line: 43
			-- upvalues: v15 (copy)
			v15.setHasHeroMedia(false)
		end
	end, {})

	local offsetX = v16.heroMedia.offsetX

	return React.createElement(View, {
		tag = v16.heroMediaWrapper.tag,
		LayoutOrder = Constants.MIN_LAYOUT_ORDER,
		testId = `{ v15.testId }--hero-media`
	}, {
		RoundedCorners = React.createElement(Image, {
			ZIndex = 0,
			Image = v14.media,
			imageStyle = v14.mediaStyle,
			backgroundStyle = v14.backgroundStyle,
			aspectRatio = v14.aspectRatio,
			Position = UDim2.fromOffset(-offsetX, 0),
			Size = UDim2.new(1, offsetX * 2, v14.height.Scale, v14.height.Offset)
		}, {
			TransparencyGradient = React.createElement(Gradient, {
				top = false,
				fillDirection = Enum.FillDirection.Vertical
			})
		}),
		Image = React.createElement(Image, {
			Image = v14.media,
			imageStyle = v14.mediaStyle,
			backgroundStyle = v14.backgroundStyle,
			tag = v16.heroMedia.tag,
			aspectRatio = v14.aspectRatio,
			Position = UDim2.fromOffset(-offsetX, 0),
			Size = UDim2.new(1, offsetX * 2, v14.height.Scale, v14.height.Offset)
		}, {
			TransparencyGradient = React.createElement(Gradient, {
				top = true,
				fillDirection = Enum.FillDirection.Vertical
			})
		})
	})
end

return DialogHeroMedia
