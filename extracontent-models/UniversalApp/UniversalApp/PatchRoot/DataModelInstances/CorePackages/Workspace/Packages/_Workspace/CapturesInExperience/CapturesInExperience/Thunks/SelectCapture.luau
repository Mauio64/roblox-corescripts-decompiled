local ParentParent = script.Parent.Parent
local UpdateSelectedCaptures = require(ParentParent.Actions.UpdateSelectedCaptures)
local getUpdatedSelectedCapturesArray = require(ParentParent.Utils.getUpdatedSelectedCapturesArray)
local Constants = require(ParentParent.Constants)

require(ParentParent.Types)

return function(p1) -- line: 9
	-- upvalues: Constants (copy), UpdateSelectedCaptures (copy), getUpdatedSelectedCapturesArray (copy)
	return function(p2) -- line: 10
		-- upvalues: Constants (copy), UpdateSelectedCaptures (copy), getUpdatedSelectedCapturesArray (copy), p1 (copy)
		local SelectedCaptures = p2:getState()[Constants.RoduxKey].CaptureManager.SelectedCaptures

		p2:dispatch(UpdateSelectedCaptures(getUpdatedSelectedCapturesArray(SelectedCaptures, p1)))
	end
end
