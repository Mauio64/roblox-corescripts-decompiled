local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)

local Cryo = require(parent2.Cryo)
local Responsive = require(parent2.Responsive)

local AppHeaderBarComponent = require(script.Parent.AppHeaderBarComponent)

local useStyle = UIBlox.Core.Style.useStyle
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger
local usePreferredInput = Responsive.usePreferredInput

require(parent.Types)

local function AppHeaderBarResponsive(props)
	local v = useBreakpointXOrLarger(Responsive.Keys.Medium)
	local v2 = useBreakpointXOrLarger(Responsive.Keys.Large)
	local v3 = usePreferredInput() == Responsive.Input.Directional
	local tokens = useStyle().Tokens
	local titleFontStyle = props.titleFontStyle
	local shouldRenderTitle = props.shouldRenderTitle
	local shouldRenderCenter = props.shouldRenderCenter
	local isTitleCentered = props.isTitleCentered
	local utilitiesGap = props.utilitiesGap
	local paddingTop = props.paddingTop
	local paddingBottom = props.paddingBottom
	local onMedia = props.onMedia

	local v4 = React.useMemo(function()
		local title

		if v2 and v3 then
			title = Cryo.None
		end

		local renderCenter

		if not (v2 and not v3 or shouldRenderCenter) then
			renderCenter = Cryo.None
		end

		local renderUserInfo

		if not v2 then
			renderUserInfo = Cryo.None
		end

		local avatarActionIcon

		if v2 then
			avatarActionIcon = Cryo.None
		end

		local searchActionIcon

		if v2 and not v3 then
			searchActionIcon = Cryo.None
		end

		local paddingTop2

		if v2 and not paddingTop then
			paddingTop2 = UDim.new(0, tokens.Size.Size_400)
		end

		local paddingBottom2

		if v2 and not paddingBottom then
			paddingBottom2 = UDim.new(0, tokens.Size.Size_400)
		end

		local v4 = {
			title = title,
			renderCenter = renderCenter,
			renderUserInfo = renderUserInfo,
			avatarActionIcon = avatarActionIcon,
			searchActionIcon = searchActionIcon,
			paddingTop = paddingTop2,
			paddingBottom = paddingBottom2,
			onMedia = v2 and v3 and onMedia == nil and true or nil
		}

		if shouldRenderTitle then
			v4.title = nil
		end

		local titleFontStyle2

		if v and not isTitleCentered then
			titleFontStyle2 = tokens.Typography.HeadingLarge
		else
			titleFontStyle2 = tokens.Typography.HeadingSmall
		end

		if titleFontStyle then
			titleFontStyle2 = nil
		end

		v4.titleFontStyle = titleFontStyle2
		local udim

		if v then
			udim = UDim.new(0, tokens.Size.Size_600)
		else
			udim = UDim.new(0, tokens.Size.Size_400)
		end

		if utilitiesGap then
			udim = nil
		end

		v4.utilitiesGap = udim

		return v4
	end, {
		v,
		v2,
		v3,
		tokens,
		titleFontStyle,
		shouldRenderCenter,
		isTitleCentered,
		utilitiesGap,
		paddingTop,
		paddingBottom,
		onMedia
	})

	local joined = Cryo.Dictionary.join(props, v4)
	return React.createElement(AppHeaderBarComponent, joined)
end

return AppHeaderBarResponsive
