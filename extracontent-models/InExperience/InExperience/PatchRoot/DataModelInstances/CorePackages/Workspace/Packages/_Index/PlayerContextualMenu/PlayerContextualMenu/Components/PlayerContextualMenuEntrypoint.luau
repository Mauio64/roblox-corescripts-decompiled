local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local parent = PlayerContextualMenu.Parent
local React = require(parent.React)

local HttpRequestContext = require(script.Parent.HttpRequest.HttpRequestContext)
local DefaultHttpRequestInstance = require(script.Parent.HttpRequest.DefaultHttpRequestInstance)

local PlayerContextualMenuContainer = require(PlayerContextualMenu.Components.PlayerContextualMenuContainer)

local function PlayerContextualMenuEntrypoint(p)
	return React.createElement(HttpRequestContext.Provider, {
		value = p.httpRequest or DefaultHttpRequestInstance
	}, {
		app = React.createElement(PlayerContextualMenuContainer, p)
	})
end

return PlayerContextualMenuEntrypoint
