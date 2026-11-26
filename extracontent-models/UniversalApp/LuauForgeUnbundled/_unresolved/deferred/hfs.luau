local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Dash = require(CorePackages.Packages.Dash)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local segmentedControl = UIBlox.App.Control.SegmentedControl

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/gJz")
local module2 = require("@luauforge/bundled/fDf")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local module4 = require("@luauforge/bundled/fAe")

local fFlagAXUseProfileIconEntryPoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseProfileIconEntryPoint

local extended = Roact.PureComponent:extend("AXTransitionSegmentedMenu")

extended.validateProps = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	navigation = t.table,
	avatarRoute = avatarRoute.Interface,
	topBarHeight = t.number,
	avatarAnalytics = t.table,
	catalogAnalytics = t.table,
	[Roact.Ref] = t.optional(t.table)
})

function extended:getOpaquePage()
	return self.props.avatarRoute.opaque.name
end

function extended:init()
	self:setState({ segmentedControlWidth = 234 })

	function self.goToAvatarEditorPage()
		if self:getOpaquePage() ~= avatarScreen.AvatarEditor then
			self.props.navigation.navigate(avatarScreen.AvatarEditor)

			self.props.avatarAnalytics.catalogToAvatarButton()
		end
	end

	function self.goToCatalogPage()
		if self:getOpaquePage() ~= avatarScreen.Catalog then
			self.props.navigation.navigate(avatarScreen.Catalog)

			self.props.catalogAnalytics.avatarToCatalogButton()
		end
	end

	function self.onTabActivated(p2)
		if p2 == 1 then
			self.goToCatalogPage()
		elseif p2 == 2 then
			self.goToAvatarEditorPage()
		end
	end
end

function extended:render()
	return withLocalization({
		customizeText = "Feature.Catalog.Action.Customize",
		shopText = "Feature.Avatar.Action.Marketplace"
	})(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended:renderWithProviders(p2)
	if fFlagAXUseProfileIconEntryPoint and self:getOpaquePage() == avatarScreen.Profile then
		return nil
	end

	local v6 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = function(p3)
			self:absoluteSizeChanged(p3)
		end
	}

	local v7 = self.props.formFactor == "WIDE"

	return Roact.createElement(RoactGamepad.Focusable.Frame, v6, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SegmentedControl = Roact.createElement(segmentedControl, {
			width = UDim.new(0, self.state.segmentedControlWidth),
			maxWidth = not v7 and 234 or nil,
			selectedTabIndex = self:getOpaquePage() == avatarScreen.Catalog and 1 or 2,
			onTabActivated = self.onTabActivated,
			tabs = {
				{ tabName = p2.shopText },
				{ tabName = p2.customizeText }
			}
		})
	})
end

function extended.absoluteSizeChanged(object, p2)
	object:setState({
		segmentedControlWidth = p2.AbsoluteSize.X >= 234 and 234 or 224
	})
end

local v6 = RoactRodux.connect(function(p2, p3)
	return { topBarHeight = p2.TopBar.topBarHeight }
end, nil)(extended)

local v7 = roactServices.connect({
	avatarAnalytics = module,
	catalogAnalytics = module2
})(v6)

return (module4((RoactNavigation.withNavigation(v7))))
