local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local GamePlayButton = require(parent.GamePlayButton)
local RoactServiceTags = require(parent.RoactServiceTags)
local SduiFeedContext = require(SduiSharedContent.Components.SduiFeedContext)
local useTokens = Foundation.Hooks.useTokens
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local usePlayButtonState = GamePlayButton.usePlayButtonState

require(parent.SduiCoreSystem)

local Text = Foundation.Text
local View = Foundation.View

local function SduiPlayButtonContextualMessage(props)
	local v = useRoactService(RoactServiceTags.RoactNetworking)
	local v2 = useTokens()
	local v3 = React.useContext(SduiFeedContext)
	local ref = React.useRef(nil)

	local v4 = usePlayButtonState(v, props.universeId, props.fetchDelayInSeconds)
	local v5 = usePlayButtonContextualMessage(props.universeId, v4.playButtonState, v4.playabilityStatus)

	if v5 == nil or v5 == "" then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-xy",
		LayoutOrder = props.layoutOrder
	}, {
		Text = React.createElement(Text, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left",
			textStyle = v2.Color.Content.Emphasis,
			Text = v5,
			ref = ref
		}),
		ImpressionsDetector = React.createElement(GamePlayButton.PlayButtonContextualMessageImpressionsDetector, {
			containerRef = ref,
			universeId = props.universeId,
			playabilityStatus = v4.playabilityStatus,
			contextualMessage = v5,
			pageContext = props.sduiContext and props.sduiContext.appPage or "",
			scrollViewPositionChangedSignal = v3 and v3.scrollViewPositionChangedSignal
		})
	})
end

return React.memo(SduiPlayButtonContextualMessage)
