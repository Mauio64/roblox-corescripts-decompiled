local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local v6 = Roact.PureComponent:extend("PageNavigationWatcher")

v6.validateProps = t.strictInterface({
	desiredPage = t.string,
	onNavigateTo = t.optional(t.callback),
	onNavigateAway = t.optional(t.callback),
	currentPage = t.string,
	menuOpen = t.boolean
})

function v6.init(p1, p2) -- line: 25
	p1:setState({
		lastPage = p2.currentPage,
		lastMenuOpen = p2.menuOpen
	})
end
function v6.render(p3) -- line: 32
	-- upvalues: Roact (copy)
	return Roact.createFragment(p3.props[Roact.Children])
end
function v6.didUpdate(p4) -- line: 36
	local lastPage = p4.state.lastPage
	local lastMenuOpen = p4.state.lastMenuOpen
	local currentPage = p4.props.currentPage
	local menuOpen = p4.props.menuOpen

	if lastPage ~= currentPage or lastMenuOpen ~= menuOpen then
		p4:setState({
			lastPage = currentPage,
			lastMenuOpen = menuOpen
		})

		if currentPage == p4.props.desiredPage and menuOpen and p4.props.onNavigateTo ~= nil then
			p4.props.onNavigateTo()

			return
		end

		if lastPage == p4.props.desiredPage and lastMenuOpen and p4.props.onNavigateAway ~= nil then
			p4.props.onNavigateAway()

			return
		end

		if lastMenuOpen and not menuOpen and p4.props.onNavigateAway ~= nil then
			p4.props.onNavigateAway()
		end
	end
end

return RoactRodux.UNSTABLE_connect2(function(p5) -- line: 58
	return {
		currentPage = p5.menuPage,
		menuOpen = p5.isMenuOpen
	}
end)(v6)
