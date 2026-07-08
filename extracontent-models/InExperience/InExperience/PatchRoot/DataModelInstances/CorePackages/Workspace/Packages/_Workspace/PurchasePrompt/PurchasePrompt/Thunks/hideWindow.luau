local ParentParent = script.Parent.Parent
local SetWindowState = require(ParentParent.Actions.SetWindowState)
local WindowState = require(ParentParent.Enums.WindowState)
local Thunk = require(ParentParent.Thunk)

local function hideWindow() -- line: 7
	-- upvalues: Thunk (copy), SetWindowState (copy), WindowState (copy)
	return Thunk.new(script.Name, {}, function(p1, _) -- line: 8
		-- upvalues: SetWindowState (copy), WindowState (copy)
		return p1:dispatch(SetWindowState(WindowState.Hidden))
	end)
end

return hideWindow
