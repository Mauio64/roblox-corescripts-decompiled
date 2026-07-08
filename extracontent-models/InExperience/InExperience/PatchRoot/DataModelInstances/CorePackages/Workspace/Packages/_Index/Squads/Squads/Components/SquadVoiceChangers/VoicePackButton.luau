local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Foundation = require(SquadsParent.Foundation)
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local Cryo = dependencies.Cryo
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	voicePackName = "",
	LayoutOrder = 1,
	isSelected = false,
	isVoiceChangerActive = false,
	onActivated = function() -- line: 28
	end
}

local function VoicePackButton(p1) -- line: 32
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), React (copy), Foundation (copy)
	local v11 = Cryo.Dictionary.join(t1, p1)
	local Size = useTokens().Size
	local Size_1000 = Size.Size_1000
	local Size_600 = Size.Size_600
	local Size_400 = Size.Size_400

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y radius-medium row align-x-left align-y-center gap-large padding-x-large padding-y-xsmall",
		LayoutOrder = v11.LayoutOrder,
		onActivated = v11.onActivated
	}, {
		Label = React.createElement(Foundation.Text, {
			tag = "auto-xy fill text-align-x-left text-label-medium content-emphasis text-truncate-end text-no-wrap",
			LayoutOrder = 1,
			Text = v11.voicePackName
		}),
		RadioButtonContainer = React.createElement(Foundation.View, {
			tag = "auto-x row align-x-right align-y-center",
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, Size_1000)
		}, {
			DefaultIcon = React.createElement(Foundation.Image, {
				tag = "bg-action-subtle content-emphasis anchor-center-center position-center-center",
				Image = "component_assets/circle_24_stroke_1",
				Size = UDim2.new(0, Size_600, 0, Size_600)
			}, {
				SelectedIcon = v11.isSelected and React.createElement(Foundation.Image, {
					tag = "bg-action-subtle content-emphasis anchor-center-center position-center-center",
					Image = "component_assets/circle_16",
					Size = UDim2.new(0, Size_400, 0, Size_400)
				})
			})
		})
	})
end

return VoicePackButton
