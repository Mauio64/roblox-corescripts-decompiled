local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes")
local CollectionLayoutStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/CollectionLayoutStoreContext")
local createCollectionLayoutStore = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/createCollectionLayoutStore")
local getMainCollectionLayoutStore = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/getMainCollectionLayoutStore")

local function CollectionLayoutStoreProvider(p2)
	local v5, v6 = React.useMemo(function()
		return Signals.createSignal(0)
	end, {})

	React.useEffect(function()
		local container = p2.container

		if not container then
			return
		end

		v6(container.AbsoluteSize.X)
		local absoluteSizeChangedConnection = container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			v6(container.AbsoluteSize.X)
		end)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { p2.container })

	local v7 = React.useMemo(function()
		return createCollectionLayoutStore(v5, getMainCollectionLayoutStore(false))
	end, { v5 })

	return React.createElement(CollectionLayoutStoreContext.Provider, { value = v7 }, p2.children)
end

return CollectionLayoutStoreProvider
