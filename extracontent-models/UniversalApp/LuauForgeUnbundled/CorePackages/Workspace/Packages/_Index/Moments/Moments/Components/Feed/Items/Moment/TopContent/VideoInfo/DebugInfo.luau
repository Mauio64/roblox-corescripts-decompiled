local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")

local textInput = Foundation.TextInput
local view = Foundation.View
local inputSize = Foundation.Enums.InputSize

local useSignalState = SignalsReact.useSignalState

local function noop() end

local function DebugInfo(p2)
	local v6 = useSignalState(GetMomentsPreferencesStore(false).getDebugModeEnabled)
	local v7 = MomentContext.useMoment()

	if not v6 then
		return nil
	end

	local feedItemId = v7.store.getData(false).feedItemId or ""

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "col align-x-left gap-small size-full-0 auto-y"
		},
		{
			DebugMomentId = React.createElement(textInput, {
				label = "momentId",
				LayoutOrder = 1,
				onChanged = noop,
				size = inputSize.Medium,
				text = v7.momentId,
				width = UDim.new(1, 0)
			}),
			DebugFeedItemId = React.createElement(textInput, {
				label = "feedItemId",
				LayoutOrder = 2,
				onChanged = noop,
				size = inputSize.Medium,
				text = feedItemId,
				width = UDim.new(1, 0)
			})
		}
	)
end

return React.memo(DebugInfo)
