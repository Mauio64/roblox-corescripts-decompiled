local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local useSignalBinding = SignalsReact.useSignalBinding
local GetRewriteDropdownStore = require(ExpChat.Stores.GetRewriteDropdownStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

local Localization = require(ExpChat.Localization)

local Flags = ExpChat.Flags
local FStringInExpChatRewriteReasonKey = require(Flags.FStringInExpChatRewriteReasonKey)

local mergeBindableScalar = require(ExpChat.ChatWindow.Helpers.mergeBindableScalar)

local function RewriteDropdown(p)
	local v = Foundation.Hooks.useTokens()

	local v2 = Localization.useLocalization({
		rewrittenReasonLabelText = FStringInExpChatRewriteReasonKey,
		defaultRewrittenReasonLabelText = "CoreScripts.TextChat.ChatWindows.RewrittenReasonLabel"
	})
	local text

	if v2.rewrittenReasonLabelText and v2.rewrittenReasonLabelText ~= "" then
		text = v2.rewrittenReasonLabelText
	else
		text = v2.defaultRewrittenReasonLabelText
	end

	local messagesStore = GetMessagesStore(false)
	local rewriteDropdownStore = GetRewriteDropdownStore(false)

	local v3 = React.useMemo(function()
		local computed = Signals.createComputed(function(p2)
			local componentId = rewriteDropdownStore.getComponentId(p2)

			if not componentId then
				return nil
			end

			local openMessageId = rewriteDropdownStore.getOpenMessageId(p2)

			if not openMessageId then
				return nil
			end

			local messageComponentSignal = messagesStore.getMessageComponentSignal(componentId)

			if not messageComponentSignal then
				return nil
			end

			local v3 = messageComponentSignal(p2)

			if not v3 then
				return nil
			end

			local v4 = messagesStore.getMessage(v3)(p2)

			if not v4 then
				return nil
			end

			return if v3 == openMessageId then v4 else nil
		end)

		return {
			getVisible = Signals.createComputed(function(p2)
				local v3 = computed(p2)

				return if v3 then v3.wasRewritten else false
			end),
			getLayoutOrder = Signals.createComputed(function(p2)
				local componentId = rewriteDropdownStore.getComponentId(p2)

				if not componentId then
					return 0
				end

				local layoutOrderSignal = messagesStore.getLayoutOrderSignal(componentId)

				if layoutOrderSignal then
					return layoutOrderSignal(p2) + 1
				end

				return 0
			end),
			getOriginalText = Signals.createComputed(function(p2)
				local v3 = computed(p2)

				if v3 then
					return v3.originalText or ""
				end

				return ""
			end)
		}
	end, {})

	local visible = useSignalBinding(v3.getVisible)
	local layoutOrder = useSignalBinding(v3.getLayoutOrder)
	local text2 = useSignalBinding(v3.getOriginalText)
	local mapped = text2:map(function(p2): boolean
		return p2 ~= nil and p2 ~= ""
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = layoutOrder,
		Visible = visible
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.Padding.XXSmall),
			PaddingBottom = UDim.new(0, v.Padding.XXSmall),
			PaddingRight = p.arButtonPadding
		}),
		React.createElement(Foundation.View, {
			tag = "col align-x-left gap-xxsmall padding-small radius-medium size-full-0 auto-y",
			backgroundStyle = {
				Color3 = v.Color.Common.Scrim.Color3,
				Transparency = mergeBindableScalar(0.7, p.textTransparency)
			}
		}, {
			OriginalText = React.createElement(Foundation.Text, {
				Text = text2,
				tag = "text-body-small text-align-x-left text-wrap size-full-0 auto-y",
				LayoutOrder = 1,
				RichText = true,
				Visible = mapped,
				textStyle = {
					Color3 = v.Color.Content.Muted.Color3,
					Transparency = mergeBindableScalar(v.Color.Content.Muted.Transparency, p.textTransparency)
				},
				stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Transparency = mergeBindableScalar(0.5, p.textTransparency),
					Thickness = v.Stroke.Thin
				}
			}),
			Divider = React.createElement(Foundation.Divider, {
				orientation = Foundation.Enums.Orientation.Horizontal,
				LayoutOrder = 2,
				Visible = React.joinBindings({ p.textTransparency, mapped }):map(function(list)
					return list[1] < 1 and list[2]
				end),
				DividerVariant = Foundation.Enums.DividerVariant.Default
			}),
			ReasoningText = React.createElement(Foundation.Text, {
				Text = text,
				tag = "text-body-small text-align-x-left text-wrap size-full-0 auto-y",
				LayoutOrder = 3,
				RichText = true,
				textStyle = {
					Color3 = v.Color.Content.Default.Color3,
					Transparency = mergeBindableScalar(v.Color.Content.Default.Transparency, p.textTransparency)
				},
				stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Transparency = mergeBindableScalar(0.5, p.textTransparency),
					Thickness = v.Stroke.Thin
				}
			})
		})
	})
end

return React.memo(RewriteDropdown)
