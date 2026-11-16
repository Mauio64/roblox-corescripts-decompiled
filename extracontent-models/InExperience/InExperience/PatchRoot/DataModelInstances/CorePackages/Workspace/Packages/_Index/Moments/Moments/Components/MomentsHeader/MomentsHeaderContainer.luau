local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local ImmersiveHeaderChrome = require(script.Parent.ImmersiveHeaderChrome)
local MomentsHeaderView = require(script.Parent.MomentsHeaderView)
local useMomentsHeaderViewModel = require(script.Parent.useMomentsHeaderViewModel)

local function MomentsHeaderContainer(props)
	local animateWithImmersiveChrome = props.animateWithImmersiveChrome == true
	local v = useMomentsHeaderViewModel(props, animateWithImmersiveChrome, props.showHamburger ~= false)

	local element = React.createElement(MomentsHeaderView, v)

	if animateWithImmersiveChrome then
		return React.createElement(ImmersiveHeaderChrome, {
			layoutOrder = props.layoutOrder,
			children = element
		})
	end

	return element
end

return MomentsHeaderContainer
