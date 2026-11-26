local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local MessageRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/MessageRow")

local function RecycledMessageRow(p2)
	local v5 = SignalsReact.useSignalState(p2.itemSignal)
	return React.createElement(MessageRow, { key = v5.stable_key, item = v5 })
end

local function EndSpacer()
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 10)
	})
end

local recyclableView = ViewRecyclerReact.createRecyclableView(RecycledMessageRow, {
	readiness = ViewRecyclerReact.RecyclableViewReadiness.ReadyOnCommit
})

local recyclableView2 = ViewRecyclerReact.createRecyclableView(EndSpacer)

return {
	MessageRowType = recyclableView,
	EndSpacerItem = ViewRecyclerReact.createPinnedItem({
		key = "EndSpacer",
		value = {},
		itemType = recyclableView2
	})
}
