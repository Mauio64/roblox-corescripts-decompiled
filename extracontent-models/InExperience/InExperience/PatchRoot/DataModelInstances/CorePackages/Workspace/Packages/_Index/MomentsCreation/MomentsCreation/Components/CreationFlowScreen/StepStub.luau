local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FoundationText = Foundation.Text
local View = Foundation.View

local function makeStepStub(s1: string) -- line: 19
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	local function StepStub(_) -- line: 20
		-- upvalues: React (copy), View (copy), FoundationText (copy), s1 (copy)
		return React.createElement(View, {
			tag = "col align-x-center align-y-center size-full"
		}, {
			Label = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-center content-default",
				Text = `{ s1 } placeholder`
			})
		})
	end

	return StepStub
end

return makeStepStub
