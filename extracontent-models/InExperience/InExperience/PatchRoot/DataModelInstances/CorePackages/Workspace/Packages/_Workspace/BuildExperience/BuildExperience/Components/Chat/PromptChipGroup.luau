local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceFTUXChipExhaustedTelemetry)

local FIntBuildExperienceFTUXChipExhaustedThresholdPx = require(BuildExperience.Flags.FIntBuildExperienceFTUXChipExhaustedThresholdPx)

local ChipGroup = Foundation.ChipGroup
local ChipGroupVariant = Foundation.Enums.ChipGroupVariant
local ChipSize = Foundation.Enums.ChipSize
local IconName = Foundation.Enums.IconName
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function getIconName(promptChip) -- 1 equivalent call inferred from this helper
	if promptChip.value == "2D" then
		return IconName.SquareCheck
	end

	if promptChip.value == "3D" then
		return IconName.CubeVertexes
	end

	return IconName.PlusLarge
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
			local v = scrollingFrame.AbsoluteCanvasSize.X - scrollingFrame.AbsoluteWindowSize.X

			if v > 0 then
				local x = scrollingFrame.CanvasPosition.X

				if v - FIntBuildExperienceFTUXChipExhaustedThresholdPx <= x and not ref2.current then
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
	local v = useTokens()
	local ref

	if FFlagBuildExperienceFTUXChipExhaustedTelemetry then
		ref = useChipExhaustionListener(props)
	end

	local chips = {}

	for k, promptChip in props.promptChips do
		local onActivated = props.onActivated
		chips[k] = {
			text = promptChip.value,
			leading = getIconName(promptChip), -- inferred equivalent call
			onActivated = onActivated ~= nil and function()
				onActivated(promptChip)
			end or nil
		}
	end

	local children = {}

	for i = 1, 3 do
		children[`Skeleton{i}`] = React.createElement(Skeleton, {
			LayoutOrder = i,
			radius = Radius.Circle,
			Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_800),
			testId = `PromptChipGroup.Skeleton{i}`
		})
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col size-full-0 auto-y padding-bottom-large padding-top-small clip",
		testId = "PromptChipGroup"
	}
	local content

	if props.isLoading then
		content = React.createElement(
			View,
			{ tag = "row gap-small size-full-0 auto-y", testId = "PromptChipGroup.Skeletons" },
			children
		)
	else
		local createElement2 = React.createElement
		local v3 = {
			chips = chips,
			size = ChipSize.Medium,
			variant = ChipGroupVariant.Row,
			ref = 0,
			testId = "PromptChipGroup.Chips"
		}

		if not FFlagBuildExperienceFTUXChipExhaustedTelemetry then
			ref = nil
		end

		v3.ref = ref
		content = createElement2(ChipGroup, v3)
	end

	return createElement(View, v2, { Content = content })
end

return PromptChipGroup
