local parent = script.Parent.Parent

local UpdateSelectedCaptures = require(parent.Actions.UpdateSelectedCaptures)
local getUpdatedSelectedCapturesArray = require(parent.Utils.getUpdatedSelectedCapturesArray)

local Constants = require(parent.Constants)
require(parent.Types)

return function(p)
	return function(object)
		object:dispatch(UpdateSelectedCaptures(getUpdatedSelectedCapturesArray(
			object:getState()[Constants.RoduxKey].CaptureManager.SelectedCaptures,
			p
		)))
	end
end
