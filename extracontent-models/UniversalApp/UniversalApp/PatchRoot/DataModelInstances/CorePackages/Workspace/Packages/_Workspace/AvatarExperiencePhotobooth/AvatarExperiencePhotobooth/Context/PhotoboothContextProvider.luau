local Parent = script:FindFirstAncestor("AvatarExperiencePhotobooth").Parent
local React = require(Parent.React)
local PhotoboothContext = require(script.Parent.PhotoboothContext)
local createPhotoboothStore = require(script.Parent.Parent.Stores.createPhotoboothStore)
local PhotoboothStoreBridge = require(script.Parent.Parent.PhotoboothStoreBridge)

local function PhotoboothContextProvider(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), createPhotoboothStore (copy), PhotoboothStoreBridge (copy), PhotoboothContext (copy)
	local v8 = React.useMemo(function() -- line: 20
		-- upvalues: createPhotoboothStore (copy)
		return createPhotoboothStore()
	end, {})

	React.useEffect(function() -- line: 25
		-- upvalues: PhotoboothStoreBridge (copy), v8 (copy)
		PhotoboothStoreBridge.setStore(v8)

		return function() -- line: 27
			-- upvalues: PhotoboothStoreBridge (copy)
			PhotoboothStoreBridge.clearStore()
		end
	end, { v8 })

	local v9 = React.useMemo(function() -- line: 32
		-- upvalues: v8 (copy)
		return {
			photoboothStore = v8
		}
	end, { v8 })

	return React.createElement(PhotoboothContext.Provider, {
		value = v9
	}, t1.children)
end

return PhotoboothContextProvider
