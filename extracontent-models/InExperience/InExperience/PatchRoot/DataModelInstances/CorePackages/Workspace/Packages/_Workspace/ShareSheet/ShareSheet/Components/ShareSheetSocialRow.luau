local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local ShareSheetRow = require(script.Parent.ShareSheetRow)
local ShareSheetItemContainer = require(script.Parent.ShareSheetItemContainer)
local Players = game:GetService("Players")
local v10 = game:DefineFastInt("ShareSheetNumAvatarSkeletons", 6)

require(Parent.AppChat.GetConversationListStore)

local function getOtherParticipants(t1: {[any]: any}, s1: string) -- line: 34
	local t2 = {}

	for _, v19 in t1 do
		if v19 ~= s1 then
			table.insert(t2, v19)
		end
	end

	return t2
end
local function createSkeletonItems() -- line: 44
	-- upvalues: v10 (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local t3 = {}

	for i = 1, v10 do
		t3[`Skeleton{ i }`] = React.createElement(View, {
			tag = "col align-x-center gap-small size-1700-0 auto-y",
			LayoutOrder = i
		}, {
			Avatar = React.createElement(View, {
				LayoutOrder = 1,
				tag = "size-full-1700",
				testId = "share-sheet-avatar-skeleton-container"
			}, {
				Skeleton = React.createElement(Skeleton, {
					testId = "share-sheet-avatar-skeleton",
					radius = EnumsRadius.Circle
				})
			}),
			Text = React.createElement(View, {
				LayoutOrder = 2,
				tag = "size-full-400",
				testId = "share-sheet-text-skeleton-container"
			}, {
				Skeleton = React.createElement(Skeleton, {
					testId = "share-sheet-text-skeleton",
					radius = EnumsRadius.Medium
				})
			})
		})
	end

	return t3
end
local function ShareSheetConversationItem(t4: {[any]: any}) -- line: 86
	-- upvalues: React (copy), ShareSheetItemContainer (copy)
	local conversation = t4.conversation
	local id = conversation.id
	local v25 = React.useCallback(function() -- line: 89
		-- upvalues: t4 (copy), id (copy)
		t4.onConversationActivated(id)
	end, {
		id,
		t4.onConversationActivated
	})
	local v26 = conversation.participants or {}
	local localUserId = t4.localUserId
	local t5 = {}

	for _, v30 in v26 do
		if v30 ~= localUserId then
			table.insert(t5, v30)
		end
	end

	local v31 = t5[1] or t4.localUserId
	local v32 = if not (#t5 >= 2) then nil else t5[2]
	local titleForViewer = conversation.titleForViewer
	local v34 = if not titleForViewer or titleForViewer == "" then conversation.title or "" else titleForViewer

	return React.createElement(ShareSheetItemContainer, {
		primaryUserId = v31,
		secondUserId = v32,
		isSelected = t4.isSelected,
		label = v34,
		onActivated = v25,
		LayoutOrder = t4.LayoutOrder
	})
end
local function ShareSheetSocialRow(t6: {[any]: any}) -- line: 109
	-- upvalues: Players (copy), createSkeletonItems (copy), React (copy), ShareSheetConversationItem (copy), ShareSheetRow (copy)
	local str = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local t7 = {}

	if t6.isLoading or t6.conversationEligibility.isLoading then
		t7 = createSkeletonItems()
	else
		for v38, v39 in t6.conversationEligibility.eligibleConversations do
			local id = v39.id

			t7[id] = React.createElement(ShareSheetConversationItem, {
				conversation = v39,
				isSelected = t6.selectedConversationIds[id] == true,
				localUserId = str,
				onConversationActivated = t6.onConversationActivated,
				LayoutOrder = v38
			})
		end
	end

	return React.createElement(ShareSheetRow, {
		LayoutOrder = t6.LayoutOrder
	}, t7)
end

return ShareSheetSocialRow
