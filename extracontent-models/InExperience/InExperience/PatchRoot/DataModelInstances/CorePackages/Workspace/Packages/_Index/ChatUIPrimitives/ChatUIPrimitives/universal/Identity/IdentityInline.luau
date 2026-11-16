local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

require(script.Parent.Parent.Types)

local function IdentityInline(p)
	local nextOrder = createNextOrder()
	local v = SignalsReact.useSignalBinding(p.getIdentity)

	return React.createElement(
		Foundation.View,
		{ tag = "row align-x-left align-y-center gap-xsmall auto-xy", LayoutOrder = p.LayoutOrder },
		{
			avatar = React.createElement(Foundation.Image, {
				tag = "size-400-400 stroke-standard stroke-default radius-circle",
				Image = v:map(function(p2)
					if p2 and p2.avatarContent then
						return p2.avatarContent
					end

					return ""
				end),
				LayoutOrder = nextOrder()
			}),
			displayName = React.createElement(Foundation.Text, {
				tag = "auto-xy",
				Text = v:map(function(p2)
					if p2 then
						return `{p2.displayName}:`
					end

					return ""
				end),
				LayoutOrder = nextOrder()
			})
		}
	)
end

return IdentityInline
