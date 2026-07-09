local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local Cryo = require(ServerDrivenUiParent.Cryo)
local React = require(ServerDrivenUiParent.React)
local HeroUnitContainer = require(ServerDrivenUiParent.DiscoveryHeroUnit).HeroUnitContainer
local SduiAttributionRow = require(ServerDrivenUiParent.SduiSharedContent).SduiAttributionRow
local SduiTextPill = require(ServerDrivenUi.Content.SduiTextPill)

require(ServerDrivenUiParent.SduiCoreSystem)

local function SduiHeroUnit(t1: {[any]: any}) -- line: 112
	-- upvalues: React (copy), SduiAttributionRow (copy), SduiTextPill (copy), Cryo (copy), HeroUnitContainer (copy)
	local children = t1.children
	local v11 = React.useMemo(function() -- line: 117
		-- upvalues: t1 (copy), React (copy), SduiAttributionRow (copy)
		if t1.asset then
			return React.createElement(SduiAttributionRow, {
				image = t1.asset.image,
				title = t1.asset.title,
				subtitle = t1.asset.subtitle,
				rightButtonContent = t1.ctaButtonComponent,
				sduiContext = t1.sduiContext,
				onActivated = t1.onActivated
			})
		end

		return nil
	end, {
		t1.asset,
		t1.ctaButtonComponent,
		t1.sduiContext,
		t1.onActivated
	})
	local v12 = React.useMemo(function() -- line: 133
		-- upvalues: t1 (copy), React (copy), SduiTextPill (copy)
		if t1.badgeText then
			return React.createElement(SduiTextPill, {
				sduiContext = t1.sduiContext,
				text = t1.badgeText
			})
		end

		return nil
	end, {
		t1.badgeText,
		t1.sduiContext
	})
	local v13 = React.useMemo(function() -- line: 143
		-- upvalues: Cryo (copy), v11 (copy), v12 (copy), t1 (copy)
		return (Cryo.Dictionary.join({
			bottomRowComponent = v11,
			overlayComponent = v12,
			sideMargin = t1.pageSideMargin
		}, t1))
	end, {
		t1,
		v11,
		v12,
		t1.pageSideMargin
	})

	return React.createElement(HeroUnitContainer, v13, children)
end

return React.memo(SduiHeroUnit)
