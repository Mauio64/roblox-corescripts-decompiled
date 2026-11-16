local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local Foundation = require(parent.Foundation)

local dependencies = require(Squads.dependencies)

local react = dependencies.React
local cryo = dependencies.Cryo

local useTokens = Foundation.Hooks.useTokens

local v = {
	voicePackName = "",
	LayoutOrder = 1,
	isSelected = false,
	onActivated = function() end,
	isVoiceChangerActive = false
}

local function getVoicePackSlug(voicePackName: string) -- 1 equivalent call inferred from this helper
	return string.lower((string.gsub(voicePackName, "%s+", "-")))
end

local function VoicePackButton(p)
	local joined = cryo.Dictionary.join(v, p)
	local testId

	if FFlagSquadsEnableFoundationTestIds then
		testId = joined.testId or `--social-squad-voice-changers--voice-pack-{getVoicePackSlug(joined.voicePackName)}` -- inferred equivalent call
	end

	local size = useTokens().Size
	local size_1000 = size.Size_1000
	local size_600 = size.Size_600
	local size_400 = size.Size_400

	local createElement = react.createElement
	local view = Foundation.View
	local v2 = {
		tag = "size-full-0 auto-y radius-medium row align-x-left align-y-center gap-large padding-x-large padding-y-xsmall",
		LayoutOrder = joined.LayoutOrder,
		onActivated = joined.onActivated,
		testId = testId
	}

	local createElement2 = react.createElement
	local text = Foundation.Text
	local v3 = {
		tag = "auto-xy fill text-align-x-left text-label-medium content-emphasis text-truncate-end text-no-wrap",
		LayoutOrder = 1,
		Text = joined.voicePackName,
		testId = 0
	}
	local testId2

	if testId then
		testId2 = `{testId}--label`
	end

	v3.testId = testId2
	local children = { Label = createElement2(text, v3), RadioButtonContainer = 0 }

	local createElement3 = react.createElement
	local view2 = Foundation.View
	local v4 = {
		Size = UDim2.new(0, 0, 0, size_1000),
		tag = "auto-x row align-x-right align-y-center",
		LayoutOrder = 2
	}

	local createElement4 = react.createElement
	local image = Foundation.Image
	local v5 = {
		tag = "bg-action-subtle content-emphasis anchor-center-center position-center-center",
		Image = "component_assets/circle_24_stroke_1",
		Size = UDim2.new(0, size_600, 0, size_600),
		testId = 0
	}
	local testId3

	if testId then
		testId3 = `{testId}--radio`
	end

	v5.testId = testId3

	local selectedIcon = joined.isSelected

	if selectedIcon then
		local createElement5 = react.createElement
		local image2 = Foundation.Image
		local v6 = {
			tag = "bg-action-subtle content-emphasis anchor-center-center position-center-center",
			Image = "component_assets/circle_16",
			Size = UDim2.new(0, size_400, 0, size_400),
			testId = 0
		}
		local testId4

		if testId then
			testId4 = `{testId}--radio-selected`
		end

		v6.testId = testId4
		selectedIcon = createElement5(image2, v6)
	end

	children.RadioButtonContainer = createElement3(view2, v4, {
		DefaultIcon = createElement4(image, v5, { SelectedIcon = selectedIcon })
	})
	return createElement(view, v2, children)
end

return VoicePackButton
