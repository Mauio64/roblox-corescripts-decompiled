local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local Sheet = require(BuildExperience.FoundationFork.Sheet)
local Button = Foundation.Button
local FoundationText = Foundation.Text
local TextInput = Foundation.TextInput

local function AgentSpecDebugSheet(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), CreatorAgentChat (copy), Sheet (copy), FoundationText (copy), TextInput (copy), Button (copy), Foundation (copy)
	local v12, v13 = React.useState(CreatorAgentChat.experimentOverride.get() or "")

	return React.createElement(Sheet.Root, {
		isOpen = true,
		preferCenterSheet = true,
		onClose = t1.onClose
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = React.createElement(FoundationText, {
				Text = "Agent Spec",
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			Input = React.createElement(TextInput, {
				label = "specVersion",
				placeholder = "Leave empty for latest",
				text = v12,
				width = UDim.new(1, 0),
				onChanged = v13
			})
		}),
		Actions = React.createElement(Sheet.Actions, nil, {
			Save = React.createElement(Button, {
				text = "Save",
				size = Foundation.Enums.InputSize.Large,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				onActivated = function() -- line: 48
					-- upvalues: CreatorAgentChat (copy), v12 (copy), t1 (copy)
					CreatorAgentChat.experimentOverride.set(v12)
					t1.onClose()
				end
			})
		})
	})
end

return AgentSpecDebugSheet
