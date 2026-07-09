local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local TextInput = Foundation.TextInput
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local useSignalState = SignalsReact.useSignalState

local function noop() -- line: 26
end
local function DebugInfo(t1: {[any]: any}) -- line: 32
	-- upvalues: GetMomentsPreferencesStore (copy), useSignalState (copy), MomentContext (copy), React (copy), View (copy), TextInput (copy), noop (copy), InputSize (copy)
	local v15 = GetMomentsPreferencesStore(false)
	local v16 = useSignalState(v15.getDebugModeEnabled)
	local v17 = MomentContext.useMoment()

	if not v16 then
		return nil
	end

	local v18 = v17.store.getData(false).feedItemId or v17.momentId

	return React.createElement(View, {
		tag = "col align-x-left gap-small size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		DebugMomentId = React.createElement(TextInput, {
			label = "momentId",
			LayoutOrder = 1,
			onChanged = noop,
			size = InputSize.Medium,
			text = v17.momentId,
			width = UDim.new(1, 0)
		}),
		DebugItemId = React.createElement(TextInput, {
			label = "itemId",
			LayoutOrder = 2,
			onChanged = noop,
			size = InputSize.Medium,
			text = v18,
			width = UDim.new(1, 0)
		})
	})
end

return React.memo(DebugInfo)
