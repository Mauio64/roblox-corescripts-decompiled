local parent = script.Parent.Parent

local Constants = require(parent.Constants)

local function waitForFlashOverlay(object)
	if not object:getState()[Constants.RoduxKey].IsOverlayFlashActive then
		return
	end

	local lastTime = tick()

	while
		object:getState()[Constants.RoduxKey].IsOverlayFlashActive
		and not (tick() - lastTime > Constants.FlashTimeout)
	do
		task.wait()
	end
end

return waitForFlashOverlay
