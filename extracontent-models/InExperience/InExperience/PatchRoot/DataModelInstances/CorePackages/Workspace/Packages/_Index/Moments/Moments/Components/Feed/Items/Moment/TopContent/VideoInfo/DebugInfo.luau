local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)

local TextInput = Foundation.TextInput
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize

local useSignalState = SignalsReact.useSignalState

local function noop() end

local function DebugInfo(p)
	local v = useSignalState(GetMomentsPreferencesStore(false).getDebugModeEnabled)
	local v2 = MomentContext.useMoment()

	if not v then
		return nil
	end

	local feedItemId = v2.store.getData(false).feedItemId or ""

	return React.createElement(
		View,
		{ LayoutOrder = p.LayoutOrder, tag = "col align-x-left gap-small size-full-0 auto-y" },
		{
			DebugMomentId = React.createElement(TextInput, {
				label = "momentId",
				LayoutOrder = 1,
				onChanged = noop,
				size = InputSize.Medium,
				text = v2.momentId,
				width = UDim.new(1, 0)
			}),
			DebugFeedItemId = React.createElement(TextInput, {
				label = "feedItemId",
				LayoutOrder = 2,
				onChanged = noop,
				size = InputSize.Medium,
				text = feedItemId,
				width = UDim.new(1, 0)
			})
		}
	)
end

return React.memo(DebugInfo)
