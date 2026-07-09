local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FavoritePillView = require(script.Parent.FavoritePillView)
local useFavoritePillViewModel = require(script.Parent.useFavoritePillViewModel)

local function FavoritePillContainer(p1) -- line: 15
	-- upvalues: useFavoritePillViewModel (copy), React (copy), FavoritePillView (copy)
	local v7 = useFavoritePillViewModel(p1)

	return React.createElement(FavoritePillView, v7)
end

return FavoritePillContainer
