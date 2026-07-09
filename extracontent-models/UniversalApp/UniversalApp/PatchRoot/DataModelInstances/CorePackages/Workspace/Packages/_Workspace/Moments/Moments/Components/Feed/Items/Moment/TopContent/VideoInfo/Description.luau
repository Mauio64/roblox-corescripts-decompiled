local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)

local function Description(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), MomentContext (copy), useSignalBinding (copy), React (copy), View (copy), FoundationText (copy), getColorStyleWithTransparency (copy)
	local v14 = useTokens()
	local v15 = MomentContext.useMoment()
	local v16 = useSignalBinding(v15.store.getIsModerated)
	local animationRatio = v15.animationRatio
	local description = v15.store.getData(false).description

	if not description or description == "" then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder,
		Visible = v16:map(function(b1: boolean) -- line: 48
			return not b1
		end)
	}, {
		DescriptionText = React.createElement(FoundationText, {
			tag = "auto-xy text-body-large text-wrap text-align-x-left text-align-y-top text-truncate-split content-emphasis",
			Text = description,
			textStyle = animationRatio:map(function(n1: number) -- line: 57
				-- upvalues: getColorStyleWithTransparency (copy), v14 (copy)
				return getColorStyleWithTransparency(v14.Color.Content.Emphasis, n1)
			end)
		})
	})
end

return React.memo(Description)
