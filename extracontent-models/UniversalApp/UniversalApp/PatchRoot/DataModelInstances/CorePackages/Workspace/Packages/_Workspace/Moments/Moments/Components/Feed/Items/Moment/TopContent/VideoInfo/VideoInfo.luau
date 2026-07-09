local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local Foundation = require(MomentsParent.Foundation)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)
local CreatorAttribution = require(script.Parent.CreatorAttribution)
local DebugInfo = require(script.Parent.DebugInfo)
local Description = require(script.Parent.Description)
local Reactions = require(script.Parent.Reactions)
local StatusChip = require(script.Parent.StatusChip)
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState

local function VideoInfo(t1: {[any]: any}) -- line: 38
	-- upvalues: MomentContext (copy), useSignalState (copy), useMomentsSession (copy), React (copy), DebugInfo (copy), CreatorAttribution (copy), Description (copy), Reactions (copy), StatusChip (copy), View (copy)
	local v17 = MomentContext.useMoment()
	local v18 = useSignalState(v17.store.getData).kind == "experience"
	local v19 = useMomentsSession()
	local t2 = {}

	if not useSignalState(v19.getHideDetails) then
		t2.DebugInfo = React.createElement(DebugInfo, {
			LayoutOrder = 0
		})
		t2.CreatorAttribution = if not v18 then nil else React.createElement(CreatorAttribution, {
			LayoutOrder = 1
		})
		t2.Description = React.createElement(Description, {
			LayoutOrder = 2
		})
		t2.Reactions = if not v18 then nil else React.createElement(Reactions, {
			LayoutOrder = 3
		})
		t2.StatusChip = React.createElement(StatusChip, {
			LayoutOrder = 4
		})
	end

	return React.createElement(View, {
		tag = "col align-x-left align-y-bottom grow gap-small auto-y",
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return React.memo(VideoInfo)
