local parent = script.Parent.Parent
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local UIBlox = require(parent.UIBlox)
local RoduxPresence = require(parent.RoduxPresence)
local RoduxFriends = require(parent.RoduxFriends)

return {
	Roact = require(parent.Roact),
	React = require(parent.React),
	UIBlox = UIBlox,
	Foundation = require(parent.Foundation),
	RoactFitComponents = require(parent.RoactFitComponents),
	GenericPagination = require(parent.GenericPagination),
	Cryo = require(parent.Cryo),
	RoactNavigation = require(parent.RoactNavigation),
	Rodux = require(parent.Rodux),
	Lumberyak = require(parent.Lumberyak),
	tutils = require(parent.tutils),
	t = require(parent.t),
	Promise = require(parent.Promise),
	Symbol = require(parent.Symbol),
	LuauPolyfill = require(parent.LuauPolyfill),
	Otter = require(parent.Otter),
	llama = require(parent.llama),
	RoduxPresence = RoduxPresence.config({ keyPath = "SocialLibraries.Presence" }),
	RoduxFriends = RoduxFriends.config({ keyPath = "SocialLibraries.Friends" }),
	enumerate = require(parent.enumerate),
	Players = Players,
	UserInputService = UserInputService,
	Text = require(script.Parent.temp.Text),
	UserModel = require(script.Parent.temp.User)
}
