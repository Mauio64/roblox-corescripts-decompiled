local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local Foundation = require(AppChatParent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local t1 = {
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.5,
		addBottomPadding = true
	},
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = false,
		widthPercentage = 0.2
	},
	{
		heightFactor = 1,
		isIncoming = false,
		showAvatarCircle = false,
		widthPercentage = 0.6,
		addBottomPadding = true
	},
	{
		heightFactor = 2,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.75,
		addBottomPadding = true
	},
	{
		heightFactor = 2,
		isIncoming = false,
		showAvatarCircle = false,
		widthPercentage = 0.75,
		addBottomPadding = true
	},
	{
		heightFactor = 1,
		isIncoming = false,
		showAvatarCircle = false,
		widthPercentage = 0.4
	},
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.7,
		addBottomPadding = true
	},
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = false,
		widthPercentage = 0.5
	}
}
local t2 = {
	size = UDim2.fromScale(1, 1),
	itemList = t1
}

local function renderSkeletonRow(t3: {[any]: any}, p1, t4: {[any]: any}, n1: number) -- line: 50
	-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local v20 = t3.heightFactor * p1.Size.Size_500 + p1.Size.Size_400
	local Size_900 = p1.Size.Size_900
	local v22 = if not t3.addBottomPadding then p1.Size.Size_100 else p1.Size.Size_600

	return React.createElement(View, {
		testId = "ConversationMessageSkeletonRow",
		LayoutOrder = n1,
		tag = {
			["row align-y-bottom gap-small size-full-0 auto-y"] = true,
			["align-x-left"] = t3.isIncoming,
			["align-x-right"] = not t3.isIncoming
		},
		padding = {
			left = UDim.new(0, t4.left),
			right = UDim.new(0, t4.right),
			bottom = UDim.new(0, v22),
			top = if not t3.addTopPadding then nil else UDim.new(0, p1.Size.Size_600)
		}
	}, {
		Avatar = if not t3.isIncoming or not t3.showAvatarCircle then nil else React.createElement(Skeleton, {
			LayoutOrder = 1,
			radius = EnumsRadius.Circle,
			Size = UDim2.fromOffset(Size_900, Size_900)
		}),
		Bubble = React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = EnumsRadius.Medium,
			Size = UDim2.new(t3.widthPercentage, 0, 0, v20)
		})
	})
end
local function ConversationMessageSkeletonList(t5: {[any]: any}) -- line: 90
	-- upvalues: Cryo (copy), t2 (copy), useTokens (copy), useChatPagePadding (copy), t1 (copy), renderSkeletonRow (copy), React (copy), View (copy)
	local v24 = Cryo.Dictionary.union(t2, t5)
	local v25 = useTokens()
	local v26 = useChatPagePadding()
	local t6 = {}

	for v28, v29 in v24.itemList or t1 do
		t6["SkeletonRow" .. v28] = renderSkeletonRow(v29, v25, v26, v28)
	end

	return React.createElement(View, {
		testId = "ConversationMessageSkeletonList",
		tag = "size-full clip",
		Size = v24.size,
		LayoutOrder = v24.layoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}
	}, t6)
end

return memo(ConversationMessageSkeletonList)
