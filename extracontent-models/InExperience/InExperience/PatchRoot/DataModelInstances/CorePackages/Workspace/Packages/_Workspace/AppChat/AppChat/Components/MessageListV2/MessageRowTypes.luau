local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ViewRecycler = require(parent.ViewRecycler)

local MessageRow = require(script.Parent.MessageRow)

local function RecycledMessageRow(p)
	local v = SignalsReact.useSignalState(p.itemSignal)
	return React.createElement(MessageRow, { key = v.stable_key, item = v })
end

local function EndSpacer()
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 10)
	})
end

local recyclableView = ViewRecycler.createRecyclableView(RecycledMessageRow, {
	readiness = ViewRecycler.RecyclableViewReadiness.ReadyOnCommit
})

local recyclableView2 = ViewRecycler.createRecyclableView(EndSpacer)

return {
	MessageRowType = recyclableView,
	EndSpacerItem = ViewRecycler.createPinnedItem({
		key = "EndSpacer",
		value = {},
		itemType = recyclableView2
	})
}
