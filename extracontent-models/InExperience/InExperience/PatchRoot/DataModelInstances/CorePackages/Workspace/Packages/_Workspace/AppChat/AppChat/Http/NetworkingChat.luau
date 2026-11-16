local parent = script:FindFirstAncestor("AppChat").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local networkingChat = LuaSocialLibrariesDeps.NetworkingChat

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return networkingChat.config({ roduxNetworking = RoduxNetworking })
