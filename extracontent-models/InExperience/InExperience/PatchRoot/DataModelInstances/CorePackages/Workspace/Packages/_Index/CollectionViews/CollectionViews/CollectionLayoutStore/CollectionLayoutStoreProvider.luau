local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

require(CollectionViews.CollectionViewTypes)
local CollectionLayoutStoreContext = require(script.Parent.CollectionLayoutStoreContext)
local createCollectionLayoutStore = require(script.Parent.createCollectionLayoutStore)
local getMainCollectionLayoutStore = require(script.Parent.getMainCollectionLayoutStore)

local function CollectionLayoutStoreProvider(p)
	local v, v2 = React.useMemo(function()
		return Signals.createSignal(0)
	end, {})

	React.useEffect(function()
		local container = p.container

		if not container then
			return
		end

		v2(container.AbsoluteSize.X)
		local absoluteSizeChangedConnection = container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			v2(container.AbsoluteSize.X)
		end)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { p.container })

	local v3 = React.useMemo(function()
		return createCollectionLayoutStore(v, getMainCollectionLayoutStore(false))
	end, { v })

	return React.createElement(CollectionLayoutStoreContext.Provider, { value = v3 }, p.children)
end

return CollectionLayoutStoreProvider
