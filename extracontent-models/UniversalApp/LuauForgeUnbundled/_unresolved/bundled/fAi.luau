local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local utilityActionIcon = UIBlox.App.Button.UtilityActionIcon

local Foundation = require(CorePackages.Packages.Foundation)

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local fFlagEnableHeaderBarButtonsUpdate = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableHeaderBarButtonsUpdate

local iconscommonsearch = images["icons/common/search"]

local extended = Roact.PureComponent:extend("SearchButton")

extended.validateProps = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	isSecondary = t.optional(t.boolean),
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	enableSearch = t.boolean
})

local function isVisible(p2)
	return p2.enableSearch and p2.isCompactView
end

function extended:updateVisibility(p3)
	local props = self.props
	local isCompactView = props.enableSearch and props.isCompactView

	if isCompactView ~= p3 then
		self.props.setVisible(isCompactView)
	end
end

function extended:didMount()
	self:updateVisibility(nil)
end

function extended:didUpdate(p2, p3)
	self:updateVisibility(p2.enableSearch and p2.isCompactView)
end

function extended.render(p2)
	if fFlagEnableHeaderBarButtonsUpdate then
		return Roact.createElement(Foundation.IconButton, {
			isCircular = true,
			icon = Foundation.Enums.IconName.MagnifyingGlass,
			onActivated = p2.props.activateSearch,
			ref = p2.props.buttonRef,
			testId = "--topbar-button-search"
		})
	end

	return Roact.createElement(utilityActionIcon, {
		icon = iconscommonsearch,
		onActivated = p2.props.activateSearch,
		ref = p2.props.buttonRef
	})
end

return (roactAppPolicy.connect(function(p2, p3)
	return { enableSearch = p2.getSearchBar() }
end)(extended))
