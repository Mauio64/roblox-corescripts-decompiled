local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)
local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

require(Foundation.Enums.DialogSize)

local useDialog = require(script.Parent.Parent.useDialog)
local withDefaults = require(Foundation.Utility.withDefaults)
local useDialogVariants = require(script.Parent.Parent.useDialogVariants)
local useDialogVariants2 = useDialogVariants.useDialogVariants

local v = { height = UDim.new(1, 0) }

local function DialogHeroMedia(p)
	local v2 = withDefaults(p, v)
	local v3 = useDialog()
	local v4 = useDialogVariants2()

	React.useEffect(function()
		v3.setHasHeroMedia(true)

		return function()
			v3.setHasHeroMedia(false)
		end
	end, {})

	local offsetX = v4.heroMedia.offsetX

	return React.createElement(
		View,
		{
			tag = v4.heroMediaWrapper.tag,
			LayoutOrder = Constants.MIN_LAYOUT_ORDER,
			testId = `{v3.testId}--hero-media`
		},
		{
			Image = React.createElement(Image, {
				Image = v2.media,
				imageStyle = v2.mediaStyle,
				backgroundStyle = v2.backgroundStyle,
				tag = v4.heroMedia.tag,
				aspectRatio = v2.aspectRatio,
				ScaleType = v2.scaleType,
				testId = `{v3.testId}--hero-media-image`,
				Position = UDim2.fromOffset(-offsetX, 0),
				Size = UDim2.new(1, offsetX * 2, v2.height.Scale, v2.height.Offset)
			})
		}
	)
end

return DialogHeroMedia
