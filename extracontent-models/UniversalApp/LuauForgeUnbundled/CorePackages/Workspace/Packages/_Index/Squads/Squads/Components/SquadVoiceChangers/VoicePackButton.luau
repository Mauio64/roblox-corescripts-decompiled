local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local react = dependencies.React
local cryo = dependencies.Cryo

local useTokens = Foundation.Hooks.useTokens

local v5 = {
	voicePackName = "",
	LayoutOrder = 1,
	isSelected = false,
	onActivated = function() end,
	isVoiceChangerActive = false
}

local function getVoicePackSlug(value)
	return string.lower((string.gsub(value, "%s+", "-")))
end

local function VoicePackButton(p2)
	local joined = cryo.Dictionary.join(v5, p2)
	local v6

	if FFlagSquadsEnableFoundationTestIds then
		v6 = joined.testId

		if not v6 then
			local voicePackName = joined.voicePackName
			v6 = `--social-squad-voice-changers--voice-pack-{string.lower((string.gsub(voicePackName, "%s+", "-")))}`
		end
	end

	local size = useTokens().Size
	local size_1000 = size.Size_1000
	local size_600 = size.Size_600
	local size_400 = size.Size_400

	local createElement = react.createElement
	local view = Foundation.View
	local v7 = {
		tag = "size-full-0 auto-y radius-medium row align-x-left align-y-center gap-large padding-x-large padding-y-xsmall",
		LayoutOrder = joined.LayoutOrder,
		onActivated = joined.onActivated,
		testId = v6
	}

	local createElement2 = react.createElement
	local text = Foundation.Text
	local v8 = {
		tag = "auto-xy fill text-align-x-left text-label-medium content-emphasis text-truncate-end text-no-wrap",
		LayoutOrder = 1,
		Text = joined.voicePackName,
		testId = 0
	}
	local v9 = if v6 then `{v6}--label` else nil
	v8.testId = v9
	local children = { Label = createElement2(text, v8), RadioButtonContainer = 0 }

	local createElement3 = react.createElement
	local view2 = Foundation.View
	local v10 = {
		Size = UDim2.new(0, 0, 0, size_1000),
		tag = "auto-x row align-x-right align-y-center",
		LayoutOrder = 2
	}

	local createElement4 = react.createElement
	local image = Foundation.Image
	local v12 = {
		tag = "bg-action-subtle content-emphasis anchor-center-center position-center-center",
		Image = "component_assets/circle_24_stroke_1",
		Size = UDim2.new(0, size_600, 0, size_600),
		testId = 0
	}
	local v13 = if v6 then `{v6}--radio` else nil
	v12.testId = v13

	local v15 = joined.isSelected

	if v15 then
		local createElement5 = react.createElement
		local image2 = Foundation.Image
		local v16 = {
			tag = "bg-action-subtle content-emphasis anchor-center-center position-center-center",
			Image = "component_assets/circle_16",
			Size = UDim2.new(0, size_400, 0, size_400),
			testId = 0
		}
		local v17 = if v6 then `{v6}--radio-selected` else nil
		v16.testId = v17
		v15 = createElement5(image2, v16)
	end

	children.RadioButtonContainer = createElement3(view2, v10, {
		DefaultIcon = createElement4(image, v12, { SelectedIcon = v15 })
	})
	return createElement(view, v7, children)
end

return VoicePackButton
