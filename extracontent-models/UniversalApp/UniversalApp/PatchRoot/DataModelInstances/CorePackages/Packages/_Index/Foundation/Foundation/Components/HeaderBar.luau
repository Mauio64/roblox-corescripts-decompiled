local Actions = require(script.Actions)
local Content = require(script.Content)
local Leading = require(script.Leading)
local HeaderBar = require(script.HeaderBar)
local Trailing = require(script.Trailing)

return {
	Root = HeaderBar,
	Leading = Leading,
	Trailing = Trailing,
	Content = Content,
	Actions = Actions
}
