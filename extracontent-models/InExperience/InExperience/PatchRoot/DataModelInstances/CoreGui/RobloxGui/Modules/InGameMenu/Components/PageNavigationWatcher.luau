local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local extended = Roact.PureComponent:extend("PageNavigationWatcher")
extended.validateProps = t.strictInterface({
	desiredPage = t.string,
	onNavigateTo = t.optional(t.callback),
	onNavigateAway = t.optional(t.callback),
	currentPage = t.string,
	menuOpen = t.boolean
})

function extended.init(object, p)
	object:setState({ lastPage = p.currentPage, lastMenuOpen = p.menuOpen })
end

function extended.render(p)
	return Roact.createFragment(p.props[Roact.Children])
end

function extended.didUpdate(object)
	local lastPage = object.state.lastPage
	local lastMenuOpen = object.state.lastMenuOpen
	local currentPage = object.props.currentPage
	local menuOpen = object.props.menuOpen

	if lastPage ~= currentPage or lastMenuOpen ~= menuOpen then
		object:setState({ lastPage = currentPage, lastMenuOpen = menuOpen })

		if currentPage == object.props.desiredPage and menuOpen and object.props.onNavigateTo ~= nil then
			object.props.onNavigateTo()
		elseif lastPage == object.props.desiredPage and lastMenuOpen and object.props.onNavigateAway ~= nil then
			object.props.onNavigateAway()
		elseif lastMenuOpen and not menuOpen and object.props.onNavigateAway ~= nil then
			object.props.onNavigateAway()
		end
	end
end

return RoactRodux.UNSTABLE_connect2(function(p)
	return { currentPage = p.menuPage, menuOpen = p.isMenuOpen }
end)(extended)
