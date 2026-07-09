local ParentParent = script.Parent.Parent.Parent
local enumerate = require(ParentParent.enumerate)
local t1 = {
	Subscription = "Subscription"
}

return (enumerate(script.Name, t1))
