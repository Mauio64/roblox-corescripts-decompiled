local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Dev.Roact)

return {
	name = "QRCodeDisplay",
	storyRoots = { script.Parent },
	roact = Roact
}
