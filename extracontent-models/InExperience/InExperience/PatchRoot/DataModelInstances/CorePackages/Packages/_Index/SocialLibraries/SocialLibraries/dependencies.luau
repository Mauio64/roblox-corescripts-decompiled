local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lazyRequire = require(ParentParent.LazyRequire).lazyRequire
local UIBlox = require(ParentParent.UIBlox)
local RoduxPresence = require(ParentParent.RoduxPresence)
local RoduxFriends = require(ParentParent.RoduxFriends)

if game:DefineFastFlag("LuaAppSocialLibUseLazyRequire", false) then
	return {
		Roact = require(ParentParent.Roact),
		React = require(ParentParent.React),
		UIBlox = UIBlox,
		Foundation = require(ParentParent.Foundation),
		RoactFitComponents = lazyRequire(ParentParent.RoactFitComponents),
		GenericPagination = lazyRequire(ParentParent.GenericPagination),
		Cryo = require(ParentParent.Cryo),
		RoactNavigation = require(ParentParent.RoactNavigation),
		Rodux = require(ParentParent.Rodux),
		Lumberyak = require(ParentParent.Lumberyak),
		tutils = require(ParentParent.tutils),
		t = require(ParentParent.t),
		Promise = lazyRequire(ParentParent.Promise),
		Symbol = lazyRequire(ParentParent.Symbol),
		LuauPolyfill = lazyRequire(ParentParent.LuauPolyfill),
		Otter = lazyRequire(ParentParent.Otter),
		llama = lazyRequire(ParentParent.llama),
		RoduxPresence = RoduxPresence.config({
			keyPath = "SocialLibraries.Presence"
		}),
		RoduxFriends = RoduxFriends.config({
			keyPath = "SocialLibraries.Friends"
		}),
		enumerate = require(ParentParent.enumerate),
		Players = Players,
		UserInputService = UserInputService,
		Text = require(script.Parent.temp.Text),
		UserModel = require(script.Parent.temp.User)
	}
end

return {
	Roact = require(ParentParent.Roact),
	React = require(ParentParent.React),
	UIBlox = UIBlox,
	Foundation = require(ParentParent.Foundation),
	RoactFitComponents = require(ParentParent.RoactFitComponents),
	GenericPagination = require(ParentParent.GenericPagination),
	Cryo = require(ParentParent.Cryo),
	RoactNavigation = require(ParentParent.RoactNavigation),
	Rodux = require(ParentParent.Rodux),
	Lumberyak = require(ParentParent.Lumberyak),
	tutils = require(ParentParent.tutils),
	t = require(ParentParent.t),
	Promise = require(ParentParent.Promise),
	Symbol = require(ParentParent.Symbol),
	LuauPolyfill = require(ParentParent.LuauPolyfill),
	Otter = require(ParentParent.Otter),
	llama = require(ParentParent.llama),
	RoduxPresence = RoduxPresence.config({
		keyPath = "SocialLibraries.Presence"
	}),
	RoduxFriends = RoduxFriends.config({
		keyPath = "SocialLibraries.Friends"
	}),
	enumerate = require(ParentParent.enumerate),
	Players = Players,
	UserInputService = UserInputService,
	Text = require(script.Parent.temp.Text),
	UserModel = require(script.Parent.temp.User)
}
