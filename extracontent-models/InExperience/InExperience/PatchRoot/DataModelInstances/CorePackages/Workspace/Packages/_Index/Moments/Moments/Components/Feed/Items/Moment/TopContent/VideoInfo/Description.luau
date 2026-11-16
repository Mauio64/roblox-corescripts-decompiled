local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Text = Foundation.Text
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding

local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)

local function Description(p)
	local v = useTokens()
	local v2 = MomentContext.useMoment()

	local v3 = useSignalBinding(v2.store.getIsModerated)
	local animationRatio = v2.animationRatio

	local description = v2.store.getData(false).description

	if description and description ~= "" then
		return React.createElement(View, {
			LayoutOrder = p.LayoutOrder,
			tag = "size-full-0 auto-y",
			Visible = v3:map(function(flag: boolean): boolean
				return not flag
			end)
		}, {
			DescriptionText = React.createElement(Text, {
				tag = "auto-xy text-body-large text-wrap text-align-x-left text-align-y-top text-truncate-split content-emphasis",
				Text = description,
				textStyle = animationRatio:map(function(p2: number)
					return getColorStyleWithTransparency(v.Color.Content.Emphasis, p2)
				end)
			})
		})
	end

	return nil
end

return React.memo(Description)
