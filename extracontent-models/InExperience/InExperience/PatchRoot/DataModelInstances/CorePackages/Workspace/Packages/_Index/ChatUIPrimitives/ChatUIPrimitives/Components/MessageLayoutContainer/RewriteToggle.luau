local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

require(ChatUIPrimitives.Types)

local function RewriteToggle(props)
	local v = Foundation.Hooks.useTokens()
	local icon

	if props.showOriginal then
		icon = Foundation.Enums.IconName.ChevronLargeUp
	else
		icon = Foundation.Enums.IconName.ChevronLargeDown
	end

	local mapped = props.messageBinding:map(function(p): boolean
		return p ~= nil and p.wasRewritten == true
	end)

	local mapped2 = props.messageBinding:map(function(p)
		if p and p.originalText then
			return `<s>{p.originalText}</s>`
		end

		return ""
	end)

	local mapped3 = props.messageBinding:map(function(p)
		return p ~= nil and p.wasRewritten == true and props.showOriginal
	end)

	return React.createElement(Foundation.View, {
		tag = "col gap-xsmall auto-y",
		Size = UDim2.new(1, 0, 0, 0),
		backgroundStyle = { Color3 = Color3.new(0, 0, 0), Transparency = 1 },
		LayoutOrder = props.LayoutOrder
	}, {
		toggleRow = React.createElement(Foundation.View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			backgroundStyle = { Color3 = Color3.new(0, 0, 0), Transparency = 1 },
			Visible = mapped,
			LayoutOrder = 1
		}, {
			label = React.createElement(Foundation.Text, {
				tag = "auto-xy text-caption-small text-align-x-left content-muted",
				Text = "(rephrased)",
				LayoutOrder = 1
			}),
			caret = React.createElement(Foundation.IconButton, {
				icon = icon,
				variant = Foundation.Enums.ButtonVariant.Utility,
				size = Foundation.Enums.InputSize.XSmall,
				isCircular = true,
				onActivated = props.onToggle,
				LayoutOrder = 2
			})
		}),
		dropdown = React.createElement(Foundation.View, {
			tag = "col gap-xxsmall size-full-0 auto-y padding-small radius-medium",
			backgroundStyle = { Color3 = v.Color.Common.Scrim.Color3, Transparency = 0.7 },
			Visible = mapped3,
			LayoutOrder = 2
		}, {
			original = React.createElement(Foundation.Text, {
				tag = "text-caption-medium text-wrap text-align-x-left content-muted",
				Text = mapped2,
				RichText = true,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}),
			explanation = React.createElement(Foundation.Text, {
				tag = "text-caption-medium text-wrap text-align-x-left content-muted",
				Text = "Roblox rephrases messages that break safety rules.",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			})
		})
	})
end

return React.memo(RewriteToggle)
