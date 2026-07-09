local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local Cryo = require(ParentParentParent.Cryo)
local Responsive = require(ParentParentParent.Responsive)
local AppHeaderBarComponent = require(script.Parent.AppHeaderBarComponent)
local useStyle = UIBlox.Core.Style.useStyle
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger
local usePreferredInput = Responsive.usePreferredInput

require(ParentParent.Types)

local function AppHeaderBarResponsive(p1) -- line: 20
	-- upvalues: useBreakpointXOrLarger (copy), Responsive (copy), usePreferredInput (copy), useStyle (copy), React (copy), Cryo (copy), AppHeaderBarComponent (copy)
	local v13 = useBreakpointXOrLarger(Responsive.Keys.Medium)
	local v14 = useBreakpointXOrLarger(Responsive.Keys.Large)
	local v15 = usePreferredInput() == Responsive.Input.Directional
	local Tokens = useStyle().Tokens
	local titleFontStyle = p1.titleFontStyle
	local shouldRenderTitle = p1.shouldRenderTitle
	local shouldRenderCenter = p1.shouldRenderCenter
	local isTitleCentered = p1.isTitleCentered
	local utilitiesGap = p1.utilitiesGap
	local paddingTop = p1.paddingTop
	local paddingBottom = p1.paddingBottom
	local onMedia = p1.onMedia
	local v25 = React.useMemo(function() -- line: 37
		-- upvalues: v14 (copy), v15 (copy), Cryo (copy), shouldRenderCenter (copy), paddingTop (copy), Tokens (copy), paddingBottom (copy), onMedia (copy), shouldRenderTitle (copy), v13 (copy), isTitleCentered (copy), titleFontStyle (copy), utilitiesGap (copy)
		local t1 = {
			title = if not v14 or not v15 then nil else Cryo.None,
			renderCenter = if not (not not v14 and not v15) and not shouldRenderCenter then Cryo.None else nil,
			renderUserInfo = if not v14 then Cryo.None else nil,
			avatarActionIcon = if not v14 then nil else Cryo.None,
			searchActionIcon = if not v14 or v15 then nil else Cryo.None,
			paddingTop = if not v14 or paddingTop then nil else UDim.new(0, Tokens.Size.Size_400),
			paddingBottom = if not v14 or paddingBottom then nil else UDim.new(0, Tokens.Size.Size_400),
			onMedia = v14 and (not not v15 and onMedia == nil) or nil
		}

		if shouldRenderTitle then
			t1.title = nil
		end

		local v28 = if not v13 or isTitleCentered then Tokens.Typography.HeadingSmall else Tokens.Typography.HeadingLarge

		t1.titleFontStyle = if not titleFontStyle then v28 else nil

		local v29 = if not v13 then UDim.new(0, Tokens.Size.Size_400) else UDim.new(0, Tokens.Size.Size_600)

		t1.utilitiesGap = if not utilitiesGap then v29 else nil

		return t1
	end, {
		v13,
		v14,
		v15,
		Tokens,
		titleFontStyle,
		shouldRenderCenter,
		isTitleCentered,
		utilitiesGap,
		paddingTop,
		paddingBottom,
		onMedia
	})
	local v26 = Cryo.Dictionary.join(p1, v25)

	return React.createElement(AppHeaderBarComponent, v26)
end

return AppHeaderBarResponsive
