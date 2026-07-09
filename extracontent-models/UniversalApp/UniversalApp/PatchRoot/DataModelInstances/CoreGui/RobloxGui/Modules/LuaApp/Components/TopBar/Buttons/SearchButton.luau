local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local Foundation = require(CorePackages.Packages.Foundation)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local FFlagEnableHeaderBarButtonsUpdate = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableHeaderBarButtonsUpdate
local v11 = Images["icons/common/search"]
local v12 = Roact.PureComponent:extend("SearchButton")

v12.validateProps = t.strictInterface({
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

local function isVisible(p1) -- line: 35
	return p1.enableSearch and p1.isCompactView
end

function v12.updateVisibility(p2, p3) -- line: 40
	local props = p2.props
	local v18 = props.enableSearch and props.isCompactView

	if v18 ~= p3 then
		p2.props.setVisible(v18)
	end
end
function v12.didMount(p4) -- line: 47
	p4:updateVisibility(nil)
end
function v12.didUpdate(p5, p6, _) -- line: 51
	p5:updateVisibility(p6.enableSearch and p6.isCompactView)
end
function v12.render(p8) -- line: 55
	-- upvalues: FFlagEnableHeaderBarButtonsUpdate (copy), Roact (copy), Foundation (copy), UtilityActionIcon (copy), v11 (copy)
	if FFlagEnableHeaderBarButtonsUpdate then
		return Roact.createElement(Foundation.IconButton, {
			isCircular = true,
			icon = Foundation.Enums.IconName.MagnifyingGlass,
			onActivated = p8.props.activateSearch,
			ref = p8.props.buttonRef
		})
	end

	return Roact.createElement(UtilityActionIcon, {
		icon = v11,
		onActivated = p8.props.activateSearch,
		ref = p8.props.buttonRef
	})
end

return (RoactAppPolicy.connect(function(p9, _) -- line: 72
	return {
		enableSearch = p9.getSearchBar()
	}
end)(v12))
