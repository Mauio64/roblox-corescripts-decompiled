local Actions = require(script.Actions)
local Content = require(script.Content)
local HeroMedia = require(script.HeroMedia)
return {
	Root = require(script.Dialog),
	Actions = Actions,
	Content = Content,
	Text = require(script.Text),
	HeroMedia = HeroMedia,
	Title = require(script.Title)
}
