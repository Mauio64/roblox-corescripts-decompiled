local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Avatar = require(Foundation.Components.Avatar)
local Badge = require(Foundation.Components.Badge)
local Icon = require(Foundation.Components.Icon)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)

require(Foundation.Providers.Style.Tokens)

local AccessoryType = require(Foundation.Enums.AccessoryType)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)

require(Foundation.Enums.InputSize)

local function Accessory(t1: {[any]: any}) -- line: 46
	-- upvalues: AccessoryType (copy), React (copy), View (copy), PresentationContext (copy), ColorNamespace (copy), Avatar (copy), Text (copy), Badge (copy), Icon (copy)
	local accessory = t1.accessory

	if accessory == nil then
		return nil
	end

	local v15 = `align-x-center align-y-center { t1.iconVariant.tag }`

	if accessory.type == AccessoryType.Avatar then
		return React.createElement(View, {
			LayoutOrder = t1.LayoutOrder,
			tag = v15,
			testId = t1.testId
		}, {
			Avatar = React.createElement(PresentationContext.Provider, {
				value = {
					isIconSize = true,
					colorNamespace = ColorNamespace.Color
				}
			}, {
				Avatar = React.createElement(Avatar, {
					userId = accessory.userId,
					backplateStyle = t1.tokens.Color.Shift.Shift_200,
					size = t1.size
				})
			})
		})
	end

	if accessory.type == "Hint" then
		return React.createElement(View, {
			tag = "row align-y-center auto-xy padding-x-xsmall radius-small bg-shift-200",
			LayoutOrder = t1.LayoutOrder,
			testId = t1.testId
		}, {
			Text = React.createElement(Text, {
				tag = "auto-xy text-caption-medium content-muted",
				Text = accessory.text
			})
		})
	end

	if accessory.type == "Badge" then
		return React.createElement(Badge, {
			LayoutOrder = t1.LayoutOrder,
			text = accessory.text,
			icon = accessory.icon,
			variant = accessory.variant,
			testId = t1.testId
		})
	end

	return React.createElement(View, {
		LayoutOrder = t1.LayoutOrder,
		tag = v15,
		testId = t1.testId
	}, {
		Icon = React.createElement(Icon, {
			name = accessory.iconName,
			variant = accessory.iconVariant,
			style = t1.iconVariant.style,
			size = t1.iconVariant.size
		})
	})
end

return Accessory
