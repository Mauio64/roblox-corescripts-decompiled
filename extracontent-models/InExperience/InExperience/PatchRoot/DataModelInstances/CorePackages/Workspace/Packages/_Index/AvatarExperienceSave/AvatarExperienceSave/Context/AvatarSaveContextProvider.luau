local Parent = script:FindFirstAncestor("AvatarExperienceSave").Parent
local React = require(Parent.React)
local AvatarSaveContext = require(script.Parent.AvatarSaveContext)
local useAvatarSaveContextProviderValue = require(script.Parent.useAvatarSaveContextProviderValue)

local function AvatarSaveContextProvider(t1: {[any]: any}) -- line: 9
	-- upvalues: useAvatarSaveContextProviderValue (copy), React (copy), AvatarSaveContext (copy)
	local v7 = useAvatarSaveContextProviderValue()

	return React.createElement(AvatarSaveContext.Provider, {
		value = v7
	}, t1.children)
end

return AvatarSaveContextProvider
