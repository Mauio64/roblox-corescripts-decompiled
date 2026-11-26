local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/UIBlox")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Cryo")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Responsive")

local AppHeaderBarComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Components/AppHeaderBarComponent")

local useStyle = UIBlox.Core.Style.useStyle
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger
local usePreferredInput = Responsive.usePreferredInput

require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Types")

local function AppHeaderBarResponsive(props)
	local v5 = useBreakpointXOrLarger(Responsive.Keys.Medium)
	local v6 = useBreakpointXOrLarger(Responsive.Keys.Large)
	local v7 = usePreferredInput() == Responsive.Input.Directional
	local tokens = useStyle().Tokens
	local titleFontStyle = props.titleFontStyle
	local shouldRenderTitle = props.shouldRenderTitle
	local shouldRenderCenter = props.shouldRenderCenter
	local isTitleCentered = props.isTitleCentered
	local utilitiesGap = props.utilitiesGap
	local paddingTop = props.paddingTop
	local paddingBottom = props.paddingBottom
	local onMedia = props.onMedia

	local v8 = React.useMemo(function()
		local v10 = if v6 and v7 then Cryo.None else nil

		local v11 = if not (v6 and not v7 or shouldRenderCenter) then Cryo.None else nil
		local v12 = if not v6 then Cryo.None else nil
		local v13 = if v6 then Cryo.None else nil
		local v14 = if v6 and not v7 then Cryo.None else nil
		local v15 = if v6 and not paddingTop then UDim.new(0, tokens.Size.Size_400) else nil
		local v16 = if v6 and not paddingBottom then UDim.new(0, tokens.Size.Size_400) else nil
		local v9 = {
			title = v10,
			renderCenter = v11,
			renderUserInfo = v12,
			avatarActionIcon = v13,
			searchActionIcon = v14,
			paddingTop = v15,
			paddingBottom = v16,
			onMedia = v6 and v7 and onMedia == nil and true or nil
		}

		if shouldRenderTitle then
			v9.title = nil
		end

		local v17

		if v5 and not isTitleCentered then
			v17 = tokens.Typography.HeadingLarge
		else
			v17 = tokens.Typography.HeadingSmall
		end

		if titleFontStyle then
			v17 = nil
		end

		v9.titleFontStyle = v17

		local udim = if v5 then UDim.new(0, tokens.Size.Size_600) else UDim.new(0, tokens.Size.Size_400)

		if utilitiesGap then
			udim = nil
		end

		v9.utilitiesGap = udim

		return v9
	end, {
		v5,
		v6,
		v7,
		tokens,
		titleFontStyle,
		shouldRenderCenter,
		isTitleCentered,
		utilitiesGap,
		paddingTop,
		paddingBottom,
		onMedia
	})

	local joined = Cryo.Dictionary.join(props, v8)
	return React.createElement(AppHeaderBarComponent, joined)
end

return AppHeaderBarResponsive
