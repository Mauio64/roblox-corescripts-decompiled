local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnimatedChipGroupContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AnimatedChipGroup/AnimatedChipGroupContainer")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFTUXChipExhaustedTelemetry")

local FIntBuildExperienceFTUXChipExhaustedThresholdPx = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntBuildExperienceFTUXChipExhaustedThresholdPx")

local FFlagBuildExperienceFTUXChipLoadInAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFTUXChipLoadInAnimation")

local chipGroup = Foundation.ChipGroup
local chipGroupVariant = Foundation.Enums.ChipGroupVariant
local chipSize = Foundation.Enums.ChipSize
local iconName = Foundation.Enums.IconName
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function getIconName(p2)
	if p2.value == "2D" then
		return iconName.SquareCheck
	end

	if p2.value == "3D" then
		return iconName.CubeVertexes
	end

	return iconName.PlusLarge
end

local function useChipExhaustionListener(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		ref2.current = false
	end, { props.promptChips })

	React.useEffect(function()
		if props.onExhausted == nil then
			return
		end

		local current = ref.current

		if current == nil then
			return
		end

		local scrollingFrame = current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if scrollingFrame == nil then
			return
		end

		local canvasPositionChangedConnection = scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			local v5 = scrollingFrame.AbsoluteCanvasSize.X - scrollingFrame.AbsoluteWindowSize.X

			if v5 > 0 then
				local x = scrollingFrame.CanvasPosition.X

				if v5 - FIntBuildExperienceFTUXChipExhaustedThresholdPx <= x and not ref2.current then
					ref2.current = true
					props.onExhausted()
				end
			end
		end)
		return function()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { props.onExhausted, props.promptChips, props.isLoading })

	return ref
end

local function PromptChipGroup(props)
	local v5 = useTokens()

	local v6 = if FFlagBuildExperienceFTUXChipExhaustedTelemetry then useChipExhaustionListener(props) else nil

	local v7 = {}

	for k, promptChip in props.promptChips do
		local onActivated = props.onActivated
		local v8 = { text = promptChip.value, leading = 0, onActivated = 0 }
		local v9

		if promptChip.value == "2D" then
			v9 = iconName.SquareCheck
		else
			v9 = if promptChip.value == "3D" then iconName.CubeVertexes else iconName.PlusLarge
		end

		v8.leading = v9
		v8.onActivated = onActivated ~= nil and function()
			onActivated(promptChip)
		end or nil
		v7[k] = v8
	end

	local children = {}

	for i = 1, 3 do
		children[`Skeleton{i}`] = React.createElement(skeleton, {
			LayoutOrder = i,
			radius = radius.Circle,
			Size = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_800),
			testId = `PromptChipGroup.Skeleton{i}`
		})
	end

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col size-full-0 auto-y padding-bottom-large padding-top-small clip",
		testId = "PromptChipGroup"
	}
	local v11

	if props.isLoading then
		v11 = React.createElement(
			view,
			{
				tag = "row gap-small size-full-0 auto-y",
				testId = "PromptChipGroup.Skeletons"
			},
			children
		)
	elseif FFlagBuildExperienceFTUXChipLoadInAnimation and #v7 > 0 then
		v11 = React.createElement(AnimatedChipGroupContainer, { chips = v7, chipGroupRef = v6 })
	else
		local createElement2 = React.createElement
		local v13 = {
			chips = v7,
			size = chipSize.Medium,
			variant = chipGroupVariant.Row,
			ref = 0,
			testId = "PromptChipGroup.Chips"
		}

		if not FFlagBuildExperienceFTUXChipExhaustedTelemetry then
			v6 = nil
		end

		v13.ref = v6
		v11 = createElement2(chipGroup, v13)
	end

	return createElement(view, v9, { Content = v11 })
end

return PromptChipGroup
