local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Dash = require(CorePackages.Packages.Dash)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local SegmentedControl = UIBlox.App.Control.SegmentedControl
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local v19 = Roact.PureComponent:extend("AXTransitionSegmentedMenu")

v19.validateProps = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
	topBarHeight = t.number,
	avatarAnalytics = t.table,
	catalogAnalytics = t.table,
	[Roact.Ref] = t.optional(t.table)
})

function v19.getOpaquePage(p1) -- line: 61
	return p1.props.avatarRoute.opaque.name
end
function v19.init(p2) -- line: 65
	-- upvalues: AvatarScreen (copy)
	p2:setState({
		segmentedControlWidth = 234
	})

	function p2.goToAvatarEditorPage() -- line: 70
		-- upvalues: p2 (copy), AvatarScreen (copy)
		if p2:getOpaquePage() ~= AvatarScreen.AvatarEditor then
			p2.props.navigation.navigate(AvatarScreen.AvatarEditor)
			p2.props.avatarAnalytics.catalogToAvatarButton()
		end
	end
	function p2.goToCatalogPage() -- line: 78
		-- upvalues: p2 (copy), AvatarScreen (copy)
		if p2:getOpaquePage() ~= AvatarScreen.Catalog then
			p2.props.navigation.navigate(AvatarScreen.Catalog)
			p2.props.catalogAnalytics.avatarToCatalogButton()
		end
	end
	function p2.onTabActivated(p3) -- line: 86
		-- upvalues: p2 (copy)
		if p3 == 1 then
			p2.goToCatalogPage()

			return
		end

		if p3 == 2 then
			p2.goToAvatarEditorPage()
		end
	end
end
function v19.render(p4) -- line: 95
	-- upvalues: withLocalization (copy)
	return withLocalization({
		customizeText = "Feature.Catalog.Action.Customize",
		shopText = "Feature.Avatar.Action.Marketplace"
	})(function(p5) -- line: 99
		-- upvalues: p4 (copy)
		return p4:renderWithProviders(p5)
	end)
end
function v19.renderWithProviders(p6, p7) -- line: 104
	-- upvalues: Roact (copy), RoactGamepad (copy), SegmentedControl (copy), AvatarScreen (copy)
	local t1 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = function(p8) -- line: 108
			-- upvalues: p6 (copy)
			p6:absoluteSizeChanged(p8)
		end
	}
	local v28 = p6.props.formFactor == "WIDE"

	return Roact.createElement(RoactGamepad.Focusable.Frame, t1, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SegmentedControl = Roact.createElement(SegmentedControl, {
			width = UDim.new(0, p6.state.segmentedControlWidth),
			maxWidth = if v28 then nil else 234,
			selectedTabIndex = p6:getOpaquePage() ~= AvatarScreen.Catalog and 2 or 1,
			onTabActivated = p6.onTabActivated,
			tabs = {
				{
					tabName = p7.shopText
				},
				{
					tabName = p7.customizeText
				}
			}
		})
	})
end
function v19.absoluteSizeChanged(p9, p10) -- line: 141
	p9:setState({
		segmentedControlWidth = not (p10.AbsoluteSize.X >= 234) and 224 or 234
	})
end

local v20 = RoactRodux.connect(function(p11, _) -- line: 147
	return {
		topBarHeight = p11.TopBar.topBarHeight
	}
end, nil)(v19)
local v21 = RoactServices.connect({
	avatarAnalytics = Analytics,
	catalogAnalytics = Analytics2
})(v20)

return (withAvatarRoute((RoactNavigation.withNavigation(v21))))
