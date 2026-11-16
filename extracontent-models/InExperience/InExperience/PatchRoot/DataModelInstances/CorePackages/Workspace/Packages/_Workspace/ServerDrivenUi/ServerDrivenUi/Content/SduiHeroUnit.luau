local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local DiscoveryHeroUnit = require(parent.DiscoveryHeroUnit)
local HeroUnitContainer = DiscoveryHeroUnit.HeroUnitContainer
local SduiSharedContent = require(parent.SduiSharedContent)
local SduiAttributionRow = SduiSharedContent.SduiAttributionRow
local SduiTextPill = require(ServerDrivenUi.Content.SduiTextPill)

require(parent.SduiCoreSystem)

local function SduiHeroUnit(props)
	local children = props.children

	local bottomRowComponent = React.useMemo(function()
		if props.asset then
			return React.createElement(SduiAttributionRow, {
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

	local overlayComponent = React.useMemo(function()
		if props.badgeText then
			return React.createElement(SduiTextPill, {
				sduiContext = props.sduiContext,
				text = props.badgeText
			})
		end

		return nil
	end, { props.badgeText, props.sduiContext })

	local v = React.useMemo(function()
		return (Cryo.Dictionary.join(
			{
				bottomRowComponent = bottomRowComponent,
				overlayComponent = overlayComponent,
				sideMargin = props.pageSideMargin
			},
			props
		))
	end, { props, bottomRowComponent, overlayComponent, props.pageSideMargin })

	return React.createElement(HeroUnitContainer, v, children)
end

return React.memo(SduiHeroUnit)
