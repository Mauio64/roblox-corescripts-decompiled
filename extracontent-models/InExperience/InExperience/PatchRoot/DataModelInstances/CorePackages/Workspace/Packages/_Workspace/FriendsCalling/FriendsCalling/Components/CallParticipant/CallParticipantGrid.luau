local parent = script:FindFirstAncestor("FriendsCalling").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local CallParticipantCard = require(script.Parent.CallParticipantCard)
local resolveGridLayout = require(script.Parent.resolveGridLayout)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function useContainerSize()
	local ref = React.useRef(nil)
	local state, setState = React.useState(Vector2.zero)

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		local function update() -- 1 equivalent call inferred from this helper
			setState(current.AbsoluteSize)
		end

		update() -- inferred equivalent call
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, {})

	return ref, state
end

local function CallParticipantGrid(p)
	local medium = useTokens().Gap.Medium
	local ref, v = useContainerSize()
	local gridLayout = resolveGridLayout(v, #p.participants, medium)

	local children = {}

	for i = 1, gridLayout.rows do
		local children2 = {}

		for j = 1, gridLayout.columns do
			local v2 = (i - 1) * gridLayout.columns + j
			local participant = p.participants[v2]

			if participant == nil then
				break
			end

			children2[`Participant{v2}`] = React.createElement(
				View,
				{
					LayoutOrder = j,
					Size = UDim2.fromOffset(gridLayout.cardSize.X, gridLayout.cardSize.Y)
				},
				{
					Card = React.createElement(CallParticipantCard, {
						userId = participant.userId,
						name = participant.name,
						statusText = participant.statusText,
						isMuted = participant.isMuted,
						isSpeaking = participant.isSpeaking,
						isDimmed = participant.isDimmed,
						showStatusAnimation = participant.showStatusAnimation
					})
				}
			)
		end

		children[`Row{i}`] = React.createElement(
			View,
			{ LayoutOrder = i, tag = "row align-x-center gap-medium size-full-0 auto-y" },
			children2
		)
	end

	return React.createElement(
		View,
		{
			ref = ref,
			tag = "col align-x-center align-y-center gap-medium size-full",
			testId = p.testId
		},
		children
	)
end

return CallParticipantGrid
