local Immutable = require(script.Parent.Parent.Immutable)
local Constants = require(script.Parent.Parent.Constants)

local SetDevConsoleVisibility = require(script.Parent.Parent.Actions.SetDevConsoleVisibility)
local SetDevConsoleMinimized = require(script.Parent.Parent.Actions.SetDevConsoleMinimized)
local ChangeDevConsoleSize = require(script.Parent.Parent.Actions.ChangeDevConsoleSize)
local SetDevConsolePosition = require(script.Parent.Parent.Actions.SetDevConsolePosition)
local SetActiveTab = require(script.Parent.Parent.Actions.SetActiveTab)

return function(p, data)
	local v = p or {
		formFactor = Constants.FormFactor.Large,
		isVisible = false,
		isMinimized = false,
		position = Constants.MainWindowInit.Position,
		size = Constants.MainWindowInit.Size,
		visibleStartTime = 0
	}

	if data.type == SetDevConsoleVisibility.name then
		local v2 = { isVisible = data.isVisible }

		if v2.isVisible then
			v2.isMinimized = false
			v2.visibleStartTime = tick()
		end

		return Immutable.JoinDictionaries(v, v2)
	end

	if data.type == SetDevConsolePosition.name then
		return (Immutable.Set(v, "position", data.position))
	end

	if data.type == SetDevConsoleMinimized.name then
		return (Immutable.Set(v, "isMinimized", data.isMinimized))
	end

	if data.type == ChangeDevConsoleSize.name then
		if v.formFactor == Constants.FormFactor.Large then
			return (Immutable.Set(v, "size", data.newSize))
		end
	elseif data.type == SetActiveTab.name then
		return (Immutable.Set(v, "isMinimized", false))
	end

	return v
end
