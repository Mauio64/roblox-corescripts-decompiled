local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local React = require(SduiSharedContentParent.React)
local Foundation = require(SduiSharedContentParent.Foundation)
local GamePlayButton = require(SduiSharedContentParent.GamePlayButton)
local RoactServiceTags = require(SduiSharedContentParent.RoactServiceTags)
local SduiFeedContext = require(SduiSharedContent.Components.SduiFeedContext)
local useTokens = Foundation.Hooks.useTokens
local useRoactService = require(SduiSharedContentParent.RobloxAppHooks).useRoactService
local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local usePlayButtonState = GamePlayButton.usePlayButtonState

require(SduiSharedContentParent.SduiCoreSystem)

local FoundationText = Foundation.Text
local View = Foundation.View

local function SduiPlayButtonContextualMessage(t1: {[any]: any}) -- line: 30
	-- upvalues: useRoactService (copy), RoactServiceTags (copy), useTokens (copy), React (copy), SduiFeedContext (copy), usePlayButtonState (copy), usePlayButtonContextualMessage (copy), View (copy), FoundationText (copy), GamePlayButton (copy)
	local v16 = useRoactService(RoactServiceTags.RoactNetworking)
	local v17 = useTokens()
	local v18 = React.useContext(SduiFeedContext)
	local v19 = React.useRef(nil)
	local v20 = usePlayButtonState(v16, t1.universeId, t1.fetchDelayInSeconds)
	local v21 = usePlayButtonContextualMessage(t1.universeId, v20.playButtonState, v20.playabilityStatus)

	if v21 == nil or v21 == "" then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-xy",
		LayoutOrder = t1.layoutOrder
	}, {
		Text = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left",
			textStyle = v17.Color.Content.Emphasis,
			Text = v21,
			ref = v19
		}),
		ImpressionsDetector = React.createElement(GamePlayButton.PlayButtonContextualMessageImpressionsDetector, {
			containerRef = v19,
			universeId = t1.universeId,
			playabilityStatus = v20.playabilityStatus,
			contextualMessage = v21,
			pageContext = t1.sduiContext and t1.sduiContext.appPage or "",
			scrollViewPositionChangedSignal = v18 and v18.scrollViewPositionChangedSignal
		})
	})
end

return React.memo(SduiPlayButtonContextualMessage)
