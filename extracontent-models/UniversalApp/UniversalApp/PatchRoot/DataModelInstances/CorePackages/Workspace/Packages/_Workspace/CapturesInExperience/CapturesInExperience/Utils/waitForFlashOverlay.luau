local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

local function waitForFlashOverlay(p1) -- line: 5
	-- upvalues: Constants (copy)
	if not p1:getState()[Constants.RoduxKey].IsOverlayFlashActive then
		return
	end

	local timestamp = tick()

	while p1:getState()[Constants.RoduxKey].IsOverlayFlashActive and not (tick() - timestamp > Constants.FlashTimeout) do
		task.wait()
	end
end

return waitForFlashOverlay
