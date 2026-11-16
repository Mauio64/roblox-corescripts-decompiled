local Actions = require(script.Actions)
local Content = require(script.Content)
local Leading = require(script.Leading)
return {
	Root = require(script.HeaderBar),
	Leading = Leading,
	Trailing = require(script.Trailing),
	Content = Content,
	Actions = Actions
}
