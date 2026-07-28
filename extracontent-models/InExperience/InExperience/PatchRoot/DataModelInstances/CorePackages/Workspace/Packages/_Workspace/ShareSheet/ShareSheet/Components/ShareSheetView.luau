local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Divider = Foundation.Divider
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local ShareSheetSocialRow = require(script.Parent.ShareSheetSocialRow)
local ShareSheetActionRow = require(script.Parent.ShareSheetActionRow)
local ShareSendRow = require(script.Parent.ShareSendRow)

local function setContentScrollingFrameRef(p1) -- line: 35
	if p1 then
		p1.AutomaticSize = Enum.AutomaticSize.Y
		p1.ScrollBarThickness = 0
	end
end
local function ShareSheetView(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), Sheet (copy), FoundationText (copy), setContentScrollingFrameRef (copy), View (copy), ShareSheetSocialRow (copy), Divider (copy), ShareSendRow (copy), ShareSheetActionRow (copy)
	local v15 = next(t1.selectedConversationIds) ~= nil

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		isOpen = t1.isOpen,
		onClose = t1.onClose
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small content-emphasis",
				Text = t1.shareLabel
			})
		}),
		Content = React.createElement(Sheet.Content, {
			isContentFullBleed = true,
			scrollingFrameRef = setContentScrollingFrameRef
		}, {
			ContentLayout = React.createElement(View, {
				tag = "col gap-xlarge size-full-0 auto-y"
			}, {
				SocialRow = if not t1.shouldShowSocialRow then nil else React.createElement(ShareSheetSocialRow, {
					LayoutOrder = 1,
					conversationEligibility = t1.conversationEligibility,
					isLoading = t1.isSocialRowLoading,
					onConversationActivated = t1.onConversationActivated,
					selectedConversationIds = t1.selectedConversationIds
				}),
				RowDivider = if not t1.shouldShowSocialRow then nil else React.createElement(Divider, {
					LayoutOrder = 2,
					testId = "share-sheet-row-divider"
				}),
				ActionsRow = if not v15 and not t1.isSending then React.createElement(ShareSheetActionRow, {
					LayoutOrder = 3,
					canShare = t1.canShareLink,
					context = t1.context,
					telemetryId = t1.telemetryId,
					url = t1.url
				}) else React.createElement(ShareSendRow, {
					LayoutOrder = 3,
					isLoading = t1.isSending,
					label = t1.sendLabel,
					messagePlaceholder = t1.messagePlaceholder,
					onActivated = t1.onSendActivated
				})
			})
		})
	})
end

return ShareSheetView
