local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local ImmersiveHeaderChrome = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/ImmersiveHeaderChrome")
local MomentsHeaderView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/MomentsHeaderView")
local useMomentsHeaderViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/useMomentsHeaderViewModel")

local function MomentsHeaderContainer(props)
	local animateWithImmersiveChrome = props.animateWithImmersiveChrome == true
	local showHamburger = props.showHamburger ~= false
	local v5 = useMomentsHeaderViewModel(props, animateWithImmersiveChrome, showHamburger)

	local element = React.createElement(MomentsHeaderView, v5)

	if animateWithImmersiveChrome then
		return React.createElement(ImmersiveHeaderChrome, {
			layoutOrder = props.layoutOrder,
			children = element
		})
	end

	return element
end

return MomentsHeaderContainer
