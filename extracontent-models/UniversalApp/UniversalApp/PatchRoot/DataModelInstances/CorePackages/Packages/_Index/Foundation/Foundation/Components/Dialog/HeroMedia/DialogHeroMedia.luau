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
local Flags = require(Foundation.Utility.Flags)
local t1 = {
	height = UDim.new(1, 0)
}

local function DialogHeroMedia(t2: {[any]: any}) -- line: 37
	-- upvalues: withDefaults (copy), t1 (copy), useDialog (copy), useDialogVariants (copy), React (copy), View (copy), Constants (copy), Flags (copy), Image (copy), Gradient (copy)
	local v15 = withDefaults(t2, t1)
	local v16 = useDialog()
	local v17 = useDialogVariants()

	React.useEffect(function() -- line: 42
		-- upvalues: v16 (copy)
		v16.setHasHeroMedia(true)

		return function() -- line: 45
			-- upvalues: v16 (copy)
			v16.setHasHeroMedia(false)
		end
	end, {})

	local offsetX = v17.heroMedia.offsetX

	return React.createElement(View, {
		tag = v17.heroMediaWrapper.tag,
		LayoutOrder = Constants.MIN_LAYOUT_ORDER,
		testId = `{ v16.testId }--hero-media`
	}, {
		RoundedCorners = if Flags.FoundationMediaRoundedCornerTags then nil else React.createElement(Image, {
			ZIndex = 0,
			Image = v15.media,
			imageStyle = v15.mediaStyle,
			backgroundStyle = v15.backgroundStyle,
			aspectRatio = v15.aspectRatio,
			Position = UDim2.fromOffset(-offsetX, 0),
			Size = UDim2.new(1, offsetX * 2, v15.height.Scale, v15.height.Offset)
		}, {
			TransparencyGradient = React.createElement(Gradient, {
				top = false,
				fillDirection = Enum.FillDirection.Vertical
			})
		}),
		Image = React.createElement(Image, {
			Image = v15.media,
			imageStyle = v15.mediaStyle,
			backgroundStyle = v15.backgroundStyle,
			tag = v17.heroMedia.tag,
			aspectRatio = v15.aspectRatio,
			Position = UDim2.fromOffset(-offsetX, 0),
			Size = UDim2.new(1, offsetX * 2, v15.height.Scale, v15.height.Offset)
		}, if Flags.FoundationMediaRoundedCornerTags then nil else {
			TransparencyGradient = React.createElement(Gradient, {
				top = true,
				fillDirection = Enum.FillDirection.Vertical
			})
		})
	})
end

return DialogHeroMedia
