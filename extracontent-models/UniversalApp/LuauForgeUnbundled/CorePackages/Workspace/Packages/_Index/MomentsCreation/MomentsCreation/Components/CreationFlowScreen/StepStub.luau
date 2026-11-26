local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local text = Foundation.Text
local view = Foundation.View

local function makeStepStub(p2)
	local function StepStub(p3)
		return React.createElement(view, {
			tag = "col align-x-center align-y-center size-full"
		}, {
			Label = React.createElement(text, {
				tag = "auto-xy text-body-medium text-align-x-center content-default",
				Text = `{p2} placeholder`
			})
		})
	end

	return StepStub
end

return makeStepStub
