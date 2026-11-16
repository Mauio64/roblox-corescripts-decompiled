local parent = script.Parent.Parent

local SetWindowState = require(parent.Actions.SetWindowState)
local WindowState = require(parent.Enums.WindowState)
local Thunk = require(parent.Thunk)

local function hideWindow()
	return Thunk.new(script.Name, {}, function(object, _)
		return object:dispatch(SetWindowState(WindowState.Hidden))
	end)
end

return hideWindow
