local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")

local heroUnitContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryHeroUnit").HeroUnitContainer
local sduiAttributionRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiAttributionRow
local SduiTextPill = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTextPill")

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local function SduiHeroUnit(props)
	local children = props.children

	local v5 = React.useMemo(function()
		if props.asset then
			return React.createElement(sduiAttributionRow, {
				image = props.asset.image,
				title = props.asset.title,
				subtitle = props.asset.subtitle,
				rightButtonContent = props.ctaButtonComponent,
				sduiContext = props.sduiContext,
				onActivated = props.onActivated
			})
		end

		return nil
	end, { props.asset, props.ctaButtonComponent, props.sduiContext, props.onActivated })

	local v6 = React.useMemo(function()
		if props.badgeText then
			return React.createElement(SduiTextPill, {
				sduiContext = props.sduiContext,
				text = props.badgeText
			})
		end

		return nil
	end, { props.badgeText, props.sduiContext })

	local v7 = React.useMemo(function()
		return (Cryo.Dictionary.join(
			{
				bottomRowComponent = v5,
				overlayComponent = v6,
				sideMargin = props.pageSideMargin
			},
			props
		))
	end, { props, v5, v6, props.pageSideMargin })

	return React.createElement(heroUnitContainer, v7, children)
end

return React.memo(SduiHeroUnit)
