local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ChatUserMessage(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationText (copy)
	local v10 = useTokens()
	local message = t1.message

	return React.createElement(View, {
		tag = "row gap-small size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		Spacer = React.createElement(View, {
			LayoutOrder = 1,
			tag = "fill"
		}),
		Message = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-right gap-xsmall auto-y",
			Size = UDim2.new(0.78, 0, 0, 0)
		}, {
			Bubble = React.createElement(View, {
				LayoutOrder = 1,
				tag = "auto-xy padding-medium bg-shift-200",
				cornerRadius = UDim.new(0, v10.Size.Size_500)
			}, {
				Text = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
					Text = message.text,
					Size = UDim2.new(1, 0, 0, 0)
				})
			})
		})
	})
end

return React.memo(ChatUserMessage)
