local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local Foundation = require(ChatUIPrimitivesParent.Foundation)

require(ChatUIPrimitives.Types)

local function RewriteToggle(t1: {[any]: any}) -- line: 18
	-- upvalues: Foundation (copy), React (copy)
	local v7 = Foundation.Hooks.useTokens()
	local v8 = if not t1.showOriginal then Foundation.Enums.IconName.ChevronLargeDown else Foundation.Enums.IconName.ChevronLargeUp
	local v9 = t1.messageBinding:map(function(p1) -- line: 27
		return p1 ~= nil and p1.wasRewritten == true
	end)
	local v10 = t1.messageBinding:map(function(p2) -- line: 31
		if not p2 or not p2.originalText then
			return ""
		end

		return `<s>{ p2.originalText }</s>`
	end)
	local v11 = t1.messageBinding:map(function(p3) -- line: 38
		-- upvalues: t1 (copy)
		return p3 ~= nil and (p3.wasRewritten == true and t1.showOriginal)
	end)

	return React.createElement(Foundation.View, {
		tag = "col gap-xsmall auto-y",
		Size = UDim2.new(1, 0, 0, 0),
		backgroundStyle = {
			Transparency = 1,
			Color3 = Color3.new(0, 0, 0)
		},
		LayoutOrder = t1.LayoutOrder
	}, {
		toggleRow = React.createElement(Foundation.View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 1,
			backgroundStyle = {
				Transparency = 1,
				Color3 = Color3.new(0, 0, 0)
			},
			Visible = v9
		}, {
			label = React.createElement(Foundation.Text, {
				tag = "auto-xy text-caption-small text-align-x-left content-muted",
				Text = "(rephrased)",
				LayoutOrder = 1
			}),
			caret = React.createElement(Foundation.IconButton, {
				isCircular = true,
				LayoutOrder = 2,
				icon = v8,
				variant = Foundation.Enums.ButtonVariant.Utility,
				size = Foundation.Enums.InputSize.XSmall,
				onActivated = t1.onToggle
			})
		}),
		dropdown = React.createElement(Foundation.View, {
			tag = "col gap-xxsmall size-full-0 auto-y padding-small radius-medium",
			LayoutOrder = 2,
			backgroundStyle = {
				Transparency = 0.7,
				Color3 = v7.Color.Common.Scrim.Color3
			},
			Visible = v11
		}, {
			original = React.createElement(Foundation.Text, {
				tag = "text-caption-medium text-wrap text-align-x-left content-muted",
				RichText = true,
				LayoutOrder = 1,
				Text = v10,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			explanation = React.createElement(Foundation.Text, {
				tag = "text-caption-medium text-wrap text-align-x-left content-muted",
				Text = "Roblox rephrases messages that break safety rules.",
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		})
	})
end

return React.memo(RewriteToggle)
