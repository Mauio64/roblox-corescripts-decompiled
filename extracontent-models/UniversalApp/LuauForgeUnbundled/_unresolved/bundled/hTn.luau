local module = require("@luauforge/bundled/hTe")
local module2 = require("@luauforge/bundled/hTj")
local module3 = require("@luauforge/bundled/hTo")
local module4 = require("@luauforge/bundled/hTp")
local module5 = require("@luauforge/bundled/hTi")

local useLocalization = module3.Hooks.useLocalization
local useAbbreviatedNumberLocalization = module3.Hooks.useAbbreviatedNumberLocalization

local view = module2.View
local text = module2.Text
local avatar = module2.Avatar
local inputSize = module2.Enums.InputSize

local emojiWrapper = module4.EmojiWrapper

local v5 = {
	formerMember = "Feature.Groups.Label.FormerMember",
	reply = "Feature.Groups.Label.Reply",
	replies = "Feature.Groups.Label.Replies"
}

local function SduiGroupForumPostPreview(props)
	local v6 = useLocalization(v5)

	local replyCount = props.replyCount or 0
	local v8 = if replyCount > 0 then replyCount else nil
	local v9 = useAbbreviatedNumberLocalization(v8) or tostring(replyCount)
	local v10 = if replyCount == 1 then v6.reply else v6.replies

	local creatorRoleName = props.creatorRoleName or v6.formerMember
	local creatorDisplayName = props.creatorDisplayName or ""
	local creatorUserId = tonumber(props.creatorUserId)
	local v11

	if props.creatorIsVerified then
		v11 = module.createElement(
			emojiWrapper,
			{ emoji = module4.emoji.verified, layoutOrder = 2, size = UDim2.new() },
			{
				NameText = module.createElement(text, {
					Text = creatorDisplayName,
					tag = "padding-right-small auto-xy text-title-small text-no-wrap text-align-x-left text-truncate-end content-default"
				})
			}
		)
	else
		v11 = module.createElement(text, {
			Text = creatorDisplayName,
			tag = "auto-xy text-title-small text-no-wrap text-align-x-left text-truncate-end content-default",
			LayoutOrder = 2
		})
	end

	local createElement = module.createElement
	local v13 = {
		tag = "col gap-small size-full-0 auto-y padding-small radius-medium",
		LayoutOrder = props.layoutOrder,
		onActivated = props.onActivated,
		testId = props.testId
	}

	local createElement2 = module.createElement

	local v17 = if creatorUserId then module.createElement(avatar, {
		userId = creatorUserId,
		size = inputSize.Medium,
		LayoutOrder = 1
	}) else nil
	return createElement(view, v13, {
		Header = createElement2(
			view,
			{ tag = "row align-y-center gap-small size-full-0 auto-y", LayoutOrder = 1 },
			{
				Avatar = v17,
				Author = v11,
				Role = module.createElement(text, {
					Text = creatorRoleName,
					tag = "auto-xy text-body-small text-no-wrap text-align-x-left text-truncate-end content-muted",
					LayoutOrder = 3
				})
			}
		),
		Title = module.createElement(text, {
			Text = props.title or "",
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-default",
			LayoutOrder = 2
		}),
		Body = module.createElement("Frame", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Interactable = false,
			LayoutOrder = 3
		}, {
			Layout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Markdown = module.createElement(module5, {
				text = props.body or "",
				maxLines = 3
			})
		}),
		Replies = module.createElement(
			view,
			{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = 4 },
			{
				Count = module.createElement(text, {
					Text = v9,
					tag = "auto-xy text-body-small content-muted",
					LayoutOrder = 1
				}),
				Label = module.createElement(text, {
					Text = v10,
					tag = "auto-xy text-body-small content-muted",
					LayoutOrder = 2
				})
			}
		)
	})
end

return module.memo(SduiGroupForumPostPreview)
