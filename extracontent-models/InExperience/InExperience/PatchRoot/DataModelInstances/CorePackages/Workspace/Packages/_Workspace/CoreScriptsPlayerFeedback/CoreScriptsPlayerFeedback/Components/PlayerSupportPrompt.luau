local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local CoreScriptsPlayerFeedbackParent = CoreScriptsPlayerFeedback.Parent
local React = require(CoreScriptsPlayerFeedbackParent.React)
local Foundation = require(CoreScriptsPlayerFeedbackParent.Foundation)
local Dialog = Foundation.Dialog
local Checkbox = Foundation.Checkbox
local Dropdown = Foundation.Dropdown
local TextArea = Foundation.TextArea
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local InputVariant = Foundation.Enums.InputVariant
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(CoreScriptsPlayerFeedbackParent.Localization).Hooks.useLocalization
local constants = require(CoreScriptsPlayerFeedback.constants)
local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)
local t1 = {
	TICKET_CATEGORY_DATA_RESTORE_REQUEST = true,
	TICKET_CATEGORY_PURCHASING_ISSUE = true
}

return (React.memo(function(t2: {[any]: any}) -- line: 70
	-- upvalues: useTokens (copy), constants (copy), useLocalization (copy), t1 (copy), React (copy), useEscapeDismiss (copy), Dialog (copy), View (copy), FoundationText (copy), Dropdown (copy), InputSize (copy), InputVariant (copy), TextArea (copy), Checkbox (copy), ButtonVariant (copy)
	local v20 = useTokens()
	local description = t2.description
	local setDescription = t2.setDescription
	local category = t2.category
	local setCategory = t2.setCategory
	local shareUserId = t2.shareUserId
	local setShareUserId = t2.setShareUserId
	local MIN_FEEDBACK_LENGTH = constants.MIN_FEEDBACK_LENGTH
	local MAX_PLAYER_SUPPORT_LENGTH = constants.MAX_PLAYER_SUPPORT_LENGTH
	local v29 = useLocalization({
		Title = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Title",
		ReportAbuseLead = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ReportAbuse.Lead",
		ReportAbuseLink = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ReportAbuse.Link",
		CategoryLabel = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.Label",
		CategoryPlaceholder = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.Placeholder",
		CategoryItemBugReport = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.BugReport",
		CategoryItemDataRestoreRequest = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.DataRestoreRequest",
		CategoryItemPurchasingIssue = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.PurchasingIssue",
		CategoryItemOther = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Category.Other",
		DescriptionLabel = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Description.Label",
		DescriptionPlaceholderBugReport = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.BugReport",
		DescriptionPlaceholderDataRestoreRequest = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.DataRestoreRequest",
		DescriptionPlaceholderPurchasingIssue = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.PurchasingIssue",
		DescriptionPlaceholderOther = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Placeholder.Other",
		ShareUserIdLabel = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ShareUserId.Label",
		ShareUserIdLabelRequired = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ShareUserId.LabelRequired",
		ShareUserIdHint = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.ShareUserId.Hint",
		Send = "CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Send",
		DescriptionHint = {
			"CoreScripts.FeedbackPrompt.PlayerSupportPrompt.Description.CharacterLimitHint",
			MAX = tostring(MAX_PLAYER_SUPPORT_LENGTH)
		}
	})
	local t3 = {
		{
			id = "TICKET_CATEGORY_BUG_REPORT",
			text = v29.CategoryItemBugReport
		},
		{
			id = "TICKET_CATEGORY_DATA_RESTORE_REQUEST",
			text = v29.CategoryItemDataRestoreRequest
		},
		{
			id = "TICKET_CATEGORY_PURCHASING_ISSUE",
			text = v29.CategoryItemPurchasingIssue
		},
		{
			id = "TICKET_CATEGORY_OTHER",
			text = v29.CategoryItemOther
		}
	}
	local t4 = {
		TICKET_CATEGORY_BUG_REPORT = v29.DescriptionPlaceholderBugReport,
		TICKET_CATEGORY_DATA_RESTORE_REQUEST = v29.DescriptionPlaceholderDataRestoreRequest,
		TICKET_CATEGORY_PURCHASING_ISSUE = v29.DescriptionPlaceholderPurchasingIssue,
		TICKET_CATEGORY_OTHER = v29.DescriptionPlaceholderOther
	}
	local v32 = t1[category] == true
	local v33 = v32 or shareUserId
	local v34 = MIN_FEEDBACK_LENGTH <= #description and (MAX_PLAYER_SUPPORT_LENGTH >= #description and category ~= "")
	local v35 = React.useCallback(function() -- line: 142
		-- upvalues: v34 (copy), description (copy), category (copy), v33 (copy), t2 (copy)
		if not v34 then
			return
		end

		pcall(function() -- line: 146
			-- upvalues: description (copy), category (copy), v33 (copy)
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionCompleted then
				SocialService:SignalFeedbackSubmissionCompleted("", {
					Description = description,
					Category = category,
					ShareUserIdPreference = not v33 and "SHARE_USER_ID_PREFERENCE_DO_NOT_SHARE" or "SHARE_USER_ID_PREFERENCE_SHARE"
				})
			end
		end)
		t2.closePrompt()
	end, {
		description,
		category,
		v33,
		v34,
		t2.closePrompt
	})
	local v36 = React.useCallback(function() -- line: 166
		-- upvalues: t2 (copy)
		pcall(function() -- line: 167
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionPermissionDenied then
				SocialService:SignalFeedbackSubmissionPermissionDenied()
			end
		end)
		t2.onFormAbandoned()
		t2.closePrompt()
	end, {
		t2.closePrompt,
		t2.onFormAbandoned
	})
	local v37 = React.useCallback(function() -- line: 182
		-- upvalues: t2 (copy)
		pcall(function() -- line: 183
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionPermissionDenied then
				SocialService:SignalFeedbackSubmissionPermissionDenied()
			end
		end)
		t2.onFormAbandoned()
		t2.closePrompt()
		pcall(function() -- line: 191
			local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
			local v44 = RobloxGui and RobloxGui:FindFirstChild("Modules") or nil
			local v45 = v44 and v44:FindFirstChild("Settings") or nil
			local v46 = v45 and v45:FindFirstChild("SettingsHub") or nil

			if not v46 then
				return
			end

			local lib = require(v46)

			lib:SetVisibility(true, false, lib.Instance.ReportAbusePage)
		end)
	end, {
		t2.closePrompt,
		t2.onFormAbandoned
	})

	useEscapeDismiss("PlayerSupportPromptCancel", v36)

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		onClose = v36
	}, {
		Title = React.createElement(Dialog.Title, {
			text = v29.Title
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 1
		}, {
			Body = React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y",
				padding = {
					top = UDim.new(0, -(v20.Gap.XLarge - v20.Gap.Large))
				}
			}, {
				ReportAbuseRow = React.createElement(View, {
					tag = "row gap-small auto-y",
					LayoutOrder = 0
				}, {
					Lead = React.createElement(FoundationText, {
						tag = "auto-xy",
						LayoutOrder = 1,
						Text = v29.ReportAbuseLead
					}),
					Link = React.createElement(FoundationText, {
						RichText = true,
						tag = "auto-xy",
						LayoutOrder = 2,
						Text = v29.ReportAbuseLink,
						onActivated = v37,
						selection = {
							Selectable = true
						}
					})
				}),
				CategorySection = React.createElement(View, {
					tag = "col gap-small size-full-0 auto-y",
					LayoutOrder = 1
				}, {
					Label = React.createElement(FoundationText, {
						tag = "size-0 auto-xy text-title-medium text-wrap text-align-x-left text-align-y-top",
						LayoutOrder = 1,
						Text = v29.CategoryLabel,
						textStyle = v20.Color.Content.Emphasis
					}),
					DropdownBorder = React.createElement(View, {
						tag = "radius-medium",
						LayoutOrder = 2,
						Size = UDim2.new(1, -v20.Stroke.Standard * 2, 0, 0),
						Position = UDim2.new(0, v20.Stroke.Standard, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						stroke = {
							Color = v20.Color.Stroke.Default.Color3,
							Thickness = v20.Stroke.Standard,
							Transparency = v20.Color.Stroke.Default.Transparency
						},
						cornerRadius = UDim.new(0, v20.Radius.Medium)
					}, {
						Dropdown = React.createElement(Dropdown.Root, {
							label = "",
							value = if category == "" then nil else category,
							placeholder = v29.CategoryPlaceholder,
							items = t3,
							size = InputSize.Medium,
							variant = InputVariant.Utility,
							width = UDim.new(1, 0),
							onItemChanged = function(p1) -- line: 272
								-- upvalues: setCategory (copy)
								setCategory((tostring(p1)))
							end
						})
					})
				}),
				Description = React.createElement(View, {
					tag = "col gap-small size-full-0 auto-y",
					LayoutOrder = 2,
					GroupTransparency = category ~= "" and 0 or 0.75
				}, {
					Label = React.createElement(FoundationText, {
						tag = "size-0 auto-xy text-title-medium text-wrap text-align-x-left text-align-y-top",
						LayoutOrder = 1,
						Text = v29.DescriptionLabel,
						textStyle = v20.Color.Content.Emphasis
					}),
					InputBorderSlot = React.createElement(View, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 2
					}, {
						InputBorder = React.createElement(View, {
							tag = "radius-medium",
							Size = UDim2.new(1, -v20.Stroke.Standard * 2, 0, 0),
							Position = UDim2.new(0, v20.Stroke.Standard, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							stroke = {
								Color = v20.Color.Stroke.Default.Color3,
								Thickness = v20.Stroke.Standard,
								Transparency = v20.Color.Stroke.Default.Transparency
							},
							cornerRadius = UDim.new(0, v20.Radius.Medium)
						}, {
							Input = React.createElement(TextArea, {
								label = "",
								hint = "",
								numLines = 4,
								text = description,
								onChanged = setDescription,
								placeholder = t4[category] or "",
								width = UDim.new(1, 0),
								variant = InputVariant.Utility,
								size = InputSize.Medium,
								isDisabled = category == ""
							})
						})
					}),
					Hint = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-left text-align-y-top",
						LayoutOrder = 3,
						Text = v29.DescriptionHint,
						textStyle = v20.Color.Content.Emphasis
					})
				}),
				ShareCheckboxRow = React.createElement(View, {
					tag = "col gap-xsmall size-full-0 auto-y",
					LayoutOrder = 3
				}, {
					Checkbox = React.createElement(Checkbox, {
						LayoutOrder = 1,
						label = if not v32 then v29.ShareUserIdLabel else v29.ShareUserIdLabelRequired,
						isChecked = v33,
						isDisabled = v32,
						onActivated = function(b1: boolean) -- line: 338
							-- upvalues: setShareUserId (copy)
							setShareUserId(b1)
						end,
						size = InputSize.Medium
					}),
					HintRow = React.createElement(View, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 2,
						padding = {
							left = UDim.new(0, v20.Size.Size_600 + v20.Gap.Medium)
						}
					}, {
						Hint = React.createElement(FoundationText, {
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
							Text = v29.ShareUserIdHint
						})
					})
				})
			})
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 2,
			actions = {{
				text = v29.Send,
				variant = if not v34 then ButtonVariant.Standard else ButtonVariant.Emphasis,
				onActivated = v35,
				isDisabled = not v34
			}}
		})
	})
end))
