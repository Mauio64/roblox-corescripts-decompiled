local Immutable = require(script.Parent.Parent.Immutable)
local Constants = require(script.Parent.Parent.Constants)
local SetDevConsoleVisibility = require(script.Parent.Parent.Actions.SetDevConsoleVisibility)
local SetDevConsoleMinimized = require(script.Parent.Parent.Actions.SetDevConsoleMinimized)
local ChangeDevConsoleSize = require(script.Parent.Parent.Actions.ChangeDevConsoleSize)
local SetDevConsolePosition = require(script.Parent.Parent.Actions.SetDevConsolePosition)
local SetActiveTab = require(script.Parent.Parent.Actions.SetActiveTab)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 19
	-- upvalues: Constants (copy), SetDevConsoleVisibility (copy), Immutable (copy), SetDevConsolePosition (copy), SetDevConsoleMinimized (copy), ChangeDevConsoleSize (copy), SetActiveTab (copy)
	local v10 = t1 or {
		isVisible = false,
		isMinimized = false,
		visibleStartTime = 0,
		formFactor = Constants.FormFactor.Large,
		position = Constants.MainWindowInit.Position,
		size = Constants.MainWindowInit.Size
	}

	if t2.type == SetDevConsoleVisibility.name then
		local t3 = {
			isVisible = t2.isVisible
		}

		if t3.isVisible then
			t3.isMinimized = false
			t3.visibleStartTime = tick()
		end

		return Immutable.JoinDictionaries(v10, t3)
	end

	if t2.type == SetDevConsolePosition.name then
		return (Immutable.Set(v10, "position", t2.position))
	end

	if t2.type == SetDevConsoleMinimized.name then
		return (Immutable.Set(v10, "isMinimized", t2.isMinimized))
	end

	if t2.type == ChangeDevConsoleSize.name then
		if v10.formFactor == Constants.FormFactor.Large then
			return (Immutable.Set(v10, "size", t2.newSize))
		end
	elseif t2.type == SetActiveTab.name then
		return (Immutable.Set(v10, "isMinimized", false))
	end

	return v10
end
