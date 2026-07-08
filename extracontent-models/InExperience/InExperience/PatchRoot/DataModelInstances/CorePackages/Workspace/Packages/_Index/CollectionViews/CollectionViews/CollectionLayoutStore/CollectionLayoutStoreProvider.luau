local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local Signals = require(CollectionViewsParent.Signals)

require(CollectionViews.CollectionViewTypes)

local CollectionLayoutStoreContext = require(script.Parent.CollectionLayoutStoreContext)
local createCollectionLayoutStore = require(script.Parent.createCollectionLayoutStore)
local getMainCollectionLayoutStore = require(script.Parent.getMainCollectionLayoutStore)

local function CollectionLayoutStoreProvider(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), Signals (copy), createCollectionLayoutStore (copy), getMainCollectionLayoutStore (copy), CollectionLayoutStoreContext (copy)
	local v10, v11 = React.useMemo(function() -- line: 23
		-- upvalues: Signals (copy)
		return Signals.createSignal(0)
	end, {})

	React.useEffect(function() -- line: 27
		-- upvalues: t1 (copy), v11 (copy)
		local container = t1.container

		if not container then
			return
		end

		v11(container.AbsoluteSize.X)

		local connection = container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 33
			-- upvalues: v11 (copy), container (copy)
			v11(container.AbsoluteSize.X)
		end)

		return function() -- line: 36
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { t1.container })

	local v12 = React.useMemo(function() -- line: 41
		-- upvalues: createCollectionLayoutStore (copy), v10 (copy), getMainCollectionLayoutStore (copy)
		return createCollectionLayoutStore(v10, getMainCollectionLayoutStore(false))
	end, { v10 })

	return React.createElement(CollectionLayoutStoreContext.Provider, {
		value = v12
	}, t1.children)
end

return CollectionLayoutStoreProvider
