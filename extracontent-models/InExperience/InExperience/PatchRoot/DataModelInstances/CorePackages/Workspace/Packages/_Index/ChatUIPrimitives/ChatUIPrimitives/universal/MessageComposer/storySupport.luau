local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(script.Parent.MessageComposer)
require(script.Parent.Parent.Types)
local PlainTextContentModel = require(script.Parent.Parent.ContentKinds.PlainText.PlainTextContentModel)
local PresetContentModel = require(script.Parent.Parent.ContentKinds.Preset.PresetContentModel)
local EmojiContentModel = require(script.Parent.Parent.ContentKinds.Emoji.EmojiContentModel)

local StorySupport = {}

StorySupport.noopDelivery = {
	sendMessageDraft = function(_) end
}

function StorySupport.draftLabel(p)
	local v = {}

	for _, content in p.contents do
		local draft = PlainTextContentModel.getDraft(content)

		if draft then
			table.insert(v, `plainText "{draft.text}"`)
		end

		local draft2 = PresetContentModel.getDraft(content)

		if draft2 then
			table.insert(v, `preset "{draft2.presetId}" "{draft2.displayText}"`)
		end

		local draft3 = EmojiContentModel.getDraft(content)

		if draft3 then
			table.insert(v, `emoji "{draft3.emojiId}" {draft3.unicode}`)
		end
	end

	if #v == 0 then
		return "(no content)"
	end

	return table.concat(v, ", ")
end

function StorySupport.useEventLog()
	local state, setState = React.useState({})
	return state, (React.useCallback(function(p: string)
		setState(function(p2)
			local clone = table.clone(p2)
			table.insert(clone, p)
			return clone
		end)
	end, {}))
end

function StorySupport.useDeliveryLog()
	local entries, v = StorySupport.useEventLog()

	local sendMessageDraft = React.useCallback(function(p)
		v(`sent: {StorySupport.draftLabel(p)}`)
	end, { v })

	return {
		messageDelivery = React.useMemo(function()
			return { sendMessageDraft = sendMessageDraft }
		end, { sendMessageDraft }),
		entries = entries
	}
end

function StorySupport.LogPanel(props)
	local count = 0
	local children = {}

	for k, text in props.header or {} do
		count += 1
		children[`header-{k}`] = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-wrap text-align-x-left text-caption-medium",
			Text = text,
			LayoutOrder = count
		})
	end

	if #props.lines == 0 then
		local layoutOrder = count + 1
		children.empty = React.createElement(Foundation.Text, {
			tag = "content-muted size-full-0 auto-y text-wrap text-align-x-left text-caption-medium",
			Text = props.emptyText,
			LayoutOrder = layoutOrder
		})
	else
		for k, line in props.lines do
			count += 1
			children[`line-{k}`] = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-y text-wrap text-align-x-left text-caption-medium",
				Text = line,
				LayoutOrder = count
			})
		end
	end

	return React.createElement(
		Foundation.View,
		{
			tag = "col gap-xsmall auto-y",
			Size = UDim2.fromOffset(300, 0),
			LayoutOrder = props.LayoutOrder
		},
		children
	)
end

function StorySupport.Layout(props)
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v = { tag = "col gap-medium auto-y", Size = UDim2.fromOffset(400, 0), LayoutOrder = 1 }
	local toolbar

	if props.toolbar then
		toolbar = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1
		}, props.toolbar)
	end

	local v2 = {
		composerColumn = createElement2(view2, v, {
			toolbar = toolbar,
			composer = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y", LayoutOrder = 2 },
				props.composer
			)
		}),
		panel = 0
	}
	local panel

	if props.panel then
		panel = React.createElement(Foundation.View, { tag = "auto-xy", LayoutOrder = 2 }, props.panel)
	end

	v2.panel = panel
	return createElement(view, { tag = "row gap-large auto-xy" }, v2)
end

return StorySupport
