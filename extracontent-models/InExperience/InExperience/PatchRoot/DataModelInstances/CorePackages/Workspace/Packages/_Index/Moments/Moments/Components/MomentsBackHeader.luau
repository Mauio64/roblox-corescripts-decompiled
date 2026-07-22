local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local MomentsHeaderContainer = require(Moments.Components.MomentsHeader.MomentsHeaderContainer)

local function MomentsBackHeader(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy), MomentsHeaderContainer (copy)
	return React.createElement(MomentsHeaderContainer, {
		variant = "back",
		showTopScrim = true,
		layoutOrder = t1.layoutOrder,
		onBack = t1.onBack
	})
end

return MomentsBackHeader
