local parent = script.Parent.Parent
local ReactReconciler = require(parent.ReactReconciler)

local ReactRobloxHostConfig = require(script.Parent.client.ReactRobloxHostConfig)

return ReactReconciler(ReactRobloxHostConfig)
