local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local Signals = require(ExpChatParent.Signals)
local useSignalBinding = require(ExpChatParent.SignalsReact).useSignalBinding
local GetRewriteDropdownStore = require(ExpChat.Stores.GetRewriteDropdownStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local Localization = require(ExpChat.Localization)
local Flags = ExpChat.Flags
local FStringInExpChatRewriteReasonKey = require(Flags.FStringInExpChatRewriteReasonKey)
local mergeBindableScalar = require(ExpChat.ChatWindow.Helpers.mergeBindableScalar)

local function RewriteDropdown(t1: {[any]: any}) -- line: 25
	-- upvalues: Foundation (copy), Localization (copy), FStringInExpChatRewriteReasonKey (copy), GetMessagesStore (copy), GetRewriteDropdownStore (copy), React (copy), Signals (copy), useSignalBinding (copy), mergeBindableScalar (copy)
	local v15 = Foundation.Hooks.useTokens()
	local v16 = Localization.useLocalization({
		defaultRewrittenReasonLabelText = "CoreScripts.TextChat.ChatWindows.RewrittenReasonLabel",
		rewrittenReasonLabelText = FStringInExpChatRewriteReasonKey
	})
	local v17 = if not v16.rewrittenReasonLabelText or v16.rewrittenReasonLabelText == "" then v16.defaultRewrittenReasonLabelText else v16.rewrittenReasonLabelText
	local v18 = GetMessagesStore(false)
	local v19 = GetRewriteDropdownStore(false)
	local v20 = React.useMemo(function() -- line: 40
		-- upvalues: Signals (copy), v19 (copy), v18 (copy)
		local v25 = Signals.createComputed(function(p1) -- line: 41
			-- upvalues: v19 (copy), v18 (copy)
			local v32 = v19.getComponentId(p1)

			if not v32 then
				return nil
			end

			local v33 = v19.getOpenMessageId(p1)

			if not v33 then
				return nil
			end

			local v34 = v18.getMessageComponentSignal(v32)

			if not v34 then
				return nil
			end

			local v35 = v34(p1)

			if not v35 then
				return nil
			end

			local v36 = v18.getMessage(v35)(p1)

			if not v36 then
				return nil
			end

			if v35 == v33 then
				return v36
			end

			return nil
		end)
		local v26 = Signals.createComputed(function(p2) -- line: 69
			-- upvalues: v25 (copy)
			local v38 = v25(p2)

			if not v38 then
				return false
			end

			return v38.wasRewritten
		end)
		local v27 = Signals.createComputed(function(p3) -- line: 77
			-- upvalues: v19 (copy), v18 (copy)
			local v40 = v19.getComponentId(p3)

			if not v40 then
				return 0
			end

			local v41 = v18.getLayoutOrderSignal(v40)

			if not v41 then
				return 0
			end

			return v41(p3) + 1
		end)
		local v28 = Signals.createComputed(function(p4) -- line: 89
			-- upvalues: v25 (copy)
			local v43 = v25(p4)

			if not v43 then
				return ""
			end

			return v43.originalText or ""
		end)

		return {
			getVisible = v26,
			getLayoutOrder = v27,
			getOriginalText = v28
		}
	end, {})
	local v21 = useSignalBinding(v20.getVisible)
	local v22 = useSignalBinding(v20.getLayoutOrder)
	local v23 = useSignalBinding(v20.getOriginalText)
	local v24 = v23:map(function(p5) -- line: 107
		return p5 ~= nil and p5 ~= ""
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = v22,
		Visible = v21
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v15.Padding.XXSmall),
			PaddingBottom = UDim.new(0, v15.Padding.XXSmall),
			PaddingRight = t1.arButtonPadding
		}),
		React.createElement(Foundation.View, {
			tag = "col align-x-left gap-xxsmall padding-small radius-medium size-full-0 auto-y",
			backgroundStyle = {
				Color3 = v15.Color.Common.Scrim.Color3,
				Transparency = mergeBindableScalar(0.7, t1.textTransparency)
			}
		}, {
			OriginalText = React.createElement(Foundation.Text, {
				tag = "text-body-small text-align-x-left text-wrap size-full-0 auto-y",
				LayoutOrder = 1,
				RichText = true,
				Text = v23,
				Visible = v24,
				textStyle = {
					Color3 = v15.Color.Content.Muted.Color3,
					Transparency = mergeBindableScalar(v15.Color.Content.Muted.Transparency, t1.textTransparency)
				},
				stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Transparency = mergeBindableScalar(0.5, t1.textTransparency),
					Thickness = v15.Stroke.Thin
				}
			}),
			Divider = React.createElement(Foundation.Divider, {
				LayoutOrder = 2,
				orientation = Foundation.Enums.Orientation.Horizontal,
				Visible = React.joinBindings({
					t1.textTransparency,
					v24
				}):map(function(p6) -- line: 150
					return p6[1] < 1 and p6[2]
				end),
				DividerVariant = Foundation.Enums.DividerVariant.Default
			}),
			ReasoningText = React.createElement(Foundation.Text, {
				tag = "text-body-small text-align-x-left text-wrap size-full-0 auto-y",
				LayoutOrder = 3,
				RichText = true,
				Text = v17,
				textStyle = {
					Color3 = v15.Color.Content.Default.Color3,
					Transparency = mergeBindableScalar(v15.Color.Content.Default.Transparency, t1.textTransparency)
				},
				stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Transparency = mergeBindableScalar(0.5, t1.textTransparency),
					Thickness = v15.Stroke.Thin
				}
			})
		})
	})
end

return React.memo(RewriteDropdown)
