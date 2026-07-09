local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local PlayerContextualMenuParent = PlayerContextualMenu.Parent
local React = require(PlayerContextualMenuParent.React)
local HttpRequestContext = require(script.Parent.HttpRequest.HttpRequestContext)
local DefaultHttpRequestInstance = require(script.Parent.HttpRequest.DefaultHttpRequestInstance)
local PlayerContextualMenuContainer = require(PlayerContextualMenu.Components.PlayerContextualMenuContainer)

local function PlayerContextualMenuEntrypoint(p1) -- line: 17
	-- upvalues: React (copy), HttpRequestContext (copy), DefaultHttpRequestInstance (copy), PlayerContextualMenuContainer (copy)
	return React.createElement(HttpRequestContext.Provider, {
		value = p1.httpRequest or DefaultHttpRequestInstance
	}, {
		app = React.createElement(PlayerContextualMenuContainer, p1)
	})
end

return PlayerContextualMenuEntrypoint
