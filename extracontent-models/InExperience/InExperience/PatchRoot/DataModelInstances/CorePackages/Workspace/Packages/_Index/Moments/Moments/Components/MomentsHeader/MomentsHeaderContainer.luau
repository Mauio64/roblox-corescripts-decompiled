local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local FFlagMomentsImmersiveChrome = require(Moments.Flags.FFlagMomentsImmersiveChrome)
local FFlagMomentsUseCompositionLibrary = require(Moments.Flags.FFlagMomentsUseCompositionLibrary)
local FFlagMomentsUseFoundationHeaderBar = require(Moments.Flags.FFlagMomentsUseFoundationHeaderBar)
local ImmersiveHeaderChrome = require(script.Parent.ImmersiveHeaderChrome)
local MomentsHeaderView = require(script.Parent.MomentsHeaderView)
local MomentsLegacyHeaderView = require(script.Parent.MomentsLegacyHeaderView)
local useMomentsHeaderViewModel = require(script.Parent.useMomentsHeaderViewModel)

local function MomentsHeaderContainer(p1) -- line: 18
	-- upvalues: FFlagMomentsImmersiveChrome (copy), FFlagMomentsUseCompositionLibrary (copy), FFlagMomentsUseFoundationHeaderBar (copy), useMomentsHeaderViewModel (copy), React (copy), MomentsHeaderView (copy), MomentsLegacyHeaderView (copy), ImmersiveHeaderChrome (copy)
	local v13 = p1.animateWithImmersiveChrome == true and FFlagMomentsImmersiveChrome
	local v14 = FFlagMomentsUseCompositionLibrary and FFlagMomentsUseFoundationHeaderBar
	local v15 = not v14 or p1.showHamburger ~= false
	local v16 = useMomentsHeaderViewModel(p1, v13, v15)
	local v17 = if not v14 then React.createElement(MomentsLegacyHeaderView, v16) else React.createElement(MomentsHeaderView, v16)

	if v13 then
		return React.createElement(ImmersiveHeaderChrome, {
			layoutOrder = p1.layoutOrder,
			children = v17
		})
	end

	return v17
end

return MomentsHeaderContainer
