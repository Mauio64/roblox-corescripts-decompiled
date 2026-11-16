local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local MomentShareCardView = require(script.Parent.MomentShareCardView)
local useMomentShareCardViewModel = require(script.Parent.useMomentShareCardViewModel)

local function MomentShareCardContainer(p)
	local v = useMomentShareCardViewModel(p)
	return React.createElement(MomentShareCardView, v)
end

return MomentShareCardContainer
