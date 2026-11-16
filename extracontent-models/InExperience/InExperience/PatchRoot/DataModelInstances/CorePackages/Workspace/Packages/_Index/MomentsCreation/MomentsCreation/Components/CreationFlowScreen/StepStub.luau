local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

local function makeStepStub(p: string)
	local function StepStub(_)
		return React.createElement(View, { tag = "col align-x-center align-y-center size-full" }, {
			Label = React.createElement(Text, {
				tag = "auto-xy text-body-medium text-align-x-center content-default",
				Text = `{p} placeholder`
			})
		})
	end

	return StepStub
end

return makeStepStub
