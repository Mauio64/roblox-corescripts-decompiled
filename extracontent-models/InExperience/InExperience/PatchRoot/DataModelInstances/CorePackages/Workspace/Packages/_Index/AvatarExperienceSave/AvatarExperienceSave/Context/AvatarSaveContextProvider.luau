local parent = script:FindFirstAncestor("AvatarExperienceSave").Parent

local React = require(parent.React)

local AvatarSaveContext = require(script.Parent.AvatarSaveContext)
local useAvatarSaveContextProviderValue = require(script.Parent.useAvatarSaveContextProviderValue)

local function AvatarSaveContextProvider(p)
	local v = useAvatarSaveContextProviderValue()
	return React.createElement(AvatarSaveContext.Provider, { value = v }, p.children)
end

return AvatarSaveContextProvider
