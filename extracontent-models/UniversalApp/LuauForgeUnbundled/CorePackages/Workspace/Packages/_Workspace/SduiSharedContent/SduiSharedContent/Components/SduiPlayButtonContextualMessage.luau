local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/GamePlayButton")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RoactServiceTags")
local SduiFeedContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiFeedContext")
local useTokens = Foundation.Hooks.useTokens
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RobloxAppHooks").useRoactService

local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local usePlayButtonState = GamePlayButton.usePlayButtonState

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local text = Foundation.Text
local view = Foundation.View

local function SduiPlayButtonContextualMessage(props)
	local v5 = useRoactService(RoactServiceTags.RoactNetworking)
	local v6 = useTokens()
	local v7 = React.useContext(SduiFeedContext)
	local ref = React.useRef(nil)

	local v8 = usePlayButtonState(v5, props.universeId, props.fetchDelayInSeconds)
	local v9 = usePlayButtonContextualMessage(props.universeId, v8.playButtonState, v8.playabilityStatus)

	if v9 == nil or v9 == "" then
		return nil
	end

	return React.createElement(view, {
		tag = "size-full-0 auto-xy",
		LayoutOrder = props.layoutOrder
	}, {
		Text = React.createElement(text, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left",
			textStyle = v6.Color.Content.Emphasis,
			Text = v9,
			ref = ref
		}),
		ImpressionsDetector = React.createElement(GamePlayButton.PlayButtonContextualMessageImpressionsDetector, {
			containerRef = ref,
			universeId = props.universeId,
			playabilityStatus = v8.playabilityStatus,
			contextualMessage = v9,
			pageContext = props.sduiContext and props.sduiContext.appPage or "",
			scrollViewPositionChangedSignal = v7 and v7.scrollViewPositionChangedSignal
		})
	})
end

return React.memo(SduiPlayButtonContextualMessage)
