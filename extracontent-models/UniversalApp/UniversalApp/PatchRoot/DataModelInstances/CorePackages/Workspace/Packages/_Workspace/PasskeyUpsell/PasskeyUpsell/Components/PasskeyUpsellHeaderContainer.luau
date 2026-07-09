local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local ThemeName = UIBlox.App.Style.Constants.ThemeName
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local FoundationImage = Foundation.Image

local function checkGraphicExistence(s1: string) -- line: 30
	-- upvalues: Images (copy)
	return Images[s1].image
end
local function PasskeyUpsellHeaderContainer(t1: {[any]: any}) -- line: 37
	-- upvalues: useStyle (copy), useStyleMetadata (copy), ThemeName (copy), checkGraphicExistence (copy), React (copy), View (copy), ImageSetButton (copy), Images (copy), FoundationText (copy), FoundationImage (copy)
	local v17 = useStyle()
	local v18 = useStyleMetadata().ThemeName == ThemeName.Dark
	local s2 = "icons/graphic/passkey_upsell"
	local ok, _ = pcall(checkGraphicExistence, s2)

	if not ok then
		s2 = not v18 and "icons/graphic/passkey_upsell_light" or "icons/graphic/passkey_upsell_dark"
	end

	return React.createElement(View, {
		tag = "col gap-xxlarge size-full-0 auto-y padding-bottom-xxlarge",
		padding = {
			top = UDim.new(0, 48)
		}
	}, {
		CloseButton = React.createElement(ImageSetButton, {
			Size = UDim2.new(0, 36, 0, 36),
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			Image = Images["icons/navigation/close"],
			[React.Event.Activated] = t1.onCancelButtonPressed,
			BackgroundColor3 = v17.Theme.BackgroundUIContrast.Color,
			ImageColor3 = v17.Theme.UIEmphasis.Color,
			LayoutOrder = 1,
			Active = not t1.isDisabled
		}),
		Title = React.createElement(FoundationText, {
			TextWrapped = true,
			tag = "content-action-emphasis text-align-x-left text-heading-medium auto-xy padding-left",
			LayoutOrder = 3,
			Text = t1.localizedTitleText,
			textStyle = {
				Color3 = v17.Theme.TextEmphasis.Color
			}
		}),
		Graphic = t1.shouldRenderGraphic and React.createElement(View, {
			tag = "auto-xy position-center-center grow",
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0.27, 0)
		}, {
			UpsellGraphic = React.createElement(FoundationImage, {
				Image = s2,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	})
end

return PasskeyUpsellHeaderContainer
